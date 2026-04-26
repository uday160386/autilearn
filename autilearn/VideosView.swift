import SwiftUI
import SwiftData
import WebKit

// MARK: - Videos Home

struct VideosHomeView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \VideoWatchRecord.watchedAt, order: .reverse) private var watchHistory: [VideoWatchRecord]
    @State private var selectedCategory: VideoCategory = .all
    @State private var selectedVideo: EducationalVideo? = nil
    @State private var showHistory = false

    private var filteredVideos: [EducationalVideo] {
        if selectedCategory == .all { return EducationalVideo.available }
        return EducationalVideo.available.filter { $0.category == selectedCategory }
    }

    private var dailyPicks: [EducationalVideo] {
        EducationalVideo.dailyVideos(count: 6)
    }

    private let columns = [GridItem(.adaptive(minimum: 200, maximum: 320), spacing: 14)]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                headerCard.padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 16)

                // Daily refresh section
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Label("Today's Picks 🌟", systemImage: "sparkles")
                            .font(.system(size: 15, weight: .semibold))
                        Spacer()
                        Text("Refreshes daily").font(.system(size: 11)).foregroundColor(.secondary)
                    }.padding(.horizontal, 20)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(dailyPicks) { video in
                                DailyPickCard(video: video) { selectedVideo = video }
                                    .frame(width: 180)
                            }
                        }.padding(.horizontal, 20)
                    }
                }.padding(.bottom, 16)

                // Watch history strip
                if !watchHistory.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Label("Continue Watching", systemImage: "clock.arrow.circlepath")
                                .font(.system(size: 15, weight: .semibold))
                            Spacer()
                            Button { showHistory = true } label: {
                                Text("See All").font(.system(size: 12)).foregroundColor(Color(hex: "534AB7"))
                            }
                        }.padding(.horizontal, 20)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(watchHistory.prefix(8)) { record in
                                    if let video = EducationalVideo.all.first(where: { $0.id == record.videoID }) {
                                        HistoryCard(video: video) { selectedVideo = video }
                                            .frame(width: 140)
                                    }
                                }
                            }.padding(.horizontal, 20)
                        }
                    }.padding(.bottom, 16)
                }

                // Category filter tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(VideoCategory.allCases, id: \.self) { cat in
                            VideoCategoryChip(category: cat, isSelected: selectedCategory == cat) {
                                withAnimation(.easeInOut(duration: 0.2)) { selectedCategory = cat }
                            }
                        }
                    }.padding(.horizontal, 20)
                }.padding(.bottom, 16)

                // Video grid
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(filteredVideos) { video in
                        VideoCard(video: video) { selectedVideo = video }
                    }
                }
                .padding(.horizontal).padding(.bottom, 30)
                .frame(maxWidth: 1100).frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Learning Videos")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(item: $selectedVideo) { video in
            VideoPlayerView(video: video, onWatch: { saveToHistory(video) })
        }
        .sheet(isPresented: $showHistory) {
            WatchHistorySheet(watchHistory: watchHistory, allVideos: EducationalVideo.all) { video in
                showHistory = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { selectedVideo = video }
            }
        }
    }

    private func saveToHistory(_ video: EducationalVideo) {
        // Don't duplicate — update timestamp if already in history
        if let existing = watchHistory.first(where: { $0.videoID == video.id }) {
            existing.watchedAt = Date()
        } else {
            let record = VideoWatchRecord(video: video)
            context.insert(record)
        }
        try? context.save()
    }

    private var headerCard: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Explore & learn").font(.system(size: 20, weight: .medium))
                Text("Videos refresh every day ✨").font(.system(size: 14)).foregroundColor(.secondary)
            }
            Spacer()
            ZStack {
                Circle().fill(Color(hex: "D4537E").opacity(0.12)).frame(width: 56, height: 56)
                Text("🎬").font(.system(size: 28))
            }
        }
        .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Daily pick card (horizontal scroll)

