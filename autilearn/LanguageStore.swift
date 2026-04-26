import Foundation
import SwiftUI

// MARK: - Indian Language

enum IndianLanguage: String, CaseIterable, Identifiable {
    case telugu    = "Telugu"
    case hindi     = "Hindi"
    case tamil     = "Tamil"
    case kannada   = "Kannada"
    case malayalam = "Malayalam"
    case marathi   = "Marathi"
    case bengali   = "Bengali"
    case gujarati  = "Gujarati"
    case punjabi   = "Punjabi"
    case odia      = "Odia"
    case assamese  = "Assamese"
    case urdu      = "Urdu"

    var id: String { rawValue }

    var nativeName: String {
        switch self {
        case .telugu:    return "తెలుగు"
        case .hindi:     return "हिन्दी"
        case .tamil:     return "தமிழ்"
        case .kannada:   return "ಕನ್ನಡ"
        case .malayalam: return "മലയാളം"
        case .marathi:   return "मराठी"
        case .bengali:   return "বাংলা"
        case .gujarati:  return "ગુજરાતી"
        case .punjabi:   return "ਪੰਜਾਬੀ"
        case .odia:      return "ଓଡ଼ିଆ"
        case .assamese:  return "অসমীয়া"
        case .urdu:      return "اردو"
        }
    }

    var flag: String {
        // All Indian languages share 🇮🇳, so we use script icons
        switch self {
        case .telugu:    return "🔵"
        case .hindi:     return "🟠"
        case .tamil:     return "🔴"
        case .kannada:   return "🟡"
        case .malayalam: return "🟢"
        case .marathi:   return "🟣"
        case .bengali:   return "🟤"
        case .gujarati:  return "⚫"
        case .punjabi:   return "⚪"
        case .odia:      return "🔵"
        case .assamese:  return "🟠"
        case .urdu:      return "🟢"
        }
    }

    var colorHex: String {
        switch self {
        case .telugu:    return "#534AB7"
        case .hindi:     return "#D85A30"
        case .tamil:     return "#D4537E"
        case .kannada:   return "#BA7517"
        case .malayalam: return "#1D9E75"
        case .marathi:   return "#8B2FC9"
        case .bengali:   return "#185FA5"
        case .gujarati:  return "#3B6D11"
        case .punjabi:   return "#D85A30"
        case .odia:      return "#1CA8DD"
        case .assamese:  return "#D4537E"
        case .urdu:      return "#1D9E75"
        }
    }

    /// The JSON category key for stories videos in this language
    var storiesCategory: String { rawValue.lowercased() + "Stories" }

    /// The JSON category key for devotional videos in this language
    var devotionalCategory: String { rawValue.lowercased() + "Devotional" }
}

// MARK: - Language Store
// Stored in memory only (temp) — resets when app is killed.
// This is intentional per requirements: no persistence, just session memory.

@MainActor
@Observable
final class LanguageStore {
    static let shared = LanguageStore()

    /// Currently selected language — nil means no preference (show all)
    var selectedLanguage: IndianLanguage? = nil

    var displayName: String {
        selectedLanguage.map { "\($0.rawValue) (\($0.nativeName))" } ?? "Select Language"
    }

    var hasSelection: Bool { selectedLanguage != nil }
}
