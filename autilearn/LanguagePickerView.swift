import SwiftUI

// MARK: - Preferences Sheet
// Two tabs: Language selection + Sports & Activities selection.
// Both stored in session memory (reset on app kill).

struct LanguagePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var tab: PrefsTab = .language
    private var langStore: LanguageStore     { LanguageStore.shared }
    private var intStore:  InterestStore     { InterestStore.shared }

    enum PrefsTab: String, CaseIterable {
        case language   = "Language"
        case activities = "Activities"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab picker
                Picker("", selection: $tab) {
                    ForEach(PrefsTab.allCases, id: \.self) {
                        Label($0.rawValue,
                              systemImage: $0 == .language ? "globe" : "figure.run")
                            .tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)

                Divider()

                if tab == .language {
                    LanguageTab(store: langStore, dismiss: { dismiss() })
                } else {
                    ActivitiesTab(store: intStore)
                }
            }
            .navigationTitle("Preferences")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Language Tab

private struct LanguageTab: View {
    let store: LanguageStore
    let dismiss: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 6) {
                    Text("🇮🇳").font(.system(size: 44)).padding(.top, 16)
                    Text("Choose Your Language")
                        .font(.system(size: 18, weight: .semibold))
                    Text("Devotional and story videos will show in your language")
                        .font(.system(size: 13)).foregroundColor(.secondary)
                        .multilineTextAlignment(.center).padding(.horizontal, 32)
                }
                .padding(.bottom, 20)

                LazyVGrid(
                    columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                    spacing: 12
                ) {
                    ForEach(IndianLanguage.allCases) { lang in
                        LanguageCell(language: lang, isSelected: store.selectedLanguage == lang) {
                            store.selectedLanguage = lang
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { dismiss() }
                        }
                    }
                }
                .padding(.horizontal, 20)

                if store.hasSelection {
                    Button {
                        store.selectedLanguage = nil
                    } label: {
                        Label("Show all languages", systemImage: "globe")
                            .font(.system(size: 13)).foregroundColor(.secondary).padding(.vertical, 16)
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }
}

// MARK: - Activities Tab (multi-select)

private struct ActivitiesTab: View {
    let store: InterestStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(spacing: 6) {
                    Text("🏅").font(.system(size: 44)).padding(.top, 16)
                    Text("Choose Your Interests")
                        .font(.system(size: 18, weight: .semibold))
                    Text("Select one or more — we'll show matching videos")
                        .font(.system(size: 13)).foregroundColor(.secondary)
                        .multilineTextAlignment(.center).padding(.horizontal, 32)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 8)

                // Selection summary badge
                if store.hasSelections {
                    HStack {
                        Spacer()
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(store.displaySummary)
                                .font(.system(size: 13, weight: .medium))
                        }
                        .padding(.horizontal, 14).padding(.vertical, 7)
                        .background(Color.green.opacity(0.1))
                        .clipShape(Capsule())
                        Spacer()
                    }
                }

                // Groups
                ForEach(ActivityGroup.allCases, id: \.self) { group in
                    ActivityGroupSection(group: group, store: store)
                }

                // Clear all
                if store.hasSelections {
                    Button { store.clearAll() } label: {
                        Label("Clear all selections", systemImage: "xmark.circle")
                            .font(.system(size: 13)).foregroundColor(.secondary).padding(.vertical, 8)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
    }
}

private struct ActivityGroupSection: View {
    let group: ActivityGroup
    let store: InterestStore

    private var activities: [KidActivity] {
        KidActivity.allCases.filter { $0.group == group }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Group header
            HStack(spacing: 6) {
                Text(group.emoji).font(.system(size: 16))
                Text(group.rawValue)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
            }

            // 2-column grid of activity chips
            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
                spacing: 10
            ) {
                ForEach(activities) { activity in
                    ActivityChip(activity: activity, isSelected: store.selectedActivities.contains(activity)) {
                        store.toggle(activity)
                    }
                }
            }
        }
    }
}

struct ActivityChip: View {
    let activity: KidActivity
    let isSelected: Bool
    let onTap: () -> Void

    private var accent: Color { Color(hex: activity.colorHex) }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Text(activity.emoji)
                    .font(.system(size: 18))
                VStack(alignment: .leading, spacing: 1) {
                    Text(activity.rawValue)
                        .font(.system(size: 12, weight: isSelected ? .semibold : .medium))
                        .foregroundColor(isSelected ? .white : .primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 12).padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? accent : Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? accent : Color(.separator).opacity(0.3),
                                    lineWidth: isSelected ? 0 : 0.5)
                    )
            )
            .shadow(color: isSelected ? accent.opacity(0.25) : .clear, radius: 4, y: 2)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

// MARK: - Language Cell (unchanged)

struct LanguageCell: View {
    let language: IndianLanguage
    let isSelected: Bool
    let onTap: () -> Void

    private var accent: Color { Color(hex: language.colorHex) }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? accent : accent.opacity(0.1))
                        .frame(height: 52)
                    Text(language.nativeName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isSelected ? .white : accent)
                }
                Text(language.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? accent : .secondary)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.systemBackground))
                    .overlay(RoundedRectangle(cornerRadius: 14)
                        .stroke(isSelected ? accent : Color(.separator).opacity(0.3),
                                lineWidth: isSelected ? 2 : 0.5))
                    .shadow(color: isSelected ? accent.opacity(0.2) : .clear, radius: 6, y: 2)
            )
        }
        .buttonStyle(.plain)
    }
}
