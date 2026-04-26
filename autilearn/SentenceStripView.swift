import SwiftUI

struct SentenceStripView: View {
    @Binding var sentence: [AACSymbol]
    let isSpeaking: Bool
    let onSpeak: () -> Void
    let onClear: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 10) {

            // Scrollable token row
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    if sentence.isEmpty {
                        Text("Tap symbols to build a sentence...")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .padding(.leading, 6)
                    } else {
                        ForEach(Array(sentence.enumerated()), id: \.offset) { i, sym in
                            SentenceToken(symbol: sym) {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    var updated = sentence
                                    updated.remove(at: i)
                                    sentence = updated
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 6)
                .frame(minHeight: 60)
            }

            Divider()
                .frame(height: 44)

            // Speak + Clear
            VStack(spacing: 6) {
                Button(action: onSpeak) {
                    HStack(spacing: 5) {
                        Image(systemName: isSpeaking ? "waveform" : "speaker.wave.2.fill")
                            .imageScale(.small)
                        Text(isSpeaking ? "Speaking…" : "Speak")
                    }
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(isSpeaking ? Color.gray : Color(hex: "#1D9E75"))
                    .clipShape(Capsule())
                }
                .disabled(sentence.isEmpty || isSpeaking)

                Button("Clear", action: onClear)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .disabled(sentence.isEmpty)
            }
            .padding(.trailing, 8)
        }
        .padding(.vertical, 8)
        .padding(.leading, 10)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(.separator).alpha(0.4), lineWidth: 0.5)
        )
    }
}

// MARK: - Token chip (tap to remove)
struct SentenceToken: View {
    let symbol: AACSymbol
    let onRemove: () -> Void

    @State private var isPressed = false

    var body: some View {
        VStack(spacing: 2) {
            Text(symbol.emoji)
                .font(.system(size: 22))
            Text(symbol.word)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.separator).alpha(0.3), lineWidth: 0.5)
        )
        .scaleEffect(isPressed ? 0.92 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture(perform: onRemove)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true  }
                .onEnded   { _ in isPressed = false }
        )
        .accessibilityLabel("Remove \(symbol.word) from sentence")
    }
}
