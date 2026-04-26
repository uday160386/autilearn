import Foundation
import SwiftData

enum SymbolCategory: String, Codable, CaseIterable {
    case feelings, actions, needs, people, places

    var colorHex: String {
        switch self {
        case .feelings: return "#1D9E75"
        case .actions:  return "#534AB7"
        case .needs:    return "#BA7517"
        case .people:   return "#D4537E"
        case .places:   return "#185FA5"
        }
    }

    var displayName: String { rawValue.capitalized }
}

@Model
class AACSymbol {
    var id: UUID
    var word: String
    var emoji: String
    var imageName: String?
    var category: SymbolCategory
    var position: Int
    var usageCount: Int
    var youtubeURL: String?

    init(word: String, emoji: String, category: SymbolCategory, position: Int, youtubeURL: String? = nil) {
        self.id         = UUID()
        self.word       = word
        self.emoji      = emoji
        self.category   = category
        self.position   = position
        self.usageCount = 0
        self.youtubeURL = youtubeURL
    }
}
