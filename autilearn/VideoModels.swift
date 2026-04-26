import Foundation
import SwiftUI
import SwiftData

// MARK: - Watch History (SwiftData)

@Model
class VideoWatchRecord {
    var id: UUID
    var videoID: String
    var videoTitle: String
    var videoChannel: String
    var categoryRaw: String
    var watchedAt: Date

    init(video: EducationalVideo) {
        self.id           = UUID()
        self.videoID      = video.id
        self.videoTitle   = video.title
        self.videoChannel = video.channel
        self.categoryRaw  = video.category.rawValue
        self.watchedAt    = Date()
    }
}

// MARK: - Video category

enum VideoCategory: String, CaseIterable {
    case all              = "All"
    case autism           = "Autism Support"
    case yoga             = "Yoga & Exercise"
    case socialSkills     = "Social Skills"
    case communication    = "Communication"
    case cooking          = "Cooking"
    case sports           = "Sports"
    case math             = "Math"
    case science          = "Science"
    case experiments      = "Experiments"
    case music            = "Music & Relax"
    case arts             = "Art & Crafts"
    case activities       = "Activities"
    case telugu           = "Telugu Stories 🇮🇳"
    case teluguDevotional = "Telugu Devotional 🙏"
    case measurements     = "Measurements"

    var colorHex: String {
        switch self {
        case .all:              return "#888888"
        case .autism:           return "#D4537E"
        case .yoga:             return "#1D9E75"
        case .socialSkills:     return "#534AB7"
        case .communication:    return "#5DCAA5"
        case .cooking:          return "#D85A30"
        case .sports:           return "#185FA5"
        case .math:             return "#BA7517"
        case .science:          return "#3B6D11"
        case .experiments:      return "#8B5E3C"
        case .music:            return "#3B79BA"
        case .arts:             return "#C074C2"
        case .activities:       return "#1CA8DD"
        case .telugu:           return "#FF6B35"
        case .teluguDevotional: return "#8B2FC9"
        case .measurements:     return "#185FA5"
        }
    }

    var icon: String {
        switch self {
        case .all:              return "square.grid.2x2"
        case .autism:           return "heart.fill"
        case .yoga:             return "figure.mind.and.body"
        case .socialSkills:     return "person.2.fill"
        case .communication:    return "bubble.left.and.bubble.right.fill"
        case .cooking:          return "fork.knife"
        case .sports:           return "figure.run"
        case .math:             return "function"
        case .science:          return "atom"
        case .experiments:      return "flask.fill"
        case .music:            return "music.note"
        case .arts:             return "paintpalette.fill"
        case .activities:       return "figure.walk"
        case .telugu:           return "character.book.closed.fill"
        case .teluguDevotional: return "hands.sparkles.fill"
        case .measurements:     return "ruler.fill"
        }
    }
}

// MARK: - Video model

struct EducationalVideo: Identifiable, Hashable {
    let id: String
    let title: String
    let channel: String
    let category: VideoCategory
    let description: String

    var thumbnailURL: URL? { URL(string: "https://img.youtube.com/vi/\(id)/hqdefault.jpg") }
    var watchURL: URL?     { URL(string: "https://www.youtube.com/watch?v=\(id)") }
    var embedURL: URL?     { URL(string: "https://www.youtube.com/embed/\(id)?playsinline=1&autoplay=0&rel=0&modestbranding=1&enablejsapi=1") }
}

// MARK: - JSON loading

extension EducationalVideo {

    /// All videos loaded from videos.json in the app bundle.
    static let all: [EducationalVideo] = loadFromJSON()

    /// Videos filtered to only those confirmed embeddable (updated async on launch).
    /// Falls back to `all` until the availability check completes.
    @MainActor
    static var available: [EducationalVideo] {
        let ids = VideoAvailabilityStore.shared.embeddableIDs
        guard !ids.isEmpty else { return all }
        return all.filter { ids.contains($0.id) }
    }

    static func dailyVideos(count: Int = 6) -> [EducationalVideo] {
        let pool = VideoAvailabilityStore.shared.embeddableIDs.isEmpty
            ? all
            : all.filter { VideoAvailabilityStore.shared.embeddableIDs.contains($0.id) }
        let cal = Calendar.current
        let dayOfYear = cal.ordinality(of: .day, in: .year, for: Date()) ?? 1
        var rng = SeededGenerator(seed: dayOfYear)
        return pool.shuffled(using: &rng).prefix(count).map { $0 }
    }

