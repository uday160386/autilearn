import SwiftUI
import SwiftData

// MARK: - Main Tab View

struct MainTabView: View {
    @Environment(\.horizontalSizeClass) private var hSizeClass
    var body: some View {
        if hSizeClass == .regular { iPadSplitView } else { iPhoneTabView }
    }

    // MARK: iPhone — 5 tabs
    private var iPhoneTabView: some View {
        TabView {
            // 1. Dashboard
            NavigationStack { DashboardView() }
                .tabItem { Label("Dashboard", systemImage: "house.fill") }

            // 2. Study
            NavigationStack { StudyHomeView() }
                .tabItem { Label("Study", systemImage: "books.vertical.fill") }

            // 3. Activities
            NavigationStack { ActivitiesTabView() }
                .tabItem { Label("Activities", systemImage: "figure.run") }

            // 4. Schedule
            NavigationStack { ScheduleCalendarView() }
                .tabItem { Label("Schedule", systemImage: "calendar") }

            // 5. More
            NavigationStack { MoreMenuView() }
                .tabItem { Label("More", systemImage: "ellipsis.circle") }
        }
    }

    // MARK: iPad — full sidebar
    private var iPadSplitView: some View {
        NavigationSplitView {
            List {
                Section("Dashboard") {
                    NavigationLink(value: AppSection.dashboard)    { Label("Dashboard",        systemImage: "house.fill") }
                    NavigationLink(value: AppSection.profile)      { Label("My Profile",       systemImage: "person.crop.circle.fill") }
                    NavigationLink(value: AppSection.memories)     { Label("Memories",         systemImage: "photo.stack.fill") }
                    NavigationLink(value: AppSection.rewards)      { Label("My Stars",         systemImage: "star.fill") }
                }
                Section("Emotions") {
                    NavigationLink(value: AppSection.emotions)     { Label("Emotions",          systemImage: "face.smiling") }
                    NavigationLink(value: AppSection.mirror)       { Label("Mirror Mode",       systemImage: "face.dashed") }
                    NavigationLink(value: AppSection.identify)     { Label("Identify Emotions", systemImage: "sparkles") }
                    NavigationLink(value: AppSection.stories)      { Label("Social Stories",    systemImage: "book.fill") }
                    NavigationLink(value: AppSection.sixSecond)    { Label("6-Second Rule",     systemImage: "timer") }
                }
                Section("Study") {
                    NavigationLink(value: AppSection.math)         { Label("Math & Numbers",    systemImage: "function") }
                    NavigationLink(value: AppSection.english)      { Label("English",           systemImage: "textformat") }
                    NavigationLink(value: AppSection.science)      { Label("Science",           systemImage: "atom") }
                    NavigationLink(value: AppSection.currency)     { Label("Currency",          systemImage: "indianrupeesign.circle") }
                    NavigationLink(value: AppSection.measurements) { Label("Measurements",      systemImage: "ruler") }
                }
                Section("Activities") {
                    NavigationLink(value: AppSection.yoga)         { Label("Yoga & Exercise",   systemImage: "figure.mind.and.body") }
                    NavigationLink(value: AppSection.socialSkills) { Label("Social Skills",     systemImage: "person.2.fill") }
                    NavigationLink(value: AppSection.cooking)      { Label("Cooking",           systemImage: "fork.knife") }
                    NavigationLink(value: AppSection.sports)       { Label("Sports",            systemImage: "sportscourt.fill") }
                    NavigationLink(value: AppSection.physicalActs) { Label("Physical Activities",systemImage: "figure.skating") }
                    NavigationLink(value: AppSection.teluguDevotional) { Label("Telugu Devotional 🙏", systemImage: "hands.sparkles.fill") }
                }
                Section("Explore") {
                    NavigationLink(value: AppSection.videos)       { Label("Videos",            systemImage: "play.rectangle.fill") }
                    NavigationLink(value: AppSection.tours)        { Label("Virtual Explore",   systemImage: "globe.americas.fill") }
                    NavigationLink(value: AppSection.places)       { Label("Places",            systemImage: "map.fill") }
                    NavigationLink(value: AppSection.videoModeling){ Label("Video Modeling",    systemImage: "video.fill") }
                }
                Section("Daily Life") {
                    NavigationLink(value: AppSection.schedule)     { Label("Schedule",          systemImage: "calendar") }
                    NavigationLink(value: AppSection.routine)      { Label("Daily Routine",     systemImage: "checklist") }
                    NavigationLink(value: AppSection.calm)         { Label("Calm Corner",       systemImage: "wind") }
                }
            }
            .navigationTitle("AutiLearn")
            .listStyle(.sidebar)
        } detail: {
            NavigationStack { DashboardView() }
                .navigationDestination(for: AppSection.self) { section in
                    switch section {
                    case .dashboard:     DashboardView()
                    case .profile:       ProfileHomeView()
                    case .emotions:      EmotionHomeView()
                    case .mirror:        MirrorModeView()
                    case .identify:      IdentifyModeView()
                    case .math:          MathHomeView()
                    case .english:       EnglishLessonsHomeView()
                    case .science:       ScienceHomeView()
                    case .currency:      CurrencyHomeView()
                    case .measurements:  MeasurementsHomeView()
                    case .yoga:          VideoCategoryView(category: .yoga)
                    case .socialSkills:  VideoCategoryView(category: .socialSkills)
                    case .cooking:       VideoCategoryView(category: .cooking)
                    case .sports:        VideoCategoryView(category: .sports)
                    case .physicalActs:  ActivitiesHomeView()
                    case .teluguDevotional: VideoCategoryView(category: .teluguDevotional)
                    case .tours:         VirtualToursHomeView()
                    case .videos:        VideosHomeView()
                    case .places:        PlacesHomeView()
                    case .videoModeling: VideoModelingHomeView()
                    case .sixSecond:     SixSecondRuleView()
                    case .stories:       SocialStoriesHomeView()
                    case .schedule:      ScheduleCalendarView()
                    case .routine:       DailyRoutineView()
                    case .calm:          CalmingToolsHomeView()
                    case .rewards:       RewardsView()
                    case .memories:      MemoriesHomeView()
                    case .activities:    ActivitiesTabView()
                    case .study:         StudyHomeView()
                    }
                }
        }
    }
}

