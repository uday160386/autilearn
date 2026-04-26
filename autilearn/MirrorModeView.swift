import SwiftUI
import SwiftData
import AVFoundation

/// Module 2 — Screen 1: Mirror Mode
/// Child is shown a target emotion and tries to match it with their own face.
/// Vision framework detects their expression in real time and gives feedback.
struct MirrorModeView: View {
    @Environment(\.modelContext) private var context
    @State private var engine         = FaceDetectionEngine()
    @State private var speechEngine   = SpeechEngine()
    @State private var targetEmotion  : Emotion = .happy
    @State private var holdStartTime  : Date?   = nil
    @State private var matchProgress  : Double  = 0
    @State private var showSuccess    = false
    @State private var streakCount    = 0
    @State private var totalStars     = 0
    @State private var starBurst      = false
    @State private var attemptCount   = 0

    // How long the child must hold the correct expression (seconds)
    private let holdDuration: Double = 2.0
    // Match threshold — inferredEmotion must equal target
    private var isMatching: Bool {
        engine.faceState.inferredEmotion == targetEmotion
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Target emotion card ──────────────────────────
                targetCard
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                // ── Camera + overlay ─────────────────────────────
                cameraSection
                    .padding(.top, 16)

                // ── Progress / feedback bar ──────────────────────
                feedbackBar
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)

