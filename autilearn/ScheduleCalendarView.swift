import SwiftUI
import SwiftData

// MARK: - Schedule & Calendar
// Daily time-slot schedule + monthly calendar with current date
// and Singapore / India festival markers.

// MARK: - Time slot model

@Model
class TimeSlot {
    var id: UUID
    var title: String
    var emoji: String
    var colorHex: String
    var section: String    // "Emotions","Math","Science","Videos","Routine","Stories","Calm","Rewards","English","Currency","Activities","Custom"
    var startHour: Int
    var startMinute: Int
    var durationMinutes: Int
    var dayOfWeek: Int     // 0=Sun 1=Mon ... 6=Sat, 7=Every day
    var isCompleted: Bool

    init(title: String, emoji: String, section: String, startHour: Int, startMinute: Int, durationMinutes: Int, dayOfWeek: Int = 7, colorHex: String = "#1D9E75") {
        self.id              = UUID()
        self.title           = title
        self.emoji           = emoji
        self.colorHex        = colorHex
        self.section         = section
        self.startHour       = startHour
        self.startMinute     = startMinute
        self.durationMinutes = durationMinutes
        self.dayOfWeek       = dayOfWeek
        self.isCompleted     = false
    }

    var timeString: String {
        let h = startHour, m = startMinute
        let suffix = h < 12 ? "AM" : "PM"
        let h12 = h == 0 ? 12 : h > 12 ? h - 12 : h
        return String(format: "%d:%02d %@", h12, m, suffix)
    }

    var endTimeString: String {
        let totalMins = startHour * 60 + startMinute + durationMinutes
        let eh = (totalMins / 60) % 24; let em = totalMins % 60
        let suffix = eh < 12 ? "AM" : "PM"
        let h12 = eh == 0 ? 12 : eh > 12 ? eh - 12 : eh
        return String(format: "%d:%02d %@", h12, em, suffix)
    }
}

// MARK: - Festival model

struct Festival: Identifiable {
    let id: Int
    let name: String
    let emoji: String
    let country: FestivalCountry
    let month: Int          // 1–12
    let day: Int            // approximate day
    let colorHex: String
    let description: String
    let howCelebrated: String

    enum FestivalCountry: String { case india = "India 🇮🇳"; case singapore = "Singapore 🇸🇬"; case both = "India & Singapore" }
}