// MARK: - Dashboard

struct DashboardView: View {
    @Environment(\.modelContext) private var context
    @Query private var profiles: [ChildProfile]
    @Query(sort: \Memory.createdAt, order: .reverse) private var memories: [Memory]
    @Query(sort: \StarEntry.date,   order: .reverse) private var stars: [StarEntry]

    private var profile: ChildProfile? { profiles.first }

    private var todayStarCount: Int {
        let cal = Calendar.current
        return stars.filter { cal.isDateInToday($0.date) }.count
    }

    // Quick-access tiles shown on the dashboard
    private struct Tile {
        let title: String; let emoji: String
        let color: String; let dest: AppSection
    }
    private let tiles: [Tile] = [
        .init(title: "Emotions",      emoji: "😊", color: "#1D9E75", dest: .emotions),
        .init(title: "Study",         emoji: "🎓", color: "#BA7517", dest: .study),
        .init(title: "Activities",    emoji: "🏃", color: "#185FA5", dest: .activities),
        .init(title: "Videos",        emoji: "🎬", color: "#534AB7", dest: .videos),
        .init(title: "Calm Corner",   emoji: "🌬️", color: "#5DCAA5", dest: .calm),
        .init(title: "Schedule",      emoji: "📅", color: "#D85A30", dest: .schedule),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // ── Profile card ──────────────────────────────────────
                NavigationLink(destination: ProfileHomeView()) {
                    HStack(spacing: 16) {
                        // Avatar
                        ZStack {
                            Circle()
                                .fill(Color(hex: profile?.favoriteColor ?? "#1D9E75").opacity(0.18))
                                .frame(width: 64, height: 64)
                            if let data = profile?.photoData,
                               let ui = UIImage(data: data) {
                                Image(uiImage: ui)
                                    .resizable().scaledToFill()
                                    .frame(width: 64, height: 64)
                                    .clipShape(Circle())
                            } else {
                                Text(profile.map { String($0.name.prefix(1)) } ?? "👤")
                                    .font(.system(size: 26, weight: .semibold))
                                    .foregroundColor(Color(hex: profile?.favoriteColor ?? "#1D9E75"))
                            }
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(profile.map { "Hi, \($0.name)! 👋" } ?? "Set up your profile")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                            Text(profile != nil
                                 ? "Age \(profile!.age) · \(todayStarCount) ⭐ today"
                                 : "Tap to add your name and photo")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)

                // ── Quick-access grid ─────────────────────────────────
                VStack(alignment: .leading, spacing: 10) {
                    Text("Quick Access")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(.horizontal, 20)

                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 100, maximum: 140), spacing: 12)],
                        spacing: 12
                    ) {
                        ForEach(tiles, id: \.title) { tile in
                            NavigationLink(destination: tileDestination(tile.dest)) {
                                VStack(spacing: 8) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(hex: tile.color).opacity(0.13))
                                            .frame(height: 56)
                                        Text(tile.emoji).font(.system(size: 26))
                                    }
                                    Text(tile.title)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color(hex: tile.color).opacity(0.22), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                }

