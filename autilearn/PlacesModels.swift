import Foundation
import SwiftUI
import MapKit

// MARK: - Country

enum PlaceCountry: String, CaseIterable, Identifiable {
    case india     = "India"
    case singapore = "Singapore"
    case japan     = "Japan"
    case thailand  = "Thailand"

    var id: String { rawValue }

    var flag: String {
        switch self {
        case .india:     return "🇮🇳"
        case .singapore: return "🇸🇬"
        case .japan:     return "🇯🇵"
        case .thailand:  return "🇹🇭"
        }
    }

    var colorHex: String {
        switch self {
        case .india:     return "#D85A30"
        case .singapore: return "#D4537E"
        case .japan:     return "#D85A30"
        case .thailand:  return "#BA7517"
        }
    }

    var mapCenter: CLLocationCoordinate2D {
        switch self {
        case .india:     return CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629)
        case .singapore: return CLLocationCoordinate2D(latitude: 1.3521,  longitude: 103.8198)
        case .japan:     return CLLocationCoordinate2D(latitude: 36.2048, longitude: 138.2529)
        case .thailand:  return CLLocationCoordinate2D(latitude: 15.8700, longitude: 100.9925)
        }
    }
}

// MARK: - Place type

enum PlaceType: String {
    case monument    = "Monument"
    case landmark    = "Landmark"
    case temple      = "Temple"
    case palace      = "Palace"
    case nature      = "Nature"
    case wildlife    = "Wildlife"
    case themePark   = "Theme Park"
    case market      = "Market"
    case memorial    = "Memorial"

    var colorHex: String {
        switch self {
        case .monument:   return "#534AB7"
        case .landmark:   return "#185FA5"
        case .temple:     return "#D85A30"
        case .palace:     return "#BA7517"
        case .nature:     return "#1D9E75"
        case .wildlife:   return "#3B6D11"
        case .themePark:  return "#D4537E"
        case .market:     return "#BA7517"
        case .memorial:   return "#888888"
        }
    }
}

// MARK: - Tourist place

struct TouristPlace: Identifiable {
    let id = UUID()
    let country: PlaceCountry
    let name: String
    let city: String
    let type: PlaceType
    let emoji: String
    let photoURL: String       // Wikipedia / Wikimedia URL
    let headline: String       // 1-sentence kid-friendly description
    let description: String    // 2–3 sentence deeper explanation
    let facts: [(label: String, value: String)]
    let coordinate: CLLocationCoordinate2D
}

extension TouristPlace {
    static let all: [TouristPlace] = india + singapore + japan + thailand

