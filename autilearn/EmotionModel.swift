import Foundation
import SwiftUI
import SwiftData

// MARK: - Core emotion types (expanded to 20)

enum Emotion: String, CaseIterable, Codable {
    case happy, sad, angry, scared, surprised, calm,
         excited, proud, worried, bored, grateful, lonely,
         disgusted, confused, embarrassed, jealous, frustrated, hopeful, shy, tired

    var displayName: String { rawValue.capitalized }

    var realPhotoURL: String {
        switch self {
        case .happy:        return "https://images.unsplash.com/photo-1489710437720-ebb67ec84dd2?w=400&q=80"
        case .sad:          return "https://images.unsplash.com/photo-1541216970279-affbfdd55aa8?w=400&q=80"
        case .angry:        return "https://images.unsplash.com/photo-1594751543129-6701ad444259?w=400&q=80"
        case .scared:       return "https://images.unsplash.com/photo-1617791160505-6f00504e3519?w=400&q=80"
        case .surprised:    return "https://images.unsplash.com/photo-1607453998774-d533f65dac99?w=400&q=80"
        case .calm:         return "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400&q=80"
        case .excited:      return "https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=400&q=80"
        case .proud:        return "https://images.unsplash.com/photo-1531844251246-29acf1f17b73?w=400&q=80"
        case .worried:      return "https://images.unsplash.com/photo-1557804506-669a67965ba0?w=400&q=80"
        case .bored:        return "https://images.unsplash.com/photo-1493836512294-502baa1986e2?w=400&q=80"
        case .grateful:     return "https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=400&q=80"
        case .lonely:       return "https://images.unsplash.com/photo-1542596594-649edbc13630?w=400&q=80"
        case .disgusted:    return "https://images.unsplash.com/photo-1521566652839-697aa473761a?w=400&q=80"
        case .confused:     return "https://images.unsplash.com/photo-1504703395950-b89145a5425b?w=400&q=80"
        case .embarrassed:  return "https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400&q=80"
        case .jealous:      return "https://images.unsplash.com/photo-1498019559366-a1cbd07b5160?w=400&q=80"
        case .frustrated:   return "https://images.unsplash.com/photo-1534385842125-8a776c4a2019?w=400&q=80"
        case .hopeful:      return "https://images.unsplash.com/photo-1469571486292-0ba58a3f068b?w=400&q=80"
        case .shy:          return "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=400&q=80"
        case .tired:        return "https://images.unsplash.com/photo-1484626080767-0b4e5c31e2a8?w=400&q=80"
        }
    }

    // YouTube video demonstrating each emotion
    var emotionVideoID: String {
        switch self {
        case .happy:        return "y6Sxv-sUYtM"
        case .sad:          return "nQ5-pTCJtAo"
        case .angry:        return "RdLrHEBh0eE"
        case .scared:       return "5nT1bQ_TMxQ"
        case .surprised:    return "QKXW6XGvC8E"
        case .calm:         return "KMaOeFQQkJM"
        case .excited:      return "IanMGGN1JAI"
        case .proud:        return "hHCNqzJxb0M"
        case .worried:      return "0Wg9Lh5HNCA"
        case .bored:        return "NRrpY7KZROU"
        case .grateful:     return "2OEL4P1Rz04"
        case .lonely:       return "Ud9i4-LHxlQ"
        case .disgusted:    return "GN1nRuQxHos"
        case .confused:     return "gHHGovFD2R0"
        case .embarrassed:  return "7OIvIZ5U_Yk"
        case .jealous:      return "RMbkfMDgVEE"
        case .frustrated:   return "7bxwnXjhXHI"
        case .hopeful:      return "LLqsBKjLRkI"
        case .shy:          return "vG1rVhP2JsE"
        case .tired:        return "UKtLSSXPiRo"
        }
    }