                // ── Memories strip ────────────────────────────────────
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("My Memories")
                            .font(.system(size: 15, weight: .semibold))
                        Spacer()
                        NavigationLink(destination: MemoriesHomeView()) {
                            Text("See All")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "#534AB7"))
                        }
                    }
                    .padding(.horizontal, 20)

                    if memories.isEmpty {
                        // Empty state
                        NavigationLink(destination: MemoriesHomeView()) {
                            HStack(spacing: 12) {
                                Image(systemName: "photo.stack")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color(hex: "#D4537E"))
                                Text("Add your first memory 📸")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                            .padding(16)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .padding(.horizontal, 20)
                        }
                        .buttonStyle(.plain)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(memories.prefix(10)) { memory in
                                    NavigationLink(destination: MemoriesHomeView()) {
                                        MemoryThumbnail(memory: memory)
                                    }
                                    .buttonStyle(.plain)
                                }
                                // "See all" tile
                                NavigationLink(destination: MemoriesHomeView()) {
                                    VStack(spacing: 6) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color(hex: "#D4537E").opacity(0.1))
                                                .frame(width: 90, height: 90)
                                            Image(systemName: "arrow.right.circle.fill")
                                                .font(.system(size: 28))
                                                .foregroundColor(Color(hex: "#D4537E"))
                                        }
                                        Text("All")
                                            .font(.system(size: 11, weight: .medium))
                                            .foregroundColor(Color(hex: "#D4537E"))
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }

                // ── Stars today ───────────────────────────────────────
                NavigationLink(destination: RewardsView()) {
                    HStack(spacing: 14) {
                        Text(todayStarCount == 0 ? "⭐" : String(repeating: "⭐", count: min(todayStarCount, 5)))
                            .font(.system(size: 24))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(todayStarCount == 0
                                 ? "No stars earned today yet"
                                 : "\(todayStarCount) star\(todayStarCount == 1 ? "" : "s") earned today!")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.primary)
                            Text("Tap to see your star chart")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                    .background(Color(hex: "#BA7517").opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "#BA7517").opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                }
                .buttonStyle(.plain)

                Spacer(minLength: 20)
            }
            .padding(.top, 16)
        }
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                LanguagePickerButton()
            }
        }
    }

    @ViewBuilder
    private func tileDestination(_ s: AppSection) -> some View {
        switch s {
        case .emotions:   EmotionHomeView()
        case .study:      StudyHomeView()
        case .activities: ActivitiesTabView()
        case .videos:     VideosHomeView()
        case .calm:       CalmingToolsHomeView()
        case .schedule:   ScheduleCalendarView()
        default:          EmptyView()
        }
    }
}

// MARK: - Memory thumbnail (used in dashboard strip)

struct MemoryThumbnail: View {
    let memory: Memory
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#D4537E").opacity(0.1))
                    .frame(width: 90, height: 90)
                if let data = memory.mediaData, let ui = UIImage(data: data) {
                    Image(uiImage: ui)
                        .resizable().scaledToFill()
                        .frame(width: 90, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Text(memory.mood).font(.system(size: 32))
                }
            }
            Text(memory.title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(1)
                .frame(width: 90)
        }
    }
}

// MARK: - Study Hub