extension Festival {
    static let all: [Festival] = [
        // India
        Festival(id:1,name:"Diwali",emoji:"🪔",country:.india,month:10,day:20,colorHex:"#BA7517",description:"The Festival of Lights — one of India's biggest festivals celebrating the victory of light over darkness.",howCelebrated:"Families light diyas (clay lamps) and colourful lights. Children burst firecrackers. Sweets like ladoo and barfi are shared with family and neighbours. Rangoli patterns are drawn on floors. New clothes are worn and gifts are exchanged."),
        Festival(id:2,name:"Holi",emoji:"🌈",country:.india,month:3,day:8,colorHex:"#D4537E",description:"The Festival of Colours — celebrating the arrival of spring and the triumph of good over evil.",howCelebrated:"People throw colourful powder and water at each other in joyful celebration. Bonfires are lit the night before (Holika Dahan). Special sweets like gujiya are made. Music, dancing, and singing fill the streets."),
        Festival(id:3,name:"Navratri",emoji:"🕺",country:.india,month:10,day:3,colorHex:"#D85A30",description:"Nine nights celebrating the goddess Durga — a festival of dance, devotion, and fasting.",howCelebrated:"Garba and Dandiya Raas dances are performed in colourful traditional clothes. Fasting is observed. Elaborate goddess idol decorations are installed in homes and community halls."),
        Festival(id:4,name:"Eid-ul-Fitr",emoji:"🌙",country:.both,month:4,day:10,colorHex:"#1D9E75",description:"End of Ramadan — a joyful celebration of gratitude and community after a month of fasting.",howCelebrated:"Special prayers are held at mosques in the morning. Families wear new clothes and share delicious food. Children receive gifts and money (Eidi). Charity is given to those in need. Sweets like seviyan and sheer khurma are made."),
        Festival(id:5,name:"Christmas",emoji:"🎄",country:.both,month:12,day:25,colorHex:"#1D9E75",description:"Celebrated across both countries by Christian communities and beyond as a cultural festival of joy.",howCelebrated:"Churches hold midnight mass services. Families exchange gifts and decorate homes and Christmas trees. In Singapore, Orchard Road is decorated with spectacular lights. Carol singing and festive food bring communities together."),
        Festival(id:6,name:"Pongal",emoji:"🌾",country:.india,month:1,day:14,colorHex:"#3B6D11",description:"A harvest festival from Tamil Nadu celebrating the Sun and thanking nature for a good harvest.",howCelebrated:"The traditional Pongal dish of rice boiled in milk is prepared in a clay pot. Homes are decorated with kolam (rice flour patterns). Cattle are bathed and decorated. Traditional music and folk dances are performed."),
        Festival(id:7,name:"Ganesh Chaturthi",emoji:"🐘",country:.india,month:8,day:19,colorHex:"#BA7517",description:"Celebration of Lord Ganesha's birthday — the beloved elephant-headed god of wisdom and new beginnings.",howCelebrated:"Ganesha idols are installed in homes and public spaces and worshipped for 1–10 days. Modak sweets are offered. On the final day, idols are immersed in water in a joyful procession."),
        Festival(id:8,name:"Independence Day",emoji:"🇮🇳",country:.india,month:8,day:15,colorHex:"#D85A30",description:"India's independence from British rule in 1947. A national day of pride and patriotism.",howCelebrated:"Flag hoisting ceremonies take place across the country. The Prime Minister addresses the nation from the Red Fort in Delhi. Parades, patriotic songs, and kite flying mark the day. Schools and offices are decorated in tricolour."),

        // Singapore
        Festival(id:9,name:"Chinese New Year",emoji:"🧧",country:.singapore,month:1,day:22,colorHex:"#D85A30",description:"The most important festival in the Chinese calendar, celebrating the new year with family reunions.",howCelebrated:"Families gather for reunion dinners on New Year's Eve. Red packets (hongbao) with money are given to children. Lion and dragon dances fill the streets. The Singapore River Hongbao event draws huge crowds. Chinatown is beautifully decorated."),
        Festival(id:10,name:"Vesak Day",emoji:"☸️",country:.singapore,month:5,day:15,colorHex:"#534AB7",description:"Buddhist celebration of the birth, enlightenment, and passing of Buddha.",howCelebrated:"Buddhists visit temples, offer prayers, and release birds and animals symbolising freedom. Lantern processions take place. Candle-lit ceremonies are held. Devotees perform acts of charity and kindness throughout the day."),
        Festival(id:11,name:"National Day Singapore",emoji:"🇸🇬",country:.singapore,month:8,day:9,colorHex:"#D85A30",description:"Singapore's independence day since 1965 — a grand celebration of nationhood.",howCelebrated:"A spectacular parade and show at the Padang or Marina Bay features military march-pasts, aerial displays from the RSAF, parachutists, and fireworks. Schools perform community segments. The city glows red and white."),
        Festival(id:12,name:"Deepavali (Singapore)",emoji:"🪔",country:.singapore,month:10,day:20,colorHex:"#BA7517",description:"Festival of Lights celebrated by Singapore's Hindu Tamil community.",howCelebrated:"Little India is decorated with thousands of colourful lights. Families wear new clothes and visit temples. Traditional oil lamps are lit. Sweets and snacks are shared with neighbours. A street light-up in Serangoon Road is a major attraction."),
        Festival(id:13,name:"Thaipusam",emoji:"🔱",country:.singapore,month:1,day:25,colorHex:"#534AB7",description:"A significant Hindu festival at Batu Caves (Malaysia) and Sri Thendayuthapani Temple in Singapore.",howCelebrated:"Devotees carry kavadi (elaborate decorated structures) as acts of thanksgiving. A procession travels from Sri Srinivasa Perumal Temple to Chettiair Temple along Serangoon Road. Coconuts are broken and milk is offered."),
        Festival(id:14,name:"Hari Raya Puasa",emoji:"🌙",country:.singapore,month:4,day:10,colorHex:"#1D9E75",description:"End of Ramadan — Singapore's Malay Muslim community celebrates with open houses and family gatherings.",howCelebrated:"Geylang Serai bazaar is filled with traditional food, clothes, and decorations. Families visit each other's homes (open house). Traditional Malay dishes like lemang, ketupat, and rendang are prepared. New clothes (baju kurung/baju melayu) are worn."),
        Festival(id:15,name:"Mid-Autumn Festival",emoji:"🏮",country:.singapore,month:9,day:17,colorHex:"#BA7517",description:"The Mooncake Festival — a beautiful Chinese harvest festival celebrating the full moon.",howCelebrated:"Mooncakes (sweet pastries with lotus seed paste) are gifted and eaten. Children carry colourful lanterns in the evening. Chinatown hosts a spectacular lantern display. Families sit outdoors to admire the full moon together."),
    ]