    var description: String {
        switch self {
        case .happy:        return "Your face lights up, eyes crinkle, mouth curves into a big smile"
        case .sad:          return "Eyes droop, corners of mouth turn down, you might feel like crying"
        case .angry:        return "Eyebrows pull together and down, jaw tightens, face feels hot"
        case .scared:       return "Eyes open very wide, eyebrows shoot up, heart beats fast"
        case .surprised:    return "Eyes and mouth both open wide — something unexpected happened!"
        case .calm:         return "Face is relaxed, breathing is slow and easy, everything feels peaceful"
        case .excited:      return "Eyes wide and bright, big smile, bouncing energy inside"
        case .proud:        return "Standing tall, chest out, big smile — you did something great!"
        case .worried:      return "Eyebrows furrowed, thinking about something that might go wrong"
        case .bored:        return "Flat face, half-closed eyes, sighing — nothing feels interesting"
        case .grateful:     return "Warm feeling in your chest, smiling softly, thankful for something"
        case .lonely:       return "Quiet and still, wishing someone was nearby to be with you"
        case .disgusted:    return "Nose wrinkles, mouth turns down, you really don't like something"
        case .confused:     return "Head tilts, eyebrows scrunch together, you're not sure what's happening"
        case .embarrassed:  return "Cheeks feel warm and red, you want to hide — it's okay, everyone feels this!"
        case .jealous:      return "You wish you had what someone else has — a tight feeling in your chest"
        case .frustrated:   return "You've tried but it's not working — tight feeling, might want to give up"
        case .hopeful:      return "Looking forward to something good — a warm, light feeling inside"
        case .shy:          return "You feel unsure around new people — your voice gets quiet, you look away"
        case .tired:        return "Heavy eyes, slow body, everything takes more effort than usual"
        }
    }

    var color: Color {
        switch self {
        case .happy:        return Color(hex: "1D9E75")
        case .sad:          return Color(hex: "185FA5")
        case .angry:        return Color(hex: "D85A30")
        case .scared:       return Color(hex: "534AB7")
        case .surprised:    return Color(hex: "BA7517")
        case .calm:         return Color(hex: "5DCAA5")
        case .excited:      return Color(hex: "BA7517")
        case .proud:        return Color(hex: "1D9E75")
        case .worried:      return Color(hex: "534AB7")
        case .bored:        return Color(hex: "888888")
        case .grateful:     return Color(hex: "D4537E")
        case .lonely:       return Color(hex: "185FA5")
        case .disgusted:    return Color(hex: "3B6D11")
        case .confused:     return Color(hex: "8B5E3C")
        case .embarrassed:  return Color(hex: "D4537E")
        case .jealous:      return Color(hex: "D85A30")
        case .frustrated:   return Color(hex: "D85A30")
        case .hopeful:      return Color(hex: "1CA8DD")
        case .shy:          return Color(hex: "C074C2")
        case .tired:        return Color(hex: "888888")
        }
    }

    var instruction: String {
        switch self {
        case .happy:        return "Think of something that makes you smile. Can you make a happy face?"
        case .sad:          return "Think of something that makes you feel sad. Can you make a sad face?"
        case .angry:        return "Think of a time something felt unfair. Can you make an angry face?"
        case .scared:       return "Think of something a little spooky. Can you make a scared face?"
        case .surprised:    return "Imagine something totally unexpected happened! Can you look surprised?"
        case .calm:         return "Take a deep breath. Relax your face. Can you look calm and peaceful?"
        case .excited:      return "Think of something amazing happening! Can you look excited?"
        case .proud:        return "Stand tall and think of something you did well. Show proud!"
        case .worried:      return "Furrow your brows a little and look thoughtful. Show worried."
        case .bored:        return "Let your face go flat and droopy. Look bored."
        case .grateful:     return "Think of someone who helps you. Show a warm grateful smile."
        case .lonely:       return "Look quietly to the side. Show lonely."
        case .disgusted:    return "Wrinkle your nose like something smells bad. Show disgusted."
        case .confused:     return "Tilt your head and scrunch your eyebrows. Show confused."
        case .embarrassed:  return "Cover your cheeks and look a little down. Show embarrassed."
        case .jealous:      return "Look at something and wish it was yours. Show jealous."
        case .frustrated:   return "Clench your fists gently and look tense. Show frustrated."
        case .hopeful:      return "Look up with soft eyes and a small smile. Show hopeful."
        case .shy:          return "Tuck your chin down a little and look sideways. Show shy."
        case .tired:        return "Let your eyes droop and your shoulders drop. Show tired."
        }
    }

