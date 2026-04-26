import SwiftUI
import AVFoundation
import Speech

// MARK: - Voice Chat View
// Lets the child speak about their feelings and receive a warm AI response.
// Uses SFSpeechRecognizer for speech-to-text and AVSpeechSynthesizer for
// text-to-speech. The AI reply comes from AIService → RemoteConfig → Supabase.

struct VoiceChatView: View {

    @State private var speechEngine        = SpeechEngine()
    @State private var isRecording         = false
    @State private var transcript          = ""
    @State private var isThinking          = false
    @State private var messages: [ChatMessage] = []
    @State private var permissionStatus    = PermissionStatus.unknown
    @State private var showPermissionAlert = false

    // Audio / speech
    @State private var audioEngine         = AVAudioEngine()
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask:    SFSpeechRecognitionTask?
    private let speechRecognizer           = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))

    var body: some View {
        VStack(spacing: 0) {
            messageList
            Divider()
            inputBar
        }
        .navigationTitle("Voice Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: requestPermissions)
        .alert("Microphone Access Needed", isPresented: $showPermissionAlert) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please allow microphone and speech recognition access in Settings to use Voice Chat.")
        }
    }

    // MARK: - Message list

    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    if messages.isEmpty {
                        emptyState
                    }
                    ForEach(messages) { msg in
                        MessageBubble(message: msg)
                            .id(msg.id)
                    }
                    if isThinking {
                        ThinkingBubble()
                            .id("thinking")
                    }
                }
                .padding(16)
            }
            .onChange(of: messages.count) {
                withAnimation {
                    if let last = messages.last { proxy.scrollTo(last.id, anchor: .bottom) }
                }
            }
            .onChange(of: isThinking) {
                if isThinking { withAnimation { proxy.scrollTo("thinking", anchor: .bottom) } }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Text("🎙️").font(.system(size: 64)).padding(.top, 50)
            Text("Tap the mic and talk about how you feel!")
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            Text("I'm here to listen 💛")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Input bar

    private var inputBar: some View {
        VStack(spacing: 8) {
            // Live transcript preview
            if !transcript.isEmpty {
                Text(transcript)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
            }

            HStack(spacing: 20) {
                Spacer()

                // Mic button
                Button(action: toggleRecording) {
                    ZStack {
                        Circle()
                            .fill(micColor)
                            .frame(width: 76, height: 76)
                            .shadow(color: micColor.opacity(0.4), radius: 10, y: 4)

                        if isRecording {
                            // Pulsing ring
                            Circle()
                                .stroke(Color.red.opacity(0.35), lineWidth: 3)
                                .frame(width: 90, height: 90)
                                .scaleEffect(isRecording ? 1.15 : 1.0)
                                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                                           value: isRecording)
                        }

                        Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .disabled(isThinking || permissionStatus == .denied)

                Spacer()
            }
            .padding(.vertical, 12)

            Text(statusText)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .padding(.bottom, 8)
        }
        .background(Color(.systemBackground))
    }

    private var micColor: Color {
        if permissionStatus == .denied { return .gray }
        return isRecording ? Color.red : Color(hex: "D4537E")
    }

    private var statusText: String {
        switch permissionStatus {
        case .denied:   return "Microphone access required — tap to open Settings"
        case .unknown:  return "Checking permissions…"
        case .granted:
            if isThinking   { return "Thinking… 💭" }
            if isRecording  { return "Listening… tap to stop" }
            return "Tap the mic to speak"
        }
    }

    // MARK: - Recording control

    private func toggleRecording() {
        guard permissionStatus == .granted else { showPermissionAlert = true; return }
        isRecording ? stopRecording() : startRecording()
    }

    private func startRecording() {
        transcript = ""
        isRecording = true

        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? session.setActive(true, options: .notifyOthersOnDeactivation)

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        recognitionRequest = request

        recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
            if let result {
                DispatchQueue.main.async {
                    transcript = result.bestTranscription.formattedString
                }
            }
            if error != nil || result?.isFinal == true {
                DispatchQueue.main.async { stopRecording() }
            }
        }

        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buf, _ in
            request.append(buf)
        }
        audioEngine.prepare()
        try? audioEngine.start()
    }

    private func stopRecording() {
        isRecording = false
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil

        let text = transcript.trimmingCharacters(in: .whitespacesAndNewlines)
        transcript = ""

        guard !text.isEmpty else { return }
        messages.append(ChatMessage(role: .user, text: text))
        generateReply(to: text)
    }

    // MARK: - AI reply

    private func generateReply(to text: String) {
        isThinking = true
        let prompt = """
        You are a warm, friendly helper for a child who may have autism. \
        Reply to their feeling or statement in 1–2 short, simple, encouraging sentences. \
        Be kind, calm and supportive. Their message: \(text)
        """
        Task {
            let reply = await AIService.shared.chatSafe(prompt: prompt)
            await MainActor.run {
                isThinking = false
                messages.append(ChatMessage(role: .assistant, text: reply))
                speechEngine.speak(reply)
            }
        }
    }

    // MARK: - Permissions

    private func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    AVAudioSession.sharedInstance().requestRecordPermission { granted in
                        DispatchQueue.main.async {
                            permissionStatus = granted ? .granted : .denied
                        }
                    }
                case .denied, .restricted:
                    permissionStatus = .denied
                default:
                    permissionStatus = .denied
                }
            }
        }
    }
}

// MARK: - Supporting types

enum PermissionStatus { case unknown, granted, denied }

struct ChatMessage: Identifiable {
    enum Role { case user, assistant }
    let id   = UUID()
    let role : Role
    let text : String
}

struct MessageBubble: View {
    let message: ChatMessage

    private var isUser: Bool { message.role == .user }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isUser { Spacer(minLength: 60) }

            if !isUser {
                ZStack {
                    Circle()
                        .fill(Color(hex: "D4537E").opacity(0.15))
                        .frame(width: 32, height: 32)
                    Text("💛").font(.system(size: 16))
                }
            }

            Text(message.text)
                .font(.system(size: 15))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    isUser
                    ? Color(hex: "534AB7")
                    : Color(.secondarySystemBackground)
                )
                .foregroundColor(isUser ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .clipShape(
                    .rect(
                        topLeadingRadius:    isUser ? 18 : 4,
                        bottomLeadingRadius: 18,
                        bottomTrailingRadius: isUser ? 4 : 18,
                        topTrailingRadius:   18
                    )
                )

            if isUser { Spacer(minLength: 0) }
        }
        .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
    }
}

struct ThinkingBubble: View {
    @State private var animating = false

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color(hex: "D4537E").opacity(0.15))
                    .frame(width: 32, height: 32)
                Text("💛").font(.system(size: 16))
            }

            HStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(Color.secondary.opacity(0.5))
                        .frame(width: 8, height: 8)
                        .scaleEffect(animating ? 1.3 : 0.7)
                        .animation(
                            .easeInOut(duration: 0.5)
                                .repeatForever()
                                .delay(Double(i) * 0.15),
                            value: animating
                        )
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18))

            Spacer(minLength: 60)
        }
        .onAppear { animating = true }
    }
}
