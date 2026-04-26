import SwiftUI
import WebKit

// MARK: - Virtual Tours, Field Trips & Interactive Games

struct VirtualTour: Identifiable {
    let id: Int
    let title: String
    let emoji: String
    let colorHex: String
    let category: TourCategory
    let description: String
    let ageRange: String
    let url: String
    let isInteractive: Bool
    let tags: [String]
}

enum TourCategory: String, CaseIterable, Identifiable {
    case naturalHistory = "Natural History"
    case zoos           = "Live Animal Cams"
    case space          = "Space & Science"
    case art            = "Art & Culture"
    case fieldTrips     = "Field Trips"
    case games          = "Interactive Games"
    var id: String { rawValue }
    var colorHex: String {
        switch self {
        case .naturalHistory: return "#3B6D11"; case .zoos: return "#1D9E75"
        case .space: return "#534AB7"; case .art: return "#D4537E"
        case .fieldTrips: return "#185FA5"; case .games: return "#D85A30"
        }
    }
    var icon: String {
        switch self {
        case .naturalHistory: return "fossil.shell.fill"; case .zoos: return "hare.fill"
        case .space: return "moon.stars.fill"; case .art: return "paintpalette.fill"
        case .fieldTrips: return "bus.fill"; case .games: return "gamecontroller.fill"
        }
    }
}

