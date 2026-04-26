import SwiftUI
import SwiftData

/// Module 2 — Screen 2: Identify Mode
/// A scenario or animated face is shown. Child taps the correct emotion from 4 choices.
struct IdentifyModeView: View {
    @Environment(\.modelContext) private var context
    @State private var speechEngine   = SpeechEngine()
    @State private var currentCard    = EmotionScenario.random()
    @State private var choices        : [Emotion] = []
    @State private var selectedAnswer : Emotion?  = nil
    @State private var showResult     = false
    @State private var score          = 0
    @State private var questionNumber = 1
    @State private var shake          = false
    @State private var bounce         = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Score header
                scoreHeader
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                // Scenario card
                scenarioCard
                    .padding(.horizontal, 20)

                // Answer choices
                choiceGrid
                    .padding(.horizontal, 20)

                // Result feedback
                if showResult {
                    resultBanner
                        .padding(.horizontal, 20)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // Next button
                if showResult {
                    Button {
                        nextQuestion()
                    } label: {
                        Text("Next question →")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(hex: "#1D9E75"))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .transition(.opacity)
                }
            }
        }
        .navigationTitle("Identify Mode")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { setupChoices() }
    }

    // MARK: - Sub-views

    private var scoreHeader: some View {
        HStack {
            Label("Question \(questionNumber)", systemImage: "questionmark.circle")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 14))
                Text("\(score)")
                    .font(.system(size: 15, weight: .medium))
            }
        }
    }

    private var scenarioCard: some View {
        VStack(spacing: 16) {
            // Real photo (emoji fallback if offline)
            AsyncImage(url: URL(string: currentCard.emotion.realPhotoURL)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                        .frame(height: 160).clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                default:
                    Text(currentCard.emotion.emoji).font(.system(size: 80)).frame(height: 160)
                }
            }
            .scaleEffect(bounce ? 1.02 : 1.0)
            .animation(.spring(response: 0.3), value: bounce)

            // Scenario text
            VStack(spacing: 6) {
                Text("How does this person feel?")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                Text(currentCard.scenario)
                    .font(.system(size: 16, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // Hear the scenario
            Button {
                speechEngine.speak(currentCard.scenario)
            } label: {
                Label("Hear the story", systemImage: "speaker.wave.2")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#1D9E75"))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var choiceGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)],
                  spacing: 12) {
            ForEach(choices, id: \.self) { emotion in
                ChoiceButton(
                    emotion: emotion,
                    state: buttonState(for: emotion),
                    shake: shake && selectedAnswer == emotion && emotion != currentCard.emotion
                ) {
                    guard !showResult else { return }
                    selectAnswer(emotion)
                }
            }
        }
    }

    private var resultBanner: some View {
        let correct = selectedAnswer == currentCard.emotion
        let bgColor: Color = correct
            ? Color(hex: "#1D9E75").alpha(0.1)
            : Color(hex: "#D85A30").alpha(0.1)
        return HStack(spacing: 12) {
            Text(correct ? "✓" : "✗")
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(correct ? Color(hex: "#1D9E75") : Color(hex: "#D85A30"))

            VStack(alignment: .leading, spacing: 2) {
                Text(correct ? "That's right!" : "Not quite — it's \(currentCard.emotion.displayName)")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)
                Text(currentCard.emotion.description)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(14)
        .background(bgColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Logic

    private func buttonState(for emotion: Emotion) -> ChoiceButtonState {
        guard showResult else { return .idle }
        if emotion == currentCard.emotion { return .correct }
        if emotion == selectedAnswer       { return .wrong   }
        return .idle
    }

    private func setupChoices() {
        // Always include the correct answer + 3 distractors
        var pool = Emotion.allCases.filter { $0 != currentCard.emotion }.shuffled()
        choices = ([currentCard.emotion] + pool.prefix(3)).shuffled()
        selectedAnswer = nil
        showResult = false
        bounce = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { bounce = false }
        speechEngine.speak(currentCard.scenario)
    }

    private func selectAnswer(_ emotion: Emotion) {
        selectedAnswer = emotion
        let correct = emotion == currentCard.emotion

        if correct {
            score += 1
            let haptic = UINotificationFeedbackGenerator()
            haptic.notificationOccurred(.success)
            speechEngine.speak("Yes! That's \(currentCard.emotion.displayName)!")
        } else {
            shake = true
            let haptic = UINotificationFeedbackGenerator()
            haptic.notificationOccurred(.error)
            speechEngine.speak("Good try! This one is \(currentCard.emotion.displayName).")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { shake = false }
        }

        context.insert(EmotionAttempt(emotion: currentCard.emotion,
                                      wasCorrect: correct,
                                      gameMode: .identify))
        try? context.save()

        withAnimation { showResult = true }
    }

    private func nextQuestion() {
        questionNumber += 1
        currentCard = EmotionScenario.random()
        withAnimation { showResult = false }
        setupChoices()
    }
}

// MARK: - Choice button states

enum ChoiceButtonState { case idle, correct, wrong }

struct ChoiceButton: View {
    let emotion: Emotion
    let state: ChoiceButtonState
    let shake: Bool
    let action: () -> Void

    @State private var offset: CGFloat = 0

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                AsyncImage(url: URL(string: emotion.realPhotoURL)) { phase in
                    if case .success(let img) = phase {
                        img.resizable().scaledToFill()
                            .frame(width: 56, height: 56).clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        Text(emotion.emoji).font(.system(size: 36))
                    }
                }
                .frame(width: 56, height: 56)
                Text(emotion.displayName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(textColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(borderColor, lineWidth: state == .idle ? 0.5 : 2)
            )
            .offset(x: offset)
        }
        .buttonStyle(.plain)
        .onChange(of: shake) { _, shaking in
            guard shaking else { return }
            withAnimation(.easeInOut(duration: 0.06).repeatCount(5, autoreverses: true)) {
                offset = 6
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { offset = 0 }
        }
    }

    private var bgColor: Color {
        switch state {
        case .idle:
            return Color(.secondarySystemBackground)
        case .correct:
            let c: Color = Color(hex: "#1D9E75")
            return c.alpha(0.15)
        case .wrong:
            let c: Color = Color(hex: "#D85A30")
            return c.alpha(0.12)
        }
    }

    private var borderColor: Color {
        switch state {
        case .idle:
            let c: Color = Color(.separator)
            return c.alpha(0.4)
        case .correct:
            return Color(hex: "#1D9E75")
        case .wrong:
            return Color(hex: "#D85A30")
        }
    }
    private var textColor: Color {
        switch state {
        case .idle:    return .primary
        case .correct: return Color(hex: "#1D9E75")
        case .wrong:   return Color(hex: "#D85A30")
        }
    }
}

// MARK: - Scenario bank

struct EmotionScenario {
    let emotion: Emotion
    let scenario: String

    static let all: [EmotionScenario] = [
        .init(emotion: .happy,     scenario: "It's your birthday and all your friends came to the party!"),
        .init(emotion: .happy,     scenario: "You finished a really hard puzzle all by yourself."),
        .init(emotion: .happy,     scenario: "Your favourite meal is ready for dinner."),
        .init(emotion: .sad,       scenario: "Your pet is sick and you miss playing with them."),
        .init(emotion: .sad,       scenario: "Your best friend moved to a different school."),
        .init(emotion: .sad,       scenario: "You dropped your ice cream on the floor."),
        .init(emotion: .angry,     scenario: "Someone took your toy without asking."),
        .init(emotion: .angry,     scenario: "You waited a long time but it still isn't your turn."),
        .init(emotion: .angry,     scenario: "The game crashed just before you reached the final level."),
        .init(emotion: .scared,    scenario: "You heard a very loud noise in the dark."),
        .init(emotion: .scared,    scenario: "You got lost in a big unfamiliar place."),
        .init(emotion: .scared,    scenario: "A big dog ran towards you unexpectedly."),
        .init(emotion: .surprised, scenario: "You opened a gift and it was exactly what you wanted!"),
        .init(emotion: .surprised, scenario: "Your teacher said there's no school tomorrow."),
        .init(emotion: .surprised, scenario: "You found a £10 note on the pavement."),
        .init(emotion: .calm,      scenario: "You are sitting quietly reading your favourite book."),
        .init(emotion: .calm,      scenario: "You just finished a warm bath before bedtime."),
        .init(emotion: .calm,      scenario: "You are listening to gentle music and breathing slowly."),
    ]

    static func random() -> EmotionScenario {
        all.randomElement()!
    }
}