struct DailyPickCard: View {
    let video: EducationalVideo; let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    AsyncImage(url: video.thumbnailURL) { phase in
                        switch phase {
                        case .success(let img): img.resizable().scaledToFill().frame(height: 95).clipped()
                        default: Rectangle().fill(Color(hex: video.category.colorHex).opacity(0.15)).frame(height: 95)
                            .overlay(Image(systemName: video.category.icon).font(.system(size: 24)).foregroundColor(Color(hex: video.category.colorHex)))
                        }
                    }
                    ZStack {
                        Circle().fill(Color.black.opacity(0.45)).frame(width: 30, height: 30)
                        Image(systemName: "play.fill").font(.system(size: 11)).foregroundColor(.white).offset(x: 1)
                    }
                    VStack { HStack { Spacer()
                        Text("⭐").font(.system(size: 12)).padding(4).background(Color.black.opacity(0.4)).clipShape(Capsule()).padding(4)
                    }; Spacer() }
                }.frame(height: 95).clipped()

                VStack(alignment: .leading, spacing: 3) {
                    Text(video.title).font(.system(size: 12, weight: .medium)).lineLimit(2).foregroundColor(.primary)
                    Text(video.channel).font(.system(size: 10)).foregroundColor(.secondary)
                }.padding(8)
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: video.category.colorHex).opacity(0.3), lineWidth: 1))
        }.buttonStyle(.plain)
    }
}

// MARK: - History card

struct HistoryCard: View {
    let video: EducationalVideo; let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    AsyncImage(url: video.thumbnailURL) { phase in
                        switch phase {
                        case .success(let img): img.resizable().scaledToFill().frame(height: 78).clipped()
                        default: Rectangle().fill(Color(hex: video.category.colorHex).opacity(0.12)).frame(height: 78)
                        }
                    }
                    Image(systemName: "play.circle.fill").font(.system(size: 22)).foregroundColor(.white.opacity(0.9))
                }.frame(height: 78).clipped()
                Text(video.title).font(.system(size: 11, weight: .medium)).lineLimit(2).foregroundColor(.primary).padding(7)
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.separator).opacity(0.3), lineWidth: 0.5))
        }.buttonStyle(.plain)
    }
}

// MARK: - Watch History Sheet

struct WatchHistorySheet: View {
    let watchHistory: [VideoWatchRecord]
    let allVideos: [EducationalVideo]
    let onSelect: (EducationalVideo) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(watchHistory) { record in
                    if let video = allVideos.first(where: { $0.id == record.videoID }) {
                        Button {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { onSelect(video) }
                        } label: {
                            HStack(spacing: 12) {
                                AsyncImage(url: video.thumbnailURL) { phase in
                                    switch phase {
                                    case .success(let img): img.resizable().scaledToFill().frame(width: 60, height: 44).clipped().clipShape(RoundedRectangle(cornerRadius: 6))
                                    default: Rectangle().fill(Color(hex: video.category.colorHex).opacity(0.15)).frame(width: 60, height: 44).clipShape(RoundedRectangle(cornerRadius: 6))
                                    }
                                }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(video.title).font(.system(size: 13, weight: .medium)).lineLimit(2).foregroundColor(.primary)
                                    Text(record.watchedAt, style: .relative).font(.system(size: 11)).foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "play.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: video.category.colorHex))
                            }
                        }.buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Watch History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } }
            }
        }
    }
}

// MARK: - Category chip

struct VideoCategoryChip: View {
    let category: VideoCategory; let isSelected: Bool; let onTap: () -> Void
    var accent: Color { Color(hex: category.colorHex) }
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 5) {
                Image(systemName: category.icon).font(.system(size: 11))
                Text(category.rawValue).font(.system(size: 12, weight: isSelected ? .semibold : .regular))
            }
            .foregroundColor(isSelected ? .white : accent)
            .padding(.horizontal, 14).padding(.vertical, 8)
            .background(isSelected ? accent : accent.opacity(0.1))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

