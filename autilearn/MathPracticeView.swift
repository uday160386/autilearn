import SwiftUI
import SwiftData

// MARK: - Math Practice: one problem at a time

struct MathPracticeView: View {
    let operation: MathOperation

    @Environment(\.modelContext) private var context

    @State private var speechEngine   = SpeechEngine()
    @State private var currentProblem : MathProblem
    @State private var answerText     = ""
    @State private var resultState    : ResultState = .waiting
    @State private var shakeOffset    : CGFloat = 0
    @State private var sessionCorrect = 0
    @State private var sessionTried   = 0
    @FocusState private var inputFocused: Bool

    enum ResultState { case waiting, correct, wrong }

    init(operation: MathOperation) {
        self.operation = operation
        _currentProblem = State(initialValue: operation.randomProblem())
    }

    private var accentColor: Color { Color(hex: operation.colorHex) }

    // Session star count (1 star per 3 correct)
    private var stars: Int { sessionCorrect / 3 }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Score strip
                scoreStrip
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                // Visual dots (helps younger learners count)
                if currentProblem.dotCount > 0 {
                    dotsVisualiser
                        .padding(.horizontal, 20)
                }

                // Problem card
                problemCard
                    .padding(.horizontal, 20)

                // Answer input + check
                answerSection
                    .padding(.horizontal, 20)

                // Feedback banner
                if resultState != .waiting {
                    feedbackBanner
                        .padding(.horizontal, 20)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer(minLength: 40)
            }
        }
        .navigationTitle(operation.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { inputFocused = true }
        .frame(maxWidth: 700)
        .frame(maxWidth: .infinity)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Check ✓") { checkAnswer() }
                    .fontWeight(.medium)
                    .disabled(answerText.isEmpty)
            }
        }
    }

    // MARK: - Sub-views

    private var scoreStrip: some View {
        HStack(spacing: 0) {
            ScorePill(label: "Correct", value: "\(sessionCorrect)", color: accentColor)
            Spacer()
            // Stars
            HStack(spacing: 4) {
                ForEach(0..<5, id: \.self) { i in
                    Image(systemName: i < (sessionCorrect % 5 == 0 && sessionCorrect > 0 ? 5 : sessionCorrect % 5) ? "star.fill" : "star")
                        .font(.system(size: 14))
                        .foregroundColor(.yellow)
                }
            }
            Spacer()
            ScorePill(label: "Tried", value: "\(sessionTried)", color: .secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var dotsVisualiser: some View {
        let dotIcons = ["🍎", "🌟", "🔵", "🍊", "🟢"]
        let icon = dotIcons[(sessionTried) % dotIcons.count]
        return VStack(alignment: .leading, spacing: 6) {
            Text("Count the \(iconLabel(icon)):")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            LazyVGrid(
                columns: Array(repeating: GridItem(.fixed(30), spacing: 6), count: 10),
                spacing: 6
            ) {
                ForEach(0..<currentProblem.dotCount, id: \.self) { _ in
                    Text(icon)
                        .font(.system(size: 20))
                }
            }
        }
        .padding(14)
        .background(accentColor.alpha(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func iconLabel(_ icon: String) -> String {
        switch icon {
        case "🍎": return "apples"
        case "🌟": return "stars"
        case "🔵": return "dots"
        case "🍊": return "oranges"
        default:   return "shapes"
        }
    }

    private var problemCard: some View {
        VStack(spacing: 16) {
            HStack(alignment: .firstTextBaseline, spacing: 20) {
                Text("\(currentProblem.a)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                Text(operation.symbol)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(accentColor)

                Text("\(currentProblem.b)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                Text("=")
                    .font(.system(size: 48, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)

                Text("?")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(accentColor.alpha(0.4))
            }
            .frame(maxWidth: .infinity)

            // Hear the problem read aloud
            Button {
                speechEngine.speak(spokenProblem)
            } label: {
                Label("Hear the problem", systemImage: "speaker.wave.2")
                    .font(.system(size: 13))
                    .foregroundColor(accentColor)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .offset(x: shakeOffset)
    }

    private var answerSection: some View {
        VStack(spacing: 12) {
            TextField("Your answer", text: $answerText)
                .keyboardType(.numberPad)
                .focused($inputFocused)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(16)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            resultState == .correct ? accentColor
                            : resultState == .wrong   ? Color(hex: "#D85A30")
                            : Color(.separator).alpha(0.4),
                            lineWidth: resultState == .waiting ? 0.5 : 2
                        )
                )
                .onChange(of: answerText) { _, new in
                    // Strip non-digits
                    let filtered = new.filter { $0.isNumber }
                    if filtered != new { answerText = filtered }
                    if resultState != .waiting { resultState = .waiting }
                }

            HStack(spacing: 12) {
                Button {
                    checkAnswer()
                } label: {
                    Text("Check ✓")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(answerText.isEmpty ? Color.gray : accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(answerText.isEmpty)

                if resultState != .waiting {
                    Button {
                        nextProblem()
                    } label: {
                        Label("Next", systemImage: "arrow.right.circle.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(accentColor)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 20)
                            .background(accentColor.alpha(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .transition(.opacity)
                }
            }
        }
    }

    @ViewBuilder
    private var feedbackBanner: some View {
        let isCorrect = resultState == .correct
        HStack(spacing: 12) {
            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(isCorrect ? accentColor : Color(hex: "#D85A30"))

            VStack(alignment: .leading, spacing: 2) {
                Text(isCorrect ? "🎉 Brilliant! That's right!" : "Good try!")
                    .font(.system(size: 15, weight: .medium))
                if !isCorrect {
                    Text("The answer is \(currentProblem.answer).")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
        .padding(14)
        .background(
            (isCorrect ? accentColor : Color(hex: "#D85A30")).alpha(0.1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Logic

    private var spokenProblem: String {
        let ops: [MathOperation: String] = [
            .addition:       "plus",
            .subtraction:    "minus",
            .multiplication: "times",
            .division:       "divided by",
        ]
        return "\(currentProblem.a) \(ops[operation] ?? operation.rawValue) \(currentProblem.b) equals?"
    }

    private func checkAnswer() {
        guard let given = Int(answerText) else { return }
        sessionTried += 1
        let correct = given == currentProblem.answer

        withAnimation(.easeInOut(duration: 0.2)) {
            resultState = correct ? .correct : .wrong
        }

        if correct {
            sessionCorrect += 1
            let haptic = UINotificationFeedbackGenerator()
            haptic.notificationOccurred(.success)
            speechEngine.speak("Brilliant! \(currentProblem.a) \(operation.displayName == "Add" ? "plus" : operation.displayName.lowercased()) \(currentProblem.b) equals \(currentProblem.answer). Well done!")
        } else {
            // Shake the card
            withAnimation(.easeInOut(duration: 0.06).repeatCount(5, autoreverses: true)) {
                shakeOffset = 8
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { shakeOffset = 0 }

            let haptic = UINotificationFeedbackGenerator()
            haptic.notificationOccurred(.error)
            speechEngine.speak("Good try! The answer is \(currentProblem.answer).")
        }

        context.insert(MathAttempt(problem: currentProblem, givenAnswer: given))
        try? context.save()
    }

    private func nextProblem() {
        withAnimation {
            currentProblem = operation.randomProblem()
            answerText = ""
            resultState = .waiting
        }
        inputFocused = true
    }
}

// ScorePill is defined in SharedComponents.swift
