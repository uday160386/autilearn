import Foundation
import os

// MARK: - Remote Config
//
// Fetches the Anthropic API key (and other config) from Supabase at launch.
// The admin stores ONE key in the database; every user's app reads it.
// The key is never bundled in the app — it lives only in your Supabase table.
//
// SETUP (one-time, ~5 minutes):
//
//  1. Create a free Supabase project at https://supabase.com
//
//  2. In the Supabase SQL editor, run:
//       create table app_config (
//         key   text primary key,
//         value text not null
//       );
//       -- Insert your Anthropic key:
//       insert into app_config (key, value)
//       values ('anthropic_api_key', 'sk-ant-YOUR_KEY_HERE');
//       -- Allow public read-only access (no auth needed to read):
//       create policy "Public read" on app_config
//         for select using (true);
//       alter table app_config enable row level security;
//
//  3. In Config.xcconfig set:
//       SUPABASE_URL    = https://YOUR_PROJECT_ID.supabase.co
//       SUPABASE_ANON_KEY = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
//     (find these in Supabase → Project Settings → API)
//
//  4. In Xcode Build Settings → Info.plist Values add:
//       SupabaseURL     = $(SUPABASE_URL)
//       SupabaseAnonKey = $(SUPABASE_ANON_KEY)
//
//  To update the key for ALL users: just update the database row.
//  No app update needed.

@MainActor
@Observable
final class RemoteConfig {

    static let shared = RemoteConfig()

    private(set) var anthropicAPIKey: String = ""
    private(set) var isLoaded        = false
    private(set) var loadError: String?

    // Cache key and TTL
    private let cacheKey  = "remote_config_cache"
    private let cacheTTL: TimeInterval = 3600   // re-fetch every hour

    // Read from Info.plist → set via Config.xcconfig
    private var supabaseURL: String {
        Bundle.main.object(forInfoDictionaryKey: "SupabaseURL") as? String ?? ""
    }
    private var supabaseAnonKey: String {
        Bundle.main.object(forInfoDictionaryKey: "SupabaseAnonKey") as? String ?? ""
    }

    // MARK: - Public

    func load() {
        // Try cache first for instant startup
        if let cached = loadFromCache() {
            anthropicAPIKey = cached
            isLoaded        = true
        }
        // Always fetch fresh in background
        Task { await fetchFromSupabase() }
    }

    // MARK: - Supabase fetch

    private func fetchFromSupabase() async {
        guard !supabaseURL.isEmpty, !supabaseAnonKey.isEmpty,
              !supabaseURL.contains("YOUR_") else {
            os_log(.error, "RemoteConfig: Supabase URL or anon key not configured")
            loadError = "Remote config not configured"
            isLoaded  = true
            return
        }

        guard let url = URL(string:
            "\(supabaseURL)/rest/v1/app_config?key=eq.anthropic_api_key&select=value"
        ) else { return }

        var req = URLRequest(url: url, timeoutInterval: 10)
        req.setValue("application/json",  forHTTPHeaderField: "Accept")
        req.setValue(supabaseAnonKey,     forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(supabaseAnonKey)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: req)

            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode) else {
                os_log(.error, "RemoteConfig: Supabase returned non-200")
                isLoaded = true
                return
            }

            // Response is [{\"value\": \"sk-ant-...\"}]
            if let rows = try JSONSerialization.jsonObject(with: data) as? [[String: Any]],
               let first = rows.first,
               let value = first["value"] as? String,
               !value.isEmpty {
                anthropicAPIKey = value
                saveToCache(value)
                os_log(.info, "RemoteConfig: API key loaded from Supabase")
            } else {
                os_log(.error, "RemoteConfig: No anthropic_api_key row found in app_config table")
            }

        } catch {
            os_log(.error, "RemoteConfig: fetch failed — %@", error.localizedDescription)
            // Keep cached value if available, don't clear it
        }

        isLoaded = true
    }

    // MARK: - Local cache (UserDefaults — value is not sensitive enough for Keychain
    //          but you can move it there if preferred)

    private func loadFromCache() -> String? {
        guard let entry = UserDefaults.standard.dictionary(forKey: cacheKey),
              let value = entry["value"] as? String,
              let saved = entry["date"]  as? Date,
              Date().timeIntervalSince(saved) < cacheTTL,
              !value.isEmpty else { return nil }
        return value
    }

    private func saveToCache(_ value: String) {
        UserDefaults.standard.set(
            ["value": value, "date": Date()],
            forKey: cacheKey
        )
    }
}
