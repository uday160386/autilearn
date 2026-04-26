import os
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
    // Hindi
    case hindiStories     = "Hindi Stories"
    case hindiDevotional  = "Hindi Devotional 🙏"
    // Tamil
    case tamilStories     = "Tamil Stories"
    case tamilDevotional  = "Tamil Devotional 🙏"
    // Kannada
    case kannadaStories   = "Kannada Stories"
    case kannadaDevotional = "Kannada Devotional 🙏"
    // Malayalam
    case malayalamStories  = "Malayalam Stories"
    case malayalamDevotional = "Malayalam Devotional 🙏"
    // Marathi
    case marathiStories   = "Marathi Stories"
    case marathiDevotional = "Marathi Devotional 🙏"
    // Bengali
    case bengaliStories   = "Bengali Stories"
    case bengaliDevotional = "Bengali Devotional 🙏"
    // Gujarati
    case gujaratiStories  = "Gujarati Stories"
    case gujaratiDevotional = "Gujarati Devotional 🙏"
    // Punjabi
    case punjabiStories   = "Punjabi Stories"
    case punjabiDevotional = "Punjabi Devotional 🙏"
    // Sports
    case sportCricket     = "Cricket 🏏"
    case sportBadminton   = "Badminton 🏸"
    case sportSwimming    = "Swimming 🏊"
    case sportAthletics   = "Athletics 🏃"
    case sportBasketball  = "Basketball 🏀"
    case sportTableTennis = "Table Tennis 🏓"
    case sportKabaddi     = "Kabaddi 🤼"
    case sportSkating     = "Ice Skating ⛸️"
    case sportRollerSkating = "Roller Skating 🛼"
    case sportMartialArts = "Martial Arts 🥋"
    // Activities
    case actChess         = "Chess ♟️"
    case actGymnastics    = "Gymnastics 🤸"
    case actDance         = "Dance 💃"
    case actSinging       = "Singing 🎤"
    case actPhotography   = "Photography 📷"
    case actCoding        = "Coding & Robotics 💻"
    case actReading       = "Reading Club 📚"
    case actDrama         = "Drama & Theatre 🎭"
    case actDebate        = "Debate & Speaking 🗣️"
    case actGardening     = "Gardening 🌱"
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
        case .hindiStories, .hindiDevotional:       return "#D85A30"
        case .tamilStories, .tamilDevotional:       return "#D4537E"
        case .kannadaStories, .kannadaDevotional:   return "#BA7517"
        case .malayalamStories, .malayalamDevotional: return "#1D9E75"
        case .marathiStories, .marathiDevotional:   return "#8B2FC9"
        case .bengaliStories, .bengaliDevotional:   return "#185FA5"
        case .gujaratiStories, .gujaratiDevotional: return "#3B6D11"
        case .punjabiStories, .punjabiDevotional:   return "#D85A30"
        case .sportCricket:    return "#185FA5"
        case .sportBadminton:  return "#534AB7"
        case .sportSwimming:   return "#1CA8DD"
        case .sportAthletics:  return "#D85A30"
        case .sportBasketball: return "#BA7517"
        case .sportTableTennis:return "#D4537E"
        case .sportKabaddi:    return "#D85A30"
        case .sportSkating:    return "#185FA5"
        case .sportRollerSkating: return "#1CA8DD"
        case .sportMartialArts:return "#D85A30"
        case .actChess:        return "#3B3B3B"
        case .actGymnastics:   return "#8B2FC9"
        case .actDance:        return "#D4537E"
        case .actSinging:      return "#D85A30"
        case .actPhotography:  return "#3B6D11"
        case .actCoding:       return "#185FA5"
        case .actReading:      return "#534AB7"
        case .actDrama:        return "#D85A30"
        case .actDebate:       return "#185FA5"
        case .actGardening:    return "#3B6D11"
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
        case .teluguDevotional:                       return "hands.sparkles.fill"
        case .hindiStories, .tamilStories, .kannadaStories,
             .malayalamStories, .marathiStories, .bengaliStories,
             .gujaratiStories, .punjabiStories:        return "character.book.closed.fill"
        case .hindiDevotional, .tamilDevotional, .kannadaDevotional,
             .malayalamDevotional, .marathiDevotional, .bengaliDevotional,
             .gujaratiDevotional, .punjabiDevotional:  return "hands.sparkles.fill"
        case .sportCricket, .sportBadminton, .sportSwimming,
             .sportAthletics, .sportBasketball, .sportTableTennis,
             .sportKabaddi:                            return "sportscourt.fill"
        case .sportSkating:    return "figure.skating"
        case .sportRollerSkating: return "figure.skating"
        case .sportMartialArts:return "figure.martial.arts"
        case .actChess:        return "square.grid.3x3.fill"
        case .actGymnastics:   return "figure.gymnastics"
        case .actDance:        return "music.note.list"
        case .actSinging:      return "mic.fill"
        case .actPhotography:  return "camera.fill"
        case .actCoding:       return "laptopcomputer"
        case .actReading:      return "book.fill"
        case .actDrama:        return "theatermasks.fill"
        case .actDebate:       return "bubble.left.and.bubble.right.fill"
        case .actGardening:    return "leaf.fill"
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
    let language: String?       // optional language tag e.g. "hindi", "tamil"

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

    /// Returns videos for a set of selected KidActivity interests.
    static func videos(for activities: Set<KidActivity>) -> [EducationalVideo] {
        let keys = Set(activities.map(\.videoCategory))
        return all.filter { keys.contains(categoryKey($0.category)) }
    }

    /// Returns videos filtered by BOTH language AND activities.
    /// - If a video has an explicit language tag, it must match selectedLanguage.
    /// - If a video has no language tag, it is included for all languages.
    /// - Activity category filter applied on top.
    static func videos(
        for activities: Set<KidActivity>,
        language: IndianLanguage?
    ) -> [EducationalVideo] {
        let keys = Set(activities.map(\.videoCategory))
        return all.filter { video in
            // Must match activity category
            guard keys.contains(categoryKey(video.category)) else { return false }
            // If video has explicit language tag, must match selected language
            if let lang = language, let vLang = video.language {
                return vLang.lowercased() == lang.rawValue.lowercased()
            }
            // No language tag on video — include it (language-neutral content)
            return true
        }
    }

    /// Returns stories + devotional videos filtered by language, with optional activity filter.
    static func languageVideos(
        language: IndianLanguage,
        activities: Set<KidActivity>? = nil
    ) -> [EducationalVideo] {
        let langKey  = language.rawValue.lowercased()
        return all.filter { video in
            // Match by explicit language tag OR by language-named category key
            let catKey = categoryKey(video.category)
            let matchesLang = video.language?.lowercased() == langKey
                || catKey.lowercased().hasPrefix(langKey)
            guard matchesLang else { return false }
            // If activities filter provided, also check category
            if let acts = activities, !acts.isEmpty {
                let actKeys = Set(acts.map(\.videoCategory))
                return actKeys.contains(catKey)
            }
            return true
        }
    }
    /// Falls back to Telugu if no match found.
    static func videos(for language: IndianLanguage) -> [EducationalVideo] {
        let storiesKey    = language.storiesCategory
        let devotionalKey = language.devotionalCategory
        return all.filter { v in
            categoryKey(v.category) == storiesKey ||
            categoryKey(v.category) == devotionalKey
        }
    }

    /// Returns devotional-only videos for a given language.
    static func devotionalVideos(for language: IndianLanguage) -> [EducationalVideo] {
        let key = language.devotionalCategory
        return all.filter { categoryKey($0.category) == key }
    }

    /// Returns stories-only videos for a given language.
    static func storiesVideos(for language: IndianLanguage) -> [EducationalVideo] {
        let key = language.storiesCategory
        return all.filter { categoryKey($0.category) == key }
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
            os_log(.error, "videos.json not found in bundle")
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
                        os_log(.fault, "Unknown video category: %@ for id: %@", entry.category, entry.id)
                        return nil
                    }
                    return EducationalVideo(id: entry.id, title: entry.title,
                                           channel: entry.channel, category: cat,
                                           description: entry.description,
                                           language: entry.language)
                }
                return EducationalVideo(id: entry.id, title: entry.title,
                                        channel: entry.channel, category: category,
                                        description: entry.description,
                                        language: entry.language)
            }
        } catch {
            os_log(.error, "Failed to load videos.json: %@", error.localizedDescription)
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
        case .hindiStories:     return "hindiStories"
        case .hindiDevotional:  return "hindiDevotional"
        case .tamilStories:     return "tamilStories"
        case .tamilDevotional:  return "tamilDevotional"
        case .kannadaStories:   return "kannadaStories"
        case .kannadaDevotional:return "kannadaDevotional"
        case .malayalamStories: return "malayalamStories"
        case .malayalamDevotional: return "malayalamDevotional"
        case .marathiStories:   return "marathiStories"
        case .marathiDevotional:return "marathiDevotional"
        case .bengaliStories:   return "bengaliStories"
        case .bengaliDevotional:return "bengaliDevotional"
        case .gujaratiStories:  return "gujaratiStories"
        case .gujaratiDevotional: return "gujaratiDevotional"
        case .punjabiStories:   return "punjabiStories"
        case .punjabiDevotional:return "punjabiDevotional"
        case .sportCricket:     return "sportCricket"
        case .sportBadminton:   return "sportBadminton"
        case .sportSwimming:    return "sportSwimming"
        case .sportAthletics:   return "sportAthletics"
        case .sportBasketball:  return "sportBasketball"
        case .sportTableTennis: return "sportTableTennis"
        case .sportKabaddi:     return "sportKabaddi"
        case .sportSkating:     return "sportSkating"
        case .sportRollerSkating: return "sportRollerSkating"
        case .sportMartialArts: return "sportMartialArts"
        case .actChess:         return "actChess"
        case .actGymnastics:    return "actGymnastics"
        case .actDance:         return "actDance"
        case .actSinging:       return "actSinging"
        case .actPhotography:   return "actPhotography"
        case .actCoding:        return "actCoding"
        case .actReading:       return "actReading"
        case .actDrama:         return "actDrama"
        case .actDebate:        return "actDebate"
        case .actGardening:     return "actGardening"
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
        let language: String?     // optional e.g. "hindi", "tamil"

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
                "hindiStories":     "Hindi Stories",
                "hindiDevotional":  "Hindi Devotional 🙏",
                "tamilStories":     "Tamil Stories",
                "tamilDevotional":  "Tamil Devotional 🙏",
                "kannadaStories":   "Kannada Stories",
                "kannadaDevotional":"Kannada Devotional 🙏",
                "malayalamStories": "Malayalam Stories",
                "malayalamDevotional":"Malayalam Devotional 🙏",
                "marathiStories":   "Marathi Stories",
                "marathiDevotional":"Marathi Devotional 🙏",
                "bengaliStories":   "Bengali Stories",
                "bengaliDevotional":"Bengali Devotional 🙏",
                "gujaratiStories":  "Gujarati Stories",
                "gujaratiDevotional":"Gujarati Devotional 🙏",
                "punjabiStories":   "Punjabi Stories",
                "punjabiDevotional":"Punjabi Devotional 🙏",
                "sportCricket":     "Cricket 🏏",
                "sportBadminton":   "Badminton 🏸",
                "sportSwimming":    "Swimming 🏊",
                "sportAthletics":   "Athletics 🏃",
                "sportBasketball":  "Basketball 🏀",
                "sportTableTennis": "Table Tennis 🏓",
                "sportKabaddi":     "Kabaddi 🤼",
                "sportSkating":     "Ice Skating ⛸️",
                "sportRollerSkating":"Roller Skating 🛼",
                "sportMartialArts": "Martial Arts 🥋",
                "actChess":         "Chess ♟️",
                "actGymnastics":    "Gymnastics 🤸",
                "actDance":         "Dance 💃",
                "actSinging":       "Singing 🎤",
                "actPhotography":   "Photography 📷",
                "actCoding":        "Coding & Robotics 💻",
                "actReading":       "Reading Club 📚",
                "actDrama":         "Drama & Theatre 🎭",
                "actDebate":        "Debate & Speaking 🗣️",
                "actGardening":     "Gardening 🌱",
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
