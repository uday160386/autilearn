import SwiftUI
import SwiftData

struct MathProgressView: View {
    @Query(sort: \MathAttempt.timestamp, order: .reverse) private var attempts: [MathAttempt]

    private var total: Int    { attempts.count }
    private var correct: Int  { attempts.filter(\.wasCorrect).count }
    private var accuracy: Int {
        guard total > 0 else { return 0 }
        return Int(Double(correct) / Double(total) * 100)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Summary
                HStack(spacing: 12) {
                    StatCard(label: "Solved",   value: "\(total)")
                    StatCard(label: "Correct",  value: "\(correct)")
                    StatCard(label: "Accuracy", value: "\(accuracy)%")
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                // Per-operation breakdown
                VStack(alignment: .leading, spacing: 10) {
                    Text("By operation")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 20)

                    ForEach(MathOperation.allCases, id: \.self) { op in
                        operationRow(for: op)
                            .padding(.horizontal, 20)
                    }
                }

                // Recent attempts
                if !attempts.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recent problems")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)

                        ForEach(attempts.prefix(15)) { attempt in
                            HStack {
                                Text(attempt.operation.capitalized)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Color(hex: opColorHex(attempt.operation)))
                                    .frame(width: 80, alignment: .leading)

                                Text("\(attempt.questionA) \(opSymbol(attempt.operation)) \(attempt.questionB) = \(attempt.correctAnswer)")
                                    .font(.system(size: 14, design: .rounded))
                                    .foregroundColor(.primary)

                                Spacer()

                                if !attempt.wasCorrect {
                                    Text("You said \(attempt.givenAnswer)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Image(systemName: attempt.wasCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(attempt.wasCorrect ? Color(hex: "#1D9E75") : Color(hex: "#D85A30"))
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 4)
                        }
                    }
                }

                Spacer(minLength: 30)
            }
        }
        .navigationTitle("Math Progress")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func operationRow(for op: MathOperation) -> some View {
        let opAttempts = attempts.filter { $0.operation == op.rawValue }
        let opCorrect  = opAttempts.filter(\.wasCorrect).count
        let pct: Double = opAttempts.isEmpty ? 0 : Double(opCorrect) / Double(opAttempts.count)

        HStack(spacing: 12) {
            Image(systemName: op.icon)
                .font(.system(size: 18))
                .foregroundColor(Color(hex: op.colorHex))
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(op.displayName)
                        .font(.system(size: 14, weight: .medium))
                    Spacer()
                    Text(opAttempts.isEmpty ? "Not tried yet" : "\(opCorrect)/\(opAttempts.count)")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(.systemFill))
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(hex: op.colorHex))
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

    private func opSymbol(_ raw: String) -> String {
        MathOperation(rawValue: raw)?.symbol ?? "?"
    }
    private func opColorHex(_ raw: String) -> String {
        MathOperation(rawValue: raw)?.colorHex ?? "#888"
    }
}