// MARK: - Video card

struct VideoCard: View {
    let video: EducationalVideo; let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                AsyncImage(url: video.thumbnailURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill().frame(height: 100).clipped()
                    case .failure, .empty:
                        Rectangle().fill(Color(hex: video.category.colorHex).opacity(0.15)).frame(height: 100)
                            .overlay(Image(systemName: "play.rectangle.fill").font(.system(size: 28)).foregroundColor(Color(hex: video.category.colorHex).opacity(0.6)))
                    @unknown default:
                        Rectangle().fill(Color(.secondarySystemBackground)).frame(height: 100)
                    }
                }
                .overlay(alignment: .center) {
                    ZStack {
                        Circle().fill(Color.black.opacity(0.45)).frame(width: 36, height: 36)
                        Image(systemName: "play.fill").font(.system(size: 14)).foregroundColor(.white).offset(x: 1)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(video.category.rawValue).font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color(hex: video.category.colorHex))
                        .padding(.horizontal, 7).padding(.vertical, 2)
                        .background(Color(hex: video.category.colorHex).opacity(0.1)).clipShape(Capsule())
                    Text(video.title).font(.system(size: 13, weight: .medium)).foregroundColor(.primary).lineLimit(2).multilineTextAlignment(.leading)
                    Text(video.channel).font(.system(size: 11)).foregroundColor(.secondary)
                }.padding(10)
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.separator).opacity(0.35), lineWidth: 0.5))
        }.buttonStyle(.plain)
    }
}

// MARK: - Full-screen in-app Video Player

struct VideoPlayerView: View {
    let video: EducationalVideo
    var onWatch: (() -> Void)? = nil

    @State private var speechEngine = SpeechEngine()
    @State private var hasRecordedWatch = false

    private var accent: Color { Color(hex: video.category.colorHex) }

    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height

            VStack(spacing: 0) {

                // ── Video player ─────────────────────────────────────
                Group {
                    if let url = video.embedURL {
                        VideoWebView(url: url)
                            .onAppear {
                                if !hasRecordedWatch {
                                    hasRecordedWatch = true
                                    onWatch?()
                                }
                            }
                    } else {
                        Color.black.overlay(
                            VStack(spacing: 12) {
                                Image(systemName: "video.slash")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white.opacity(0.5))
                                Text("Video unavailable")
                                    .foregroundColor(.white.opacity(0.6))
                                    .font(.system(size: 14))
                            }
                        )
                    }
                }
                .frame(width: geo.size.width,
                       height: isLandscape ? geo.size.height : geo.size.width * 9 / 16)
                .background(Color.black)

                // ── Info panel (portrait only) ────────────────────────
                if !isLandscape {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 14) {
                            // Category + title
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 6) {
                                    Image(systemName: video.category.icon)
                                        .font(.system(size: 10, weight: .semibold))
                                    Text(video.category.rawValue)
                                        .font(.system(size: 11, weight: .semibold))
                                }
                                .foregroundColor(accent)
                                .padding(.horizontal, 10).padding(.vertical, 4)
                                .background(accent.opacity(0.12))
                                .clipShape(Capsule())

                                Text(video.title)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .fixedSize(horizontal: false, vertical: true)

