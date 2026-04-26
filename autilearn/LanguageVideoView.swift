import SwiftUI
import SwiftData

// MARK: - Language Video View
// Shows stories or devotional videos filtered by the selected Indian language.
// If no language is selected, defaults to Telugu and prompts user to choose.

struct LanguageVideoView: View {
    enum VideoMode { case stories, devotional }
    let mode: VideoMode

    @Environment(\.modelContext) private var context
    @Query(sort: \VideoWatchRecord.watchedAt, order: .reverse) private var watchHistory: [VideoWatchRecord]
    @State private var selectedVideo: EducationalVideo? = nil
    @State private var showLanguagePicker = false

    private var store: LanguageStore { LanguageStore.shared }
    private var intStore: InterestStore { InterestStore.shared }
    private var language: IndianLanguage { store.selectedLanguage ?? .telugu }

    private var videos: [EducationalVideo] {
        let available = VideoAvailabilityStore.shared.embeddableIDs
        let pool: [EducationalVideo]
        switch mode {
        case .devotional: pool = EducationalVideo.devotionalVideos(for: language)
        case .stories:    pool = EducationalVideo.storiesVideos(for: language)
        }
        guard !available.isEmpty else { return pool }
        return pool.filter { available.contains($0.id) }
    }

    private var title: String {
        switch mode {
        case .devotional: return "\(language.rawValue) Devotional"
        case .stories:    return "\(language.rawValue) Stories"
        }
    }

    private var accent: Color { Color(hex: language.colorHex) }

    private let columns = [GridItem(.adaptive(minimum: 200, maximum: 320), spacing: 14)]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header with language switcher
                HStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title).font(.system(size: 20, weight: .medium))
                        Text("\(videos.count) videos · \(language.nativeName)")
                            .font(.system(size: 14)).foregroundColor(.secondary)
                    }
                    Spacer()
                    Button { showLanguagePicker = true } label: {
                        HStack(spacing: 6) {
                            Text(language.nativeName)
                                .font(.system(size: 13, weight: .semibold))
                            Image(systemName: "chevron.down")
                                .font(.system(size: 11, weight: .semibold))
                        }
                        .foregroundColor(accent)
                        .padding(.horizontal, 12).padding(.vertical, 7)
                        .background(accent.opacity(0.1))
                        .clipShape(Capsule())
                    }
                }
                .padding(16)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 16)

                if videos.isEmpty {
                    VStack(spacing: 16) {
                        Text("🙏").font(.system(size: 48))
                        Text("No \(title.lowercased()) found.")
                            .font(.system(size: 16, weight: .medium))
                        Text("Tap the language button above to switch language")
                            .font(.system(size: 13)).foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Button { showLanguagePicker = true } label: {
                            Label("Choose Language", systemImage: "globe")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20).padding(.vertical, 10)
                                .background(accent)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.horizontal, 32).padding(.top, 60).frame(maxWidth: .infinity)
                } else {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(videos) { video in
                            VideoCard(video: video) { selectedVideo = video }
                        }
                    }
                    .padding(.horizontal, 20).padding(.bottom, 30)
                    .frame(maxWidth: 1100).frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(item: $selectedVideo) { video in
            VideoPlayerView(video: video, onWatch: { saveHistory(video) })
        }
        .sheet(isPresented: $showLanguagePicker) {
            LanguagePickerView()
        }
    }

    private func saveHistory(_ video: EducationalVideo) {
        if let existing = watchHistory.first(where: { $0.videoID == video.id }) {
            existing.watchedAt = Date()
        } else {
            context.insert(VideoWatchRecord(video: video))
        }
        try? context.save()
    }
}

// MARK: - Language + Interest Picker Button (toolbar)

struct LanguagePickerButton: View {
    var openTab: LanguagePickerView.PrefsTab = .language
    @State private var showPicker = false
    private var langStore: LanguageStore  { LanguageStore.shared }
    private var intStore:  InterestStore  { InterestStore.shared }

    var body: some View {
        Button { showPicker = true } label: {
            HStack(spacing: 5) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 14))
                if langStore.hasSelection || intStore.hasSelections {
                    let parts = [
                        langStore.selectedLanguage.map { $0.nativeName },
                        intStore.hasSelections ? "\(intStore.selectedActivities.count) 🏅" : nil
                    ].compactMap { $0 }
                    Text(parts.joined(separator: " · "))
                        .font(.system(size: 11, weight: .semibold))
                        .lineLimit(1)
                }
            }
            .foregroundColor(Color(hex: "#534AB7"))
            .padding(.horizontal, (langStore.hasSelection || intStore.hasSelections) ? 10 : 0)
            .padding(.vertical, (langStore.hasSelection || intStore.hasSelections) ? 5 : 0)
            .background((langStore.hasSelection || intStore.hasSelections)
                        ? Color(hex: "#534AB7").opacity(0.1) : Color.clear)
            .clipShape(Capsule())
        }
        .sheet(isPresented: $showPicker) {
            LanguagePickerView()
        }
    }
}

