import SwiftUI
import SwiftData
import PhotosUI
import AVFoundation
import WebKit

// MARK: - Video Modeling — video-first, no text as primary content

struct VideoModel: Identifiable {
    let id: Int
    let title: String
    let emoji: String
    let colorHex: String
    let category: String
    let youtubeID: String
    let steps: [String]        // shown only as optional reference below video
    let whyItHelps: String
}

extension VideoModel {
    static let templates: [VideoModel] = [
        VideoModel(id:1,  title:"Washing Hands",     emoji:"🤲", colorHex:"#185FA5", category:"Hygiene",
            youtubeID:"eCPsRL3iiCM",
            steps:["Turn on the tap","Wet both hands","Apply soap","Rub hands 20 sec","Rinse","Turn off tap","Dry hands"],
            whyItHelps:"Seeing each step clearly helps understand the sequence."),
        VideoModel(id:2,  title:"Brushing Teeth",    emoji:"🪥", colorHex:"#1D9E75", category:"Hygiene",
            youtubeID:"9kp4BXVN7EA",
            steps:["Toothpaste on brush","Top teeth 30 sec","Bottom teeth 30 sec","Tongue","Rinse","Rinse brush"],
            whyItHelps:"A visual model makes the routine concrete and easier to follow."),
        VideoModel(id:3,  title:"Greeting a Friend", emoji:"👋", colorHex:"#D4537E", category:"Social",
            youtubeID:"lJqNnv8KRbQ",
            steps:["Look at face","Smile","Say Hello","Wait for response","Ask: How are you?","Listen"],
            whyItHelps:"Watching step-by-step removes guesswork and builds confidence."),
        VideoModel(id:4,  title:"Asking for Help",   emoji:"🙋", colorHex:"#534AB7", category:"Social",
            youtubeID:"gHHGovFD2R0",
            steps:["Notice you need help","Go to adult","Wait","Say: Excuse me…","Explain","Say thank you"],
            whyItHelps:"Practising the words reduces anxiety in the real moment."),
        VideoModel(id:5,  title:"Getting Dressed",   emoji:"👕", colorHex:"#BA7517", category:"Self-care",
            youtubeID:"iJ2bJlmFSzE",
            steps:["Underwear","Trousers","Top","Socks","Check mirror"],
            whyItHelps:"Small steps help children with sequencing become independent."),
        VideoModel(id:6,  title:"Calming Down",      emoji:"😮‍💨", colorHex:"#5DCAA5", category:"Regulation",
            youtubeID:"KMaOeFQQkJM",
            steps:["Notice feeling","Go quiet spot","Sit","5 deep breaths","Count 10–1","Tell adult"],
            whyItHelps:"Watching primes the brain to use the strategy when needed."),
        VideoModel(id:7,  title:"Packing School Bag",emoji:"🎒", colorHex:"#3B6D11", category:"Organisation",
            youtubeID:"X0ZrJHmHFnA",
            steps:["Get checklist","Books","Pencil case","Lunchbox","Zip bag","Bag by door"],
            whyItHelps:"Reduces morning stress and supports independence."),
        VideoModel(id:8,  title:"Saying Sorry",      emoji:"🙇", colorHex:"#D85A30", category:"Social",
            youtubeID:"oRCNfWLMc8c",
            steps:["Look at person","Breath","Say: I am sorry for…","Name what you did","Wait","I will try not to again"],
            whyItHelps:"Modelling exact words makes this complex task more manageable."),
        VideoModel(id:9,  title:"Table Manners",     emoji:"🍽️", colorHex:"#185FA5", category:"Social",
            youtubeID:"Yx3oQKsEHDQ",
            steps:["Wash hands","Sit up","Napkin on lap","Use fork/spoon","Don't talk full mouth","Say thank you"],
            whyItHelps:"Practising meal routines reduces anxiety at family events."),
        VideoModel(id:10, title:"Morning Routine",   emoji:"🌅", colorHex:"#BA7517", category:"Routine",
            youtubeID:"TvUQIKIqKZ0",
            steps:["Wake up","Bathroom","Brush teeth","Wash face","Get dressed","Breakfast","Pack bag"],
            whyItHelps:"A consistent morning video anchors the sequence and reduces decision fatigue."),
        VideoModel(id:11, title:"Sharing & Turns",   emoji:"🔄", colorHex:"#D4537E", category:"Social",
            youtubeID:"RMbkfMDgVEE",
            steps:["Wait for your turn","Let friend go first","Your turn next","Say: My turn please","Take turns fairly"],
            whyItHelps:"Watching sharing modelled helps internalise fair-play rules."),
        VideoModel(id:12, title:"Bedtime Routine",   emoji:"🌙", colorHex:"#534AB7", category:"Routine",
            youtubeID:"LLqsBKjLRkI",
            steps:["Bath or wash","Pyjamas on","Brush teeth","Read or quiet time","Lights off","Sleep"],
            whyItHelps:"A calm bedtime video cues the brain that sleep time is coming."),
    ]
}