                // ── Action controls ──────────────────────────────
                controlBar
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }

            // ── Star burst overlay on success ────────────────────
            if showSuccess {
                successOverlay
            }

            // ── Permission denied state ──────────────────────────
            if engine.permissionDenied {
                permissionView
            }

            // ── Simulator / no-camera fallback ───────────────────
            if engine.noCameraAvailable {
                simulatorPlaceholderView
            }
        }
        .navigationTitle("Mirror Mode")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            engine.start()
            speakInstruction()
        }
        .onDisappear { engine.stop() }
        .onChange(of: isMatching) { _, matching in
            handleMatchChange(matching)
        }
        .onChange(of: matchProgress) { _, p in
            if p >= 1.0 { triggerSuccess() }
        }
    }

    // MARK: - Sub-views

    private var targetCard: some View {
        HStack(spacing: 16) {
            Text(targetEmotion.emoji)
                .font(.system(size: 52))
                .padding(12)
                .background(targetEmotion.color.alpha(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 4) {
                Text("Can you look...")
                    .font(.system(size: 13))
                    .foregroundColor(.white.alpha(0.6))
                Text(targetEmotion.displayName)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.white)
                Text(targetEmotion.description)
                    .font(.system(size: 12))
                    .foregroundColor(.white.alpha(0.55))
                    .lineLimit(2)
            }

            Spacer()

            // Stars earned this session
            VStack(spacing: 2) {
                Text("⭐️")
                    .font(.title2)
                    .scaleEffect(starBurst ? 1.4 : 1.0)
                    .animation(.spring(response: 0.3), value: starBurst)
                Text("\(totalStars)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .padding(16)
        .background(Color.white.alpha(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var cameraSection: some View {
        ZStack {
            if engine.isRunning {
                CameraPreviewView(engine: engine)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                isMatching
                                    ? targetEmotion.color
                                    : Color.white.alpha(0.2),
                                lineWidth: isMatching ? 3 : 1
                            )
                    )

                // Face guide overlay
                FaceOverlayView(
                    faceDetected: engine.faceState.faceDetected,
                    emotion: engine.faceState.inferredEmotion
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))

                // Live emotion label bottom-left
                if engine.faceState.faceDetected,
                   let inferred = engine.faceState.inferredEmotion {
                    VStack {
                        Spacer()
                        HStack {
                            Label(inferred.displayName, systemImage: "face.smiling")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(inferred.color.alpha(0.8))
                                .clipShape(Capsule())
                                .padding(14)
                            Spacer()
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }

            } else if !engine.isRunning && !engine.permissionDenied {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.alpha(0.06))
                    .overlay(
                        ProgressView()
                            .tint(.white)
                    )
            }
        }
        .frame(height: 300)
        .padding(.horizontal, 20)
    }

    private var feedbackBar: some View {
        VStack(spacing: 6) {
            HStack {
                Text(feedbackMessage)
                    .font(.system(size: 14))
                    .foregroundColor(.white.alpha(0.8))
                Spacer()
                if isMatching {
                    Text("Hold it! \(Int(matchProgress * 100))%")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(targetEmotion.color)
                }
            }

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.alpha(0.12))
                        .frame(height: 8)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(targetEmotion.color)
                        .frame(width: geo.size.width * matchProgress, height: 8)
                        .animation(.linear(duration: 0.1), value: matchProgress)
                }
            }
            .frame(height: 8)
        }
    }

    private var controlBar: some View {
        HStack(spacing: 12) {
            // Speak instruction again
            Button {
                speakInstruction()
            } label: {
                Label("Hear tip", systemImage: "speaker.wave.2")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.white.alpha(0.1))
                    .clipShape(Capsule())
            }

            Spacer()

            // Skip to next emotion
            Button {
                nextEmotion()
            } label: {
                Label("Next emotion", systemImage: "arrow.right.circle.fill")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(Color.white.alpha(0.15))
                    .clipShape(Capsule())
            }
        }
    }

    private var successOverlay: some View {
        ZStack {
            Color.black.alpha(0.55)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("⭐️")
                    .font(.system(size: 72))
                    .scaleEffect(showSuccess ? 1.0 : 0.3)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showSuccess)

                Text("Amazing \(targetEmotion.displayName) face!")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)

                if streakCount > 1 {
                    Text("\(streakCount) in a row! 🔥")
                        .font(.system(size: 16))
                        .foregroundColor(.yellow)
                }

                Button {
                    withAnimation { showSuccess = false }
                    nextEmotion()
                } label: {
                    Text("Keep going!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
            }
        }
        .transition(.opacity)
    }

    private var permissionView: some View {
        ZStack {
            Color.black.alpha(0.85).ignoresSafeArea()
            VStack(spacing: 16) {
                Image(systemName: "camera.slash")
                    .font(.system(size: 48))
                    .foregroundColor(.white.alpha(0.6))
                Text("Camera access needed")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                Text("Please allow camera access in Settings so the app can see your face expressions.")
                    .font(.system(size: 14))
                    .foregroundColor(.white.alpha(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                .foregroundColor(.accentColor)
            }
        }
    }

    private var simulatorPlaceholderView: some View {
        ZStack {
            Color.black.alpha(0.85).ignoresSafeArea()
            VStack(spacing: 16) {
                Image(systemName: "iphone.slash")
                    .font(.system(size: 48))
                    .foregroundColor(.white.alpha(0.6))
                Text("Camera not available")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                Text("Mirror Mode uses the front camera. Run on a real device to use face detection.")
                    .font(.system(size: 14))
                    .foregroundColor(.white.alpha(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                Button("Try Identify Mode instead") {
                    // No-op — user navigates back via nav bar
                }
                .foregroundColor(.accentColor)
            }
        }
    }

    // MARK: - Logic

    private var feedbackMessage: String {
        guard engine.faceState.faceDetected else {
            return "Move your face into the circle above"
        }
        if isMatching {
            return "Yes! Keep holding that \(targetEmotion.displayName) face!"
        }
        return targetEmotion.instruction
    }

    private func handleMatchChange(_ matching: Bool) {
        if matching {
            holdStartTime = Date()
        } else {
            holdStartTime = nil
            matchProgress = 0
        }
    }

    private func updateProgress() {
        guard isMatching, let start = holdStartTime else {
            matchProgress = 0
            return
        }
        matchProgress = min(1.0, Date().timeIntervalSince(start) / holdDuration)
    }

    private func triggerSuccess() {
        streakCount += 1
        totalStars  += 1
        attemptCount += 1
        showSuccess = true
        starBurst   = true

        // Haptics
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)

        // Log attempt
        context.insert(EmotionAttempt(emotion: targetEmotion,
                                      wasCorrect: true,
                                      gameMode: .learn))
        try? context.save()

        speechEngine.speak("Brilliant! That's \(targetEmotion.displayName)!")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            starBurst = false
        }

        matchProgress = 0
        holdStartTime = nil
    }

    private func nextEmotion() {
        let all = Emotion.allCases.filter { $0 != targetEmotion }
        targetEmotion = all.randomElement() ?? .happy
        matchProgress = 0
        holdStartTime = nil
        speakInstruction()
    }

    private func speakInstruction() {
        speechEngine.speak(targetEmotion.audioPrompt)
    }
}

// Timer-based progress update
extension MirrorModeView {
    // Call this from a .onReceive(timer) in the view
    func tickProgress() {
        guard isMatching else { return }
        updateProgress()
    }
}