    static func upcoming(from date: Date = Date(), count: Int = 5) -> [Festival] {
        let cal = Calendar.current
        let m = cal.component(.month, from: date)
        let d = cal.component(.day, from: date)
        let sorted = all.sorted {
            let a = ($0.month * 100 + $0.day); let b = ($1.month * 100 + $1.day)
            let today = m * 100 + d
            let aAdj = a >= today ? a : a + 1200
            let bAdj = b >= today ? b : b + 1200
            return aAdj < bAdj
        }
        return Array(sorted.prefix(count))
    }
}

// MARK: - Schedule & Calendar Home

struct ScheduleCalendarView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \TimeSlot.startHour) private var allSlots: [TimeSlot]
    @State private var selectedDate  = Date()
    @State private var showAddSlot   = false
    @State private var selectedTab   = 0

    private var todaySlots: [TimeSlot] {
        let dow = Calendar.current.component(.weekday, from: selectedDate) - 1
        return allSlots.filter { $0.dayOfWeek == dow || $0.dayOfWeek == 7 }
    }

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $selectedTab) {
                Text("Schedule").tag(0)
                Text("Calendar").tag(1)
                Text("Festivals").tag(2)
            }
            .pickerStyle(.segmented).padding(.horizontal, 20).padding(.vertical, 12)
            .background(Color(.systemBackground))

            switch selectedTab {
            case 0:  scheduleView
            case 1:  calendarView
            default: festivalsView
            }
        }
        .navigationTitle("Schedule")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showAddSlot = true } label: { Image(systemName: "plus.circle.fill") }
            }
        }
        .sheet(isPresented: $showAddSlot) {
            AddTimeSlotSheet { slot in context.insert(slot); try? context.save() }
        }
        .onAppear { seedDefaultSlotsIfNeeded() }
    }

    // MARK: Schedule view

    private var scheduleView: some View {
        ScrollView {
            VStack(spacing: 12) {

                // Today header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(selectedDate, format: .dateTime.weekday(.wide))
                            .font(.system(size: 22, weight: .bold))
                        Text(selectedDate, format: .dateTime.day().month(.wide).year())
                            .font(.system(size: 14)).foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(todaySlots.isEmpty ? "No slots" : "\(todaySlots.count) activities")
                        .font(.system(size: 13)).foregroundColor(.secondary)
                }
                .padding(.horizontal, 20).padding(.top, 8)

                // Day selector strip
                weekStrip

                if todaySlots.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "calendar.badge.plus").font(.system(size: 44)).foregroundColor(.secondary)
                        Text("No activities scheduled. Tap + to add.").font(.system(size: 14)).foregroundColor(.secondary)
                    }.frame(maxWidth: .infinity).padding(40)
                } else {
                    ForEach(todaySlots) { slot in
                        TimeSlotRow(slot: slot) {
                            slot.isCompleted.toggle(); try? context.save()
                        }
                    }.padding(.horizontal, 20)
                }
                Spacer(minLength: 30)
            }
        }
    }

    private var weekStrip: some View {
        let cal = Calendar.current
        let startOfWeek = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(0..<7) { i in
                    let day = cal.date(byAdding: .day, value: i, to: startOfWeek)!
                    let isSelected = cal.isDate(day, inSameDayAs: selectedDate)
                    let isToday    = cal.isDateInToday(day)
                    Button { selectedDate = day } label: {
                        VStack(spacing: 4) {
                            Text(day, format: .dateTime.weekday(.abbreviated))
                                .font(.system(size: 11)).foregroundColor(isSelected ? .white : .secondary)
                            Text(day, format: .dateTime.day())
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(isSelected ? .white : isToday ? Color(hex: "#1D9E75") : .primary)
                        }
                        .frame(width: 44, height: 56)
                        .background(isSelected ? Color(hex: "#1D9E75") : isToday ? Color(hex: "#1D9E75").opacity(0.1) : Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }.buttonStyle(.plain)
                }
            }.padding(.horizontal, 20)
        }
    }

    // MARK: Calendar view

    private var calendarView: some View {
        ScrollView {
            VStack(spacing: 16) {
                CalendarGridView(selectedDate: $selectedDate, festivals: Festival.all)
                    .padding(.horizontal, 20).padding(.top, 8)

                // Festivals this month
                let m = Calendar.current.component(.month, from: selectedDate)
                let monthFests = Festival.all.filter { $0.month == m }
                if !monthFests.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("This month's festivals").font(.system(size: 14, weight: .semibold)).padding(.horizontal, 20)
                        ForEach(monthFests) { f in
                            FestivalRow(festival: f)
                        }.padding(.horizontal, 20)
                    }
                }
                Spacer(minLength: 30)
            }
        }
    }

    // MARK: Festivals view

    private var festivalsView: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Upcoming
                VStack(alignment: .leading, spacing: 10) {
                    Text("Coming up soon").font(.system(size: 15, weight: .semibold)).padding(.horizontal, 20).padding(.top, 8)
                    ForEach(Festival.upcoming()) { f in
                        FestivalCard(festival: f)
                    }.padding(.horizontal, 20)
                }
                // All festivals grouped by country
                ForEach(["India 🇮🇳","Singapore 🇸🇬","India & Singapore"], id: \.self) { country in
                    let list = Festival.all.filter { $0.country.rawValue == country }
                    if !list.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(country).font(.system(size: 15, weight: .semibold)).padding(.horizontal, 20).padding(.top, 16)
                            ForEach(list) { f in FestivalCard(festival: f) }.padding(.horizontal, 20)
                        }
                    }
                }
                Spacer(minLength: 30)
            }
        }
    }

    private func seedDefaultSlotsIfNeeded() {
        guard allSlots.isEmpty else { return }
        let defaults: [(String,String,String,Int,Int,Int,String)] = [
            ("Morning Emotions Check","😊","Emotions",8,0,20,"#1D9E75"),
            ("Math Practice","🔢","Math",9,0,30,"#534AB7"),
            ("Science Experiment","🔬","Science",10,0,30,"#3B6D11"),
            ("English Lesson","📖","English",11,0,25,"#D4537E"),
            ("Free Play / Video","📺","Videos",13,0,30,"#185FA5"),
            ("Calm Corner","🧘","Calm",14,30,15,"#5DCAA5"),
            ("Daily Routine Check","📋","Routine",15,0,20,"#BA7517"),
            ("Stories Time","📚","Stories",19,0,20,"#534AB7"),
        ]
        for (i,(title,emoji,sec,h,m,dur,col)) in defaults.enumerated() {
            context.insert(TimeSlot(title:title,emoji:emoji,section:sec,startHour:h,startMinute:m,durationMinutes:dur,dayOfWeek:7,colorHex:col))
            _ = i
        }
        try? context.save()
    }
}

