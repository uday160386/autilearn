import Foundation
import os

// MARK: - AI Service
//
// Calls the Anthropic API using the key fetched from RemoteConfig (Supabase).
// The key is never bundled — it lives in your database and is fetched at launch.

enum AIServiceError: LocalizedError {
    case keyNotAvailable
    case networkError(String)
    case serverError(Int, String)

    var errorDescription: String? {
        switch self {
        case .keyNotAvailable:       return "AI service not available"
        case .networkError(let m):   return m
        case .serverError(let c, _): return "Server error \(c)"
        }
    }
}

actor AIService {

    static let shared = AIService()

    func chat(
        prompt: String,
        systemPrompt: String = "You are a kind, gentle helper for a child who may have autism. Reply in 1-2 short, simple, encouraging sentences. Be warm and supportive. Never say anything negative.",
        maxTokens: Int = 150
    ) async throws -> String {

        let key = await MainActor.run { RemoteConfig.shared.anthropicAPIKey }

        guard !key.isEmpty else {
            os_log(.error, "AIService: no API key — RemoteConfig not loaded yet")
            throw AIServiceError.keyNotAvailable
        }

        guard let url = URL(string: "https://api.anthropic.com/v1/messages") else {
            throw AIServiceError.networkError("Invalid URL")
        }

        var req = URLRequest(url: url, timeoutInterval: 15)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(key,                forHTTPHeaderField: "x-api-key")
        req.setValue("2023-06-01",       forHTTPHeaderField: "anthropic-version")

        let body: [String: Any] = [
            "model"     : "claude-haiku-4-5-20251001",
            "max_tokens": maxTokens,
            "system"    : systemPrompt,
            "messages"  : [["role": "user", "content": prompt]]
        ]
        req.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: req)

        guard let http = response as? HTTPURLResponse else {
            throw AIServiceError.networkError("Non-HTTP response")
        }
        guard (200..<300).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? ""
            os_log(.error, "AIService: HTTP %d — %@", http.statusCode, body)
            throw AIServiceError.serverError(http.statusCode, body)
        }

        guard
            let json    = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let content = json["content"] as? [[String: Any]],
            let text    = content.first?["text"] as? String
        else {
            throw AIServiceError.networkError("Unexpected response format")
        }

        return text
    }

    /// Non-throwing convenience — returns friendly fallback text on any error.
    func chatSafe(prompt: String) async -> String {
        do {
            return try await chat(prompt: prompt)
        } catch AIServiceError.keyNotAvailable {
            return "Keep going — you're doing great! 💛"
        } catch {
            os_log(.error, "AIService: %@", error.localizedDescription)
            return "You're doing wonderfully! 🌟"
        }
    }
}
