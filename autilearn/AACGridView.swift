import SwiftUI
import SwiftData

struct AACGridView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \AACSymbol.position) private var allSymbols: [AACSymbol]

    @State private var speechEngine     = SpeechEngine()
    @State private var sentence         : [AACSymbol] = []
    @State private var selectedCategory : SymbolCategory? = nil
    @State private var showParentMode   = false

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 10), count: 4
    )

    private var displayedSymbols: [AACSymbol] {
        guard let cat = selectedCategory else { return allSymbols }
        return allSymbols.filter { $0.category == cat }
    }

    var body: some View {
        VStack(spacing: 0) {

            SentenceStripView(
                sentence: $sentence,
                isSpeaking: speechEngine.isSpeaking,
                onSpeak: { speechEngine.speakSentence(sentence) },
                onClear: { sentence.removeAll() }
            )
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 10)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    CategoryTab(label: "All", isSelected: selectedCategory == nil) {
                        selectedCategory = nil
                    }
                    ForEach(SymbolCategory.allCases, id: \.self) { cat in
                        CategoryTab(
                            label: cat.displayName,
                            colorHex: cat.colorHex,
                            isSelected: selectedCategory == cat
                        ) {
                            selectedCategory = selectedCategory == cat ? nil : cat
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 10)

            Divider()

            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(displayedSymbols) { symbol in
                        SymbolButton(symbol: symbol) {
                            addToSentence(symbol)
                            speechEngine.speakSymbol(symbol)
                        }
                    }
                }
                .padding(16)
            }
        }
        .navigationTitle("AutiLearn")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showParentMode = true
                } label: {
                    Label("Parent Mode", systemImage: "lock.shield")
                        .font(.system(size: 14))
                }
            }
        }
        .sheet(isPresented: $showParentMode) {
            ParentModeView()
        }
        .onAppear {
            seedDefaultSymbolsIfNeeded()
        }
    }

    // MARK: - Actions

    private func addToSentence(_ symbol: AACSymbol) {
        withAnimation(.easeInOut(duration: 0.15)) {
            sentence.append(symbol)
        }
        symbol.usageCount += 1
        try? context.save()
    }

    private func seedDefaultSymbolsIfNeeded() {
        guard allSymbols.isEmpty else { return }

        let defaults: [(String, String, SymbolCategory)] = [
            ("I",        "🙋", .people),
            ("Mum",      "👩",  .people),
            ("Dad",      "👨",  .people),
            ("Friend",   "🤝", .people),
            ("Teacher",  "👩‍🏫", .people),
            ("Happy",    "😊", .feelings),
            ("Sad",      "😢", .feelings),
            ("Angry",    "😠", .feelings),
            ("Scared",   "😨", .feelings),
            ("Tired",    "😴", .feelings),
            ("Calm",     "😌", .feelings),
            ("Excited",  "🤩", .feelings),
            ("Want",     "🤲", .actions),
            ("Go",       "🚶", .actions),
            ("Stop",     "✋", .actions),
            ("Play",     "🎮", .actions),
            ("Eat",      "🍽️", .actions),
            ("Drink",    "🥤", .actions),
            ("Help",     "🆘", .needs),
            ("More",     "➕", .needs),
            ("Water",    "💧", .needs),
            ("Food",     "🍎", .needs),
            ("Toilet",   "🚽", .needs),
            ("Rest",     "🛋️", .needs),
            ("Home",     "🏠", .needs),
            ("School",   "🏫", .places),
            ("Park",     "🌳", .places),
            ("Hospital", "🏥", .places),
        ]

        for (i, (word, emoji, cat)) in defaults.enumerated() {
            context.insert(AACSymbol(word: word, emoji: emoji, category: cat, position: i))
        }
        try? context.save()
    }
}

#Preview {
    NavigationStack { AACGridView() }
        .modelContainer(for: AACSymbol.self, inMemory: true)
}