struct StudyHomeView: View {
    private struct Subject {
        let title: String; let subtitle: String
        let emoji: String; let color: String; let dest: AppSection
    }
    private let subjects: [Subject] = [
        .init(title: "Math & Numbers",  subtitle: "Addition, subtraction, multiplication", emoji: "🔢", color: "#BA7517", dest: .math),
        .init(title: "English",         subtitle: "Vocabulary, flashcards & quizzes",      emoji: "📖", color: "#D4537E", dest: .english),
        .init(title: "Science",         subtitle: "Experiments & discoveries",              emoji: "🔬", color: "#1D9E75", dest: .science),
        .init(title: "Currency",        subtitle: "Money & counting practice",              emoji: "💰", color: "#534AB7", dest: .currency),
        .init(title: "Measurements",    subtitle: "Length, weight & volume",                emoji: "📏", color: "#185FA5", dest: .measurements),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Study").font(.system(size: 20, weight: .medium))
                        Text("Choose a subject to learn").font(.system(size: 14)).foregroundColor(.secondary)
                    }
                    Spacer()
                    Text("🎓").font(.system(size: 36))
                }
                .padding(16)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 20)

                VStack(spacing: 14) {
                    ForEach(subjects, id: \.title) { sub in
                        NavigationLink(destination: destView(sub.dest)) {
                            HStack(spacing: 16) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color(hex: sub.color).opacity(0.13))
                                        .frame(width: 64, height: 64)
                                    Text(sub.emoji).font(.system(size: 30))
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(sub.title).font(.system(size: 16, weight: .semibold)).foregroundColor(.primary)
                                    Text(sub.subtitle).font(.system(size: 13)).foregroundColor(.secondary).lineLimit(2)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(Color(hex: sub.color))
                            }
                            .padding(16)
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: sub.color).opacity(0.25), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Study")
        .navigationBarTitleDisplayMode(.large)
    }

    @ViewBuilder private func destView(_ s: AppSection) -> some View {
        switch s {
        case .math:         MathHomeView()
        case .english:      EnglishLessonsHomeView()
        case .science:      ScienceHomeView()
        case .currency:     CurrencyHomeView()
        case .measurements: MeasurementsHomeView()
        default:            EmptyView()
        }
    }
}

// MARK: - Activities Hub Tab

struct ActivitiesTabView: View {
    private struct ActivityGroup {
        let title: String; let subtitle: String
        let emoji: String; let color: String; let dest: AppSection
    }
    private let groups: [ActivityGroup] = [
        .init(title: "Yoga & Exercise",     subtitle: "Breathing, stretching & mindfulness", emoji: "🧘", color: "#1D9E75", dest: .yoga),
        .init(title: "Social Skills",       subtitle: "Conversations, sharing & teamwork",   emoji: "🤝", color: "#534AB7", dest: .socialSkills),
        .init(title: "Cooking",             subtitle: "Simple recipes & kitchen safety",      emoji: "🍳", color: "#D85A30", dest: .cooking),
        .init(title: "Sports",              subtitle: "Fun sports activities & games",        emoji: "⚽", color: "#185FA5", dest: .sports),
        .init(title: "Physical Activities", subtitle: "Skating, painting, drawing, swimming", emoji: "🏅", color: "#D4537E", dest: .physicalActs),
    ]

