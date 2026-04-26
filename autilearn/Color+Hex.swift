import SwiftUI

extension Color {
    /// Unambiguous opacity — avoids "Ambiguous use of 'opacity'" when the
    /// compiler can't choose between Color.opacity and View.opacity.
    func alpha(_ value: Double) -> Color {
        self.opacity(value)
    }
}

extension Color {
    /// Initialise a Color from a hex string, e.g. "#1D9E75" or "1D9E75"
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b, a: Double
        switch hex.count {
        case 6: // RGB
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >>  8) & 0xFF) / 255
            b = Double(int         & 0xFF) / 255
            a = 1.0
        case 8: // RGBA
            r = Double((int >> 24) & 0xFF) / 255
            g = Double((int >> 16) & 0xFF) / 255
            b = Double((int >>  8) & 0xFF) / 255
            a = Double(int         & 0xFF) / 255
        default:
            r = 0; g = 0; b = 0; a = 1
        }
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