// MARK: - Time slot row

struct TimeSlotRow: View {
    let slot: TimeSlot; let onToggle: () -> Void
    var body: some View {
        HStack(spacing: 0) {
            // Time column
            VStack(spacing: 2) {
                Text(slot.timeString).font(.system(size: 12, weight: .semibold)).foregroundColor(Color(hex: slot.colorHex))
                Text(slot.endTimeString).font(.system(size: 10)).foregroundColor(.secondary)
            }.frame(width: 60)
            // Colour bar
            RoundedRectangle(cornerRadius: 2).fill(Color(hex: slot.colorHex)).frame(width: 4).padding(.vertical, 4)
            // Content
            HStack(spacing: 10) {
                Text(slot.emoji).font(.system(size: 24))
                VStack(alignment: .leading, spacing: 2) {
                    Text(slot.title).font(.system(size: 14, weight: .medium)).strikethrough(slot.isCompleted)
                    Text(slot.section).font(.system(size: 11)).foregroundColor(.secondary)
                }
                Spacer()
                Button(action: onToggle) {
                    ZStack {
                        Circle().fill(slot.isCompleted ? Color(hex: "#1D9E75") : Color(.systemFill)).frame(width: 30, height: 30)
                        if slot.isCompleted { Image(systemName: "checkmark").font(.system(size: 12, weight: .bold)).foregroundColor(.white) }
                    }
                }.buttonStyle(.plain)
            }.padding(.horizontal, 10)
        }
        .padding(.vertical, 8).padding(.trailing, 8)
        .background(slot.isCompleted ? Color(hex: "#1D9E75").opacity(0.05) : Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.separator).opacity(0.25), lineWidth: 0.5))
    }
}

