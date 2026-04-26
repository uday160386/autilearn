import SwiftUI

// MARK: - Currency Learning
// INR (Indian Rupee) and SGD (Singapore Dollar) with visual coins/notes
// and real-life shopping examples for autistic kids.

// MARK: - Currency models

enum Currency: String, CaseIterable, Identifiable {
    case inr = "INR"
    case sgd = "SGD"
    var id: String { rawValue }
    var flag: String  { self == .inr ? "🇮🇳" : "🇸🇬" }
    var name: String  { self == .inr ? "Indian Rupee" : "Singapore Dollar" }
    var symbol: String { self == .inr ? "₹" : "S$" }
    var colorHex: String { self == .inr ? "#D85A30" : "#D4537E" }
}

struct MoneyDenomination: Identifiable {
    let id: Int
    let value: Int          // face value in smallest unit (paise / cents)
    let label: String       // "₹10", "S$2"
    let imageName: String   // SF symbol
    let colorHex: String
    let isNote: Bool
}

extension MoneyDenomination {
    static let inr: [MoneyDenomination] = [
        MoneyDenomination(id:1,  value:100,   label:"₹1",    imageName:"indianrupeesign.circle.fill", colorHex:"#BA7517", isNote:false),
        MoneyDenomination(id:2,  value:200,   label:"₹2",    imageName:"indianrupeesign.circle.fill", colorHex:"#BA7517", isNote:false),
        MoneyDenomination(id:3,  value:500,   label:"₹5",    imageName:"indianrupeesign.circle.fill", colorHex:"#BA7517", isNote:false),
        MoneyDenomination(id:4,  value:1000,  label:"₹10",   imageName:"indianrupeesign.circle.fill", colorHex:"#BA7517", isNote:false),
        MoneyDenomination(id:5,  value:2000,  label:"₹20",   imageName:"indianrupeesign.square.fill", colorHex:"#1D9E75", isNote:true),
        MoneyDenomination(id:6,  value:5000,  label:"₹50",   imageName:"indianrupeesign.square.fill", colorHex:"#534AB7", isNote:true),
        MoneyDenomination(id:7,  value:10000, label:"₹100",  imageName:"indianrupeesign.square.fill", colorHex:"#185FA5", isNote:true),
        MoneyDenomination(id:8,  value:20000, label:"₹200",  imageName:"indianrupeesign.square.fill", colorHex:"#D85A30", isNote:true),
        MoneyDenomination(id:9,  value:50000, label:"₹500",  imageName:"indianrupeesign.square.fill", colorHex:"#D4537E", isNote:true),
    ]
    static let sgd: [MoneyDenomination] = [
        MoneyDenomination(id:10, value:5,    label:"5¢",    imageName:"s.circle.fill",   colorHex:"#BA7517", isNote:false),
        MoneyDenomination(id:11, value:10,   label:"10¢",   imageName:"s.circle.fill",   colorHex:"#888888", isNote:false),
        MoneyDenomination(id:12, value:20,   label:"20¢",   imageName:"s.circle.fill",   colorHex:"#1D9E75", isNote:false),
        MoneyDenomination(id:13, value:50,   label:"50¢",   imageName:"s.circle.fill",   colorHex:"#D85A30", isNote:false),
        MoneyDenomination(id:14, value:100,  label:"S$1",   imageName:"s.circle.fill",   colorHex:"#BA7517", isNote:false),
        MoneyDenomination(id:15, value:200,  label:"S$2",   imageName:"s.square.fill",   colorHex:"#185FA5", isNote:true),
        MoneyDenomination(id:16, value:500,  label:"S$5",   imageName:"s.square.fill",   colorHex:"#1D9E75", isNote:true),
        MoneyDenomination(id:17, value:1000, label:"S$10",  imageName:"s.square.fill",   colorHex:"#D85A30", isNote:true),
        MoneyDenomination(id:18, value:5000, label:"S$50",  imageName:"s.square.fill",   colorHex:"#D4537E", isNote:true),
    ]
}

struct ShoppingScenario: Identifiable {
    let id: Int
    let emoji: String
    let item: String
    let priceINR: Int    // in paise (×100)
    let priceSGD: Int    // in cents (×100)
    let paidINR: Int
    let paidSGD: Int
    let description: String
}