    // MARK: India
    static let india: [TouristPlace] = [
        TouristPlace(
            country: .india, name: "Taj Mahal", city: "Agra", type: .monument, emoji: "🕌",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/Taj_Mahal_%28Edited%29.jpeg/640px-Taj_Mahal_%28Edited%29.jpeg",
            headline: "The world's most beautiful building — made of pure white marble!",
            description: "Emperor Shah Jahan built the Taj Mahal for his beloved wife Mumtaz Mahal who passed away. It took 20,000 workers and 22 years to complete. Today it is one of the Seven Wonders of the World.",
            facts: [("State", "Uttar Pradesh"), ("Built", "1653"), ("Material", "White Marble"), ("UNESCO", "Yes — since 1983")],
            coordinate: CLLocationCoordinate2D(latitude: 27.1751, longitude: 78.0421)
        ),
        TouristPlace(
            country: .india, name: "Red Fort", city: "Delhi", type: .monument, emoji: "🏰",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/RedFort2007.jpg/640px-RedFort2007.jpg",
            headline: "A massive red sandstone fort where India's PM speaks every Independence Day!",
            description: "Built by Mughal Emperor Shah Jahan (yes, the same emperor who built the Taj Mahal!), Red Fort was his royal palace in Delhi. Every year on August 15th, India's Prime Minister hoists the national flag from here.",
            facts: [("State", "Delhi"), ("Built", "1648"), ("Material", "Red Sandstone"), ("UNESCO", "Yes — since 2007")],
            coordinate: CLLocationCoordinate2D(latitude: 28.6562, longitude: 77.2410)
        ),
        TouristPlace(
            country: .india, name: "Gateway of India", city: "Mumbai", type: .landmark, emoji: "🌊",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Gateway_of_India.jpg/640px-Gateway_of_India.jpg",
            headline: "A giant stone arch by the sea — the symbol of Mumbai!",
            description: "The Gateway of India was built to welcome King George V and Queen Mary of England when they visited India in 1911. It stands 26 metres tall right on the waterfront in Mumbai Harbour. Ferry boats to Elephanta Island depart from right beside it.",
            facts: [("State", "Maharashtra"), ("Built", "1924"), ("Height", "26 metres"), ("Architect", "George Wittet")],
            coordinate: CLLocationCoordinate2D(latitude: 18.9220, longitude: 72.8347)
        ),
        TouristPlace(
            country: .india, name: "Qutub Minar", city: "Delhi", type: .monument, emoji: "🗼",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Qutb_Minar_mausoleum.jpg/480px-Qutb_Minar_mausoleum.jpg",
            headline: "The tallest brick tower in the whole world — built 800 years ago!",
            description: "Qutub Minar is 73 metres tall and has 379 steps to climb inside. It was built by Sultan Qutb-ud-din Aibak in 1193 to celebrate his victory over Delhi. The tower is decorated with beautiful Arabic writing carved into the red stone.",
            facts: [("State", "Delhi"), ("Height", "73 metres"), ("Built", "1193"), ("Steps", "379 inside")],
            coordinate: CLLocationCoordinate2D(latitude: 28.5245, longitude: 77.1855)
        ),
        TouristPlace(
            country: .india, name: "Hawa Mahal", city: "Jaipur", type: .palace, emoji: "🏯",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/86/Hawa_Mahal.jpg/480px-Hawa_Mahal.jpg",
            headline: "The 'Palace of Winds' has 953 tiny windows!",
            description: "Hawa Mahal was built in 1799 so the royal ladies of the Jaipur court could watch festivals and processions on the street below without being seen. The 953 small windows are shaped like honeycombs and keep the inside cool with a breeze.",
            facts: [("State", "Rajasthan"), ("Built", "1799"), ("Windows", "953"), ("Floors", "5")],
            coordinate: CLLocationCoordinate2D(latitude: 26.9239, longitude: 75.8267)
        ),
        TouristPlace(
            country: .india, name: "Golden Temple", city: "Amritsar", type: .temple, emoji: "⛪",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Golden_Temple_Amritsar_2012.jpg/640px-Golden_Temple_Amritsar_2012.jpg",
            headline: "A holy Sikh shrine covered in 750 kg of real gold!",
            description: "The Golden Temple (Sri Harmandir Sahib) is the holiest place in the Sikh religion. It sits in the middle of a peaceful lake called Amrit Sarovar. Every day, the temple serves free meals called langar to over 100,000 visitors — anyone can eat, for free.",
            facts: [("State", "Punjab"), ("Religion", "Sikh"), ("Gold used", "750 kg"), ("Free meals", "100,000/day")],
            coordinate: CLLocationCoordinate2D(latitude: 31.6200, longitude: 74.8765)
        ),
    ]

