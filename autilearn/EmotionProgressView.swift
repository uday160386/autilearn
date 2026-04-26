import SwiftUI
import SwiftData

/// Parent-facing progress dashboard for the emotion trainer
struct EmotionProgressView: View {
    @Query(sort: \EmotionAttempt.timestamp, order: .reverse) private var attempts: [EmotionAttempt]

    private var totalAttempts: Int { attempts.count }
    private var totalCorrect: Int  { attempts.filter(\.wasCorrect).count }
    private var accuracy: Double {
        guard totalAttempts > 0 else { return 0 }
        return Double(totalCorrect) / Double(totalAttempts) * 100
    }

    // Per-emotion accuracy
    private func stats(for emotion: Emotion) -> (attempts: Int, correct: Int) {
        let filtered = attempts.filter { $0.emotion == emotion }
        return (filtered.count, filtered.filter(\.wasCorrect).count)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Summary cards
                summaryRow
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                // Per-emotion breakdown
                VStack(alignment: .leading, spacing: 12) {
                    Text("By emotion")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 20)

                    ForEach(Emotion.allCases, id: \.self) { emotion in
                        EmotionProgressRow(
                            emotion: emotion,
                            stats: stats(for: emotion)
                        )
                        .padding(.horizontal, 20)
                    }
                }

                // Recent attempts
                if !attempts.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recent attempts")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)

                        ForEach(attempts.prefix(10)) { attempt in
                            HStack {
                                Text(attempt.emotion.emoji)
                                    .font(.title3)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(attempt.emotion.displayName)
                                        .font(.system(size: 14, weight: .medium))
                                    Text(attempt.gameMode.capitalized + " mode")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: attempt.wasCorrect
                                      ? "checkmark.circle.fill"
                                      : "xmark.circle.fill")
                                    .foregroundColor(attempt.wasCorrect
                                                     ? Color(hex: "#1D9E75")
                                                     : Color(hex: "#D85A30"))
                                Text(attempt.timestamp, style: .time)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 6)
                        }
                    }
                }

                Spacer(minLength: 30)
            }
        }
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var summaryRow: some View {
        HStack(spacing: 12) {
            StatCard(label: "Attempts", value: "\(totalAttempts)")
            StatCard(label: "Correct",  value: "\(totalCorrect)")
            StatCard(label: "Accuracy", value: "\(Int(accuracy))%")
        }
    }
}

// StatCard is defined in SharedComponents.swift

struct EmotionProgressRow: View {
    let emotion: Emotion
    let stats: (attempts: Int, correct: Int)

    private var pct: Double {
        guard stats.attempts > 0 else { return 0 }
        return Double(stats.correct) / Double(stats.attempts)
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(emotion.emoji)
                .font(.title3)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(emotion.displayName)
                        .font(.system(size: 14, weight: .medium))
                    Spacer()
                    Text(stats.attempts == 0
                         ? "Not tried yet"
                         : "\(stats.correct)/\(stats.attempts)")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(.systemFill))
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(emotion.color)
                            .frame(width: geo.size.width * pct, height: 6)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