    private var languageTileTitle: String {
        let lang = LanguageStore.shared.selectedLanguage ?? .telugu
        return "\(lang.rawValue) Devotional"
    }
    private var languageTileSubtitle: String {
        let lang = LanguageStore.shared.selectedLanguage ?? .telugu
        return "Prayers & bhakti songs in \(lang.rawValue)"
    }
    private var languageTileColor: String {
        LanguageStore.shared.selectedLanguage?.colorHex ?? "#8B2FC9"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Activities").font(.system(size: 20, weight: .medium))
                        Text("Move, learn and have fun").font(.system(size: 14)).foregroundColor(.secondary)
                    }
                    Spacer()
                    Text("🏃").font(.system(size: 36))
                }
                .padding(16)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 20)

                VStack(spacing: 14) {
                    ForEach(groups, id: \.title) { grp in
                        NavigationLink(destination: destView(grp.dest)) {
                            HStack(spacing: 16) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color(hex: grp.color).opacity(0.13))
                                        .frame(width: 64, height: 64)
                                    Text(grp.emoji).font(.system(size: 30))
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(grp.title).font(.system(size: 16, weight: .semibold)).foregroundColor(.primary)
                                    Text(grp.subtitle).font(.system(size: 13)).foregroundColor(.secondary).lineLimit(2)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(Color(hex: grp.color))
                            }
                            .padding(16)
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: grp.color).opacity(0.25), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)
                    }

                    // My Activities tile (interest-based)
                    NavigationLink(destination: InterestVideoView()) {
                        HStack(spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(hex: "#185FA5").opacity(0.13))
                                    .frame(width: 64, height: 64)
                                Text("🏅").font(.system(size: 30))
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text("My Activities")
                                    .font(.system(size: 16, weight: .semibold)).foregroundColor(.primary)
                                Text(InterestStore.shared.hasSelections
                                     ? InterestStore.shared.displaySummary
                                     : "Choose your sports & hobbies")
                                    .font(.system(size: 13)).foregroundColor(.secondary).lineLimit(2)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(hex: "#185FA5"))
                        }
                        .padding(16)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#185FA5").opacity(0.25), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)

                    // Language-aware devotional tile
                    NavigationLink(destination: LanguageVideoView(mode: .devotional)) {
                        HStack(spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(hex: languageTileColor).opacity(0.13))
                                    .frame(width: 64, height: 64)
                                Text("🙏").font(.system(size: 30))
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text(languageTileTitle)
                                    .font(.system(size: 16, weight: .semibold)).foregroundColor(.primary)
                                Text(languageTileSubtitle)
                                    .font(.system(size: 13)).foregroundColor(.secondary).lineLimit(2)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(hex: languageTileColor))
                        }
                        .padding(16)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: languageTileColor).opacity(0.25), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)

                    // Language-aware stories tile
                    NavigationLink(destination: LanguageVideoView(mode: .stories)) {
                        HStack(spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(hex: languageTileColor).opacity(0.13))
                                    .frame(width: 64, height: 64)
                                Text("📖").font(.system(size: 30))
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                let lang = LanguageStore.shared.selectedLanguage ?? .telugu
                                Text("\(lang.rawValue) Stories")
                                    .font(.system(size: 16, weight: .semibold)).foregroundColor(.primary)
                                Text("Stories and rhymes in \(lang.rawValue)")
                                    .font(.system(size: 13)).foregroundColor(.secondary).lineLimit(2)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(hex: languageTileColor))
                        }
                        .padding(16)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: languageTileColor).opacity(0.25), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Activities")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                LanguagePickerButton()
            }
        }
    }

    @ViewBuilder private func destView(_ s: AppSection) -> some View {
        switch s {
        case .yoga:         VideoCategoryView(category: .yoga)
        case .socialSkills: VideoCategoryView(category: .socialSkills)
        case .cooking:      VideoCategoryView(category: .cooking)
        case .sports:       VideoCategoryView(category: .sports)
        case .physicalActs:     ActivitiesHomeView()
        case .teluguDevotional: VideoCategoryView(category: .teluguDevotional)
        default:                EmptyView()
        }
    }
}

// MARK: - Video Category View

struct VideoCategoryView: View {
    let category: VideoCategory
    @State private var selectedVideo: EducationalVideo? = nil
    @Environment(\.modelContext) private var context
    @Query(sort: \VideoWatchRecord.watchedAt, order: .reverse) private var watchHistory: [VideoWatchRecord]

    private var store: VideoAvailabilityStore { VideoAvailabilityStore.shared }

    private var videos: [EducationalVideo] {
        let pool = store.embeddableIDs.isEmpty ? EducationalVideo.all : EducationalVideo.available
        return pool.filter { $0.category == category }
    }

    private let columns = [GridItem(.adaptive(minimum: 200, maximum: 320), spacing: 14)]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(category.rawValue).font(.system(size: 20, weight: .medium))
                        HStack(spacing: 6) {
                            Text("\(videos.count) videos").font(.system(size: 14)).foregroundColor(.secondary)
                            if store.isChecking {
                                ProgressView().scaleEffect(0.7)
                            }
                        }
                    }
                    Spacer()
                    ZStack {
                        Circle().fill(Color(hex: category.colorHex).opacity(0.12)).frame(width: 56, height: 56)
                        Image(systemName: category.icon).font(.system(size: 26)).foregroundColor(Color(hex: category.colorHex))
                    }
                }
                .padding(16)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 16)

                if videos.isEmpty && store.isChecking {
                    VStack(spacing: 16) {
                        ProgressView()
                        Text("Checking available videos…")
                            .font(.system(size: 14)).foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity).padding(.top, 60)
                } else if videos.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "video.slash").font(.system(size: 40)).foregroundColor(.secondary)
                        Text("No videos available in this category").foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity).padding(.top, 60)
                } else {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(videos) { video in
                            VideoCard(video: video) { selectedVideo = video }
                        }
                    }
                    .padding(.horizontal, 20).padding(.bottom, 30)
                    .frame(maxWidth: 1100).frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(item: $selectedVideo) { video in
            VideoPlayerView(video: video, onWatch: { saveHistory(video) })
        }
    }

    private func saveHistory(_ video: EducationalVideo) {
        if let existing = watchHistory.first(where: { $0.videoID == video.id }) {
            existing.watchedAt = Date()
        } else {
            context.insert(VideoWatchRecord(video: video))
        }
        try? context.save()
    }
}