    // MARK: Singapore
    static let singapore: [TouristPlace] = [
        TouristPlace(
            country: .singapore, name: "Marina Bay Sands", city: "Singapore", type: .landmark, emoji: "🏙",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Marina_Bay_Sands_in_the_night.jpg/640px-Marina_Bay_Sands_in_the_night.jpg",
            headline: "Three towers connected by a giant boat-shaped infinity pool 200m in the air!",
            description: "Marina Bay Sands is a famous hotel with three 57-storey towers connected at the top by a 340-metre-long platform called SkyPark. The infinity swimming pool on top is the largest outdoor pool this high up in the world. You can see the entire city from it.",
            facts: [("Towers", "3"), ("Height", "200 metres"), ("Pool length", "150 metres"), ("Opened", "2010")],
            coordinate: CLLocationCoordinate2D(latitude: 1.2834, longitude: 103.8607)
        ),
        TouristPlace(
            country: .singapore, name: "Gardens by the Bay", city: "Singapore", type: .nature, emoji: "🌿",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Gardens_by_the_Bay%2C_Singapore%2C_Supertree_Grove%2C_20130811_1.jpg/640px-Gardens_by_the_Bay%2C_Singapore%2C_Supertree_Grove%2C_20130811_1.jpg",
            headline: "18 giant metal 'Supertrees' that light up like magic at night!",
            description: "Gardens by the Bay has 18 enormous vertical gardens called Supertrees, ranging from 25 to 50 metres tall. They collect rainwater and produce solar energy. Every evening at 7:45 PM and 8:45 PM, the Supertrees put on a stunning light and music show called Garden Rhapsody.",
            facts: [("Supertrees", "18"), ("Tallest", "50 metres"), ("Area", "101 hectares"), ("Opened", "2012")],
            coordinate: CLLocationCoordinate2D(latitude: 1.2816, longitude: 103.8636)
        ),
        TouristPlace(
            country: .singapore, name: "Singapore Zoo", city: "Singapore", type: .wildlife, emoji: "🐘",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/Singapore_Zoo_Entrance_2013.jpg/640px-Singapore_Zoo_Entrance_2013.jpg",
            headline: "An open zoo where animals live in natural habitats — no bars!",
            description: "Singapore Zoo is famous for being an open-concept zoo where animals roam in spaces that look just like their natural homes. There are over 2,800 animals from 300 species. You can have breakfast with orang-utans, feed giraffes, and even pet some animals.",
            facts: [("Animals", "2,800+"), ("Species", "300+"), ("Style", "Open, no bars"), ("Award", "Best Zoo in Asia")],
            coordinate: CLLocationCoordinate2D(latitude: 1.4043, longitude: 103.7930)
        ),
        TouristPlace(
            country: .singapore, name: "Sentosa Island", city: "Singapore", type: .themePark, emoji: "🎡",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Sentosa_from_cable_car.jpg/640px-Sentosa_from_cable_car.jpg",
            headline: "Singapore's 'State of Fun' — beaches, rides, and Universal Studios!",
            description: "Sentosa is a resort island connected to Singapore by a cable car, monorail, and bridge. It has Universal Studios Singapore, Adventure Cove Waterpark, three beautiful beaches, the SEA Aquarium (one of the world's largest), and much more.",
            facts: [("Size", "5 sq km"), ("Beaches", "3"), ("Universal Studios", "Yes"), ("Meaning of name", "Peace & Tranquility")],
            coordinate: CLLocationCoordinate2D(latitude: 1.2494, longitude: 103.8303)
        ),
        TouristPlace(
            country: .singapore, name: "Merlion Park", city: "Singapore", type: .landmark, emoji: "🦁",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Merlion%2C_Singapore%2C_Dec_2005.jpg/480px-Merlion%2C_Singapore%2C_Dec_2005.jpg",
            headline: "Singapore's symbol — a lion's head with a fish body!",
            description: "The Merlion is Singapore's most iconic symbol. It is half lion (representing the old name Singapura, meaning 'Lion City') and half fish (representing Singapore's origins as a fishing village). The 8.6-metre statue shoots water from its mouth into Marina Bay.",
            facts: [("Height", "8.6 metres"), ("Weight", "70 tonnes"), ("Material", "Cement"), ("Opened", "1972")],
            coordinate: CLLocationCoordinate2D(latitude: 1.2868, longitude: 103.8545)
        ),
    ]

