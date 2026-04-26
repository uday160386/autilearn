import SwiftUI
import Combine

// MARK: - Calming Tools
// Interactive breathing exercises, sensory tools, and calming techniques.

// MARK: - Breathing exercise model

struct BreathingExercise: Identifiable {
    let id: Int
    let name: String
    let emoji: String
    let colorHex: String
    let description: String
    let phases: [BreathPhase]
    let rounds: Int
}

struct BreathPhase {
    let label: String     // "Breathe in", "Hold", "Breathe out"
    let seconds: Int
    let colorHex: String
}

extension BreathingExercise {
    static let all: [BreathingExercise] = [
        BreathingExercise(
            id: 1, name: "Box Breathing", emoji: "🟦", colorHex: "#185FA5",
            description: "Breathe in a square pattern. Great for calming fast.",
            phases: [
                BreathPhase(label: "Breathe in", seconds: 4, colorHex: "#1D9E75"),
                BreathPhase(label: "Hold", seconds: 4, colorHex: "#BA7517"),
                BreathPhase(label: "Breathe out", seconds: 4, colorHex: "#185FA5"),
                BreathPhase(label: "Hold", seconds: 4, colorHex: "#534AB7"),
            ], rounds: 4
        ),
        BreathingExercise(
            id: 2, name: "Star Breathing", emoji: "⭐️", colorHex: "#BA7517",
            description: "Trace the 5 points of a star as you breathe.",
            phases: [
                BreathPhase(label: "Breathe in", seconds: 3, colorHex: "#1D9E75"),
                BreathPhase(label: "Breathe out", seconds: 3, colorHex: "#185FA5"),
                BreathPhase(label: "Breathe in", seconds: 3, colorHex: "#1D9E75"),
                BreathPhase(label: "Breathe out", seconds: 3, colorHex: "#185FA5"),
                BreathPhase(label: "Breathe in", seconds: 3, colorHex: "#1D9E75"),
            ], rounds: 3
        ),
        BreathingExercise(
            id: 3, name: "4-7-8 Breathing", emoji: "😮‍💨", colorHex: "#1D9E75",
            description: "In for 4, hold for 7, out for 8. Very calming at bedtime.",
            phases: [
                BreathPhase(label: "Breathe in", seconds: 4, colorHex: "#1D9E75"),
                BreathPhase(label: "Hold", seconds: 7, colorHex: "#BA7517"),
                BreathPhase(label: "Breathe out", seconds: 8, colorHex: "#185FA5"),
            ], rounds: 3
        ),
        BreathingExercise(
            id: 4, name: "Belly Breathing", emoji: "🫁", colorHex: "#D4537E",
            description: "Put your hand on your tummy and feel it rise and fall.",
            phases: [
                BreathPhase(label: "Breathe in slowly", seconds: 4, colorHex: "#1D9E75"),
                BreathPhase(label: "Breathe out slowly", seconds: 6, colorHex: "#185FA5"),
            ], rounds: 5
        ),
    ]
}

// MARK: - Calming tools home

struct CalmingToolsHomeView: View {
    @State private var selectedExercise: BreathingExercise? = nil
    @State private var showSensoryTools = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Header
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Calm my Body")
                            .font(.system(size: 20, weight: .medium))
                        Text("Breathing and calming exercises")
                            .font(.system(size: 14)).foregroundColor(.secondary)
                    }
                    Spacer()
                    ZStack {
                        Circle().fill(Color(hex: "#5DCAA5").opacity(0.15)).frame(width: 56, height: 56)
                        Text("🧘").font(.system(size: 28))
                    }
                }
                .padding(16).background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20).padding(.top, 16)

                // Breathing section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Breathing Exercises")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(.horizontal, 20)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 14)], spacing: 14) {
                        ForEach(BreathingExercise.all) { ex in
                            BreathingCard(exercise: ex) { selectedExercise = ex }
                        }
                    }
                    .padding(.horizontal, 20)
                }

                // Sensory tools
                VStack(alignment: .leading, spacing: 10) {
                    Text("Calming Activities")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(.horizontal, 20)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 14)], spacing: 14) {
                        ForEach(SensoryTool.all) { tool in
                            NavigationLink(destination: SensoryToolView(tool: tool)) {
                                SensoryToolCard(tool: tool)
                            }.buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                }

                Spacer(minLength: 30)
            }
        }
        .navigationTitle("Calm Corner")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedExercise) { ex in
            BreathingExerciseView(exercise: ex)
        }
    }
}

