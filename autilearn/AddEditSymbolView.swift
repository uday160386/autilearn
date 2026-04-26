import os
import SwiftUI
import SwiftData
import WebKit

struct AddEditSymbolView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    private var existingSymbol: AACSymbol?

    @State private var emoji: String
    @State private var word: String
    @State private var category: SymbolCategory
    @State private var youtubeURL: String = ""

    // Query all symbols to compute next position when adding
    @Query(sort: \AACSymbol.position) private var symbols: [AACSymbol]

    init(symbol: AACSymbol? = nil) {
        self.existingSymbol = symbol
        // Prefill state from existing symbol if present; otherwise sensible defaults
        _emoji = State(initialValue: symbol?.emoji ?? "😀")
        _word = State(initialValue: symbol?.word ?? "")
        _youtubeURL = State(initialValue: symbol?.youtubeURL ?? "")
        _category = State(initialValue: symbol?.category ?? SymbolCategory.allCases.first ?? .feelings)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Symbol") {
                    TextField("Emoji", text: $emoji)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    TextField("Word", text: $word)
                        .textInputAutocapitalization(.words)
                    TextField("YouTube URL or ID (optional)", text: $youtubeURL)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.URL)
                        .autocorrectionDisabled(true)
                }
                Section("Category") {
                    Picker("Category", selection: $category) {
                        ForEach(SymbolCategory.allCases, id: \.self) { cat in
                            Text(cat.displayName).tag(cat)
                        }
                    }
                }
                Section("Preview") {
                    if let videoID = extractYouTubeID(from: youtubeURL) {
                        YouTubePlayerView(videoID: videoID)
                            .frame(height: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        Text("Enter a YouTube link or video ID above to preview")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle(existingSymbol == nil ? "Add Symbol" : "Edit Symbol")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { save() }
                        .disabled(!isValid)
                        .fontWeight(.medium)
                }
            }
        }
    }

    private var isValid: Bool {
        // Require non-empty word and a single visible emoji grapheme
        let trimmedWord = word.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmoji = emoji.trimmingCharacters(in: .whitespacesAndNewlines)
        // Ensure emoji is a single grapheme cluster
        return !trimmedWord.isEmpty && trimmedEmoji.count == 1
    }

    private func save() {
        guard isValid else { return }
        if let sym = existingSymbol {
            // Update existing
            sym.emoji = emoji
            sym.word = word.trimmingCharacters(in: .whitespacesAndNewlines)
            sym.category = category
            sym.youtubeURL = youtubeURL.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            // Determine next position within this category
            let maxPos = symbols.filter { $0.category == category }.map(\.position).max() ?? -1
            let new = AACSymbol(word: word.trimmingCharacters(in: .whitespacesAndNewlines), emoji: emoji, category: category, position: maxPos + 1)
            context.insert(new)
            new.youtubeURL = youtubeURL.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        do {
            try context.save()
            dismiss()
        } catch {
            // In a real app, surface error; for now, just print and keep the view open
            os_log(.error, "Failed to save symbol: %@", error.localizedDescription)
        }
    }

    private func extractYouTubeID(from text: String) -> String? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        // If the user typed a raw ID (11 chars typical), allow it
        if trimmed.count == 11, trimmed.range(of: "^[A-Za-z0-9_-]{11}$", options: .regularExpression) != nil {
            return trimmed
        }
        // Try to parse URL forms
        if let url = URL(string: trimmed), let host = url.host {
            if host.contains("youtube.com"),
               let comps = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let v = comps.queryItems?.first(where: { $0.name == "v" })?.value,
               !v.isEmpty {
                return v
            }
            if host.contains("youtu.be") {
                let id = url.lastPathComponent
                return id.isEmpty ? nil : id
            }
        }
        return nil
    }
}

private struct YouTubePlayerView: View {
    let videoID: String

    var body: some View {
        HTMLWebView(html: Self.embedHTML(for: videoID))
            .background(Color.black)
    }

    private static func embedHTML(for id: String) -> String {
        """
        <!DOCTYPE html>
        <html>
        <head>
        <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
        <style>
        html, body { margin:0; padding:0; background:#000; height:100%; }
        .container { position:relative; padding-top:56.25%; }
        iframe { position:absolute; top:0; left:0; width:100%; height:100%; border:0; }
        </style>
        </head>
        <body>
          <div class="container">
            <iframe
                src="https://www.youtube.com/embed/\(id)?playsinline=1&modestbranding=1&rel=0"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share; fullscreen">
            </iframe>
          </div>
        </body>
        </html>
        """
    }
}

private struct HTMLWebView: UIViewRepresentable {
    let html: String

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.scrollView.isScrollEnabled = false
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: nil)
    }
}

#Preview {
    // In-memory model container for preview
    struct PreviewHost: View {
        @Environment(\.modelContext) private var context
        @Query private var symbols: [AACSymbol]

        init() {}

        var body: some View {
            VStack(spacing: 20) {
                AddEditSymbolView() // Add mode

                if let symbol = symbols.first {
                    AddEditSymbolView(symbol: symbol) // Edit mode
                }
            }
            .padding()
        }
    }

    return PreviewHost()
        .modelContainer(for: AACSymbol.self, inMemory: true)
}
