import SwiftUI
import SwiftData

// MARK: - Rewards & Star Chart
// Motivational star chart tracking daily achievements.

@Model
class StarEntry {
    var id: UUID
    var date: Date
    var reason: String
    var emoji: String

    init(reason: String, emoji: String = "⭐️") {
        self.id     = UUID()
        self.date   = Date()
        self.reason = reason
        self.emoji  = emoji
    }
}

// MARK: - Rewards home

struct RewardsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \StarEntry.date, order: .reverse) private var stars: [StarEntry]
    @State private var showAddStar = false
    @State private var speechEngine = SpeechEngine()

    private var todayStars: [StarEntry] {
        stars.filter { Calendar.current.isDateInToday($0.date) }
    }
    private var weekStars: [StarEntry] {
        let week = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        return stars.filter { $0.date >= week }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Star summary banner
                summaryBanner
                    .padding(.horizontal, 20).padding(.top, 16)

                // Today's stars
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Today's Stars")
                            .font(.system(size: 16, weight: .semibold))
                        Spacer()
                        Text("\(todayStars.count) ⭐️")
                            .font(.system(size: 14)).foregroundColor(.secondary)
                    }.padding(.horizontal, 20)

                    if todayStars.isEmpty {
                        Text("No stars yet today — earn your first one!")
                            .font(.system(size: 14)).foregroundColor(.secondary)
                            .padding(.horizontal, 20).padding(.vertical, 8)
                    } else {
                        ForEach(todayStars) { star in
                            StarRow(star: star) { deleteStars(star) }
                        }
                        .padding(.horizontal, 20)
                    }
                }

                // This week chart
                weekChart
                    .padding(.horizontal, 20)

                // All time stars (recent)
                if stars.count > todayStars.count {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recent Stars")
                            .font(.system(size: 16, weight: .semibold)).padding(.horizontal, 20)
                        ForEach(stars.prefix(20)) { star in
                            StarRow(star: star) { deleteStars(star) }
                        }.padding(.horizontal, 20)
                    }
                }

                Spacer(minLength: 30)
            }
        }
        .navigationTitle("My Stars ⭐️")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showAddStar = true } label: {
                    Label("Add Star", systemImage: "star.fill")
                }
            }
        }
        .sheet(isPresented: $showAddStar) {
            AddStarSheet { reason, emoji in
                context.insert(StarEntry(reason: reason, emoji: emoji))
                try? context.save()
                speechEngine.speak("Brilliant! You earned a star for: \(reason)")
            }
        }
    }

    // MARK: Sub-views

    private var summaryBanner: some View {
        HStack(spacing: 20) {
            statPill(value: "\(todayStars.count)", label: "Today", color: "#BA7517")
            statPill(value: "\(weekStars.count)", label: "This Week", color: "#1D9E75")
            statPill(value: "\(stars.count)", label: "All Time", color: "#534AB7")
        }
        .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func statPill(value: String, label: String, color: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.system(size: 28, weight: .bold, design: .rounded)).foregroundColor(Color(hex: color))
            Text(label).font(.system(size: 11)).foregroundColor(.secondary)
        }.frame(maxWidth: .infinity)
    }

    private var weekChart: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("This Week").font(.system(size: 16, weight: .semibold))
            HStack(alignment: .bottom, spacing: 6) {
                ForEach(0..<7, id: \.self) { offset in
                    let day = Calendar.current.date(byAdding: .day, value: -(6 - offset), to: Date())!
                    let count = stars.filter { Calendar.current.isDate($0.date, inSameDayAs: day) }.count
                    let label = dayLabel(day)
                    VStack(spacing: 4) {
                        if count > 0 {
                            Text("\(count)").font(.system(size: 10, weight: .bold)).foregroundColor(Color(hex: "#BA7517"))
                        }
                        RoundedRectangle(cornerRadius: 6)
                            .fill(count > 0 ? Color(hex: "#BA7517") : Color(.systemFill))
                            .frame(height: max(8, CGFloat(count) * 18))
                        Text(label).font(.system(size: 10)).foregroundColor(.secondary)
                    }.frame(maxWidth: .infinity)
                }
            }
            .frame(height: 100, alignment: .bottom)
            .animation(.easeInOut, value: stars.count)
        }
        .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func dayLabel(_ date: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "EEE"; return f.string(from: date)
    }

    private func deleteStars(_ star: StarEntry) {
        context.delete(star); try? context.save()
    }
}

// MARK: - Star row

struct StarRow: View {
    let star: StarEntry
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(star.emoji).font(.system(size: 26))
            VStack(alignment: .leading, spacing: 2) {
                Text(star.reason).font(.system(size: 14, weight: .medium)).lineLimit(1)
                Text(star.date, style: .relative).font(.system(size: 11)).foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal, 14).padding(.vertical, 10)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.separator).opacity(0.3), lineWidth: 0.5))
        .swipeActions(edge: .trailing) {
            Button(role: .destructive, action: onDelete) { Label("Delete", systemImage: "trash") }
        }
    }
}

// MARK: - Add star sheet

struct AddStarSheet: View {
    let onAdd: (String, String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var reason = ""
    @State private var selectedEmoji = "⭐️"

    private let presets: [(String, String)] = [
        ("Tried something new", "🌟"), ("Was kind to someone", "💛"),
        ("Did my homework", "📚"), ("Ate all my food", "🍽️"),
        ("Stayed calm", "😌"), ("Asked for help", "🙋"),
        ("Made a friend", "🤝"), ("Finished my routine", "✅"),
        ("Was brave", "💪"), ("Listened well", "👂"),
        ("Shared with others", "🤲"), ("Said please & thank you", "🙏"),
    ]
    private let emojis = ["⭐️","🌟","🏅","🎯","💎","🎉","🏆","💛","💚","💙","💜","❤️"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Quick reasons") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 8)], spacing: 8) {
                        ForEach(presets, id: \.0) { p in
                            Button {
                                reason = p.0; selectedEmoji = p.1
                                onAdd(p.0, p.1); dismiss()
                            } label: {
                                HStack(spacing: 6) {
                                    Text(p.1).font(.system(size: 18))
                                    Text(p.0).font(.system(size: 12, weight: .medium)).foregroundColor(.primary).lineLimit(1)
                                }
                                .padding(.horizontal, 10).padding(.vertical, 8)
                                .background(Color(hex: "#BA7517").opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }.buttonStyle(.plain)
                        }
                    }.padding(.vertical, 4)
                }

                Section("Custom star") {
                    TextField("What did you do great?", text: $reason)
                    HStack(spacing: 10) {
                        Text("Star").font(.system(size: 14))
                        ForEach(emojis, id: \.self) { e in
                            Text(e).font(.system(size: 24))
                                .padding(4)
                                .background(selectedEmoji == e ? Color(hex: "#BA7517").opacity(0.2) : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                .onTapGesture { selectedEmoji = e }
                        }
                    }
                }
            }
            .navigationTitle("Add a Star")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading)  { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add ⭐️") {
                        guard !reason.isEmpty else { return }
                        onAdd(reason, selectedEmoji); dismiss()
                    }.disabled(reason.isEmpty).fontWeight(.medium)
                }
            }
        }
    }
}