// MARK: - Calendar grid

struct CalendarGridView: View {
    @Binding var selectedDate: Date
    let festivals: [Festival]
    private let cal = Calendar.current
    private let days = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]

    private var displayMonth: Date {
        cal.date(from: cal.dateComponents([.year,.month], from: selectedDate))!
    }
    private var daysInMonth: Int { cal.range(of: .day, in: .month, for: displayMonth)!.count }
    private var firstWeekday: Int { cal.component(.weekday, from: displayMonth) - 1 }

    var body: some View {
        VStack(spacing: 12) {
            // Month navigation
            HStack {
                Button { selectedDate = cal.date(byAdding: .month, value: -1, to: selectedDate)! } label: {
                    Image(systemName: "chevron.left").font(.system(size: 16, weight: .semibold))
                }
                Spacer()
                Text(displayMonth, format: .dateTime.month(.wide).year())
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Button { selectedDate = cal.date(byAdding: .month, value: 1, to: selectedDate)! } label: {
                    Image(systemName: "chevron.right").font(.system(size: 16, weight: .semibold))
                }
            }
            // Day headers
            HStack {
                ForEach(days, id: \.self) { d in
                    Text(d).font(.system(size: 11, weight: .medium)).foregroundColor(.secondary).frame(maxWidth: .infinity)
                }
            }
            // Day grid
            let totalCells = firstWeekday + daysInMonth
            let rows = Int(ceil(Double(totalCells) / 7.0))
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<7) { col in
                        let cellIndex = row * 7 + col
                        let dayNum    = cellIndex - firstWeekday + 1
                        if dayNum >= 1 && dayNum <= daysInMonth {
                            let thisDate = cal.date(byAdding: .day, value: dayNum - 1, to: displayMonth)!
                            let isSelected = cal.isDate(thisDate, inSameDayAs: selectedDate)
                            let isToday    = cal.isDateInToday(thisDate)
                            let m = cal.component(.month, from: displayMonth)
                            let hasFest    = festivals.contains { $0.month == m && $0.day == dayNum }
                            Button { selectedDate = thisDate } label: {
                                VStack(spacing: 2) {
                                    Text("\(dayNum)")
                                        .font(.system(size: 14, weight: isToday ? .bold : .regular))
                                        .foregroundColor(isSelected ? .white : isToday ? Color(hex:"#1D9E75") : .primary)
                                        .frame(width: 32, height: 32)
                                        .background(isSelected ? Color(hex:"#1D9E75") : isToday ? Color(hex:"#1D9E75").opacity(0.12) : Color.clear)
                                        .clipShape(Circle())
                                    if hasFest { Circle().fill(Color(hex:"#BA7517")).frame(width:5,height:5) } else { Color.clear.frame(width:5,height:5) }
                                }
                            }.buttonStyle(.plain).frame(maxWidth: .infinity)
                        } else {
                            Color.clear.frame(maxWidth: .infinity, minHeight: 44)
                        }
                    }
                }
            }
        }
        .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Festival views

struct FestivalRow: View {
    let festival: Festival
    var body: some View {
        HStack(spacing: 12) {
            Text(festival.emoji).font(.system(size: 28))
            VStack(alignment: .leading, spacing: 2) {
                Text(festival.name).font(.system(size: 14, weight: .semibold))
                Text(monthName(festival.month) + " \(festival.day)").font(.system(size: 12)).foregroundColor(.secondary)
            }
            Spacer()
            Text(festival.country.rawValue.suffix(2)).font(.system(size: 16))
        }
        .padding(.vertical, 6)
    }
    private func monthName(_ m: Int) -> String {
        DateFormatter().monthSymbols[m-1]
    }
}