extension VirtualTour {
    static let all: [VirtualTour] = [
        // Natural History
        VirtualTour(id:1,title:"Ology — AMNH Interactive Science",emoji:"🦕",colorHex:"#3B6D11",category:.naturalHistory,description:"The American Museum of Natural History Ology site has interactive science activities, quizzes, and virtual labs on dinosaurs, space, ocean life and more.",ageRange:"7–14",url:"https://www.amnh.org/explore/ology",isInteractive:true,tags:["Dinosaurs","Science","Quizzes"]),
        VirtualTour(id:2,title:"Smithsonian Natural History Museum",emoji:"🦣",colorHex:"#3B6D11",category:.naturalHistory,description:"Walk through the world's most-visited natural history museum virtually. See the Hope Diamond, ocean hall, human origins, and magnificent fossils.",ageRange:"All ages",url:"https://naturalhistory.si.edu/visit/virtual-tour",isInteractive:true,tags:["Fossils","Gems","Ocean"]),
        VirtualTour(id:3,title:"Google Arts & Culture — Natural World",emoji:"🌿",colorHex:"#3B6D11",category:.naturalHistory,description:"Explore nature in stunning detail through Google's cultural platform — from coral reefs to rainforests.",ageRange:"All ages",url:"https://artsandculture.google.com/category/natural-world",isInteractive:false,tags:["Nature","Environment"]),

        // Live Animal Cams
        VirtualTour(id:4,title:"LA Zoo Live Animal Cams",emoji:"🦁",colorHex:"#1D9E75",category:.zoos,description:"Watch live cameras at the Los Angeles Zoo — see giraffes, gorillas, condors, and elephants in real time from home.",ageRange:"All ages",url:"https://www.lazoo.org/animals/live-cams/",isInteractive:false,tags:["Lions","Giraffes","Live"]),
        VirtualTour(id:5,title:"San Diego Zoo Live Cams",emoji:"🐼",colorHex:"#1D9E75",category:.zoos,description:"Live video feeds of giant pandas, polar bears, apes, elephants, and many more amazing animals from San Diego Zoo.",ageRange:"All ages",url:"https://zoo.sandiegozoo.org/zoolive",isInteractive:false,tags:["Pandas","Live","Bears"]),
        VirtualTour(id:6,title:"Georgia Aquarium Live Cams",emoji:"🦈",colorHex:"#185FA5",category:.zoos,description:"Watch whale sharks, beluga whales, sea otters and thousands of fish swimming live at the Georgia Aquarium.",ageRange:"All ages",url:"https://www.georgiaaquarium.org/webcam/",isInteractive:false,tags:["Sharks","Fish","Live"]),
        VirtualTour(id:7,title:"Explore.org Wild Animal Cams",emoji:"🦅",colorHex:"#1D9E75",category:.zoos,description:"Hundreds of live nature cameras worldwide — brown bears catching salmon, bald eagle nests, African watering holes, and more.",ageRange:"All ages",url:"https://explore.org/livecams",isInteractive:false,tags:["Bears","Eagles","Wild"]),

        // Space
        VirtualTour(id:8,title:"NASA Eyes on the Solar System",emoji:"🌍",colorHex:"#534AB7",category:.space,description:"An interactive 3D simulation of our solar system — fly to any planet, moon, asteroid or spacecraft. Free from NASA.",ageRange:"8+",url:"https://eyes.nasa.gov/apps/solar-system/",isInteractive:true,tags:["Planets","NASA","3D"]),
        VirtualTour(id:9,title:"Google Moon & Mars Tours",emoji:"🌕",colorHex:"#534AB7",category:.space,description:"Explore the surface of the Moon and Mars in 3D. See where the Apollo missions landed and follow Mars rover tracks.",ageRange:"All ages",url:"https://moon.google.com/",isInteractive:true,tags:["Moon","Mars","Apollo"]),
        VirtualTour(id:10,title:"Hubble Space Telescope Gallery",emoji:"🔭",colorHex:"#534AB7",category:.space,description:"Stunning NASA photos from the Hubble Space Telescope — nebulae, galaxies, and star nurseries in incredible colour.",ageRange:"All ages",url:"https://hubblesite.org/images/gallery",isInteractive:false,tags:["Galaxies","Stars","Photos"]),

        // Art & Culture
        VirtualTour(id:11,title:"Google Arts & Culture Museums",emoji:"🎨",colorHex:"#D4537E",category:.art,description:"Walk through the world's greatest art museums from home — the Louvre, Met, Uffizi, and hundreds more.",ageRange:"All ages",url:"https://artsandculture.google.com/explore",isInteractive:true,tags:["Museums","Paintings","Culture"]),
        VirtualTour(id:12,title:"The British Museum Virtual Tour",emoji:"🏺",colorHex:"#D4537E",category:.art,description:"Explore ancient Egypt, Greece, Rome and more in the British Museum's virtual galleries with detailed artefact information.",ageRange:"All ages",url:"https://www.britishmuseum.org/collection",isInteractive:false,tags:["Ancient","Egypt","Greece"]),

        // Field Trips
        VirtualTour(id:13,title:"Google Expeditions — Virtual Trips",emoji:"🌎",colorHex:"#185FA5",category:.fieldTrips,description:"Take virtual field trips to the Great Barrier Reef, the International Space Station, ancient Rome, and over 900 destinations.",ageRange:"All ages",url:"https://artsandculture.google.com/project/expeditions",isInteractive:true,tags:["Reef","Space","Rome"]),
        VirtualTour(id:14,title:"Virtual Tour of the Great Wall of China",emoji:"🏯",colorHex:"#185FA5",category:.fieldTrips,description:"Walk along the Great Wall of China in immersive 360° view. Learn about its history, construction, and significance.",ageRange:"All ages",url:"https://www.thechinaguide.com/destination/great-wall-of-china",isInteractive:false,tags:["China","History","360°"]),
        VirtualTour(id:15,title:"Yellowstone National Park Virtual Tour",emoji:"🌋",colorHex:"#185FA5",category:.fieldTrips,description:"Experience Old Faithful, the Grand Prismatic Spring and wildlife in America's first national park.",ageRange:"All ages",url:"https://www.nps.gov/yell/learn/photosmultimedia/virtualtours.htm",isInteractive:false,tags:["Geysers","Wildlife","Nature"]),
        VirtualTour(id:16,title:"Antarctica Virtual Expedition",emoji:"🐧",colorHex:"#185FA5",category:.fieldTrips,description:"Explore the most remote continent on Earth — see penguin colonies, iceberg fields, and research stations.",ageRange:"All ages",url:"https://www.yourexpedition.com/expeditions/virtual-antarctica/",isInteractive:false,tags:["Penguins","Ice","Exploration"]),

        // Interactive Games
        VirtualTour(id:17,title:"PBS Kids Science Games",emoji:"🔬",colorHex:"#D85A30",category:.games,description:"Fun interactive science games from PBS — build robots, solve nature puzzles, and conduct safe virtual experiments.",ageRange:"5–12",url:"https://pbskids.org/games/science/",isInteractive:true,tags:["Science","Robots","Puzzles"]),
        VirtualTour(id:18,title:"Funbrain — Reading & Math Games",emoji:"🧠",colorHex:"#D85A30",category:.games,description:"Educational reading and math games that adapt to the child's level. Includes interactive books and challenges.",ageRange:"6–13",url:"https://www.funbrain.com/",isInteractive:true,tags:["Reading","Math","Games"]),
        VirtualTour(id:19,title:"Coolmath Games — Logic Puzzles",emoji:"🧩",colorHex:"#D85A30",category:.games,description:"Brain-training logic puzzles, strategy games, and skill challenges that make thinking fun.",ageRange:"8+",url:"https://www.coolmathgames.com/",isInteractive:true,tags:["Logic","Puzzles","Strategy"]),
        VirtualTour(id:20,title:"National Geographic Kids Games",emoji:"🦓",colorHex:"#D85A30",category:.games,description:"Interactive games and quizzes about animals, geography, nature, and science from National Geographic.",ageRange:"6–14",url:"https://kids.nationalgeographic.com/games",isInteractive:true,tags:["Animals","Geography","NatGeo"]),
    ]
}