// MARK: - Interest Video View
// Shows videos filtered by the user's selected KidActivity interests.

struct InterestVideoView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \VideoWatchRecord.watchedAt, order: .reverse) private var watchHistory: [VideoWatchRecord]
    @State private var selectedVideo: EducationalVideo? = nil
    @State private var showPreferences = false

    private var store: InterestStore { InterestStore.shared }
    private var langStore: LanguageStore { LanguageStore.shared }
    private let columns = [GridItem(.adaptive(minimum: 200, maximum: 320), spacing: 14)]

    private var videos: [EducationalVideo] {
        let available = VideoAvailabilityStore.shared.embeddableIDs
        // Use combined language+activity filter
        let pool = EducationalVideo.videos(
            for: store.selectedActivities,
            language: langStore.selectedLanguage
        )
        guard !available.isEmpty else { return pool }
        return pool.filter { available.contains($0.id) }
    }

    private var headerSubtitle: String {
        var parts: [String] = []
        if store.hasSelections { parts.append("\(videos.count) videos") }
        if let lang = langStore.selectedLanguage { parts.append(lang.nativeName) }
        return parts.isEmpty ? "No activities selected yet" : parts.joined(separator: " · ")
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                HStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("My Activities").font(.system(size: 20, weight: .medium))
                        Text(headerSubtitle)
                            .font(.system(size: 14)).foregroundColor(.secondary)
                    }
                    Spacer()
                    Button { showPreferences = true } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 13))
                            Text(store.hasSelections
                                 ? "\(store.selectedActivities.count) selected"
                                 : "Choose")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(Color(hex: "#185FA5"))
                        .padding(.horizontal, 12).padding(.vertical, 7)
                        .background(Color(hex: "#185FA5").opacity(0.1))
                        .clipShape(Capsule())
                    }
                }
                .padding(16)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 16)

                // Selected activity chips
                if store.hasSelections {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(Array(store.selectedActivities).sorted(by: { $0.rawValue < $1.rawValue })) { act in
                                HStack(spacing: 5) {
                                    Text(act.emoji).font(.system(size: 13))
                                    Text(act.rawValue).font(.system(size: 12, weight: .medium))
                                    Button { store.toggle(act) } label: {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.horizontal, 10).padding(.vertical, 5)
                                .background(Color(hex: act.colorHex).opacity(0.1))
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color(hex: act.colorHex).opacity(0.3), lineWidth: 0.5))
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 12)
                }

                if !store.hasSelections {
                    // Empty state
                    VStack(spacing: 16) {
                        Text("🏅").font(.system(size: 56))
                        Text("Choose your activities!").font(.system(size: 18, weight: .semibold))
                        Text("Pick the sports and activities you enjoy and we'll show you matching videos.")
                            .font(.system(size: 14)).foregroundColor(.secondary)
                            .multilineTextAlignment(.center).padding(.horizontal, 32)
                        Button { showPreferences = true } label: {
                            Label("Choose Activities", systemImage: "figure.run")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24).padding(.vertical, 12)
                                .background(Color(hex: "#185FA5"))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .frame(maxWidth: .infinity).padding(.top, 60)
                } else if videos.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "video.slash").font(.system(size: 40)).foregroundColor(.secondary)
                        Text("No videos found for selected activities").foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity).padding(.top, 60)
                } else {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(videos) { video in
                            VideoCard(video: video) { selectedVideo = video }
                        }
                    }
                    .padding(.horizontal, 20).padding(.bottom, 30)
                    .frame(maxWidth: 1100).frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("My Activities")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(item: $selectedVideo) { video in
            VideoPlayerView(video: video, onWatch: { saveHistory(video) })
        }
        .sheet(isPresented: $showPreferences) {
            LanguagePickerView()
        }
    }

    private func saveHistory(_ video: EducationalVideo) {
        if let existing = watchHistory.first(where: { $0.videoID == video.id }) {
            existing.watchedAt = Date()
        } else {
            context.insert(VideoWatchRecord(video: video))
        }
        try? context.save()
    }
}