    // MARK: Private JSON loader

    private static func loadFromJSON() -> [EducationalVideo] {
        guard let url = Bundle.main.url(forResource: "videos", withExtension: "json") else {
            print("⚠️  videos.json not found in bundle")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let payload = try JSONDecoder().decode(VideoPayload.self, from: data)
            return payload.videos.compactMap { entry in
                guard let category = VideoCategory(rawValue: entry.categoryDisplay) else {
                    // Try matching by case key
                    let matched = VideoCategory.allCases.first {
                        $0.rawValue.lowercased() == entry.category.lowercased() ||
                        categoryKey($0) == entry.category
                    }
                    guard let cat = matched else {
                        print("⚠️  Unknown category '\(entry.category)' for video \(entry.id)")
                        return nil
                    }
                    return EducationalVideo(id: entry.id, title: entry.title,
                                           channel: entry.channel, category: cat,
                                           description: entry.description)
                }
                return EducationalVideo(id: entry.id, title: entry.title,
                                        channel: entry.channel, category: category,
                                        description: entry.description)
            }
        } catch {
            print("⚠️  Failed to load videos.json: \(error)")
            return []
        }
    }

    /// Maps a VideoCategory to the JSON key string used in the file.
    private static func categoryKey(_ cat: VideoCategory) -> String {
        switch cat {
        case .all:              return "all"
        case .autism:           return "autism"
        case .yoga:             return "yoga"
        case .socialSkills:     return "socialSkills"
        case .communication:    return "communication"
        case .cooking:          return "cooking"
        case .sports:           return "sports"
        case .math:             return "math"
        case .science:          return "science"
        case .experiments:      return "experiments"
        case .music:            return "music"
        case .arts:             return "arts"
        case .activities:       return "activities"
        case .telugu:           return "telugu"
        case .teluguDevotional: return "teluguDevotional"
        case .measurements:     return "measurements"
        }
    }

    // MARK: - Codable helpers

    private struct VideoPayload: Decodable {
        let version: Int
        let videos: [VideoEntry]
    }

    private struct VideoEntry: Decodable {
        let id: String
        let title: String
        let channel: String
        let category: String      // key e.g. "autism"
        let description: String

        /// Attempt to match rawValue display strings too (e.g. "Autism Support")
        var categoryDisplay: String {
            // Map known display names → rawValue for VideoCategory
            let map: [String: String] = [
                "autism":           "Autism Support",
                "yoga":             "Yoga & Exercise",
                "socialSkills":     "Social Skills",
                "communication":    "Communication",
                "cooking":          "Cooking",
                "sports":           "Sports",
                "math":             "Math",
                "science":          "Science",
                "experiments":      "Experiments",
                "music":            "Music & Relax",
                "arts":             "Art & Crafts",
                "activities":       "Activities",
                "telugu":           "Telugu Stories 🇮🇳",
                "teluguDevotional":  "Telugu Devotional 🙏",
                "measurements":     "Measurements",
                "all":              "All",
            ]
            return map[category] ?? category
        }
    }
}

// MARK: - Deterministic seeded shuffle

struct SeededGenerator: RandomNumberGenerator {
    var state: UInt64
    init(seed: Int) {
        state = UInt64(bitPattern: Int64(seed &* 6364136223846793005 &+ 1442695040888963407))
    }
    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
}

// MARK: - Observable availability store (drives UI updates)

@MainActor
@Observable
final class VideoAvailabilityStore {
    static let shared = VideoAvailabilityStore()
    private(set) var embeddableIDs: Set<String> = []
    private(set) var isChecking = false

    func refresh() {
        guard !isChecking else { return }
        isChecking = true
        Task {
            let ids = await VideoAvailabilityChecker.shared.embeddableIDs(for: EducationalVideo.all)
            self.embeddableIDs = ids
            self.isChecking = false
        }
    }

    func forceRefresh() {
        Task { await VideoAvailabilityChecker.shared.invalidateCache() }
        embeddableIDs = []
        refresh()
    }
}
