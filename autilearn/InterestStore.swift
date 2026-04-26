import Foundation
import SwiftUI

// MARK: - Sports & Extracurricular Activity

enum KidActivity: String, CaseIterable, Identifiable {

    // ── Sports ──────────────────────────────────────
    case cricket      = "Cricket"
    case football     = "Football"
    case badminton    = "Badminton"
    case swimming     = "Swimming"
    case athletics    = "Athletics"
    case basketball   = "Basketball"
    case tabletennis  = "Table Tennis"
    case chess        = "Chess"
    case kabaddi      = "Kabaddi"
    case gymnastics   = "Gymnastics"
    case skating      = "Ice Skating"
    case rollerSkating = "Roller Skating"
    case martialArts  = "Martial Arts"

    // ── Arts & Creative ─────────────────────────────
    case drawing      = "Drawing & Painting"
    case music        = "Music & Instruments"
    case dance        = "Dance"
    case singing      = "Singing"
    case photography  = "Photography"

    // ── Learning & STEM ─────────────────────────────
    case coding       = "Coding & Robotics"
    case science      = "Science Club"
    case maths        = "Maths Olympiad"
    case reading      = "Reading & Story Club"

    // ── Performing & Social ─────────────────────────
    case drama        = "Drama & Theatre"
    case debate       = "Debate & Public Speaking"
    case yoga         = "Yoga & Meditation"
    case cooking      = "Cooking & Baking"
    case gardening    = "Gardening & Nature"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .cricket:     return "🏏"
        case .football:    return "⚽"
        case .badminton:   return "🏸"
        case .swimming:    return "🏊"
        case .athletics:   return "🏃"
        case .basketball:  return "🏀"
        case .tabletennis: return "🏓"
        case .chess:       return "♟️"
        case .kabaddi:     return "🤼"
        case .skating:      return "⛸️"
        case .rollerSkating:return "🛼"
        case .martialArts:  return "🥋"
        case .gymnastics:  return "🤸"
        case .drawing:     return "🎨"
        case .music:       return "🎵"
        case .dance:       return "💃"
        case .singing:     return "🎤"
        case .photography: return "📷"
        case .coding:      return "💻"
        case .science:     return "🔬"
        case .maths:       return "🔢"
        case .reading:     return "📚"
        case .drama:       return "🎭"
        case .debate:      return "🗣️"
        case .yoga:        return "🧘"
        case .cooking:     return "🍳"
        case .gardening:   return "🌱"
        }
    }

    var colorHex: String {
        switch self {
        // Sports — blues / greens
        case .cricket:     return "#185FA5"
        case .football:    return "#1D9E75"
        case .badminton:   return "#534AB7"
        case .swimming:    return "#1CA8DD"
        case .athletics:   return "#D85A30"
        case .basketball:  return "#BA7517"
        case .tabletennis: return "#D4537E"
        case .chess:       return "#3B3B3B"
        case .kabaddi:     return "#D85A30"
        case .skating:     return "#185FA5"
        case .rollerSkating: return "#1CA8DD"
        case .martialArts: return "#D85A30"
        case .gymnastics:  return "#8B2FC9"
        // Arts
        case .drawing:     return "#C074C2"
        case .music:       return "#534AB7"
        case .dance:       return "#D4537E"
        case .singing:     return "#D85A30"
        case .photography: return "#3B6D11"
        // STEM
        case .coding:      return "#185FA5"
        case .science:     return "#1D9E75"
        case .maths:       return "#BA7517"
        case .reading:     return "#534AB7"
        // Performing
        case .drama:       return "#D85A30"
        case .debate:      return "#185FA5"
        case .yoga:        return "#1D9E75"
        case .cooking:     return "#BA7517"
        case .gardening:   return "#3B6D11"
        }
    }

    var group: ActivityGroup {
        switch self {
        case .cricket, .football, .badminton, .swimming,
             .athletics, .basketball, .tabletennis, .chess,
             .kabaddi, .gymnastics, .skating, .rollerSkating, .martialArts:
            return .sports
        case .drawing, .music, .dance, .singing, .photography:
            return .arts
        case .coding, .science, .maths, .reading:
            return .stem
        case .drama, .debate, .yoga, .cooking, .gardening:
            return .performing
        }
    }

    /// JSON video category key for this activity
    var videoCategory: String {
        switch self {
        case .cricket:     return "sportCricket"
        case .football:    return "sports"           // reuse existing
        case .badminton:   return "sportBadminton"
        case .swimming:    return "sportSwimming"
        case .athletics:   return "sportAthletics"
        case .basketball:  return "sportBasketball"
        case .tabletennis: return "sportTableTennis"
        case .chess:       return "actChess"
        case .kabaddi:     return "sportKabaddi"
        case .skating:      return "sportSkating"
        case .rollerSkating:return "sportRollerSkating"
        case .martialArts:  return "sportMartialArts"
        case .gymnastics:  return "actGymnastics"
        case .drawing:     return "arts"             // reuse existing
        case .music:       return "music"            // reuse existing
        case .dance:       return "actDance"
        case .singing:     return "actSinging"
        case .photography: return "actPhotography"
        case .coding:      return "actCoding"
        case .science:     return "science"          // reuse existing
        case .maths:       return "math"             // reuse existing
        case .reading:     return "actReading"
        case .drama:       return "actDrama"
        case .debate:      return "actDebate"
        case .yoga:        return "yoga"             // reuse existing
        case .cooking:     return "cooking"          // reuse existing
        case .gardening:   return "actGardening"
        }
    }
}

enum ActivityGroup: String, CaseIterable {
    case sports     = "Sports"
    case arts       = "Arts & Creative"
    case stem       = "Learning & STEM"
    case performing = "Performing & Social"

    var emoji: String {
        switch self {
        case .sports:     return "⚽"
        case .arts:       return "🎨"
        case .stem:       return "🔬"
        case .performing: return "🎭"
        }
    }
}

// MARK: - Interest Store
// Session memory only — resets when app is killed.

@MainActor
@Observable
final class InterestStore {
    static let shared = InterestStore()

    /// Multi-select — user can pick multiple activities
    var selectedActivities: Set<KidActivity> = []

    var hasSelections: Bool { !selectedActivities.isEmpty }

    var displaySummary: String {
        if selectedActivities.isEmpty { return "Tap to choose activities" }
        if selectedActivities.count == 1 { return selectedActivities.first!.rawValue }
        return "\(selectedActivities.count) activities selected"
    }

    func toggle(_ activity: KidActivity) {
        if selectedActivities.contains(activity) {
            selectedActivities.remove(activity)
        } else {
            selectedActivities.insert(activity)
        }
    }

    func clearAll() { selectedActivities = [] }

    /// Video category keys for all selected activities
    var videoCategoryKeys: [String] {
        selectedActivities.map(\.videoCategory)
    }
}
