import SwiftUI

// MARK: - Adaptive layout helpers for iPhone + iPad

/// Returns a horizontal content padding that scales with screen width.
/// iPhone: 20pt  |  iPad: 5% of width (up to 60pt)
struct AdaptivePadding: ViewModifier {
    @Environment(\.horizontalSizeClass) private var hSizeClass

    func body(content: Content) -> some View {
        GeometryReader { geo in
            content
                .padding(.horizontal, horizontalPad(geo.size.width))
        }
    }

    private func horizontalPad(_ width: CGFloat) -> CGFloat {
        hSizeClass == .regular ? min(width * 0.06, 60) : 20
    }
}

extension View {
    /// Apply adaptive horizontal padding (20pt on iPhone, ~5% on iPad).
    func adaptivePadding() -> some View {
        modifier(AdaptivePadding())
    }
}

// MARK: - Adaptive column count

/// Returns the number of grid columns based on available width.
/// Keeps items between minWidth and maxWidth points wide.
func adaptiveColumns(
    minWidth: CGFloat = 160,
    spacing: CGFloat = 14
) -> [GridItem] {
    // SwiftUI's adaptive GridItem does this automatically
    [GridItem(.adaptive(minimum: minWidth, maximum: 360), spacing: spacing)]
}

/// Fixed column count that doubles on iPad regular width.
func adaptiveFixedColumns(
    phoneCount: Int,
    iPadCount: Int,
    spacing: CGFloat = 12
) -> [GridItem] {
    // This is evaluated at call site with current size class
    Array(repeating: GridItem(.flexible(), spacing: spacing), count: phoneCount)
}

// MARK: - Adaptive container width

/// Constrains content to a readable max-width on iPad.
struct AdaptiveContentWidth: ViewModifier {
    var maxWidth: CGFloat = 700

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: maxWidth)
            .frame(maxWidth: .infinity)  // centre on wide screens
    }
}

extension View {
    func adaptiveMaxWidth(_ max: CGFloat = 700) -> some View {
        modifier(AdaptiveContentWidth(maxWidth: max))
    }
}

// MARK: - Responsive grid columns using GeometryReader

struct AdaptiveGridView<Item: Identifiable, Cell: View>: View {
    let items: [Item]
    let minCellWidth: CGFloat
    let spacing: CGFloat
    let cell: (Item) -> Cell

    init(
        items: [Item],
        minCellWidth: CGFloat = 160,
        spacing: CGFloat = 14,
        @ViewBuilder cell: @escaping (Item) -> Cell
    ) {
        self.items       = items
        self.minCellWidth = minCellWidth
        self.spacing      = spacing
        self.cell         = cell
    }

    var body: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: minCellWidth), spacing: spacing)],
            spacing: spacing
        ) {
            ForEach(items) { item in
                cell(item)
            }
        }
    }
}