// MARK: - Breathing card

struct BreathingCard: View {
    let exercise: BreathingExercise
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(exercise.emoji).font(.system(size: 32))
                    Spacer()
                    Text("\(exercise.rounds)×").font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(hex: exercise.colorHex))
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color(hex: exercise.colorHex).opacity(0.12)).clipShape(Capsule())
                }
                Text(exercise.name).font(.system(size: 14, weight: .semibold)).foregroundColor(.primary)
                Text(exercise.description).font(.system(size: 12)).foregroundColor(.secondary).lineLimit(2)
            }
            .padding(14).frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: exercise.colorHex).opacity(0.3), lineWidth: 1))
        }.buttonStyle(.plain)
    }
}

// MARK: - Animated breathing exercise

struct BreathingExerciseView: View {
    let exercise: BreathingExercise
    @Environment(\.dismiss) private var dismiss
    @State private var phase     = 0
    @State private var countdown = 0
    @State private var round     = 1
    @State private var running   = false
    @State private var done      = false
    @State private var scale: CGFloat = 0.6
    @State private var speechEngine  = SpeechEngine()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var currentPhase: BreathPhase { exercise.phases[phase] }

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                // Animated circle
                ZStack {
                    Circle().fill(Color(hex: currentPhase.colorHex).opacity(0.08)).frame(width: 240, height: 240)
                    Circle().stroke(Color(hex: currentPhase.colorHex).opacity(0.3), lineWidth: 3).frame(width: 240, height: 240)
                    Circle().fill(Color(hex: currentPhase.colorHex).opacity(0.25))
                        .frame(width: 160, height: 160).scaleEffect(scale)
                        .animation(.easeInOut(duration: Double(currentPhase.seconds)), value: scale)

                    VStack(spacing: 6) {
                        if done {
                            Text("🎉").font(.system(size: 48))
                            Text("Done!").font(.system(size: 22, weight: .bold)).foregroundColor(Color(hex: "#1D9E75"))
                        } else {
                            Text(currentPhase.label)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(hex: currentPhase.colorHex))
                                .multilineTextAlignment(.center)
                            if running {
                                Text("\(countdown)")
                                    .font(.system(size: 44, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(hex: currentPhase.colorHex))
                            }
                        }
                    }
                }

                if !done {
                    Text("Round \(round) of \(exercise.rounds)")
                        .font(.system(size: 14)).foregroundColor(.secondary)
                }

                // Control button
                Button {
                    if done { dismiss() }
                    else if running { stopExercise() }
                    else { startExercise() }
                } label: {
                    Text(done ? "Finish 🌟" : running ? "Stop" : "Start")
                        .font(.system(size: 17, weight: .semibold)).foregroundColor(.white)
                        .padding(.horizontal, 48).padding(.vertical, 16)
                        .background(done ? Color(hex: "#1D9E75") : running ? Color(hex: "#D85A30") : Color(hex: exercise.colorHex))
                        .clipShape(Capsule())
                }

                Spacer()
            }
            .navigationTitle(exercise.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarLeading) { Button("Close") { dismiss() } } }
            .onReceive(timer) { _ in guard running else { return }; tick() }
            .onDisappear { running = false }
        }
    }

    private func startExercise() {
        phase = 0; round = 1; done = false; running = true
        countdown = currentPhase.seconds
        speechEngine.speak(currentPhase.label)
        animatePhase()
    }

    private func stopExercise() { running = false }

    private func tick() {
        countdown -= 1
        if countdown <= 0 { nextPhase() }
    }

    private func nextPhase() {
        phase += 1
        if phase >= exercise.phases.count {
            phase = 0; round += 1
            if round > exercise.rounds { running = false; done = true; speechEngine.speak("Well done! You finished!"); return }
        }
        countdown = currentPhase.seconds
        speechEngine.speak(currentPhase.label)
        animatePhase()
    }

    private func animatePhase() {
        let isInhale = currentPhase.label.lowercased().contains("in")
        withAnimation(.easeInOut(duration: Double(currentPhase.seconds))) {
            scale = isInhale ? 1.3 : 0.6
        }
    }
}

