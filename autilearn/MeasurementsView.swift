import SwiftUI
import SwiftData
import WebKit

// MARK: - Measurements View
// Height, weight, time, temperature, length — with video tutorials

struct MeasurementTopic: Identifiable {
    let id: Int
    let title: String
    let emoji: String
    let colorHex: String
    let youtubeID: String
    let description: String
    let facts: [String]
    let activity: String
}

extension MeasurementTopic {
    static let all: [MeasurementTopic] = [
        MeasurementTopic(id:1, title:"Length & Height", emoji:"📏", colorHex:"#185FA5",
            youtubeID:"GUjP7LFj5Yc",
            description:"We measure length to find out how long or tall something is.",
            facts:["A ruler measures in centimetres (cm)","A metre stick measures 100 cm","Your height is measured in cm or feet","We use 'km' for long distances like roads"],
            activity:"Measure your hand span! Spread your fingers wide and put your hand on a ruler. How many centimetres from your little finger to your thumb?"),
        MeasurementTopic(id:2, title:"Weight & Mass", emoji:"⚖️", colorHex:"#1D9E75",
            youtubeID:"4nRPFmPXPSE",
            description:"Weight tells us how heavy something is. We use grams (g) and kilograms (kg).",
            facts:["1 kg = 1000 grams","A banana weighs about 120 grams","You can weigh things on a scale","A new-born baby weighs about 3 kg"],
            activity:"Guess the weight! Hold a book in one hand and a pencil in the other. Which feels heavier? How much do you think each weighs?"),
        MeasurementTopic(id:3, title:"Telling the Time", emoji:"🕐", colorHex:"#534AB7",
            youtubeID:"X5aFWuDJRMo",
            description:"Clocks tell us what time it is. The short hand shows hours, the long hand shows minutes.",
            facts:["60 seconds = 1 minute","60 minutes = 1 hour","24 hours = 1 day","The short hand = hours, long hand = minutes"],
            activity:"Look at a clock right now! Can you read what time it is? What will you be doing in 1 hour?"),
        MeasurementTopic(id:4, title:"Temperature", emoji:"🌡️", colorHex:"#D85A30",
            youtubeID:"aD7vEYaPlY4",
            description:"Temperature measures how hot or cold something is. We use degrees Celsius (°C).",
            facts:["Water freezes at 0°C","Water boils at 100°C","Normal body temperature is 37°C","A hot day in India is about 35-40°C"],
            activity:"What is the temperature outside today? Is it hotter or cooler than your body temperature (37°C)?"),
        MeasurementTopic(id:5, title:"Volume & Capacity", emoji:"🧪", colorHex:"#BA7517",
            youtubeID:"svBFNECprIw",
            description:"Volume tells us how much liquid something can hold. We use millilitres (mL) and litres (L).",
            facts:["1 L = 1000 mL","A water bottle is usually 500 mL","A cup holds about 250 mL","A bathtub holds about 150-200 litres"],
            activity:"Fill a cup with water. Try to guess if it is more or less than 250 mL. Then check the cup if it has markings!"),
        MeasurementTopic(id:6, title:"Money (Indian Rupee)", emoji:"🪙", colorHex:"#D4537E",
            youtubeID:"w6UbK5lFPmg",
            description:"Money helps us buy things. Indian money uses Rupees (₹) and Paise.",
            facts:["100 paise = 1 Rupee (₹)","₹10 = ten rupees","₹100 is a one hundred rupee note","₹500 and ₹2000 are big notes"],
            activity:"Find some coins at home. Can you add them up? How much money do you have? What could you buy with ₹10?"),
        MeasurementTopic(id:7, title:"Area & Perimeter", emoji:"📐", colorHex:"#3B6D11",
            youtubeID:"AAB0YNFByBk",
            description:"Area is how much space is inside a shape. Perimeter is the distance around the outside.",
            facts:["Area of a square = side × side","Perimeter = add up all the sides","A football field has a large area","We measure area in cm² or m²"],
            activity:"Draw a rectangle on paper. Measure the length and width with a ruler. Calculate the area (length × width). What is the perimeter (length + width + length + width)?"),
        MeasurementTopic(id:8, title:"Speed & Distance", emoji:"🏃", colorHex:"#1CA8DD",
            youtubeID:"1-9jeBNv2-4",
            description:"Speed tells us how fast something is moving. Distance tells us how far it has travelled.",
            facts:["Speed = distance ÷ time","A walking speed is about 5 km/h","A car on a highway goes about 80-100 km/h","Sound travels at about 340 m per second!"],
            activity:"Time yourself walking from one end of a room to the other. Measure the distance. Can you work out your speed?"),
    ]
}