    // MARK: Japan
    static let japan: [TouristPlace] = [
        TouristPlace(
            country: .japan, name: "Mount Fuji", city: "Shizuoka", type: .nature, emoji: "🗻",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/080103_hakkai-1.jpg/640px-080103_hakkai-1.jpg",
            headline: "Japan's tallest mountain and a perfect snow-capped volcano!",
            description: "Mount Fuji is a stratovolcano (a type of steep, cone-shaped volcano) and stands 3,776 metres tall. It last erupted in 1707. Every summer, around 200,000 people climb to its summit. On a clear day you can see Tokyo, which is 100 km away.",
            facts: [("Height", "3,776 metres"), ("Type", "Stratovolcano"), ("Last eruption", "1707"), ("UNESCO", "Yes — since 2013")],
            coordinate: CLLocationCoordinate2D(latitude: 35.3606, longitude: 138.7274)
        ),
        TouristPlace(
            country: .japan, name: "Fushimi Inari Shrine", city: "Kyoto", type: .temple, emoji: "⛩",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9c/Fushimi_Inari-taisha_Kyoto_Jan_2010.jpg/640px-Fushimi_Inari-taisha_Kyoto_Jan_2010.jpg",
            headline: "Thousands of bright orange gates create a magical tunnel up a mountain!",
            description: "Fushimi Inari Taisha has over 10,000 vermilion (bright orange-red) torii gates that form tunnels along a 4-km path up Mount Inari. The shrine is dedicated to Inari, the Shinto god of rice, foxes, and business. You will see many fox statues along the way.",
            facts: [("Gates", "10,000+"), ("Colour", "Vermilion red"), ("Hike", "4 km to summit"), ("Age", "Over 1,300 years old")],
            coordinate: CLLocationCoordinate2D(latitude: 34.9671, longitude: 135.7727)
        ),
        TouristPlace(
            country: .japan, name: "Tokyo Skytree", city: "Tokyo", type: .landmark, emoji: "📡",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Tokyo_Sky_Tree_2012.JPG/480px-Tokyo_Sky_Tree_2012.JPG",
            headline: "The tallest tower in Japan — and the 2nd tallest structure in the world!",
            description: "Tokyo Skytree stands 634 metres tall (the number 634 is a pun — it can be read as 'mu-sa-shi', an old name for Tokyo). On a clear day you can see Mount Fuji. It is mainly used as a broadcasting tower for TV and radio, and has two observation decks.",
            facts: [("Height", "634 metres"), ("Opened", "2012"), ("Observation decks", "2"), ("Visitors", "6 million/year")],
            coordinate: CLLocationCoordinate2D(latitude: 35.7101, longitude: 139.8107)
        ),
        TouristPlace(
            country: .japan, name: "Hiroshima Peace Park", city: "Hiroshima", type: .memorial, emoji: "🕊",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Hiroshima_Peace_Memorial_Museum_1.jpg/640px-Hiroshima_Peace_Memorial_Museum_1.jpg",
            headline: "A beautiful park that reminds the world to choose peace.",
            description: "Hiroshima Peace Memorial Park was built to remember the people affected by the atomic bombing in 1945, and to promote world peace. The park has a Flame of Peace that has been burning since 1964 — it will be extinguished only when all nuclear weapons in the world are destroyed.",
            facts: [("Established", "1954"), ("Peace flame", "Burns since 1964"), ("UNESCO", "Yes — since 1996"), ("Visitors", "1.3 million/year")],
            coordinate: CLLocationCoordinate2D(latitude: 34.3955, longitude: 132.4536)
        ),
        TouristPlace(
            country: .japan, name: "Osaka Castle", city: "Osaka", type: .monument, emoji: "🏯",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Osaka_Castle%2C_Osaka%2C_Japan.jpg/640px-Osaka_Castle%2C_Osaka%2C_Japan.jpg",
            headline: "A stunning white castle surrounded by a moat in the heart of Osaka!",
            description: "Osaka Castle was built in 1583 by the great warlord Toyotomi Hideyoshi and was one of the most important castles in Japan's history. The main tower is 58 metres tall and decorated with gold leaf tigers and plum crests. Cherry blossoms bloom beautifully around the moat every spring.",
            facts: [("Built", "1583"), ("Height", "58 metres"), ("Floors", "5 visible, 8 total"), ("Moat length", "12 km")],
            coordinate: CLLocationCoordinate2D(latitude: 34.6873, longitude: 135.5262)
        ),
    ]