struct FestivalCard: View {
    let festival: Festival
    @State private var expanded = false
    @State private var speechEngine = SpeechEngine()
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button { withAnimation { expanded.toggle() } } label: {
                HStack(spacing: 12) {
                    Text(festival.emoji).font(.system(size: 32))
                    VStack(alignment: .leading, spacing: 3) {
                        Text(festival.name).font(.system(size: 15, weight: .bold)).foregroundColor(.primary)
                        HStack(spacing: 6) {
                            Text(festival.country.rawValue).font(.system(size: 11)).foregroundColor(.secondary)
                            Text("·").foregroundColor(.secondary)
                            Text(monthName(festival.month)).font(.system(size: 11)).foregroundColor(Color(hex: festival.colorHex))
                        }
                    }
                    Spacer()
                    Image(systemName: expanded ? "chevron.up" : "chevron.down").font(.system(size: 12)).foregroundColor(.secondary)
                }
            }.buttonStyle(.plain)

            if expanded {
                Text(festival.description)
                    .font(.system(size: 13)).foregroundColor(.secondary).lineSpacing(3).fixedSize(horizontal: false, vertical: true)
                VStack(alignment: .leading, spacing: 6) {
                    Label("How it is celebrated", systemImage: "sparkles").font(.system(size: 12, weight: .semibold)).foregroundColor(Color(hex: festival.colorHex))
                    Text(festival.howCelebrated)
                        .font(.system(size: 13)).foregroundColor(.primary).lineSpacing(3).fixedSize(horizontal: false, vertical: true)
                }
                .padding(10).background(Color(hex: festival.colorHex).opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 10))
                Button { speechEngine.speak(festival.name + ". " + festival.description + ". " + festival.howCelebrated) } label: {
                    Label("Hear about it", systemImage: "speaker.wave.2")
                        .font(.system(size: 12)).foregroundColor(Color(hex: festival.colorHex))
                }
                .transition(.opacity)
            }
        }
        .padding(14)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: festival.colorHex).opacity(0.3), lineWidth: 1))
    }
    private func monthName(_ m: Int) -> String { DateFormatter().monthSymbols[m-1] }
}

// MARK: - Add time slot sheet

// MARK: - Add Time Slot Sheet (with video template picker + custom task)

struct AddTimeSlotSheet: View {
    let onAdd: (TimeSlot) -> Void
    @Environment(\.dismiss) private var dismiss

    // Mode
    @State private var mode: AddMode = .pickTemplate   // start with template picker

    // Custom task fields
    @State private var title     = ""
    @State private var emoji     = "📚"
    @State private var section   = "Custom"
    @State private var hour      = 9
    @State private var minute    = 0
    @State private var duration  = 30
    @State private var dayOfWeek = 7
    @State private var colorHex  = "#1D9E75"

    enum AddMode { case pickTemplate, custom }

    private let sections = ["Emotions","Math","English","Science","Videos","Routine","Stories","Calm",
                            "Rewards","Activities","Measurements","Memories","Custom"]
    private let days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Every day"]
    private let colors = ["#1D9E75","#185FA5","#534AB7","#D85A30","#BA7517","#D4537E","#5DCAA5","#3B6D11"]