// MARK: - Virtual Tours Home View

struct VirtualToursHomeView: View {
    @State private var selectedCat: TourCategory? = nil
    @State private var selectedTour: VirtualTour?  = nil
    @State private var showWebView  = false

    private var filtered: [VirtualTour] {
        guard let cat = selectedCat else { return VirtualTour.all }
        return VirtualTour.all.filter { $0.category == cat }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerCard
                    .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 14)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        catChip(nil, label: "All", icon: "square.grid.2x2", color: "#888888")
                        ForEach(TourCategory.allCases) { cat in
                            catChip(cat, label: cat.rawValue, icon: cat.icon, color: cat.colorHex)
                        }
                    }.padding(.horizontal, 20)
                }.padding(.bottom, 16)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 280, maximum: 400), spacing: 14)], spacing: 14) {
                    ForEach(filtered) { tour in
                        TourCard(tour: tour) { selectedTour = tour }
                    }
                }.padding(.horizontal, 20).padding(.bottom, 30)
            }
        }
        .navigationTitle("Virtual Explore")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedTour) { tour in
            TourDetailSheet(tour: tour)
        }
    }

    private var headerCard: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Virtual Tours & Games")
                    .font(.system(size: 20, weight: .medium))
                Text("Explore the world from your screen")
                    .font(.system(size: 14)).foregroundColor(.secondary)
            }
            Spacer()
            Text("🌍").font(.system(size: 36))
        }
        .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func catChip(_ cat: TourCategory?, label: String, icon: String, color: String) -> some View {
        Button { withAnimation { selectedCat = cat } } label: {
            HStack(spacing: 5) {
                Image(systemName: icon).font(.system(size: 12))
                Text(label).font(.system(size: 12, weight: selectedCat == cat ? .semibold : .regular))
            }
            .foregroundColor(selectedCat == cat ? .white : Color(hex: color))
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background(selectedCat == cat ? Color(hex: color) : Color(hex: color).opacity(0.1))
            .clipShape(Capsule())
        }.buttonStyle(.plain)
    }
}

