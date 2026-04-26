import SwiftUI
import SwiftData

// MARK: - Parent Mode

struct ParentModeView: View {
    @Environment(\.dismiss)      private var dismiss
    @Environment(\.modelContext) private var context
    @Query(sort: \AACSymbol.position) private var symbols: [AACSymbol]

    @State private var showAddSymbol    = false
    @State private var editingSymbol    : AACSymbol? = nil
    @State private var showDeleteAlert  = false
    @State private var symbolToDelete   : AACSymbol? = nil
    @State private var showPasscodeEdit = false
    @State private var newPIN           = ""
    @State private var confirmPIN       = ""
    @State private var pinError         = false

    private var ga: GuidedAccessManager { GuidedAccessManager.shared }

    var body: some View {
        NavigationStack {
            List {

                // ── APP LOCK ──────────────────────────────
                Section {
                    // Guided Access status
                    HStack {
                        Label(
                            ga.isGuidedAccessEnabled
                                ? "iOS Guided Access: Active"
                                : "iOS Guided Access: Off",
                            systemImage: ga.isGuidedAccessEnabled
                                ? "lock.shield.fill" : "lock.shield"
                        )
                        .foregroundColor(ga.isGuidedAccessEnabled
                                         ? Color(hex: "1D9E75") : .secondary)
                        Spacer()
                        Circle()
                            .fill(ga.isGuidedAccessEnabled
                                  ? Color(hex: "1D9E75") : Color(.systemFill))
                            .frame(width: 10, height: 10)
                    }

                    // Lock now
                    Button {
                        ga.showUnlockOverlay = true
                    } label: {
                        HStack {
                            Label("Lock App Now", systemImage: "lock.fill")
                                .foregroundColor(Color(hex: "D85A30"))
                            Spacer()
                            Text("Requires PIN to exit")
                                .font(.caption).foregroundColor(.secondary)
                        }
                    }

                    // Change PIN
                    Button {
                        newPIN = ""; confirmPIN = ""; pinError = false
                        showPasscodeEdit = true
                    } label: {
                        HStack {
                            Label("Change Unlock PIN", systemImage: "key.fill")
                                .foregroundColor(Color(hex: "534AB7"))
                            Spacer()
                            Text(String(repeating: "●", count: ga.parentPasscode.count))
                                .font(.caption).foregroundColor(.secondary)
                        }
                    }

                } header: {
                    Text("App Lock & Kiosk Mode")
                } footer: {
                    Text("When locked, the child cannot switch to other apps or access the home screen without entering your PIN. Default PIN: 1234")
                }

                // ── GUIDED ACCESS SETUP TIP ───────────────
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Set Up iOS Guided Access", systemImage: "info.circle.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "534AB7"))

                        Text("For the strongest protection (blocks home button, volume buttons, and touch regions), enable Guided Access in Settings → Accessibility → Guided Access, then triple-click the side button while AutiLearn is open.")
                            .font(.caption).foregroundColor(.secondary).lineSpacing(3)

                        Button {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Label("Open Settings", systemImage: "arrow.up.right.square")
                                .font(.system(size: 13)).foregroundColor(Color(hex: "534AB7"))
                        }
                        .padding(.top, 2)
                    }
                    .padding(.vertical, 4)
                }

                // ── AAC SYMBOLS ───────────────────────────
                ForEach(SymbolCategory.allCases, id: \.self) { cat in
                    aacSection(cat)
                }
            }
            .navigationTitle("Parent Mode")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading)  { Button("Done") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showAddSymbol = true } label: { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $showAddSymbol)   { AddEditSymbolView() }
            .sheet(item: $editingSymbol)           { AddEditSymbolView(symbol: $0) }
            .sheet(isPresented: $showPasscodeEdit) { pinSheet }
            .alert("Delete Symbol?", isPresented: $showDeleteAlert, actions: {
                Button("Delete", role: .destructive) {
                    if let s = symbolToDelete { context.delete(s); try? context.save() }
                }
                Button("Cancel", role: .cancel) {}
            }, message: {
                if let s = symbolToDelete { Text("Remove \"\(s.word)\" from the board?") }
            })
        }
    }

    // MARK: PIN change sheet
    private var pinSheet: some View {
        NavigationStack {
            Form {
                Section("New 4-Digit PIN") {
                    SecureField("New PIN", text: $newPIN).keyboardType(.numberPad)
                    SecureField("Confirm PIN", text: $confirmPIN).keyboardType(.numberPad)
                }
                if pinError {
                    Section {
                        Label("PINs don't match or aren't 4 digits",
                              systemImage: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Change PIN")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { showPasscodeEdit = false }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        if newPIN.count == 4, newPIN == confirmPIN {
                            GuidedAccessManager.shared.parentPasscode = newPIN
                            showPasscodeEdit = false
                        } else {
                            pinError = true
                        }
                    }
                    .disabled(newPIN.count != 4)
                    .fontWeight(.medium)
                }
            }
        }
    }

    // MARK: AAC symbol sections
    @ViewBuilder
    private func aacSection(_ cat: SymbolCategory) -> some View {
        let items = symbols.filter { $0.category == cat }
        if !items.isEmpty {
            Section(cat.displayName) {
                ForEach(items) { sym in symbolRow(sym) }
                    .onMove { from, to in
                        var arr = items; arr.move(fromOffsets: from, toOffset: to)
                        for (i, s) in arr.enumerated() { s.position = i }
                        try? context.save()
                    }
            }
        }
    }

    @ViewBuilder
    private func symbolRow(_ sym: AACSymbol) -> some View {
        HStack(spacing: 12) {
            Text(sym.emoji).font(.title2).frame(width: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text(sym.word).font(.system(size: 15, weight: .medium))
                Text("Used \(sym.usageCount) times").font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Button { editingSymbol = sym } label: {
                Image(systemName: "pencil.circle").font(.title3).foregroundColor(.secondary)
            }.buttonStyle(.plain)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                symbolToDelete = sym; showDeleteAlert = true
            } label: { Label("Delete", systemImage: "trash") }
        }
    }
}