// MARK: - Video Modeling Home

struct VideoModelingHomeView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \MediaRecording.createdAt, order: .reverse) private var recordings: [MediaRecording]
    @State private var selectedTemplate: VideoModel? = nil
    @State private var selectedCategory = "All"
    @State private var speechEngine = SpeechEngine()

    private let categories = ["All","Hygiene","Social","Self-care","Regulation","Organisation","Routine"]

    private var filteredTemplates: [VideoModel] {
        selectedCategory == "All" ? VideoModel.templates
            : VideoModel.templates.filter { $0.category == selectedCategory }
    }

    private var myVideos: [MediaRecording] {
        recordings.filter { $0.tag == "task" || $0.tag == "story" }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Header
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Video Modeling")
                            .font(.system(size: 20, weight: .medium))
                        Text("Watch a task to learn how to do it")
                            .font(.system(size: 14)).foregroundColor(.secondary)
                    }
                    Spacer()
                    ZStack {
                        Circle().fill(Color(hex: "534AB7").opacity(0.12)).frame(width: 56, height: 56)
                        Text("🎬").font(.system(size: 28))
                    }
                }
                .padding(16)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20)
                .padding(.top, 16)

                // My recorded videos strip
                if !myVideos.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("My Recorded Videos (\(myVideos.count))")
                                .font(.system(size: 15, weight: .semibold))
                            Spacer()
                            NavigationLink(destination: AddMediaView(mediaType: "video")) {
                                Label("Record", systemImage: "video.badge.plus")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "534AB7"))
                            }
                        }
                        .padding(.horizontal, 20)

                        LazyVStack(spacing: 10) {
                            ForEach(myVideos) { rec in
                                VideoRecordingRow(recording: rec)
                            }
                        }.padding(.horizontal, 20)
                    }
                }

                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { cat in
                            Button {
                                withAnimation { selectedCategory = cat }
                            } label: {
                                Text(cat)
                                    .font(.system(size: 13, weight: selectedCategory == cat ? .semibold : .regular))
                                    .foregroundColor(selectedCategory == cat ? .white : Color(hex: "534AB7"))
                                    .padding(.horizontal, 14).padding(.vertical, 8)
                                    .background(selectedCategory == cat ? Color(hex: "534AB7") : Color(hex: "534AB7").opacity(0.1))
                                    .clipShape(Capsule())
                            }.buttonStyle(.plain)
                        }
                    }.padding(.horizontal, 20)
                }

                // Template grid — pure video thumbnails
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Task Video Examples")
                            .font(.system(size: 15, weight: .semibold))
                            .padding(.horizontal, 20)
                        Spacer()
                        NavigationLink(destination: AddMediaView(mediaType: "video")) {
                            Label("Record New", systemImage: "plus.circle")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "534AB7"))
                        }.padding(.trailing, 20)
                    }

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 14)], spacing: 14) {
                        ForEach(filteredTemplates) { vm in
                            TaskVideoCard(model: vm) { selectedTemplate = vm }
                        }
                    }.padding(.horizontal, 20)
                }

                Spacer(minLength: 30)
            }
        }
        .navigationTitle("Video Modeling")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedTemplate) { vm in
            TaskVideoPlayerSheet(model: vm)
        }
    }
}

// MARK: - Task video card — just the thumbnail with play button, no steps text