// MARK: - Sensory tools

struct SensoryTool: Identifiable {
    let id: Int
    let name: String
    let emoji: String
    let colorHex: String
    let description: String
    let type: ToolType
    enum ToolType { case bubbles, spinner, squeeze, sounds, count5 }
}

extension SensoryTool {
    static let all: [SensoryTool] = [
        SensoryTool(id: 1, name: "Pop Bubbles", emoji: "🫧", colorHex: "#185FA5", description: "Tap to pop calming bubbles", type: .bubbles),
        SensoryTool(id: 2, name: "Fidget Spinner", emoji: "💫", colorHex: "#534AB7", description: "Spin to focus your mind", type: .spinner),
        SensoryTool(id: 3, name: "5 Things I See", emoji: "👀", colorHex: "#1D9E75", description: "Grounding — notice the world around you", type: .count5),
        SensoryTool(id: 4, name: "Squeeze & Release", emoji: "✊", colorHex: "#D85A30", description: "Squeeze tight then let go to release tension", type: .squeeze),
    ]
}

struct SensoryToolCard: View {
    let tool: SensoryTool
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: tool.colorHex).opacity(0.12)).frame(height: 70)
                Text(tool.emoji).font(.system(size: 36))
            }
            Text(tool.name).font(.system(size: 13, weight: .semibold)).foregroundColor(.primary).lineLimit(1)
            Text(tool.description).font(.system(size: 11)).foregroundColor(.secondary).lineLimit(2).multilineTextAlignment(.center)
        }
        .padding(12).frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.separator).opacity(0.3), lineWidth: 0.5))
    }
}

// MARK: - Sensory tool interactive view

struct SensoryToolView: View {
    let tool: SensoryTool

    var body: some View {
        switch tool.type {
        case .bubbles:  BubblePopView(colorHex: tool.colorHex)
        case .spinner:  SpinnerView(colorHex: tool.colorHex)
        case .count5:   Count5View()
        case .squeeze:  SqueezeView(colorHex: tool.colorHex)
        case .sounds:   Count5View()
        }
    }
}

// MARK: Bubble pop

struct BubblePopView: View {
    let colorHex: String
    @State private var bubbles: [BubbleItem] = []
    @State private var speechEngine = SpeechEngine()

    struct BubbleItem: Identifiable {
        let id = UUID()
        var x: CGFloat; var y: CGFloat
        var size: CGFloat; var popped = false
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(hex: "#E6F1FB").opacity(0.3).ignoresSafeArea()
                ForEach($bubbles) { $b in
                    Circle()
                        .fill(b.popped ? Color.clear : Color(hex: colorHex).opacity(0.3))
                        .overlay(Circle().stroke(Color(hex: colorHex).opacity(b.popped ? 0 : 0.6), lineWidth: 2))
                        .frame(width: b.size, height: b.size)
                        .position(x: b.x, y: b.y)
                        .scaleEffect(b.popped ? 1.5 : 1)
                        .animation(.spring(response: 0.2), value: b.popped)
                        .onTapGesture {
                            b.popped = true
                            speechEngine.speak("Pop!")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { spawnBubble(in: geo.size) }
                        }
                }
            }
            .onAppear {
                for _ in 0..<12 { spawnBubble(in: geo.size) }
            }
        }
        .navigationTitle("Pop Bubbles")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func spawnBubble(in size: CGSize) {
        let b = BubbleItem(
            x: CGFloat.random(in: 40...(size.width - 40)),
            y: CGFloat.random(in: 80...(size.height - 80)),
            size: CGFloat.random(in: 44...80)
        )
        bubbles.append(b)
        if bubbles.count > 20 { bubbles.removeFirst() }
    }
}

// MARK: Spinner

