import SwiftUI
import SwiftData
import WebKit
import AVFoundation
import Speech

// MARK: - Emotion Trainer Home

struct EmotionHomeView: View {
    @Query private var attempts: [EmotionAttempt]
    @State private var speechEngine = SpeechEngine()
    @State private var selectedEmotion: Emotion? = nil

    private var totalStars: Int { attempts.filter(\.wasCorrect).count }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                headerSection
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                // Voice Chat card
                VStack(alignment: .leading, spacing: 0) {
                    NavigationLink(destination: EmotionVoiceChatView()) {
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12).fill(Color(hex: "D4537E").opacity(0.12)).frame(width: 52, height: 52)
                                Image(systemName: "mic.fill").font(.system(size: 22)).foregroundColor(Color(hex: "D4537E"))
                            }
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Voice Chat — Talk About Feelings")
                                    .font(.system(size: 15, weight: .semibold)).foregroundColor(.primary)
                                Text("Speak and get a friendly response")
                                    .font(.system(size: 12)).foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").font(.system(size: 12)).foregroundColor(.secondary)
                        }
                        .padding(14)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "D4537E").opacity(0.3), lineWidth: 1))
                    }.buttonStyle(.plain)
                }.padding(.horizontal, 20)

                // Mode cards
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

                // Emotion grid (now with video)
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
                    // Video badge
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

// MARK: - Emotion detail sheet (now with embedded video)

struct EmotionDetailSheet: View {
    let emotion: Emotion
    let speechEngine: SpeechEngine
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Embedded YouTube video for this emotion
                    if let url = URL(string: "https://www.youtube.com/embed/\(emotion.emotionVideoID)?playsinline=1&autoplay=0&rel=0&modestbranding=1") {
                        VStack(spacing: 0) {
                            GeometryReader { geo in
                                VideoWebView(url: url).frame(height: 220)
                            }.frame(height: 220)
                        }
                    }

                    // Emoji + name header
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

                    // Content
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

// MARK: - Voice Chat for Emotions

struct EmotionVoiceChatView: View {
    @State private var speechEngine = SpeechEngine()
    @State private var isRecording = false
    @State private var transcript = ""
    @State private var reply = ""
    @State private var isThinking = false
    @State private var audioEngine = AVAudioEngine()
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest? = nil
    @State private var recognitionTask: SFSpeechRecognitionTask? = nil
    @State private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    @State private var messages: [(role: String, text: String)] = []
    @State private var permissionGranted = false

    var body: some View {
        VStack(spacing: 0) {
            // Chat messages
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        if messages.isEmpty {
                            VStack(spacing: 16) {
                                Text("🎙️").font(.system(size: 60)).padding(.top, 40)
                                Text("Tap the mic and talk about how you feel!")
                                    .font(.system(size: 16)).foregroundColor(.secondary).multilineTextAlignment(.center)
                                Text("I'm here to listen 💛").font(.system(size: 14)).foregroundColor(.secondary)
                            }.padding(30)
                        }
                        ForEach(Array(messages.enumerated()), id: \.offset) { i, msg in
                            HStack {
                                if msg.role == "user" { Spacer(minLength: 60) }
                                Text(msg.text)
                                    .font(.system(size: 15)).padding(12)
                                    .background(msg.role == "user" ? Color(hex: "534AB7") : Color(.secondarySystemBackground))
                                    .foregroundColor(msg.role == "user" ? .white : .primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                if msg.role == "assistant" { Spacer(minLength: 60) }
                            }
                            .id(i)
                        }
                        if isThinking {
                            HStack {
                                Text("Thinking...").font(.system(size: 13)).foregroundColor(.secondary).padding(12)
                                    .background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 14))
                                Spacer()
                            }
                        }
                    }.padding(16)
                }
                .onChange(of: messages.count) { _ in
                    if let last = messages.indices.last { proxy.scrollTo(last, anchor: .bottom) }
                }
            }

            Divider()

            // Transcript + mic
            VStack(spacing: 10) {
                if !transcript.isEmpty {
                    Text(transcript).font(.system(size: 14)).foregroundColor(.secondary)
                        .padding(.horizontal, 16).lineLimit(2)
                }
                HStack(spacing: 16) {
                    Spacer()
                    Button {
                        if isRecording { stopRecording() } else { startRecording() }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(isRecording ? Color.red : Color(hex: "D4537E"))
                                .frame(width: 72, height: 72)
                                .shadow(color: (isRecording ? Color.red : Color(hex: "D4537E")).opacity(0.4), radius: 8)
                            Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                                .font(.system(size: 28)).foregroundColor(.white)
                        }
                    }
                    Spacer()
                }
                Text(isRecording ? "Listening... tap to stop" : "Tap mic to speak")
                    .font(.system(size: 12)).foregroundColor(.secondary)
            }.padding(16).background(Color(.systemBackground))
        }
        .navigationTitle("Voice Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { requestPermissions() }
    }

    private func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async { permissionGranted = status == .authorized }
        }
        AVAudioSession.sharedInstance().requestRecordPermission { _ in }
    }

    private func startRecording() {
        guard permissionGranted else {
            messages.append((role: "assistant", text: "Please allow microphone and speech recognition in Settings to use voice chat."))
            return
        }
        transcript = ""
        isRecording = true

        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
            if let result = result {
                DispatchQueue.main.async { transcript = result.bestTranscription.formattedString }
            }
            if error != nil || (result?.isFinal == true) {
                DispatchQueue.main.async { stopRecording() }
            }
        }

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()
        recognitionRequest = request
    }

    private func stopRecording() {
        isRecording = false
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil

        let text = transcript.trimmingCharacters(in: .whitespacesAndNewlines)
        if !text.isEmpty {
            messages.append((role: "user", text: text))
            transcript = ""
            generateReply(to: text)
        }
    }

    private func generateReply(to text: String) {
        isThinking = true
        let prompt = "You are a warm, friendly helper for a child who may have autism. Reply to their feeling or statement in 1-2 short, simple, encouraging sentences. Be kind, calm and supportive. Their message: \(text)"
        Task {
            do {
                let response = try await callClaudeAPI(prompt: prompt)
                await MainActor.run {
                    isThinking = false
                    messages.append((role: "assistant", text: response))
                    speechEngine.speak(response)
                }
            } catch {
                await MainActor.run {
                    isThinking = false
                    let fallback = "That's okay! It's good to talk about how you feel. You're doing great! 💛"
                    messages.append((role: "assistant", text: fallback))
                    speechEngine.speak(fallback)
                }
            }
        }
    }

    private func callClaudeAPI(prompt: String) async throws -> String {
        let url = URL(string: "https://api.anthropic.com/v1/messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")

        let body: [String: Any] = [
            "model": "claude-haiku-4-5-20251001",
            "max_tokens": 150,
            "messages": [["role": "user", "content": prompt]]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let content = (json?["content"] as? [[String: Any]])?.first
        return (content?["text"] as? String) ?? "You're doing great! 💛"
    }
}

// Make Emotion Identifiable for .sheet(item:)
extension Emotion: Identifiable {
    public var id: String { rawValue }
}