struct TourCard: View {
    let tour: VirtualTour; let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12).fill(Color(hex: tour.colorHex).opacity(0.12)).frame(width: 60, height: 60)
                    Text(tour.emoji).font(.system(size: 30))
                }
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        if tour.isInteractive {
                            Text("Interactive").font(.system(size: 9, weight: .semibold))
                                .foregroundColor(Color(hex: "#D85A30"))
                                .padding(.horizontal, 7).padding(.vertical, 2)
                                .background(Color(hex: "#D85A30").opacity(0.1)).clipShape(Capsule())
                        }
                        Text(tour.ageRange).font(.system(size: 10)).foregroundColor(.secondary)
                    }
                    Text(tour.title).font(.system(size: 14, weight: .semibold)).foregroundColor(.primary).lineLimit(2)
                    Text(tour.description).font(.system(size: 12)).foregroundColor(.secondary).lineLimit(2)
                    HStack(spacing: 4) {
                        ForEach(tour.tags.prefix(3), id: \.self) { tag in
                            Text(tag).font(.system(size: 10)).foregroundColor(Color(hex: tour.colorHex))
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Color(hex: tour.colorHex).opacity(0.08)).clipShape(Capsule())
                        }
                    }
                }
            }
            .padding(14).frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.separator).opacity(0.3), lineWidth: 0.5))
        }.buttonStyle(.plain)
    }
}

struct TourDetailSheet: View {
    let tour: VirtualTour
    @Environment(\.dismiss) private var dismiss
    @State private var speechEngine = SpeechEngine()
    @State private var showWeb = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if showWeb, let url = URL(string: tour.url) {
                    WebContentView(url: url).ignoresSafeArea(edges: .bottom)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Hero
                            ZStack {
                                RoundedRectangle(cornerRadius: 20).fill(Color(hex: tour.colorHex).opacity(0.12)).frame(height: 140)
                                VStack(spacing: 8) {
                                    Text(tour.emoji).font(.system(size: 64))
                                    Text(tour.category.rawValue).font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Color(hex: tour.colorHex))
                                        .padding(.horizontal, 12).padding(.vertical, 4)
                                        .background(Color(hex: tour.colorHex).opacity(0.12)).clipShape(Capsule())
                                }
                            }
                            VStack(alignment: .leading, spacing: 12) {
                                Text(tour.title).font(.system(size: 22, weight: .bold))
                                HStack { Text("Ages \(tour.ageRange)").font(.system(size: 13)).foregroundColor(.secondary); Spacer() }
                                Text(tour.description).font(.system(size: 15)).foregroundColor(.secondary).lineSpacing(4).fixedSize(horizontal: false, vertical: true)
                                HStack(spacing: 8) {
                                    ForEach(tour.tags, id: \.self) { tag in
                                        Text(tag).font(.system(size: 12)).foregroundColor(Color(hex: tour.colorHex))
                                            .padding(.horizontal, 10).padding(.vertical, 4)
                                            .background(Color(hex: tour.colorHex).opacity(0.1)).clipShape(Capsule())
                                    }
                                }
                                Button { showWeb = true } label: {
                                    HStack {
                                        Image(systemName: "globe"); Text("Open in App")
                                        if tour.isInteractive { Image(systemName: "hand.tap.fill") }
                                    }
                                    .font(.system(size: 15, weight: .semibold)).foregroundColor(.white)
                                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                                    .background(Color(hex: tour.colorHex)).clipShape(RoundedRectangle(cornerRadius: 14))
                                }
                                if let url = URL(string: tour.url) {
                                    Link(destination: url) {
                                        Label("Open in Safari", systemImage: "safari")
                                            .font(.system(size: 14)).foregroundColor(Color(hex: tour.colorHex))
                                    }
                                }
                            }.padding(.horizontal, 20)
                        }.padding(.top, 16).padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle(showWeb ? tour.title : "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(showWeb ? "Back" : "Close") { if showWeb { showWeb = false } else { dismiss() } }
                }
                if showWeb {
                    ToolbarItem(placement: .topBarTrailing) {
                        if let url = URL(string: tour.url) { Link(destination: url) { Image(systemName: "safari") } }
                    }
                }
            }
        }
    }
}

struct WebContentView: UIViewRepresentable {
    let url: URL
    func makeUIView(context: Context) -> WKWebView {
        let wv = WKWebView()
        wv.load(URLRequest(url: url))
        return wv
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