extension ShoppingScenario {
    static let all: [ShoppingScenario] = [
        ShoppingScenario(id:1, emoji:"🍎", item:"Apple",
            priceINR:2000, priceSGD:60,  paidINR:5000,  paidSGD:100,
            description:"You buy an apple at the fruit shop."),
        ShoppingScenario(id:2, emoji:"🚌", item:"Bus ticket",
            priceINR:1500, priceSGD:170, paidINR:2000,  paidSGD:200,
            description:"You hop on a bus to go to school."),
        ShoppingScenario(id:3, emoji:"📒", item:"Notebook",
            priceINR:4000, priceSGD:150, paidINR:5000,  paidSGD:200,
            description:"You buy a notebook for school."),
        ShoppingScenario(id:4, emoji:"🍦", item:"Ice cream",
            priceINR:3000, priceSGD:200, paidINR:5000,  paidSGD:500,
            description:"You buy a yummy ice cream at the park."),
        ShoppingScenario(id:5, emoji:"🎈", item:"Balloon",
            priceINR:1000, priceSGD:50,  paidINR:2000,  paidSGD:100,
            description:"You buy a colourful balloon at a fair."),
        ShoppingScenario(id:6, emoji:"🥐", item:"Bread roll",
            priceINR:800,  priceSGD:80,  paidINR:1000,  paidSGD:100,
            description:"You buy a bread roll from the bakery."),
        ShoppingScenario(id:7, emoji:"✏️", item:"Pencil",
            priceINR:500,  priceSGD:30,  paidINR:1000,  paidSGD:50,
            description:"You buy a pencil for drawing pictures."),
        ShoppingScenario(id:8, emoji:"🧃", item:"Juice box",
            priceINR:2500, priceSGD:120, paidINR:5000,  paidSGD:200,
            description:"You buy a juice box at the canteen."),
    ]
}

// MARK: - Currency home view

struct CurrencyHomeView: View {
    @State private var selectedCurrency: Currency = .inr
    @State private var selectedMode: CurrencyMode = .learn
    @State private var speechEngine = SpeechEngine()

