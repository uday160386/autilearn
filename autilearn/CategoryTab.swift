import SwiftUI

struct CategoryTab: View {
    let label: String
    let colorHex: String?
    let isSelected: Bool
    let action: () -> Void

    init(label: String, colorHex: String? = nil, isSelected: Bool, action: @escaping () -> Void) {
        self.label = label
        self.colorHex = colorHex
        self.isSelected = isSelected
        self.action = action
    }

    private var accentColor: Color {
        colorHex.map { Color(hex: $0) } ?? Color.primary
    }

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 13, weight: isSelected ? .medium : .regular))
                .foregroundColor(isSelected ? accentColor : .secondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    isSelected
                        ? Color(.systemBackground)
                        : Color.clear
                )
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(
                            isSelected
                                ? accentColor.alpha(0.5)
                                : Color(.separator).alpha(0.3),
                            lineWidth: isSelected ? 1 : 0.5
                        )
                )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
