import SwiftUI
import Combine

// MARK: - 6-Second Rule Timer
// After asking a question or giving a command, wait 6 seconds
// silently before repeating. This gives the autistic person time to
// process, reducing anxiety, frustration and sensory overload.

struct SixSecondRuleView: View {
    @State private var phase: TimerPhase = .idle
    @State private var secondsLeft  = 6
    @State private var message      = ""
    @State private var history: [TimerEntry] = []
    @State private var speechEngine = SpeechEngine()
    @State private var timerSub: AnyCancellable? = nil
    @State private var showTips = false

    enum TimerPhase { case idle, waiting, done }

    struct TimerEntry: Identifiable {
        let id = UUID()
        let question: String
        let timestamp = Date()
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Explainer
                explainerCard
                    .padding(.horizontal, 20).padding(.top, 16)

                // Timer card
                timerCard
                    .padding(.horizontal, 20)

                // Input
                inputSection
                    .padding(.horizontal, 20)

                // Tips
                tipsSection
                    .padding(.horizontal, 20)

                // History
                if !history.isEmpty {
                    historySection
                        .padding(.horizontal, 20)
                }

                Spacer(minLength: 30)
            }
        }
        .navigationTitle("6-Second Rule")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: Sub-views

    private var explainerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                ZStack {
                    Circle().fill(Color(hex: "#5DCAA5").opacity(0.15)).frame(width: 44, height: 44)
                    Text("6").font(.system(size: 22, weight: .black, design: .rounded)).foregroundColor(Color(hex: "#5DCAA5"))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("The 6-Second Rule").font(.system(size: 16, weight: .bold))
                    Text("A communication strategy for autism").font(.system(size: 12)).foregroundColor(.secondary)
                }
            }
            Text("After asking a question or giving an instruction, wait silently for 6 seconds before repeating. This gives the brain the processing time it needs. Repeating too soon causes anxiety and resets the processing clock.")
                .font(.system(size: 14)).foregroundColor(.secondary).lineSpacing(3).fixedSize(horizontal: false, vertical: true)
            Button { speechEngine.speak("The six second rule means waiting six full seconds after asking a question before you repeat it. This gives the brain time to understand and form a response. Repeating too soon resets the clock and causes frustration.") } label: {
                Label("Hear explanation", systemImage: "speaker.wave.2")
                    .font(.system(size: 13)).foregroundColor(Color(hex: "#5DCAA5"))
            }
        }
        .padding(16).background(Color(hex: "#5DCAA5").opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var timerCard: some View {
        VStack(spacing: 16) {
            // Big countdown ring
            ZStack {
                Circle().stroke(Color(.systemFill), lineWidth: 12).frame(width: 160, height: 160)
                Circle()
                    .trim(from: 0, to: phase == .waiting ? CGFloat(6 - secondsLeft) / 6.0 : phase == .done ? 1 : 0)
                    .stroke(phase == .done ? Color(hex: "#1D9E75") : Color(hex: "#5DCAA5"),
                            style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: secondsLeft)

                VStack(spacing: 4) {
                    if phase == .idle {
                        Text("⏱️").font(.system(size: 48))
                        Text("Ready").font(.system(size: 16, weight: .medium)).foregroundColor(.secondary)
                    } else if phase == .waiting {
                        Text("\(secondsLeft)")
                            .font(.system(size: 72, weight: .black, design: .rounded))
                            .foregroundColor(Color(hex: "#5DCAA5"))
                            .contentTransition(.numericText())
                        Text("seconds").font(.system(size: 14)).foregroundColor(.secondary)
                    } else {
                        Text("✅").font(.system(size: 52))
                        Text("Now you\nmay repeat").font(.system(size: 13, weight: .medium)).foregroundColor(Color(hex: "#1D9E75")).multilineTextAlignment(.center)
                    }
                }
            }

            // Status text
            Text(statusText)
                .font(.system(size: 16, weight: .medium)).multilineTextAlignment(.center)
                .foregroundColor(phase == .done ? Color(hex: "#1D9E75") : .primary)
                .animation(.easeInOut, value: phase)

            // Button
            Button { handleButton() } label: {
                Text(buttonLabel)
                    .font(.system(size: 17, weight: .bold)).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 16)
                    .background(phase == .waiting ? Color(hex: "#D85A30") : Color(hex: "#5DCAA5"))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(20).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Question or instruction").font(.system(size: 14, weight: .semibold))
            TextField("e.g. What do you want for lunch?", text: $message, axis: .vertical)
                .lineLimit(2, reservesSpace: true)
                .padding(12).background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.separator).opacity(0.4), lineWidth: 0.5))
            Text("Type the question first, then tap Start Timer.").font(.system(size: 11)).foregroundColor(.secondary)
        }
    }

    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button { withAnimation { showTips.toggle() } } label: {
                HStack {
                    Label("Tips for using this strategy", systemImage: "lightbulb.fill")
                        .font(.system(size: 14, weight: .semibold)).foregroundColor(Color(hex: "#BA7517"))
                    Spacer()
                    Image(systemName: showTips ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12)).foregroundColor(.secondary)
                }
            }.buttonStyle(.plain)

            if showTips {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(tips, id: \.self) { tip in
                        HStack(alignment: .top, spacing: 8) {
                            Text("•").foregroundColor(Color(hex: "#BA7517"))
                            Text(tip).font(.system(size: 13)).foregroundColor(.secondary).fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }.padding(12).background(Color(hex: "#BA7517").opacity(0.06)).clipShape(RoundedRectangle(cornerRadius: 10))
                .transition(.opacity)
            }
        }
        .padding(14).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent (\(history.count))").font(.system(size: 14, weight: .semibold))
            ForEach(history.prefix(5)) { entry in
                HStack {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(Color(hex: "#1D9E75")).font(.system(size: 14))
                    Text(entry.question).font(.system(size: 13)).lineLimit(1)
                    Spacer()
                    Text(entry.timestamp, style: .relative).font(.system(size: 11)).foregroundColor(.secondary)
                }
            }
        }
        .padding(14).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: Logic

    private var statusText: String {
        switch phase {
        case .idle:    return "Ask your question, then tap Start."
        case .waiting: return "Stay quiet and wait patiently... 🤫"
        case .done:    return "6 seconds complete! You may now repeat if needed."
        }
    }

    private var buttonLabel: String {
        switch phase {
        case .idle:    return "▶ Start 6-Second Timer"
        case .waiting: return "✕ Cancel"
        case .done:    return "↩ Start Again"
        }
    }

    private func handleButton() {
        switch phase {
        case .idle:
            startTimer()
        case .waiting:
            cancelTimer()
        case .done:
            resetTimer()
        }
    }

    private func startTimer() {
        secondsLeft = 6; phase = .waiting
        if !message.isEmpty { history.insert(TimerEntry(question: message), at: 0) }
        speechEngine.speak("Timer started. Stay quiet for 6 seconds.")
        timerSub = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { _ in
            if secondsLeft > 1 {
                secondsLeft -= 1
            } else {
                secondsLeft = 0; phase = .done
                timerSub?.cancel()
                let haptic = UINotificationFeedbackGenerator()
                haptic.notificationOccurred(.success)
                speechEngine.speak("Six seconds are up. You may now repeat your question if needed.")
            }
        }
    }

    private func cancelTimer() { timerSub?.cancel(); resetTimer() }
    private func resetTimer()  { phase = .idle; secondsLeft = 6 }

    private let tips = [
        "Use a neutral, calm voice and facial expression while waiting — stress is contagious.",
        "Avoid eye contact pressure during the 6 seconds — look slightly away to reduce anxiety.",
        "If you fidget or look impatient, the child may reset their processing and start again.",
        "This works for commands too, not just questions — 'Please put your shoes on' → wait 6 seconds.",
        "The 6-second rule is especially helpful for children with auditory processing differences.",
        "If the child is mid-sentence after the 6 seconds, never interrupt — let them finish.",
        "Praise the response regardless of correctness: 'Thank you for answering!'",
    ]
}