    // Quick-add presets derived from VideoModel templates
    private var templatePresets: [(emoji: String, title: String, color: String, section: String)] {
        VideoModel.templates.map { vm in
            (emoji: vm.emoji, title: vm.title, color: vm.colorHex, section: vm.category)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // Mode picker
                Picker("", selection: $mode) {
                    Text("From Video Template").tag(AddMode.pickTemplate)
                    Text("Custom Task").tag(AddMode.custom)
                }
                .pickerStyle(.segmented)
                .padding(16)

                Divider()

                if mode == .pickTemplate {
                    templatePickerView
                } else {
                    customTaskForm
                }
            }
            .navigationTitle("Add to Schedule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Cancel") { dismiss() } }
                if mode == .custom {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add") {
                            guard !title.isEmpty else { return }
                            let slot = TimeSlot(title: title,
                                               emoji: emoji.isEmpty ? "📌" : emoji,
                                               section: section,
                                               startHour: hour, startMinute: minute,
                                               durationMinutes: duration,
                                               dayOfWeek: dayOfWeek,
                                               colorHex: colorHex)
                            onAdd(slot); dismiss()
                        }
                        .disabled(title.isEmpty)
                        .fontWeight(.medium)
                    }
                }
            }
        }
    }

    // MARK: Template picker — video thumbnails
    private var templatePickerView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Tap a task video to add it to your schedule")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
                    ForEach(VideoModel.templates) { vm in
                        TemplateQuickAddCard(model: vm) {
                            // Show time picker sheet then add
                            quickAddFromTemplate(vm)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
    }

    private func quickAddFromTemplate(_ vm: VideoModel) {
        let slot = TimeSlot(
            title: vm.title,
            emoji: vm.emoji,
            section: vm.category,
            startHour: 9,
            startMinute: 0,
            durationMinutes: 20,
            dayOfWeek: 7,
            colorHex: vm.colorHex
        )
        onAdd(slot)
        dismiss()
    }

    // MARK: Custom task form
    private var customTaskForm: some View {
        Form {
            Section("Task Details") {
                HStack(spacing: 12) {
                    TextField("Emoji", text: $emoji)
                        .frame(width: 50)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 22))
                    TextField("Task title", text: $title)
                }
                Picker("Category", selection: $section) {
                    ForEach(sections, id: \.self) { Text($0).tag($0) }
                }
            }

            Section("Time") {
                Picker("Hour", selection: $hour) {
                    ForEach(0..<24, id: \.self) { h in
                        let suf = h < 12 ? "AM" : "PM"
                        let h12 = h == 0 ? 12 : h > 12 ? h - 12 : h
                        Text("\(h12) \(suf)").tag(h)
                    }
                }
                Picker("Minute", selection: $minute) {
                    ForEach([0,15,30,45], id: \.self) { Text(String(format: ":%02d", $0)).tag($0) }
                }
                Picker("Duration", selection: $duration) {
                    ForEach([10,15,20,25,30,45,60,90], id: \.self) { Text("\($0) mins").tag($0) }
                }
            }

            Section("Repeat") {
                Picker("Day", selection: $dayOfWeek) {
                    ForEach(Array(days.enumerated()), id: \.offset) { i, d in
                        Text(d).tag(i < 7 ? i : 7)
                    }
                }
            }

            Section("Colour") {
                HStack(spacing: 12) {
                    ForEach(colors, id: \.self) { c in
                        Circle()
                            .fill(Color(hex: c))
                            .frame(width: 32, height: 32)
                            .overlay(Circle().stroke(colorHex == c ? Color.primary : Color.clear, lineWidth: 2.5))
                            .onTapGesture { colorHex = c }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

// MARK: - Template quick-add card (video thumbnail + add button)

struct TemplateQuickAddCard: View {
    let model: VideoModel
    let onAdd: () -> Void

    var body: some View {
        Button(action: onAdd) {
            VStack(spacing: 0) {
                ZStack {
                    AsyncImage(url: URL(string: "https://img.youtube.com/vi/\(model.youtubeID)/hqdefault.jpg")) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable().scaledToFill().frame(height: 90).clipped()
                        default:
                            Rectangle()
                                .fill(Color(hex: model.colorHex).opacity(0.15))
                                .frame(height: 90)
                                .overlay(Text(model.emoji).font(.system(size: 32)))
                        }
                    }

                    // Add badge
                    VStack {
                        HStack {
                            Spacer()
                            ZStack {
                                Circle().fill(Color(hex: "1D9E75")).frame(width: 26, height: 26)
                                Image(systemName: "plus").font(.system(size: 12, weight: .bold)).foregroundColor(.white)
                            }
                            .padding(6)
                        }
                        Spacer()
                    }
                }
                .frame(height: 90).clipped()

                HStack(spacing: 6) {
                    Text(model.emoji).font(.system(size: 14))
                    Text(model.title)
                        .font(.system(size: 11, weight: .semibold))
                        .lineLimit(1)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 7)
                .background(Color(.systemBackground))
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: model.colorHex).opacity(0.35), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}