    enum CurrencyMode: String, CaseIterable {
        case learn    = "Learn Money"
        case shopping = "Shopping"
        case quiz     = "Quiz"
        case calc     = "Calculator"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // Currency selector
                HStack(spacing: 12) {
                    ForEach(Currency.allCases) { cur in
                        Button {
                            withAnimation { selectedCurrency = cur }
                        } label: {
                            HStack(spacing: 8) {
                                Text(cur.flag).font(.system(size: 22))
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(cur.symbol + " " + cur.rawValue)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(selectedCurrency == cur ? .white : Color(hex: cur.colorHex))
                                    Text(cur.name)
                                        .font(.system(size: 11))
                                        .foregroundColor(selectedCurrency == cur ? .white.opacity(0.8) : .secondary)
                                }
                            }
                            .padding(.horizontal, 16).padding(.vertical, 10)
                            .background(selectedCurrency == cur ? Color(hex: cur.colorHex) : Color(hex: cur.colorHex).opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }.buttonStyle(.plain)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20).padding(.top, 16)

                // Mode tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(CurrencyMode.allCases, id: \.self) { mode in
                            Button {
                                withAnimation { selectedMode = mode }
                            } label: {
                                Text(mode.rawValue)
                                    .font(.system(size: 13, weight: selectedMode == mode ? .semibold : .regular))
                                    .foregroundColor(selectedMode == mode ? .white : Color(hex: selectedCurrency.colorHex))
                                    .padding(.horizontal, 16).padding(.vertical, 8)
                                    .background(selectedMode == mode ? Color(hex: selectedCurrency.colorHex) : Color(hex: selectedCurrency.colorHex).opacity(0.1))
                                    .clipShape(Capsule())
                            }.buttonStyle(.plain)
                        }
                    }.padding(.horizontal, 20)
                }.padding(.bottom, 4)

                // Content
                Group {
                    switch selectedMode {
                    case .learn:    MoneyLearnView(currency: selectedCurrency, speechEngine: speechEngine)
                    case .shopping: ShoppingView(currency: selectedCurrency, speechEngine: speechEngine)
                    case .quiz:     MoneyQuizView(currency: selectedCurrency)
                    case .calc:     MoneyCalculatorView(currency: selectedCurrency)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Money & Currency")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Learn money denominations

struct MoneyLearnView: View {
    let currency: Currency
    let speechEngine: SpeechEngine
    private var denoms: [MoneyDenomination] { currency == .inr ? MoneyDenomination.inr : MoneyDenomination.sgd }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("These are the \(currency.name) notes and coins")
                .font(.system(size: 14)).foregroundColor(.secondary)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120, maximum: 160), spacing: 12)], spacing: 12) {
                ForEach(denoms) { d in
                    Button {
                        let words = d.isNote ? "This is a \(d.label) note" : "This is a \(d.label) coin"
                        speechEngine.speak(words)
                    } label: {
                        VStack(spacing: 8) {
                            ZStack {
                                RoundedRectangle(cornerRadius: d.isNote ? 10 : 50)
                                    .fill(Color(hex: d.colorHex).opacity(0.15))
                                    .frame(width: d.isNote ? 80 : 60, height: d.isNote ? 50 : 60)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: d.isNote ? 10 : 50)
                                            .stroke(Color(hex: d.colorHex).opacity(0.5), lineWidth: 2)
                                    )
                                Text(d.label)
                                    .font(.system(size: d.isNote ? 14 : 13, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(hex: d.colorHex))
                            }
                            Text(d.isNote ? "Note" : "Coin")
                                .font(.system(size: 11)).foregroundColor(.secondary)
                            Image(systemName: "speaker.wave.2")
                                .font(.system(size: 10)).foregroundColor(Color(hex: d.colorHex).opacity(0.6))
                        }
                        .padding(12).frame(maxWidth: .infinity)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.separator).opacity(0.3), lineWidth: 0.5))
                    }.buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Shopping scenarios

struct ShoppingView: View {
    let currency: Currency
    let speechEngine: SpeechEngine
    @State private var selectedScenario: ShoppingScenario? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Tap a scenario to learn about paying and getting change")
                .font(.system(size: 14)).foregroundColor(.secondary)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160, maximum: 220), spacing: 12)], spacing: 12) {
                ForEach(ShoppingScenario.all) { scenario in
                    Button { selectedScenario = scenario } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(scenario.emoji).font(.system(size: 32))
                                Spacer()
                                Text(currency == .inr
                                     ? "₹\(scenario.priceINR/100)"
                                     : "S$\(String(format:"%.2f", Double(scenario.priceSGD)/100))")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(hex: currency.colorHex))
                            }
                            Text(scenario.item)
                                .font(.system(size: 14, weight: .semibold)).foregroundColor(.primary)
                            Text(scenario.description)
                                .font(.system(size: 11)).foregroundColor(.secondary).lineLimit(2)
                        }
                        .padding(14).frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: currency.colorHex).opacity(0.3), lineWidth: 1))
                    }.buttonStyle(.plain)
                }
            }
        }
        .sheet(item: $selectedScenario) { s in
            ShoppingDetailView(scenario: s, currency: currency, speechEngine: speechEngine)
        }
    }
}

// MARK: - Shopping detail sheet

struct ShoppingDetailView: View {
    let scenario: ShoppingScenario
    let currency: Currency
    let speechEngine: SpeechEngine
    @Environment(\.dismiss) private var dismiss

    private var price: Int  { currency == .inr ? scenario.priceINR : scenario.priceSGD }
    private var paid: Int   { currency == .inr ? scenario.paidINR  : scenario.paidSGD  }
    private var change: Int { paid - price }
    private var sym: String { currency.symbol }
    private var fmt: (Int) -> String {{ v in
        if currency == .inr { return "\(sym)\(v/100)" }
        return "\(sym)\(String(format:"%.2f", Double(v)/100))"
    }}

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // Big emoji
                    Text(scenario.emoji).font(.system(size: 80)).padding(.top, 20)
                    Text(scenario.item)
                        .font(.system(size: 24, weight: .bold))
                    Text(scenario.description)
                        .font(.system(size: 15)).foregroundColor(.secondary).multilineTextAlignment(.center).padding(.horizontal, 24)