    var audioPrompt: String {
        switch self {
        case .happy:        return "Great! Now smile and make your eyes crinkle. Happy!"
        case .sad:          return "Let your face droop a little. That's it. Sad."
        case .angry:        return "Pull your eyebrows together. Angry!"
        case .scared:       return "Open your eyes wide. Scared!"
        case .surprised:    return "Open your mouth and eyes big. Surprised!"
        case .calm:         return "Relax everything. Breathe slowly. Calm."
        case .excited:      return "Big eyes and a huge smile! Excited!"
        case .proud:        return "Stand tall. Smile wide. You did it! Proud!"
        case .worried:      return "Furrowed brows, thinking. Worried."
        case .bored:        return "Flat face, half-closed eyes. Bored."
        case .grateful:     return "Warm smile, eyes soft. Grateful."
        case .lonely:       return "Quiet and still. Lonely. But you are not alone."
        case .disgusted:    return "Wrinkle your nose. Disgusted."
        case .confused:     return "Tilt your head and scrunch up. Confused."
        case .embarrassed:  return "Warm cheeks, look down. Embarrassed. It's okay!"
        case .jealous:      return "That tight feeling when you want what they have. Jealous."
        case .frustrated:   return "You've tried hard. It's okay to feel frustrated."
        case .hopeful:      return "Look ahead with a soft smile. Hopeful!"
        case .shy:          return "Quiet voice, looking away a little. Shy."
        case .tired:        return "Heavy eyes, slow breathing. Tired."
        }
    }

    var emoji: String {
        switch self {
        case .happy:        return "😊"
        case .sad:          return "😢"
        case .angry:        return "😠"
        case .scared:       return "😨"
        case .surprised:    return "😲"
        case .calm:         return "😌"
        case .excited:      return "🤩"
        case .proud:        return "😤"
        case .worried:      return "😟"
        case .bored:        return "😑"
        case .grateful:     return "🙏"
        case .lonely:       return "🥺"
        case .disgusted:    return "🤢"
        case .confused:     return "😕"
        case .embarrassed:  return "😳"
        case .jealous:      return "😒"
        case .frustrated:   return "😤"
        case .hopeful:      return "🌟"
        case .shy:          return "😶"
        case .tired:        return "😴"
        }
    }
}

// MARK: - Game modes
enum GameMode: String, CaseIterable {
    case learn, identify, match
    var displayName: String {
        switch self {
        case .learn:    return "Learn"
        case .identify: return "Identify"
        case .match:    return "Match"
        }
    }
    var icon: String {
        switch self {
        case .learn:    return "face.smiling"
        case .identify: return "questionmark.circle"
        case .match:    return "link"
        }
    }
}

// MARK: - SwiftData models

@Model
class EmotionAttempt {
    var id: UUID
    var emotion: Emotion
    var wasCorrect: Bool
    var timestamp: Date
    var gameMode: String
    init(emotion: Emotion, wasCorrect: Bool, gameMode: GameMode) {
        self.id         = UUID()
        self.emotion    = emotion
        self.wasCorrect = wasCorrect
        self.timestamp  = Date()
        self.gameMode   = gameMode.rawValue
    }
}

@Model
class RewardToken {
    var id: UUID
    var earnedAt: Date
    var reason: String
    init(reason: String) {
        self.id       = UUID()
        self.earnedAt = Date()
        self.reason   = reason
    }
}