                                HStack(spacing: 6) {
                                    Image(systemName: "person.wave.2")
                                        .font(.system(size: 11))
                                        .foregroundColor(.secondary)
                                    Text(video.channel)
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondary)
                                }
                            }

                            Divider()

                            Text(video.description)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineSpacing(3)

                            Button {
                                speechEngine.speak(video.description)
                            } label: {
                                Label("Read aloud", systemImage: "speaker.wave.2.fill")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(accent)
                                    .padding(.horizontal, 14).padding(.vertical, 10)
                                    .background(accent.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .padding(20)
                    }
                    .background(Color(.systemBackground))
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle(video.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.black)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

// MARK: - In-app YouTube player (full-screen WKWebView, no browser chrome)
//
// Loads youtube.com/watch?v=ID directly in a WKWebView with a real mobile
// Safari user-agent. Every video plays — including embed-restricted ones —
// because we're loading the watch page, not an embed iframe.
// The navigation delegate blocks youtube:// and all external schemes so
// the user can never leave the app.

struct VideoWebView: View {
    let url: URL

    private var videoID: String {
        url.pathComponents.last?
            .components(separatedBy: "?").first ?? ""
    }

    var body: some View {
        YouTubePlayerWebView(videoID: videoID)
    }
}

struct YouTubePlayerWebView: UIViewRepresentable {
    let videoID: String

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> WKWebView {
        let cfg = WKWebViewConfiguration()
        cfg.allowsInlineMediaPlayback                = true
        cfg.mediaTypesRequiringUserActionForPlayback = []
        cfg.allowsAirPlayForMediaPlayback            = true
        cfg.allowsPictureInPictureMediaPlayback      = true

        let wv = WKWebView(frame: .zero, configuration: cfg)

        // Use the real iOS Safari UA — YouTube serves its full mobile player
        wv.customUserAgent =
            "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) " +
            "AppleWebKit/605.1.15 (KHTML, like Gecko) " +
            "Version/17.4 Mobile/15E148 Safari/604.1"

        wv.navigationDelegate         = context.coordinator
        wv.uiDelegate                 = context.coordinator
        wv.scrollView.isScrollEnabled = true
        wv.scrollView.bounces         = false
        wv.backgroundColor            = .black
        wv.isOpaque                   = false
        return wv
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard !videoID.isEmpty else { return }
        // Only load if we haven't already loaded this video
        let alreadyLoaded = uiView.url?.absoluteString.contains(videoID) == true
        guard !alreadyLoaded else { return }

        guard let watchURL = URL(string: "https://m.youtube.com/watch?v=\(videoID)") else { return }
        var req = URLRequest(url: watchURL)
        req.setValue("https://m.youtube.com", forHTTPHeaderField: "Referer")
        req.setValue("same-origin", forHTTPHeaderField: "Sec-Fetch-Site")
        uiView.load(req)
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {

        func webView(_ webView: WKWebView,
                     decidePolicyFor action: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

            guard let url = action.request.url else {
                decisionHandler(.allow); return
            }

            let scheme = url.scheme?.lowercased() ?? ""

            // Kill any scheme that would open an external app
            if ["youtube", "itms", "itms-apps", "itms-services"].contains(scheme)
                || scheme.hasPrefix("vnd.youtube") {
                decisionHandler(.cancel)
                return
            }

            // Always allow background resource loads (JS, video chunks, XHR)
            if action.navigationType == .other {
                decisionHandler(.allow); return
            }

            // Allow all YouTube / Google infrastructure
            let host = url.host?.lowercased() ?? ""
            let allowed = ["youtube.com", "m.youtube.com", "youtu.be",
                           "ytimg.com", "yt3.ggpht.com", "googlevideo.com",
                           "googleapis.com", "google.com", "gstatic.com",
                           "accounts.google.com", "googleusercontent.com"]
            if allowed.contains(where: { host == $0 || host.hasSuffix("." + $0) }) {
                decisionHandler(.allow); return
            }

            // Block everything else
            decisionHandler(.cancel)
        }

        // Swallow any popup / new-tab attempts
        func webView(_ webView: WKWebView,
                     createWebViewWith configuration: WKWebViewConfiguration,
                     for action: WKNavigationAction,
                     windowFeatures: WKWindowFeatures) -> WKWebView? {
            // Load inside the same webview instead of opening new window
            if let url = action.request.url {
                webView.load(URLRequest(url: url))
            }
            return nil
        }
    }
}