                    // Price box
                    stepBox(step: "1", title: "Price", icon: "tag.fill",
                            color: "#D85A30",
                            text: "The \(scenario.item) costs \(fmt(price)).",
                            big: fmt(price))

                    // Paid box
                    stepBox(step: "2", title: "You pay", icon: "banknote.fill",
                            color: "#1D9E75",
                            text: "You give the shopkeeper \(fmt(paid)).",
                            big: fmt(paid))

                    // Change box
                    VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            ZStack {
                                Circle().fill(Color(hex: "#534AB7").opacity(0.15)).frame(width: 36, height: 36)
                                Text("3").font(.system(size: 14, weight: .bold)).foregroundColor(Color(hex: "#534AB7"))
                            }
                            Text("Change").font(.system(size: 15, weight: .semibold))
                            Spacer()
                        }
                        HStack(spacing: 16) {
                            Text(fmt(paid))
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "#1D9E75"))
                            Text("−")
                                .font(.system(size: 28, weight: .bold)).foregroundColor(.secondary)
                            Text(fmt(price))
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "#D85A30"))
                            Text("=")
                                .font(.system(size: 28, weight: .bold)).foregroundColor(.secondary)
                            Text(fmt(change))
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "#534AB7"))
                        }
                        Text("The shopkeeper gives you \(fmt(change)) change.")
                            .font(.system(size: 14)).foregroundColor(.secondary)
                    }
                    .padding(16).background(Color(hex: "#534AB7").opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 20)

                    Button {
                        speechEngine.speak("The \(scenario.item) costs \(fmt(price)). You pay \(fmt(paid)). Your change is \(fmt(change)).")
                    } label: {
                        Label("Hear it explained", systemImage: "speaker.wave.2.fill")
                            .font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                            .frame(maxWidth: .infinity).padding(.vertical, 14)
                            .background(Color(hex: currency.colorHex)).clipShape(RoundedRectangle(cornerRadius: 14))
                    }.padding(.horizontal, 20).padding(.bottom, 30)
                }
            }
            .navigationTitle("Shopping")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } } }
        }
    }

    private func stepBox(step: String, title: String, icon: String, color: String, text: String, big: String) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                ZStack {
                    Circle().fill(Color(hex: color).opacity(0.15)).frame(width: 36, height: 36)
                    Text(step).font(.system(size: 14, weight: .bold)).foregroundColor(Color(hex: color))
                }
                Text(title).font(.system(size: 15, weight: .semibold))
                Spacer()
            }
            Text(big).font(.system(size: 36, weight: .bold, design: .rounded)).foregroundColor(Color(hex: color))
            Text(text).font(.system(size: 14)).foregroundColor(.secondary)
        }
        .padding(16).background(Color(hex: color).opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 20)
    }
}

// MARK: - Money quiz

struct MoneyQuizView: View {
    let currency: Currency
    @State private var question = MoneyQuestion(currency: .inr)
    @State private var selected: Int? = nil
    @State private var score    = 0
    @State private var total    = 0
    @State private var speechEngine = SpeechEngine()