struct TaskVideoCard: View {
    let model: VideoModel
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // Full thumbnail — video is the primary content
                ZStack {
                    AsyncImage(url: URL(string: "https://img.youtube.com/vi/\(model.youtubeID)/hqdefault.jpg")) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable().scaledToFill().frame(height: 100).clipped()
                        default:
                            Rectangle()
                                .fill(Color(hex: model.colorHex).opacity(0.15))
                                .frame(height: 100)
                                .overlay(Text(model.emoji).font(.system(size: 40)))
                        }
                    }

                    // Play button overlay
                    ZStack {
                        Circle().fill(Color.black.opacity(0.5)).frame(width: 38, height: 38)
                        Image(systemName: "play.fill").font(.system(size: 14)).foregroundColor(.white).offset(x: 1)
                    }

                    // Category pill top-right
                    VStack {
                        HStack {
                            Spacer()
                            Text(model.category)
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 7).padding(.vertical, 3)
                                .background(Color(hex: model.colorHex).opacity(0.85))
                                .clipShape(Capsule())
                                .padding(6)
                        }
                        Spacer()
                    }
                }
                .frame(height: 100)
                .clipped()

                // Minimal title bar
                HStack(spacing: 8) {
                    Text(model.emoji).font(.system(size: 16))
                    Text(model.title)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.separator).opacity(0.3), lineWidth: 0.5))
            .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Task video player sheet — video fills top, steps optional below

struct TaskVideoPlayerSheet: View {
    let model: VideoModel
    @Environment(\.dismiss) private var dismiss
    @State private var speechEngine = SpeechEngine()
    @State private var showSteps = false
    @State private var completedSteps: Set<Int> = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {

                    // ── VIDEO FIRST ──
                    if let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeID)?playsinline=1&autoplay=0&rel=0&modestbranding=1") {
                        GeometryReader { geo in
                            VideoWebView(url: url)
                                .frame(height: max(220, geo.size.width * 9 / 16))
                        }
                        .frame(height: max(220, UIScreen.main.bounds.width * 9 / 16))
                    }

                    // Title row
                    HStack(spacing: 12) {
                        Text(model.emoji).font(.system(size: 36))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(model.title).font(.system(size: 20, weight: .bold))
                            Text(model.category)
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: model.colorHex))
                        }
                        Spacer()
                        // Open in YouTube
                        if let url = URL(string: "https://www.youtube.com/watch?v=\(model.youtubeID)") {
                            Link(destination: url) {
                                Image(systemName: "arrow.up.right.square")
                                    .font(.system(size: 20))
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    // Why it helps
                    HStack {
                        Label(model.whyItHelps, systemImage: "lightbulb.fill")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "BA7517"))
                        Spacer()
                    }
                    .padding(14)
                    .background(Color(hex: "BA7517").opacity(0.07))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                    // Speak button
                    Button {
                        speechEngine.speak("Watch the video to see how to \(model.title). \(model.whyItHelps)")
                    } label: {
                        Label("Hear description", systemImage: "speaker.wave.2")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: model.colorHex))
                    }
                    .padding(.top, 12)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Optional step checklist toggle
                    Button {
                        withAnimation { showSteps.toggle() }
                    } label: {
                        HStack {
                            Label("Step checklist (optional)", systemImage: "checklist")
                                .font(.system(size: 14, weight: .medium))
                            Spacer()
                            Image(systemName: showSteps ? "chevron.up" : "chevron.down")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(Color(hex: model.colorHex))
                        .padding(14)
                        .background(Color(hex: model.colorHex).opacity(0.07))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                    if showSteps {
                        VStack(spacing: 8) {
                            ForEach(Array(model.steps.enumerated()), id: \.offset) { i, step in
                                Button {
                                    if completedSteps.contains(i) {
                                        completedSteps.remove(i)
                                    } else {
                                        completedSteps.insert(i)
                                        speechEngine.speak("Step \(i+1). \(step)")
                                    }
                                } label: {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(completedSteps.contains(i) ? Color(hex: "1D9E75") : Color(hex: model.colorHex).opacity(0.15))
                                                .frame(width: 32, height: 32)
                                            if completedSteps.contains(i) {
                                                Image(systemName: "checkmark").font(.system(size: 12, weight: .bold)).foregroundColor(.white)
                                            } else {
                                                Text("\(i+1)").font(.system(size: 12, weight: .bold)).foregroundColor(Color(hex: model.colorHex))
                                            }
                                        }
                                        Text(step).font(.system(size: 14)).foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "speaker.wave.1").font(.system(size: 11)).foregroundColor(.secondary)
                                    }
                                    .padding(12)
                                    .background(completedSteps.contains(i) ? Color(hex: "1D9E75").opacity(0.07) : Color(.systemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.separator).opacity(0.2), lineWidth: 0.5))
                                }
                                .buttonStyle(.plain)
                            }

                            if completedSteps.count == model.steps.count && !model.steps.isEmpty {
                                Text("All done! Great job! 🌟")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Color(hex: "1D9E75"))
                                    .padding(.top, 8)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    }

                    Spacer(minLength: 40)
                }
            }
            .navigationTitle(model.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