// MARK: - More Menu (Emotions + remaining features)

struct MoreMenuView: View {
    private struct MI { let title: String; let icon: String; let color: String; let dest: AppSection }
    private let items: [MI] = [
        .init(title: "Emotions",        icon: "face.smiling",             color: "#1D9E75", dest: .emotions),
        .init(title: "Videos",          icon: "play.rectangle.fill",      color: "#534AB7", dest: .videos),
        .init(title: "Virtual Explore", icon: "globe.americas.fill",      color: "#1D9E75", dest: .tours),
        .init(title: "Video Modeling",  icon: "video.fill",               color: "#534AB7", dest: .videoModeling),
        .init(title: "Social Stories",  icon: "book.fill",                color: "#D4537E", dest: .stories),
        .init(title: "6-Second Rule",   icon: "timer",                    color: "#5DCAA5", dest: .sixSecond),
        .init(title: "Places",          icon: "map.fill",                 color: "#185FA5", dest: .places),
        .init(title: "Daily Routine",   icon: "checklist",                color: "#1D9E75", dest: .routine),
        .init(title: "Calm Corner",     icon: "wind",                     color: "#5DCAA5", dest: .calm),
        .init(title: "My Stars",        icon: "star.fill",                color: "#BA7517", dest: .rewards),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("More").font(.system(size: 20, weight: .medium))
                        Text("Everything AutiLearn has to offer").font(.system(size: 14)).foregroundColor(.secondary)
                    }
                    Spacer()
                    Text("🌈").font(.system(size: 36))
                }
                .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 16)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 14)], spacing: 14) {
                    ForEach(items, id: \.title) { item in
                        NavigationLink(destination: dest(item.dest)) {
                            VStack(spacing: 10) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color(hex: item.color).opacity(0.12)).frame(height: 70)
                                    Image(systemName: item.icon)
                                        .font(.system(size: 30)).foregroundColor(Color(hex: item.color))
                                }
                                Text(item.title)
                                    .font(.system(size: 13, weight: .semibold)).foregroundColor(.primary)
                                    .multilineTextAlignment(.center).lineLimit(2)
                            }
                            .padding(14).frame(maxWidth: .infinity)
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.separator).opacity(0.3), lineWidth: 0.5))
                        }.buttonStyle(.plain)
                    }
                }.padding(.horizontal, 20).padding(.bottom, 30)
            }
        }
        .navigationTitle("More").navigationBarTitleDisplayMode(.large)
    }

    @ViewBuilder private func dest(_ s: AppSection) -> some View {
        switch s {
        case .emotions:      EmotionHomeView()
        case .videos:        VideosHomeView()
        case .tours:         VirtualToursHomeView()
        case .videoModeling: VideoModelingHomeView()
        case .stories:       SocialStoriesHomeView()
        case .sixSecond:     SixSecondRuleView()
        case .places:        PlacesHomeView()
        case .routine:       DailyRoutineView()
        case .calm:          CalmingToolsHomeView()
        case .rewards:       RewardsView()
        default:             EmptyView()
        }
    }
}

// MARK: - App Sections

enum AppSection: Hashable {
    case dashboard
    case profile
    case emotions, mirror, identify
    case study, math, english, science, currency, measurements
    case activities, yoga, socialSkills, cooking, sports, physicalActs, teluguDevotional
    case videos, tours, places, videoModeling
    case sixSecond, stories
    case schedule, routine, calm, rewards, memories
}