    var body: some View {
        VStack(spacing: 20) {

            HStack {
                Text("Score: \(score)/\(total)").font(.system(size: 14)).foregroundColor(.secondary)
                Spacer()
                Text("\(currency.flag) \(currency.name)").font(.system(size: 13, weight: .semibold)).foregroundColor(Color(hex: currency.colorHex))
            }

            // Question card
            VStack(spacing: 12) {
                Text("💡").font(.system(size: 36))
                Text(question.text)
                    .font(.system(size: 18, weight: .semibold)).multilineTextAlignment(.center)
                    .foregroundColor(.primary).padding(.horizontal, 8)
                Text(question.context)
                    .font(.system(size: 13)).foregroundColor(.secondary).multilineTextAlignment(.center)
            }
            .padding(20).frame(maxWidth: .infinity)
            .background(Color(hex: currency.colorHex).opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            // Choices
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                ForEach(Array(question.choices.enumerated()), id: \.offset) { i, choice in
                    Button {
                        guard selected == nil else { return }
                        selected = i; total += 1
                        let correct = i == question.correctIndex
                        if correct { score += 1 }
                        speechEngine.speak(correct ? "Correct! \(question.explanation)" : "Not quite. \(question.explanation)")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                            question = MoneyQuestion(currency: currency); selected = nil
                        }
                    } label: {
                        Text(choice)
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(selected == nil ? Color(hex: currency.colorHex) :
                                             i == question.correctIndex ? .white :
                                             selected == i ? .white : .secondary)
                            .frame(maxWidth: .infinity).padding(.vertical, 16)
                            .background(selected == nil ? Color(hex: currency.colorHex).opacity(0.1) :
                                        i == question.correctIndex ? Color(hex: "#1D9E75") :
                                        selected == i ? Color(hex: "#D85A30") : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }.buttonStyle(.plain)
                }
            }

            if let s = selected {
                Text(s == question.correctIndex ? "✅ \(question.explanation)" : "❌ \(question.explanation)")
                    .font(.system(size: 14)).foregroundColor(s == question.correctIndex ? Color(hex:"#1D9E75") : Color(hex:"#D85A30"))
                    .multilineTextAlignment(.center).padding(.horizontal, 8)
                    .transition(.opacity)
            }
        }
    }
}

struct MoneyQuestion {
    let text: String
    let context: String
    let choices: [String]
    let correctIndex: Int
    let explanation: String

    init(currency: Currency) {
        let sym   = currency.symbol
        let isINR = currency == .inr
        let pool: [(String, String, [String], Int, String)] = isINR ? [
            ("How many ₹10 coins make ₹50?", "Count carefully!", ["3","4","5","6"], 2, "5 × ₹10 = ₹50"),
            ("You have ₹100 and spend ₹35. How much is left?", "Subtract the price from what you have.", ["₹55","₹65","₹75","₹45"], 1, "₹100 − ₹35 = ₹65"),
            ("A pen costs ₹12. You buy 3. What is the total?", "Multiply price × quantity.", ["₹24","₹36","₹30","₹42"], 1, "₹12 × 3 = ₹36"),
            ("You pay ₹200 for a ₹150 book. What is your change?", "Paid minus price equals change.", ["₹30","₹40","₹50","₹60"], 2, "₹200 − ₹150 = ₹50"),
            ("Which is worth more: 5 × ₹10 or 2 × ₹20?", "Calculate each total first.", ["5 × ₹10","2 × ₹20","They're equal","Cannot tell"], 2, "5×10 = 50 and 2×20 = 40. Wait — 50 > 40, so 5×₹10 is more!"),
            ("A mango costs ₹25 and a banana costs ₹5. How much for both?", "Add the prices together.", ["₹20","₹28","₹30","₹25"], 2, "₹25 + ₹5 = ₹30"),
        ] : [
            ("How many 50¢ coins make S$2?", "Count up to S$2.", ["2","3","4","5"], 2, "4 × 50¢ = S$2.00"),
            ("You have S$5 and spend S$3.20. How much is left?", "Subtract the price.", ["S$1.20","S$1.80","S$2.00","S$2.80"], 1, "S$5 − S$3.20 = S$1.80"),
            ("A drink costs S$1.50. You buy 2. Total?", "Multiply price × quantity.", ["S$2.50","S$3.00","S$3.50","S$2.00"], 1, "S$1.50 × 2 = S$3.00"),
            ("You pay S$10 for a S$7.50 book. What is your change?", "Paid minus price.", ["S$2.00","S$2.50","S$3.00","S$3.50"], 1, "S$10 − S$7.50 = S$2.50"),
            ("Which is worth more: 3 × S$2 or 5 × S$1?", "Calculate both totals.", ["3 × S$2","5 × S$1","Same","Cannot tell"], 0, "3×2 = S$6, 5×1 = S$5. So 3×S$2 is more!"),
            ("Bread costs S$2.80, butter S$3.20. Total?", "Add the two prices.", ["S$5.80","S$6.00","S$6.10","S$6.20"], 1, "S$2.80 + S$3.20 = S$6.00"),
        ]
        let pick = pool.randomElement()!
        text = pick.0; context = pick.1; choices = pick.2; correctIndex = pick.3; explanation = pick.4
    }
}