struct SpinnerView: View {
    let colorHex: String
    @State private var angle: Double = 0
    @State private var speed: Double = 0
    @GestureState private var drag: CGFloat = 0

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            ZStack {
                ForEach(0..<8, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(hex: colorHex).opacity(0.6 - Double(i) * 0.06))
                        .frame(width: 24, height: 70)
                        .offset(y: -70)
                        .rotationEffect(.degrees(Double(i) * 45))
                }
            }
            .frame(width: 160, height: 160)
            .rotationEffect(.degrees(angle))
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
                    angle += speed
                    speed = max(0, speed - 0.05)
                }
            }
            .onTapGesture { speed = min(speed + 30, 360) }
            .gesture(DragGesture().onChanged { v in speed = min(abs(v.translation.width / 3), 360) })

            Text("Tap or swipe to spin")
                .font(.system(size: 15)).foregroundColor(.secondary)
            Spacer()
        }
        .navigationTitle("Fidget Spinner")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: 5 senses grounding

struct Count5View: View {
    private let steps: [(String, String, String)] = [
        ("5 things you can SEE", "👀", "#185FA5"),
        ("4 things you can TOUCH", "✋", "#1D9E75"),
        ("3 things you can HEAR", "👂", "#534AB7"),
        ("2 things you can SMELL", "👃", "#BA7517"),
        ("1 thing you can TASTE", "👅", "#D85A30"),
    ]
    @State private var current = 0
    @State private var speechEngine = SpeechEngine()

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text(steps[current].1).font(.system(size: 80)).padding(.bottom, 16)
            Text(steps[current].0)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color(hex: steps[current].2))
                .multilineTextAlignment(.center).padding(.horizontal, 32)
            Text("Look around you and notice \(5 - current) thing\(current == 4 ? "" : "s").")
                .font(.system(size: 15)).foregroundColor(.secondary)
                .multilineTextAlignment(.center).padding(.horizontal, 32).padding(.top, 12)
            Spacer()
            HStack {
                ForEach(0..<5, id: \.self) { i in
                    Circle().fill(i == current ? Color(hex: steps[i].2) : Color(.systemFill)).frame(width: 10, height: 10)
                }
            }.padding(.bottom, 24)
            Button {
                speechEngine.speak(steps[current].0)
                withAnimation { current = (current + 1) % 5 }
            } label: {
                Text(current == 4 ? "Start again 🔁" : "Next →")
                    .font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                    .padding(.horizontal, 40).padding(.vertical, 14)
                    .background(Color(hex: steps[current].2)).clipShape(Capsule())
            }
            .padding(.bottom, 40)
        }
        .navigationTitle("5 Senses")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { speechEngine.speak(steps[0].0) }
    }
}

// MARK: Squeeze & release

struct SqueezeView: View {
    let colorHex: String
    @State private var squeezing = false
    @State private var speechEngine = SpeechEngine()

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text(squeezing ? "SQUEEZE! 💪" : "Now release... 😮‍💨")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(squeezing ? Color(hex: colorHex) : .secondary)
                .animation(.easeInOut, value: squeezing)
            ZStack {
                Circle().fill(Color(hex: colorHex).opacity(squeezing ? 0.3 : 0.08))
                    .frame(width: 200, height: 200)
                    .scaleEffect(squeezing ? 0.85 : 1.0)
                    .animation(.easeInOut(duration: 0.15), value: squeezing)
                Text("✊").font(.system(size: 72)).scaleEffect(squeezing ? 0.8 : 1.0)
                    .animation(.easeInOut(duration: 0.15), value: squeezing)
            }
            Text("Hold the button tight, then let go slowly.")
                .font(.system(size: 14)).foregroundColor(.secondary).multilineTextAlignment(.center).padding(.horizontal, 40)
            Button {} label: {
                Text(squeezing ? "Squeezing..." : "Hold to Squeeze")
                    .font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                    .padding(.horizontal, 40).padding(.vertical, 16)
                    .background(squeezing ? Color(hex: colorHex) : Color(.systemFill))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !squeezing { squeezing = true; speechEngine.speak("Squeeze tight!") }
                    }
                    .onEnded { _ in
                        squeezing = false; speechEngine.speak("Now slowly release. Feel the tension leaving your body.")
                    }
            )
            Spacer()
        }
        .navigationTitle("Squeeze & Release")
        .navigationBarTitleDisplayMode(.inline)
    }
}