// MARK: - Measurements Home

struct MeasurementsHomeView: View {
    @State private var selected: MeasurementTopic? = nil
    @State private var speechEngine = SpeechEngine()

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Measurements").font(.system(size: 20, weight: .medium))
                        Text("Watch, learn & practise!").font(.system(size: 14)).foregroundColor(.secondary)
                    }
                    Spacer()
                    ZStack {
                        Circle().fill(Color(hex: "185FA5").opacity(0.12)).frame(width: 56, height: 56)
                        Text("📏").font(.system(size: 28))
                    }
                }
                .padding(16).background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 16)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 14)], spacing: 14) {
                    ForEach(MeasurementTopic.all) { topic in
                        MeasurementCard(topic: topic) { selected = topic }
                    }
                }.padding(.horizontal, 20).padding(.bottom, 30)
            }
        }
        .navigationTitle("Measurements")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selected) { topic in
            MeasurementDetailSheet(topic: topic, speechEngine: speechEngine)
        }
    }
}

struct MeasurementCard: View {
    let topic: MeasurementTopic; let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                ZStack {
                    AsyncImage(url: URL(string: "https://img.youtube.com/vi/\(topic.youtubeID)/hqdefault.jpg")) { phase in
                        switch phase {
                        case .success(let img): img.resizable().scaledToFill().frame(height: 80).clipped()
                        default: Rectangle().fill(Color(hex: topic.colorHex).opacity(0.12)).frame(height: 80)
                            .overlay(Text(topic.emoji).font(.system(size: 36)))
                        }
                    }
                    ZStack {
                        Circle().fill(Color.black.opacity(0.4)).frame(width: 28, height: 28)
                        Image(systemName: "play.fill").font(.system(size: 10)).foregroundColor(.white).offset(x: 1)
                    }
                }.frame(height: 80).clipped()

                VStack(alignment: .leading, spacing: 4) {
                    Text(topic.title).font(.system(size: 13, weight: .semibold)).lineLimit(2)
                    Text("\(topic.facts.count) facts").font(.system(size: 11)).foregroundColor(.secondary)
                }.padding(10).frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.separator).opacity(0.3), lineWidth: 0.5))
        }.buttonStyle(.plain)
    }
}

struct MeasurementDetailSheet: View {
    let topic: MeasurementTopic
    let speechEngine: SpeechEngine
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Video
                    if let url = URL(string: "https://www.youtube.com/embed/\(topic.youtubeID)?playsinline=1&autoplay=0&rel=0&modestbranding=1") {
                        GeometryReader { _ in VideoWebView(url: url).frame(height: 240) }.frame(height: 240)
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(topic.emoji).font(.system(size: 36))
                            Text(topic.title).font(.system(size: 22, weight: .bold))
                            Spacer()
                            Button { speechEngine.speak(topic.description + ". " + topic.facts.joined(separator: ". ")) } label: {
                                Image(systemName: "speaker.wave.2.fill").font(.system(size: 18)).foregroundColor(Color(hex: topic.colorHex))
                            }
                        }

                        Text(topic.description).font(.system(size: 15)).foregroundColor(.secondary).lineSpacing(3)

                        // Key facts
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Key Facts", systemImage: "lightbulb.fill").font(.system(size: 14, weight: .semibold)).foregroundColor(Color(hex: topic.colorHex))
                            ForEach(topic.facts, id: \.self) { fact in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("•").foregroundColor(Color(hex: topic.colorHex))
                                    Text(fact).font(.system(size: 14))
                                }
                            }
                        }
                        .padding(14).background(Color(hex: topic.colorHex).opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 12))

                        // Try it activity
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Try It! 🎯", systemImage: "hand.raised.fill").font(.system(size: 14, weight: .semibold)).foregroundColor(Color(hex: "1D9E75"))
                            Text(topic.activity).font(.system(size: 14)).foregroundColor(.primary).lineSpacing(3).fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(14).background(Color(hex: "1D9E75").opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 12))

                        // Open in YouTube
                        if let url = URL(string: "https://www.youtube.com/watch?v=\(topic.youtubeID)") {
                            Link(destination: url) {
                                HStack {
                                    Image(systemName: "arrow.up.right.square")
                                    Text("Watch on YouTube")
                                }.font(.system(size: 14, weight: .medium)).foregroundColor(.white)
                                .frame(maxWidth: .infinity).padding(.vertical, 12)
                                .background(Color.red).clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }.padding(20)
                }
            }
            .navigationTitle(topic.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Close") { dismiss() } }
            }
        }
    }
}
