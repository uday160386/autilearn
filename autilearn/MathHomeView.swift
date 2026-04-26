import SwiftUI
import SwiftData

// MARK: - Math Home: operations + Money + Measurements

struct MathHomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerCard
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                // Math operations
                sectionHeader("Practice Maths")
                    .padding(.horizontal, 20)

                VStack(spacing: 12) {
                    ForEach(MathOperation.allCases, id: \.self) { op in
                        NavigationLink(destination: MathPracticeView(operation: op)) {
                            MathOperationCard(operation: op)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)

                // Money section (moved from standalone tab)
                sectionHeader("💰 Money & Currency")
                    .padding(.horizontal, 20)

                NavigationLink(destination: CurrencyHomeView()) {
                    VideoLinkCard(
                        emoji: "🪙",
                        title: "Money — Rupees & Dollars",
                        subtitle: "Learn coins, notes and shopping",
                        colorHex: "#D85A30",
                        youtubeID: "w6UbK5lFPmg"
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)

                // Measurements section
                sectionHeader("📏 Measurements")
                    .padding(.horizontal, 20)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 12)], spacing: 12) {
                    ForEach(MeasurementTopic.all) { topic in
                        NavigationLink(destination: MeasurementDetailSheet(topic: topic, speechEngine: SpeechEngine())) {
                            MeasurementVideoCard(topic: topic)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)

                // Progress
                NavigationLink(destination: MathProgressView()) {
                    ModeCard(
                        icon: "chart.bar.fill",
                        title: "My Math Progress",
                        subtitle: "See how many problems you've solved",
                        color: Color(hex: "185FA5"),
                        badge: nil
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .frame(maxWidth: 700).frame(maxWidth: .infinity)
        }
        .navigationTitle("Math & Numbers")
        .navigationBarTitleDisplayMode(.large)
    }

    private var headerCard: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Maths, Money & Measurements")
                    .font(.system(size: 20, weight: .medium))
                Text("Videos + practice for every topic")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(Color(hex: "1D9E75").opacity(0.12))
                    .frame(width: 56, height: 56)
                Text("🔢")
                    .font(.system(size: 28))
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
            Spacer()
        }
    }
}

// MARK: - Reusable video link card

struct VideoLinkCard: View {
    let emoji: String
    let title: String
    let subtitle: String
    let colorHex: String
    let youtubeID: String

    var body: some View {
        HStack(spacing: 0) {
            // YouTube thumbnail
            ZStack {
                AsyncImage(url: URL(string: "https://img.youtube.com/vi/\(youtubeID)/hqdefault.jpg")) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable().scaledToFill().frame(width: 90, height: 70).clipped()
                    default:
                        Rectangle()
                            .fill(Color(hex: colorHex).opacity(0.15))
                            .frame(width: 90, height: 70)
                            .overlay(Text(emoji).font(.system(size: 30)))
                    }
                }
                ZStack {
                    Circle().fill(Color.black.opacity(0.45)).frame(width: 26, height: 26)
                    Image(systemName: "play.fill").font(.system(size: 10)).foregroundColor(.white).offset(x: 1)
                }
            }
            .frame(width: 90, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 14)

            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .padding(.trailing, 14)
        }
        .frame(height: 70)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.separator).opacity(0.3), lineWidth: 0.5))
    }
}

// MARK: - Measurement video card (compact for grid)

struct MeasurementVideoCard: View {
    let topic: MeasurementTopic

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                AsyncImage(url: URL(string: "https://img.youtube.com/vi/\(topic.youtubeID)/hqdefault.jpg")) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable().scaledToFill().frame(height: 80).clipped()
                    default:
                        Rectangle()
                            .fill(Color(hex: topic.colorHex).opacity(0.12))
                            .frame(height: 80)
                            .overlay(Text(topic.emoji).font(.system(size: 32)))
                    }
                }
                ZStack {
                    Circle().fill(Color.black.opacity(0.4)).frame(width: 28, height: 28)
                    Image(systemName: "play.fill").font(.system(size: 10)).foregroundColor(.white).offset(x: 1)
                }
            }
            .frame(height: 80)
            .clipped()

            VStack(alignment: .leading, spacing: 3) {
                Text(topic.title)
                    .font(.system(size: 12, weight: .semibold))
                    .lineLimit(2)
                    .foregroundColor(.primary)
                Text("\(topic.facts.count) key facts")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.separator).opacity(0.3), lineWidth: 0.5))
    }
}

// MARK: - Operation card

struct MathOperationCard: View {
    let operation: MathOperation

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: operation.colorHex).opacity(0.12))
                    .frame(width: 52, height: 52)
                Image(systemName: operation.icon)
                    .font(.system(size: 22))
                    .foregroundColor(Color(hex: operation.colorHex))
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(operation.displayName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                Text(operationDescription)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(operation.symbol)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(Color(hex: operation.colorHex))
                .frame(width: 36)
            Image(systemName: "chevron.right")
                .font(.system(size: 13))
                .foregroundColor(.secondary.opacity(0.6))
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.separator).opacity(0.35), lineWidth: 0.5))
    }

    private var operationDescription: String {
        switch operation {
        case .addition:       return "Putting numbers together (1–10)"
        case .subtraction:    return "Taking numbers away (1–10)"
        case .multiplication: return "Groups of numbers (1–10)"
        case .division:       return "Sharing equally (1–10)"
        }
    }
}