// MARK: - Calculator

struct MoneyCalculatorView: View {
    let currency: Currency
    @State private var amountA: String = ""
    @State private var amountB: String = ""
    @State private var op: CalcOp = .add
    @FocusState private var focusA: Bool
    @State private var speechEngine = SpeechEngine()

    enum CalcOp: String, CaseIterable { case add = "+", subtract = "−", multiply = "×" }

    private var result: Double? {
        guard let a = Double(amountA), let b = Double(amountB) else { return nil }
        switch op {
        case .add:      return a + b
        case .subtract: return a >= b ? a - b : nil
        case .multiply: return a * b
        }
    }

    private var fmt: (Double) -> String { { v in
        currency == .inr ? "₹\(Int(v * 100) / 100)" : String(format: "S$%.2f", v)
    }}

    var body: some View {
        VStack(spacing: 16) {
            Text("Enter amounts in \(currency.name) (\(currency.symbol))")
                .font(.system(size: 14)).foregroundColor(.secondary)

            HStack(spacing: 10) {
                currencyField(placeholder: "Amount 1", text: $amountA)
                Picker("", selection: $op) {
                    ForEach(CalcOp.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }.pickerStyle(.segmented).frame(width: 120)
                currencyField(placeholder: "Amount 2", text: $amountB)
            }

            if let r = result {
                VStack(spacing: 6) {
                    Text("= \(fmt(r))")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: currency.colorHex))
                    Button {
                        speechEngine.speak("\(amountA) \(op == .add ? "plus" : op == .subtract ? "minus" : "times") \(amountB) equals \(fmt(r))")
                    } label: {
                        Label("Hear it", systemImage: "speaker.wave.2")
                            .font(.system(size: 14)).foregroundColor(Color(hex: currency.colorHex))
                    }
                }
                .padding(20).frame(maxWidth: .infinity)
                .background(Color(hex: currency.colorHex).opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            } else if !amountA.isEmpty && !amountB.isEmpty {
                Text(op == .subtract ? "Cannot subtract a larger number from a smaller one" : "Please enter valid amounts")
                    .font(.system(size: 13)).foregroundColor(Color(hex: "#D85A30")).multilineTextAlignment(.center)
            }

            // Quick examples
            VStack(alignment: .leading, spacing: 8) {
                Text("Quick examples").font(.system(size: 13, weight: .semibold)).foregroundColor(.secondary)
                ForEach(quickExamples, id: \.0) { ex in
                    Button { amountA = ex.1; amountB = ex.2; op = ex.3 } label: {
                        HStack {
                            Text(ex.0).font(.system(size: 13)).foregroundColor(.primary)
                            Spacer()
                            Text("Try →").font(.system(size: 12)).foregroundColor(Color(hex: currency.colorHex))
                        }.padding(.horizontal, 14).padding(.vertical, 8)
                        .background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 10))
                    }.buttonStyle(.plain)
                }
            }
        }
    }

    private func currencyField(placeholder: String, text: Binding<String>) -> some View {
        HStack(spacing: 4) {
            Text(currency.symbol).font(.system(size: 16, weight: .bold)).foregroundColor(Color(hex: currency.colorHex))
            TextField(placeholder, text: text).keyboardType(.decimalPad).font(.system(size: 16))
        }
        .padding(.horizontal, 12).padding(.vertical, 10)
        .background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var quickExamples: [(String, String, String, CalcOp)] {
        currency == .inr ? [
            ("Bus ₹15 + Snack ₹25",    "15", "25", .add),
            ("₹100 note, spend ₹40",   "100", "40", .subtract),
            ("3 pens × ₹12 each",      "12", "3", .multiply),
        ] : [
            ("Drink S$1.50 + Bun S$1.20", "1.50", "1.20", .add),
            ("S$10 note, spend S$6.80",   "10", "6.80", .subtract),
            ("4 stickers × S$0.50 each",  "0.50", "4", .multiply),
        ]
    }
}
