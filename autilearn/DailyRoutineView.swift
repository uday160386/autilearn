import SwiftUI
import SwiftData

// MARK: - Daily Routine Builder
// Visual schedule with drag-to-reorder, tap-to-complete, and speech support.

// MARK: - Model

@Model
class RoutineTask {
    var id: UUID
    var title: String
    var emoji: String
    var isCompleted: Bool
    var order: Int
    var colorHex: String

    init(title: String, emoji: String, order: Int, colorHex: String = "#1D9E75") {
        self.id          = UUID()
        self.title       = title
        self.emoji       = emoji
        self.isCompleted = false
        self.order       = order
        self.colorHex    = colorHex
    }
}

// MARK: - Home view

struct DailyRoutineView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \RoutineTask.order) private var tasks: [RoutineTask]
    @State private var speechEngine   = SpeechEngine()
    @State private var showAddTask    = false
    @State private var showCelebration = false

    private var completedCount: Int { tasks.filter(\.isCompleted).count }
    private var allDone: Bool       { !tasks.isEmpty && completedCount == tasks.count }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                progressBanner
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                if tasks.isEmpty {
                    emptyState
                        .padding(.horizontal, 20)
                        .padding(.top, 40)
                } else {
                    LazyVStack(spacing: 10) {
                        ForEach(tasks) { task in
                            RoutineTaskRow(task: task) {
                                toggleTask(task)
                            } onSpeak: {
                                speechEngine.speak(task.title)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }

                addButton
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
            }
        }
        .navigationTitle("My Daily Routine")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { resetAll() } label: {
                    Image(systemName: "arrow.counterclockwise")
                }
                .disabled(completedCount == 0)
            }
        }
        .sheet(isPresented: $showAddTask) {
            AddRoutineTaskSheet { title, emoji, color in
                addTask(title: title, emoji: emoji, color: color)
            }
        }
        .overlay {
            if showCelebration {
                CelebrationOverlay { showCelebration = false }
            }
        }
        .onAppear { seedDefaultTasksIfNeeded() }
    }

    // MARK: Sub-views

    private var progressBanner: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(allDone ? "All done! Great job! 🎉" : "Today's tasks")
                        .font(.system(size: 18, weight: .semibold))
                    Text("\(completedCount) of \(tasks.count) completed")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(Color(.systemFill), lineWidth: 6)
                        .frame(width: 52, height: 52)
                    Circle()
                        .trim(from: 0, to: tasks.isEmpty ? 0 : CGFloat(completedCount) / CGFloat(tasks.count))
                        .stroke(Color(hex: "#1D9E75"), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 52, height: 52)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.4), value: completedCount)
                    Text("\(tasks.isEmpty ? 0 : Int(CGFloat(completedCount) / CGFloat(tasks.count) * 100))%")
                        .font(.system(size: 11, weight: .bold))
                }
            }

            // Star dots
            HStack(spacing: 6) {
                ForEach(0..<max(tasks.count, 1), id: \.self) { i in
                    Circle()
                        .fill(i < completedCount ? Color(hex: "#1D9E75") : Color(.systemFill))
                        .frame(width: 10, height: 10)
                        .animation(.spring(response: 0.3), value: completedCount)
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Text("📋")
                .font(.system(size: 56))
            Text("No tasks yet")
                .font(.system(size: 18, weight: .medium))
            Text("Tap \"Add Task\" to build your daily routine")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var addButton: some View {
        Button { showAddTask = true } label: {
            Label("Add Task", systemImage: "plus.circle.fill")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color(hex: "#1D9E75"))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    // MARK: Logic

    private func toggleTask(_ task: RoutineTask) {
        withAnimation(.spring(response: 0.35)) {
            task.isCompleted.toggle()
        }
        speechEngine.speak(task.isCompleted ? "Done! \(task.title)" : task.title)
        try? context.save()
        if allDone {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                showCelebration = true
                speechEngine.speak("Amazing! You finished all your tasks today!")
            }
        }
    }

    private func resetAll() {
        for task in tasks { task.isCompleted = false }
        try? context.save()
    }

    private func deleteTasks(_ offsets: IndexSet) {
        let sorted = tasks
        for i in offsets { context.delete(sorted[i]) }
        try? context.save()
    }

    private func addTask(title: String, emoji: String, color: String) {
        let nextOrder = (tasks.map(\.order).max() ?? -1) + 1
        context.insert(RoutineTask(title: title, emoji: emoji, order: nextOrder, colorHex: color))
        try? context.save()
    }

    private func seedDefaultTasksIfNeeded() {
        guard tasks.isEmpty else { return }
        let defaults: [(String, String, String)] = [
            ("Wake up", "☀️", "#BA7517"),
            ("Brush teeth", "🪥", "#185FA5"),
            ("Get dressed", "👕", "#534AB7"),
            ("Eat breakfast", "🥣", "#D85A30"),
            ("Pack school bag", "🎒", "#1D9E75"),
            ("Go to school", "🏫", "#D4537E"),
            ("Do homework", "📚", "#185FA5"),
            ("Free play time", "🎮", "#1D9E75"),
            ("Bath time", "🛁", "#534AB7"),
            ("Bedtime", "😴", "#BA7517"),
        ]
        for (i, (title, emoji, color)) in defaults.enumerated() {
            context.insert(RoutineTask(title: title, emoji: emoji, order: i, colorHex: color))
        }
        try? context.save()
    }
}

// MARK: - Task row

struct RoutineTaskRow: View {
    let task: RoutineTask
    let onToggle: () -> Void
    let onSpeak: () -> Void
    @State private var pressed = false

    var body: some View {
        HStack(spacing: 14) {
            // Emoji bubble
            ZStack {
                Circle()
                    .fill(Color(hex: task.colorHex).opacity(task.isCompleted ? 0.25 : 0.12))
                    .frame(width: 52, height: 52)
                Text(task.emoji)
                    .font(.system(size: 26))
                    .opacity(task.isCompleted ? 0.4 : 1)
            }

            // Title
            Text(task.title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(task.isCompleted ? .secondary : .primary)
                .strikethrough(task.isCompleted)
                .lineLimit(2)

            Spacer()

            // Speak button
            Button(action: onSpeak) {
                Image(systemName: "speaker.wave.2")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            .padding(.trailing, 4)

            // Tick button
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .fill(task.isCompleted ? Color(hex: "#1D9E75") : Color(.systemFill))
                        .frame(width: 36, height: 36)
                    if task.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(task.isCompleted ? Color(hex: "#1D9E75").opacity(0.4) : Color(.separator).opacity(0.3), lineWidth: 1)
        )
        .scaleEffect(pressed ? 0.97 : 1)
        .animation(.easeInOut(duration: 0.1), value: pressed)
    }
}

// MARK: - Add task sheet

struct AddRoutineTaskSheet: View {
    let onAdd: (String, String, String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var title  = ""
    @State private var emoji  = ""
    @State private var color  = "#1D9E75"

    private let presets: [(String, String, String)] = [
        ("Wake up", "☀️", "#BA7517"), ("Eat breakfast", "🥣", "#D85A30"),
        ("Brush teeth", "🪥", "#185FA5"), ("Get dressed", "👕", "#534AB7"),
        ("Drink water", "💧", "#185FA5"), ("Take medicine", "💊", "#D85A30"),
        ("Go outside", "🌳", "#1D9E75"), ("Read a book", "📖", "#534AB7"),
        ("Exercise", "🏃", "#1D9E75"), ("Wash hands", "🤲", "#5DCAA5"),
        ("Tidy room", "🧹", "#BA7517"), ("Bedtime", "😴", "#534AB7"),
    ]

    private let colors = ["#1D9E75","#185FA5","#534AB7","#D85A30","#BA7517","#D4537E","#5DCAA5"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Quick add") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 10)], spacing: 10) {
                        ForEach(presets, id: \.0) { p in
                            Button {
                                title = p.0; emoji = p.1; color = p.2
                                onAdd(p.0, p.1, p.2); dismiss()
                            } label: {
                                HStack(spacing: 8) {
                                    Text(p.1).font(.system(size: 20))
                                    Text(p.0).font(.system(size: 13, weight: .medium)).foregroundColor(.primary).lineLimit(1)
                                }
                                .padding(.horizontal, 10).padding(.vertical, 8)
                                .background(Color(hex: p.2).opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("Custom task") {
                    TextField("Task name (e.g. Drink water)", text: $title)
                    TextField("Emoji (e.g. 💧)", text: $emoji)
                    HStack(spacing: 10) {
                        Text("Colour")
                        ForEach(colors, id: \.self) { c in
                            Circle().fill(Color(hex: c)).frame(width: 28, height: 28)
                                .overlay(Circle().stroke(color == c ? Color.primary : Color.clear, lineWidth: 2.5))
                                .onTapGesture { color = c }
                        }
                    }
                }
            }
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading)  { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        guard !title.isEmpty else { return }
                        onAdd(title, emoji.isEmpty ? "✅" : emoji, color)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                    .fontWeight(.medium)
                }
            }
        }
    }
}

// MARK: - Celebration overlay

struct CelebrationOverlay: View {
    let onDismiss: () -> Void
    @State private var scale = 0.3

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            VStack(spacing: 20) {
                Text("⭐️🎉⭐️").font(.system(size: 60))
                    .scaleEffect(scale)
                    .onAppear { withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) { scale = 1 } }
                Text("All Done!").font(.system(size: 32, weight: .bold)).foregroundColor(.white)
                Text("You finished all your tasks.\nAmazing work today!").font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.85)).multilineTextAlignment(.center)
                Button("Yay! 🎊") { onDismiss() }
                    .font(.system(size: 16, weight: .semibold)).foregroundColor(.black)
                    .padding(.horizontal, 36).padding(.vertical, 14)
                    .background(Color.white).clipShape(Capsule())
            }
        }
    }
}
