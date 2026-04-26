import SwiftUI

struct SymbolButton: View {
    let symbol: AACSymbol
    let onTap: () -> Void

    @State private var isPressed = false

    private var categoryColor: Color {
        Color(hex: symbol.category.colorHex)
    }

    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            onTap()
        }) {
            VStack(spacing: 6) {
                symbolImage
                    .frame(width: 52, height: 52)

                Text(symbol.word)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 6)
            .background(Color(.systemBackground))
            .overlay(alignment: .top) {
                // Colour bar encodes category — child learns by colour
                Rectangle()
                    .fill(categoryColor)
                    .frame(height: 4)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.separator).alpha(0.35), lineWidth: 0.5)
            )
            .scaleEffect(isPressed ? 0.94 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in withAnimation { isPressed = true }  }
                .onEnded   { _ in withAnimation { isPressed = false } }
        )
        .accessibilityLabel(symbol.word)
        .accessibilityHint("Tap to add \(symbol.word) to your sentence")
    }

    @ViewBuilder
    private var symbolImage: some View {
        if let name = symbol.imageName,
           let uiImg = UIImage(named: name) ?? UIImage(contentsOfFile: name) {
            Image(uiImage: uiImg)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
            Text(symbol.emoji)
                .font(.system(size: 36))
        }
    }
}
