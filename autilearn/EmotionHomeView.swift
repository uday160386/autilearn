import SwiftUI
import SwiftData

// MARK: - Emotion Trainer Home

struct EmotionHomeView: View {
    @Query private var attempts: [EmotionAttempt]
    @State private var speechEngine   = SpeechEngine()
    @State private var selectedEmotion: Emotion? = nil

    private var totalStars: Int { attempts.filter(\.wasCorrect).count }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                // Voice Chat card
                NavigationLink(destination: VoiceChatView()) {
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex: "D4537E").opacity(0.12))
                                .frame(width: 52, height: 52)
                            Image(systemName: "mic.fill")
                                .font(.system(size: 22))
                                .foregroundColor(Color(hex: "D4537E"))
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Voice Chat — Talk About Feelings")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.primary)
                            Text("Speak and get a friendly response")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    .padding(14)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: "D4537E").opacity(0.3), lineWidth: 1))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)

                VStack(spacing: 14) {
                    NavigationLink(destination: MirrorModeView()) {
                        ModeCard(icon: "face.smiling.inverse", title: "Mirror mode",
                                 subtitle: "Use your face to match emotions using the camera",
                                 color: Color(hex: "1D9E75"), badge: "Camera")
                    }.buttonStyle(.plain)
                    NavigationLink(destination: IdentifyModeView()) {
                        ModeCard(icon: "questionmark.bubble.fill", title: "Identify mode",
                                 subtitle: "Read a story and tap how the person feels",
                                 color: Color(hex: "534AB7"), badge: "Quiz")
                    }.buttonStyle(.plain)
                    NavigationLink(destination: EmotionProgressView()) {
                        ModeCard(icon: "chart.bar.fill", title: "My progress",
                                 subtitle: "See which emotions you've mastered",
                                 color: Color(hex: "BA7517"), badge: nil)
                    }.buttonStyle(.plain)
                }.padding(.horizontal, 20)

                emotionPhotoGrid.padding(.horizontal, 20).padding(.bottom, 20)
            }
        }
        .navigationTitle("Emotion Trainer")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedEmotion) { emotion in
            EmotionDetailSheet(emotion: emotion, speechEngine: speechEngine)
        }
    }

    private var headerSection: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Let's learn about feelings").font(.system(size: 20, weight: .medium))
                Text("You've earned \(totalStars) star\(totalStars == 1 ? "" : "s") so far!")
                    .font(.system(size: 14)).foregroundColor(.secondary)
            }
            Spacer()
            ZStack {
                Circle().fill(Color.yellow.opacity(0.15)).frame(width: 56, height: 56)
                Text("⭐️").font(.system(size: 28))
            }
        }
        .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var emotionPhotoGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tap a face to learn about that feeling").font(.system(size: 13)).foregroundColor(.secondary)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120, maximum: 200), spacing: 12)], spacing: 12) {
                ForEach(Emotion.allCases, id: \.self) { emotion in
                    EmotionPhotoCard(emotion: emotion) {
                        speechEngine.speak(emotion.audioPrompt)
                        selectedEmotion = emotion
                    }
                }
            }
        }
    }
}

// MARK: - Photo card

struct EmotionPhotoCard: View {
    let emotion: Emotion
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                ZStack {
                    Rectangle().fill(emotion.color.opacity(0.15)).frame(height: 90)
                    AsyncImage(url: URL(string: emotion.realPhotoURL)) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFill().frame(height: 90).clipped()
                        case .failure:
                            Text(emotion.emoji).font(.system(size: 44)).frame(height: 90)
                        case .empty:
                            ProgressView().frame(height: 90)
                        @unknown default:
                            Text(emotion.emoji).font(.system(size: 44)).frame(height: 90)
                        }
                    }
                    VStack { Spacer(); HStack { Spacer()
                        Image(systemName: "play.circle.fill").font(.system(size: 16)).foregroundColor(.white.opacity(0.9)).padding(4)
                    }}
                }.frame(height: 90).clipped()
                Text(emotion.displayName)
                    .font(.system(size: 13, weight: .semibold)).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 6).background(emotion.color)
            }
        }
        .buttonStyle(.plain)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(emotion.color.opacity(0.4), lineWidth: 1.5))
        .shadow(color: emotion.color.opacity(0.15), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Emotion detail sheet

struct EmotionDetailSheet: View {
    let emotion: Emotion
    let speechEngine: SpeechEngine
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    if let url = URL(string: "https://www.youtube.com/embed/\(emotion.emotionVideoID)?playsinline=1&autoplay=0&rel=0&modestbranding=1") {
                        VStack(spacing: 0) {
                            GeometryReader { geo in
                                VideoWebView(url: url).frame(height: 220)
                            }.frame(height: 220)
                        }
                    }
                    HStack(spacing: 12) {
                        Text(emotion.emoji).font(.system(size: 44))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(emotion.displayName).font(.system(size: 26, weight: .bold))
                            Text("Tap to hear the description").font(.system(size: 12)).foregroundColor(.secondary)
                        }
                        Spacer()
                        Button { speechEngine.speak(emotion.audioPrompt) } label: {
                            Image(systemName: "speaker.wave.2.fill").font(.system(size: 20)).foregroundColor(emotion.color)
                        }
                    }.padding(20)
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("What does it feel like?", systemImage: "heart.text.square.fill")
                                .font(.system(size: 15, weight: .semibold)).foregroundColor(emotion.color)
                            Text(emotion.description).font(.system(size: 15)).foregroundColor(.primary)
                                .lineSpacing(4).fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(16).background(emotion.color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 14))
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Try making this face!", systemImage: "face.smiling")
                                .font(.system(size: 15, weight: .semibold)).foregroundColor(emotion.color)
                            Text(emotion.instruction).font(.system(size: 15)).foregroundColor(.primary)
                                .lineSpacing(4).fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 14))
                        Button { speechEngine.speak(emotion.audioPrompt) } label: {
                            Label("Hear a description", systemImage: "speaker.wave.2.fill")
                                .font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                                .frame(maxWidth: .infinity).padding(.vertical, 14)
                                .background(emotion.color).clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }.padding(20)
                }
            }
            .ignoresSafeArea(edges: .top)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() }.fontWeight(.medium) }
            }
        }
    }
}

// Make Emotion Identifiable for .sheet(item:)
extension Emotion: Identifiable {
    public var id: String { rawValue }
}