    // MARK: Thailand
    static let thailand: [TouristPlace] = [
        TouristPlace(
            country: .thailand, name: "Grand Palace", city: "Bangkok", type: .palace, emoji: "👑",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Grand_palace_2007_001.jpg/640px-Grand_palace_2007_001.jpg",
            headline: "Bangkok's most dazzling palace — covered in gold and coloured glass!",
            description: "The Grand Palace was built in 1782 and served as the official residence of Thai kings for 150 years. The complex covers 218,000 square metres (about 30 football pitches). Inside is the famous Wat Phra Kaew temple, home to the Emerald Buddha.",
            facts: [("Built", "1782"), ("Area", "218,000 sq m"), ("Temples inside", "Several"), ("Dress code", "Smart, covered clothing")],
            coordinate: CLLocationCoordinate2D(latitude: 13.7500, longitude: 100.4913)
        ),
        TouristPlace(
            country: .thailand, name: "Wat Pho", city: "Bangkok", type: .temple, emoji: "🛕",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Wat_Pho_-_Bangkok%2C_Thailand.jpg/640px-Wat_Pho_-_Bangkok%2C_Thailand.jpg",
            headline: "Home to the world's longest reclining Buddha — 46 metres of solid gold!",
            description: "Wat Pho is one of the largest and oldest temples in Bangkok. Its most famous feature is an enormous reclining Buddha statue that is 46 metres long and 15 metres high, covered entirely in gold leaf. The feet alone are 3 metres tall and decorated with intricate mother-of-pearl designs.",
            facts: [("Buddha length", "46 metres"), ("Buddha height", "15 metres"), ("Gold leaf", "Yes"), ("Also called", "Temple of Reclining Buddha")],
            coordinate: CLLocationCoordinate2D(latitude: 13.7465, longitude: 100.4931)
        ),
        TouristPlace(
            country: .thailand, name: "Phi Phi Islands", city: "Krabi Province", type: .nature, emoji: "🏝",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/PiPi_Island_aerial_view.JPG/640px-PiPi_Island_aerial_view.JPG",
            headline: "Crystal-clear turquoise water and white-sand beaches surrounded by tall cliffs!",
            description: "The Phi Phi Islands are a group of 6 stunning tropical islands in the Andaman Sea. Phi Phi Don is the largest and has beaches, restaurants, and accommodation. Phi Phi Leh (the smaller island) is famous for Maya Bay, which appeared in the movie 'The Beach'. The water is so clear you can see fish snorkelling just from the beach.",
            facts: [("Province", "Krabi"), ("Islands", "6 in the group"), ("Water colour", "Turquoise"), ("Best for", "Snorkelling, swimming")],
            coordinate: CLLocationCoordinate2D(latitude: 7.7407, longitude: 98.7784)
        ),
        TouristPlace(
            country: .thailand, name: "Doi Suthep Temple", city: "Chiang Mai", type: .temple, emoji: "⛪",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c6/Doi_Suthep_Chiang_Mai.jpg/640px-Doi_Suthep_Chiang_Mai.jpg",
            headline: "A golden temple on a misty mountain with panoramic views of Chiang Mai!",
            description: "Wat Phra That Doi Suthep sits on a mountain 1,676 metres above sea level, overlooking Chiang Mai city. You climb 306 steps lined with golden Naga (serpent) statues to reach it. The central golden chedi (tower) is 22 metres tall and glitters in the sunshine. Buddhist pilgrims ring its bells for good luck.",
            facts: [("Altitude", "1,676 metres"), ("Steps", "306"), ("Chedi height", "22 metres"), ("Founded", "1383")],
            coordinate: CLLocationCoordinate2D(latitude: 18.8047, longitude: 98.9219)
        ),
        TouristPlace(
            country: .thailand, name: "Floating Market", city: "Bangkok", type: .market, emoji: "🛶",
            photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/Damnoen_Saduak_floating_market.jpg/640px-Damnoen_Saduak_floating_market.jpg",
            headline: "A market on the water — shoppers buy food from boats in canals!",
            description: "Damnoen Saduak Floating Market is one of the most colourful markets in Thailand. Sellers in wooden boats paddle through narrow canals selling fresh fruit, Thai snacks, and souvenirs. The best time to visit is early morning when the market is busiest and the light is beautiful.",
            facts: [("Province", "Ratchaburi"), ("Type", "Canal / floating"), ("Best time", "Early morning"), ("Famous for", "Boat vendors, colour, food")],
            coordinate: CLLocationCoordinate2D(latitude: 13.5228, longitude: 99.9575)
        ),
    ]
}
