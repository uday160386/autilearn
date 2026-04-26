import Foundation

// MARK: - Video Availability Checker
//
// On first launch (and once per day), checks every video in videos.json
// against YouTube's oEmbed endpoint. Videos that return HTTP 401 have
// embedding disabled by the owner and are filtered out of the UI.
// Results are cached in UserDefaults so checks only run once per day.

actor VideoAvailabilityChecker {

    static let shared = VideoAvailabilityChecker()

    private let cacheKey      = "video_availability_cache"
    private let cacheDateKey  = "video_availability_date"
    private let cacheTTL: TimeInterval = 86400   // 24 hours

    // Returns the set of video IDs confirmed to be embeddable.
    // Falls back to all IDs if network is unavailable.
    func embeddableIDs(for videos: [EducationalVideo]) async -> Set<String> {
        // Return cached result if fresh
        if let cached = loadCache(), isCacheFresh() {
            return cached
        }
        // Run fresh check
        let result = await checkAll(videos)
        saveCache(result)
        return result
    }

    // MARK: - Core check

    private func checkAll(_ videos: [EducationalVideo]) async -> Set<String> {
        var embeddable = Set<String>()
        await withTaskGroup(of: (String, Bool).self) { group in
            for video in videos {
                group.addTask {
                    let ok = await self.isEmbeddable(videoID: video.id)
                    return (video.id, ok)
                }
            }
            for await (id, ok) in group {
                if ok { embeddable.insert(id) }
            }
        }
        // Safety: if all failed (no network), include everything
        return embeddable.isEmpty ? Set(videos.map(\.id)) : embeddable
    }

    private func isEmbeddable(videoID: String) async -> Bool {
        guard let url = URL(string:
            "https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=\(videoID)&format=json"
        ) else { return true }

        do {
            var req = URLRequest(url: url, timeoutInterval: 8)
            req.setValue(
                "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1",
                forHTTPHeaderField: "User-Agent"
            )
            let (_, response) = try await URLSession.shared.data(for: req)
            if let http = response as? HTTPURLResponse {
                // 200 = embeddable, 401 = embedding disabled, 404 = video gone
                return http.statusCode == 200
            }
            return true
        } catch {
            // Network error — assume playable to avoid empty lists
            return true
        }
    }

    // MARK: - Cache

    private func loadCache() -> Set<String>? {
        guard let arr = UserDefaults.standard.stringArray(forKey: cacheKey) else { return nil }
        return Set(arr)
    }

    private func saveCache(_ ids: Set<String>) {
        UserDefaults.standard.set(Array(ids), forKey: cacheKey)
        UserDefaults.standard.set(Date(), forKey: cacheDateKey)
    }

    private func isCacheFresh() -> Bool {
        guard let saved = UserDefaults.standard.object(forKey: cacheDateKey) as? Date else {
            return false
        }
        return Date().timeIntervalSince(saved) < cacheTTL
    }

    // Force a fresh check (call from Settings / parent mode)
    func invalidateCache() {
        UserDefaults.standard.removeObject(forKey: cacheKey)
        UserDefaults.standard.removeObject(forKey: cacheDateKey)
    }
}
