import SwiftUI

// MARK: - English Lessons for Autistic Kids
// Visual, audio-first, clear and structured lessons.

struct EnglishLesson: Identifiable {
    let id: Int
    let title: String
    let emoji: String
    let colorHex: String
    let level: LessonLevel
    let description: String
    let cards: [LessonCard]
    enum LessonLevel: String { case beginner = "Beginner", intermediate = "Intermediate" }
}

struct LessonCard: Identifiable {
    let id: Int
    let word: String
    let example: String
    let emoji: String
    let pronunciation: String   // simple phonetic guide
    let imageKeyword: String    // for AsyncImage search
}

extension EnglishLesson {
    static let all: [EnglishLesson] = [

        EnglishLesson(id:1, title:"Colours", emoji:"🎨", colorHex:"#D4537E", level:.beginner,
            description:"Learn the names of colours you see every day.",
            cards:[
                LessonCard(id:1, word:"Red",    example:"The apple is red.",       emoji:"🍎", pronunciation:"R-EH-D",   imageKeyword:"red"),
                LessonCard(id:2, word:"Blue",   example:"The sky is blue.",        emoji:"🌊", pronunciation:"B-LOO",    imageKeyword:"blue sky"),
                LessonCard(id:3, word:"Green",  example:"Grass is green.",         emoji:"🌿", pronunciation:"G-REEN",   imageKeyword:"green grass"),
                LessonCard(id:4, word:"Yellow", example:"The sun is yellow.",      emoji:"☀️", pronunciation:"YEL-oh",   imageKeyword:"yellow"),
                LessonCard(id:5, word:"Orange", example:"Oranges are orange.",     emoji:"🍊", pronunciation:"OR-inj",   imageKeyword:"orange"),
                LessonCard(id:6, word:"Purple", example:"Grapes are purple.",      emoji:"🍇", pronunciation:"PUR-pul",  imageKeyword:"purple"),
                LessonCard(id:7, word:"Pink",   example:"Flamingos are pink.",     emoji:"🦩", pronunciation:"P-INK",    imageKeyword:"pink"),
                LessonCard(id:8, word:"White",  example:"Snow is white.",          emoji:"❄️", pronunciation:"W-ITE",    imageKeyword:"white snow"),
                LessonCard(id:9, word:"Black",  example:"The night sky is black.", emoji:"🌑", pronunciation:"B-LACK",   imageKeyword:"black"),
                LessonCard(id:10,word:"Brown",  example:"Chocolate is brown.",     emoji:"🍫", pronunciation:"B-ROWN",   imageKeyword:"brown"),
            ]
        ),

        EnglishLesson(id:2, title:"Numbers 1–20", emoji:"🔢", colorHex:"#534AB7", level:.beginner,
            description:"Say and spell numbers from one to twenty.",
            cards:[
                LessonCard(id:1,  word:"One",      example:"I have one apple.",        emoji:"1️⃣", pronunciation:"W-UN",      imageKeyword:"one"),
                LessonCard(id:2,  word:"Two",       example:"I have two eyes.",         emoji:"2️⃣", pronunciation:"T-OO",      imageKeyword:"two"),
                LessonCard(id:3,  word:"Three",     example:"A triangle has three sides.",emoji:"3️⃣", pronunciation:"TH-REE",   imageKeyword:"three"),
                LessonCard(id:4,  word:"Four",      example:"A table has four legs.",   emoji:"4️⃣", pronunciation:"F-OR",      imageKeyword:"four"),
                LessonCard(id:5,  word:"Five",      example:"I have five fingers.",     emoji:"5️⃣", pronunciation:"F-IVE",     imageKeyword:"five"),
                LessonCard(id:6,  word:"Six",       example:"An insect has six legs.",  emoji:"6️⃣", pronunciation:"S-IX",      imageKeyword:"six"),
                LessonCard(id:7,  word:"Seven",     example:"A week has seven days.",   emoji:"7️⃣", pronunciation:"SEV-en",    imageKeyword:"seven"),
                LessonCard(id:8,  word:"Eight",     example:"An octopus has eight arms.",emoji:"8️⃣", pronunciation:"AYT",      imageKeyword:"eight"),
                LessonCard(id:9,  word:"Nine",      example:"A cat has nine lives.",    emoji:"9️⃣", pronunciation:"N-INE",     imageKeyword:"nine"),
                LessonCard(id:10, word:"Ten",       example:"I have ten toes.",         emoji:"🔟", pronunciation:"T-EN",      imageKeyword:"ten"),
                LessonCard(id:11, word:"Eleven",    example:"Eleven players on a team.",emoji:"1️⃣1️⃣", pronunciation:"ih-LEV-en", imageKeyword:"eleven"),
                LessonCard(id:12, word:"Twelve",    example:"A year has twelve months.",emoji:"🕛", pronunciation:"TWELV",     imageKeyword:"twelve"),
                LessonCard(id:13, word:"Twenty",    example:"Twenty seconds passed.",  emoji:"2️⃣0️⃣", pronunciation:"TWEN-tee",  imageKeyword:"twenty"),
            ]
        ),

        EnglishLesson(id:3, title:"Animals", emoji:"🐾", colorHex:"#1D9E75", level:.beginner,
            description:"Learn names of animals in English.",
            cards:[
                LessonCard(id:1,  word:"Dog",      example:"A dog barks.",             emoji:"🐶", pronunciation:"D-OG",     imageKeyword:"dog"),
                LessonCard(id:2,  word:"Cat",      example:"A cat meows.",             emoji:"🐱", pronunciation:"K-AT",     imageKeyword:"cat"),
                LessonCard(id:3,  word:"Bird",     example:"A bird flies.",            emoji:"🐦", pronunciation:"B-URD",    imageKeyword:"bird"),
                LessonCard(id:4,  word:"Fish",     example:"A fish swims.",            emoji:"🐟", pronunciation:"F-ISH",    imageKeyword:"fish"),
                LessonCard(id:5,  word:"Elephant", example:"Elephants are very big.",  emoji:"🐘", pronunciation:"EL-eh-fant",imageKeyword:"elephant"),
                LessonCard(id:6,  word:"Lion",     example:"A lion roars.",            emoji:"🦁", pronunciation:"LY-on",    imageKeyword:"lion"),
                LessonCard(id:7,  word:"Rabbit",   example:"A rabbit hops.",           emoji:"🐰", pronunciation:"RAB-it",   imageKeyword:"rabbit"),
                LessonCard(id:8,  word:"Butterfly",example:"Butterflies are beautiful.",emoji:"🦋", pronunciation:"BUT-er-fly",imageKeyword:"butterfly"),
                LessonCard(id:9,  word:"Monkey",   example:"A monkey climbs trees.",   emoji:"🐒", pronunciation:"MUN-kee",  imageKeyword:"monkey"),
                LessonCard(id:10, word:"Penguin",  example:"Penguins waddle.",         emoji:"🐧", pronunciation:"PEN-gwin", imageKeyword:"penguin"),
            ]
        ),

        EnglishLesson(id:4, title:"My Body", emoji:"🧍", colorHex:"#185FA5", level:.beginner,
            description:"Name parts of your body in English.",
            cards:[
                LessonCard(id:1, word:"Head",    example:"I nod my head.",          emoji:"👤", pronunciation:"H-ED",      imageKeyword:"head"),
                LessonCard(id:2, word:"Eyes",    example:"I see with my eyes.",     emoji:"👁️", pronunciation:"EYE-z",     imageKeyword:"eyes"),
                LessonCard(id:3, word:"Ears",    example:"I hear with my ears.",    emoji:"👂", pronunciation:"EE-rz",     imageKeyword:"ears"),
                LessonCard(id:4, word:"Nose",    example:"I smell with my nose.",   emoji:"👃", pronunciation:"N-OHZ",     imageKeyword:"nose"),
                LessonCard(id:5, word:"Mouth",   example:"I talk with my mouth.",   emoji:"👄", pronunciation:"M-OWTH",    imageKeyword:"mouth"),
                LessonCard(id:6, word:"Hands",   example:"I write with my hands.",  emoji:"✋", pronunciation:"H-ANDZ",    imageKeyword:"hands"),
                LessonCard(id:7, word:"Feet",    example:"I walk with my feet.",    emoji:"🦶", pronunciation:"F-EET",     imageKeyword:"feet"),
                LessonCard(id:8, word:"Heart",   example:"My heart pumps blood.",   emoji:"❤️", pronunciation:"H-ART",     imageKeyword:"heart"),
                LessonCard(id:9, word:"Tummy",   example:"My tummy feels full.",    emoji:"🫁", pronunciation:"TUM-ee",    imageKeyword:"tummy"),
            ]
        ),

        EnglishLesson(id:5, title:"Action Words", emoji:"🏃", colorHex:"#D85A30", level:.intermediate,
            description:"Learn verbs — words that describe actions.",
            cards:[
                LessonCard(id:1, word:"Run",   example:"I run in the park.",          emoji:"🏃", pronunciation:"R-UN",   imageKeyword:"running"),
                LessonCard(id:2, word:"Jump",  example:"Frogs jump high.",            emoji:"🐸", pronunciation:"J-UMP",  imageKeyword:"jumping"),
                LessonCard(id:3, word:"Eat",   example:"I eat my breakfast.",         emoji:"🍽️", pronunciation:"EE-T",   imageKeyword:"eating"),
                LessonCard(id:4, word:"Sleep", example:"I sleep at night.",           emoji:"😴", pronunciation:"SL-EEP", imageKeyword:"sleeping"),
                LessonCard(id:5, word:"Swim",  example:"Fish swim in water.",         emoji:"🏊", pronunciation:"SW-IM",  imageKeyword:"swimming"),
                LessonCard(id:6, word:"Read",  example:"I read a book.",              emoji:"📖", pronunciation:"R-EED",  imageKeyword:"reading"),
                LessonCard(id:7, word:"Draw",  example:"I draw a picture.",           emoji:"✏️", pronunciation:"D-RAW",  imageKeyword:"drawing"),
                LessonCard(id:8, word:"Sing",  example:"I sing a song.",              emoji:"🎵", pronunciation:"S-ING",  imageKeyword:"singing"),
                LessonCard(id:9, word:"Play",  example:"Children play at recess.",    emoji:"🎮", pronunciation:"PL-AY",  imageKeyword:"playing"),
                LessonCard(id:10,word:"Help",  example:"I help my friend.",           emoji:"🤝", pronunciation:"H-ELP",  imageKeyword:"helping"),
            ]
        ),

        EnglishLesson(id:6, title:"Feelings Words", emoji:"💛", colorHex:"#BA7517", level:.intermediate,
            description:"Learn words to describe how you feel.",
            cards:[
                LessonCard(id:1, word:"Happy",    example:"I feel happy at my birthday.",  emoji:"😊", pronunciation:"HAP-ee",     imageKeyword:"happy"),
                LessonCard(id:2, word:"Sad",      example:"I feel sad when I lose my toy.",emoji:"😢", pronunciation:"S-AD",       imageKeyword:"sad"),
                LessonCard(id:3, word:"Excited",  example:"I'm excited about the trip.",   emoji:"🤩", pronunciation:"ex-SY-ted",  imageKeyword:"excited"),
                LessonCard(id:4, word:"Tired",    example:"I feel tired after school.",    emoji:"😴", pronunciation:"TY-erd",     imageKeyword:"tired"),
                LessonCard(id:5, word:"Worried",  example:"I feel worried about the test.",emoji:"😟", pronunciation:"WUR-eed",    imageKeyword:"worried"),
                LessonCard(id:6, word:"Proud",    example:"I feel proud of my drawing.",   emoji:"😌", pronunciation:"P-ROWD",     imageKeyword:"proud"),
                LessonCard(id:7, word:"Bored",    example:"I feel bored with nothing to do.",emoji:"😑", pronunciation:"B-ORD",   imageKeyword:"bored"),
                LessonCard(id:8, word:"Grateful", example:"I'm grateful for my family.",   emoji:"🙏", pronunciation:"GRATE-ful",  imageKeyword:"grateful"),
            ]
        ),

        EnglishLesson(id:7, title:"Polite Phrases", emoji:"🙏", colorHex:"#5DCAA5", level:.intermediate,
            description:"Words and phrases that are kind and polite.",
            cards:[
                LessonCard(id:1, word:"Please",      example:"Can I have water, please?",      emoji:"🥤", pronunciation:"PL-EEZ",       imageKeyword:"please"),
                LessonCard(id:2, word:"Thank you",   example:"Thank you for helping me.",      emoji:"🤝", pronunciation:"THANK-yoo",     imageKeyword:"thank you"),
                LessonCard(id:3, word:"Sorry",       example:"I'm sorry I bumped into you.",   emoji:"🙇", pronunciation:"SOR-ee",        imageKeyword:"sorry"),
                LessonCard(id:4, word:"Excuse me",   example:"Excuse me, may I pass?",         emoji:"🚶", pronunciation:"ex-KYOOZ mee",  imageKeyword:"excuse me"),
                LessonCard(id:5, word:"You're welcome",example:"You're welcome! It was nice.", emoji:"😊", pronunciation:"YOR WEL-kum",   imageKeyword:"welcome"),
                LessonCard(id:6, word:"Good morning",example:"Good morning, teacher!",         emoji:"☀️", pronunciation:"GOOD MOR-ning", imageKeyword:"morning"),
                LessonCard(id:7, word:"Goodbye",     example:"Goodbye! See you tomorrow.",     emoji:"👋", pronunciation:"GOOD-by",       imageKeyword:"goodbye"),
                LessonCard(id:8, word:"Can I help?", example:"Can I help you carry that?",     emoji:"💪", pronunciation:"KAN eye HELP",  imageKeyword:"help"),
            ]
        ),

        EnglishLesson(id:8, title:"Where Is It?", emoji:"📍", colorHex:"#888888", level:.intermediate,
            description:"Position words — describe where things are.",
            cards:[
                LessonCard(id:1, word:"On",     example:"The book is on the table.",      emoji:"📚", pronunciation:"ON",         imageKeyword:"on top"),
                LessonCard(id:2, word:"Under",  example:"The cat is under the chair.",    emoji:"🐱", pronunciation:"UN-der",     imageKeyword:"under"),
                LessonCard(id:3, word:"In",     example:"The apple is in the bag.",       emoji:"👜", pronunciation:"IN",         imageKeyword:"inside"),
                LessonCard(id:4, word:"Next to", example:"Sit next to your friend.",      emoji:"🧑‍🤝‍🧑", pronunciation:"NEXT too", imageKeyword:"next to"),
                LessonCard(id:5, word:"Behind", example:"The tree is behind the house.",  emoji:"🌳", pronunciation:"bee-HIND",   imageKeyword:"behind"),
                LessonCard(id:6, word:"In front", example:"Stand in front of the door.", emoji:"🚪", pronunciation:"in FRUNT",   imageKeyword:"in front"),
                LessonCard(id:7, word:"Above",  example:"The bird is above the cloud.",   emoji:"☁️", pronunciation:"uh-BUV",     imageKeyword:"above"),
                LessonCard(id:8, word:"Between",example:"Sit between Mum and Dad.",       emoji:"👨‍👩‍👦", pronunciation:"bee-TWEEN", imageKeyword:"between"),
            ]
        ),
    ]
}

// MARK: - English Lessons Home

struct EnglishLessonsHomeView: View {
    @State private var selectedLevel: EnglishLesson.LessonLevel? = nil
    @State private var openLesson: EnglishLesson? = nil

    private var filtered: [EnglishLesson] {
        guard let lv = selectedLevel else { return EnglishLesson.all }
        return EnglishLesson.all.filter { $0.level == lv }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Header
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("English Lessons")
                            .font(.system(size: 20, weight: .medium))
                        Text("Tap any card to hear the word spoken")
                            .font(.system(size: 14)).foregroundColor(.secondary)
                    }
                    Spacer()
                    Text("🔤").font(.system(size: 36))
                }
                .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 14)

                // Level filter
                HStack(spacing: 10) {
                    levelChip(nil, label: "All", color: "#888888")
                    levelChip(.beginner,     label: "Beginner",     color: "#1D9E75")
                    levelChip(.intermediate, label: "Intermediate", color: "#534AB7")
                    Spacer()
                }.padding(.horizontal, 20).padding(.bottom, 16)

                // Lesson grid
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160, maximum: 220), spacing: 14)], spacing: 14) {
                    ForEach(filtered) { lesson in
                        LessonGridCard(lesson: lesson) { openLesson = lesson }
                    }
                }.padding(.horizontal, 20).padding(.bottom, 30)
            }
        }
        .navigationTitle("English")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $openLesson) { lesson in
            EnglishLessonDetailView(lesson: lesson)
        }
    }

    private func levelChip(_ level: EnglishLesson.LessonLevel?, label: String, color: String) -> some View {
        Button { withAnimation { selectedLevel = level } } label: {
            Text(label)
                .font(.system(size: 13, weight: selectedLevel == level ? .semibold : .regular))
                .foregroundColor(selectedLevel == level ? .white : Color(hex: color))
                .padding(.horizontal, 16).padding(.vertical, 8)
                .background(selectedLevel == level ? Color(hex: color) : Color(hex: color).opacity(0.12))
                .clipShape(Capsule())
        }.buttonStyle(.plain)
    }
}

struct LessonGridCard: View {
    let lesson: EnglishLesson
    let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12).fill(Color(hex: lesson.colorHex).opacity(0.12)).frame(height: 70)
                    Text(lesson.emoji).font(.system(size: 38))
                }
                Text(lesson.title).font(.system(size: 14, weight: .semibold)).foregroundColor(.primary).lineLimit(1)
                Text("\(lesson.cards.count) words").font(.system(size: 11)).foregroundColor(.secondary)
                Text(lesson.level.rawValue)
                    .font(.system(size: 10, weight: .medium)).foregroundColor(Color(hex: lesson.colorHex))
                    .padding(.horizontal, 10).padding(.vertical, 3)
                    .background(Color(hex: lesson.colorHex).opacity(0.12)).clipShape(Capsule())
            }
            .padding(14).frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.separator).opacity(0.3), lineWidth: 0.5))
        }.buttonStyle(.plain)
    }
}

// MARK: - Lesson detail (flashcard style)

struct EnglishLessonDetailView: View {
    let lesson: EnglishLesson
    @Environment(\.dismiss) private var dismiss
    @State private var index   = 0
    @State private var flipped = false
    @State private var speechEngine = SpeechEngine()
    @State private var mode: LessonViewMode = .flashcard

    enum LessonViewMode: String, CaseIterable { case flashcard = "Flashcard", quiz = "Quiz", all = "All Words" }

    var card: LessonCard { lesson.cards[index] }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Mode tabs
                Picker("Mode", selection: $mode) {
                    ForEach(LessonViewMode.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }.pickerStyle(.segmented).padding(.horizontal, 20).padding(.vertical, 12)

                switch mode {
                case .flashcard: flashcardView
                case .quiz:      EnglishQuizView(lesson: lesson)
                case .all:       allWordsView
                }
            }
            .navigationTitle(lesson.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } } }
        }
    }

    // MARK: Flashcard

    private var flashcardView: some View {
        VStack(spacing: 20) {
            // Progress
            HStack {
                Text("Word \(index + 1) of \(lesson.cards.count)")
                    .font(.system(size: 13)).foregroundColor(.secondary)
                Spacer()
                HStack(spacing: 4) {
                    ForEach(0..<lesson.cards.count, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(i <= index ? Color(hex: lesson.colorHex) : Color(.systemFill))
                            .frame(width: i == index ? 16 : 6, height: 6)
                            .animation(.spring(response: 0.3), value: index)
                    }
                }
            }.padding(.horizontal, 24)

            Spacer()

            // Card
            ZStack {
                // Back — example sentence
                VStack(spacing: 16) {
                    Text(card.emoji).font(.system(size: 60))
                    Text(card.example)
                        .font(.system(size: 18, weight: .medium)).multilineTextAlignment(.center).padding(.horizontal, 20)
                        .foregroundColor(.white)
                    Text("Pronunciation: \(card.pronunciation)")
                        .font(.system(size: 14)).foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity, minHeight: 220)
                .padding(24)
                .background(Color(hex: lesson.colorHex))
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .rotation3DEffect(.degrees(flipped ? 0 : -90), axis: (x: 0, y: 1, z: 0))
                .opacity(flipped ? 1 : 0)

                // Front — word
                VStack(spacing: 16) {
                    Text(card.emoji).font(.system(size: 72))
                    Text(card.word)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: lesson.colorHex))
                    Text("Tap to see example →")
                        .font(.system(size: 13)).foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, minHeight: 220)
                .padding(24)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color(hex: lesson.colorHex).opacity(0.4), lineWidth: 2))
                .rotation3DEffect(.degrees(flipped ? 90 : 0), axis: (x: 0, y: 1, z: 0))
                .opacity(flipped ? 0 : 1)
            }
            .padding(.horizontal, 24)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.35)) { flipped.toggle() }
                if !flipped { speechEngine.speak("\(card.word). \(card.example)") }
            }

            // Speak button
            Button { speechEngine.speak("\(card.word). \(card.example)") } label: {
                Label("Hear it", systemImage: "speaker.wave.2.fill")
                    .font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                    .padding(.horizontal, 32).padding(.vertical, 12)
                    .background(Color(hex: lesson.colorHex)).clipShape(Capsule())
            }

            Spacer()

            // Navigation
            HStack(spacing: 16) {
                Button {
                    withAnimation { flipped = false; index = max(0, index - 1) }
                } label: {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.system(size: 44)).foregroundColor(index == 0 ? Color(.systemFill) : Color(hex: lesson.colorHex))
                }.disabled(index == 0)

                Spacer()

                Button {
                    withAnimation { flipped = false; index = min(lesson.cards.count - 1, index + 1) }
                } label: {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.system(size: 44)).foregroundColor(index == lesson.cards.count - 1 ? Color(.systemFill) : Color(hex: lesson.colorHex))
                }.disabled(index == lesson.cards.count - 1)
            }.padding(.horizontal, 40).padding(.bottom, 30)
        }
    }

    // MARK: All words grid
    private var allWordsView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 12)], spacing: 12) {
                ForEach(lesson.cards) { c in
                    Button { speechEngine.speak("\(c.word). \(c.example)") } label: {
                        VStack(spacing: 8) {
                            Text(c.emoji).font(.system(size: 36))
                            Text(c.word).font(.system(size: 16, weight: .bold)).foregroundColor(Color(hex: lesson.colorHex))
                            Text(c.example).font(.system(size: 11)).foregroundColor(.secondary).lineLimit(2).multilineTextAlignment(.center)
                            Text(c.pronunciation)
                                .font(.system(size: 10, weight: .medium)).foregroundColor(Color(hex: lesson.colorHex).opacity(0.7))
                                .padding(.horizontal, 8).padding(.vertical, 2)
                                .background(Color(hex: lesson.colorHex).opacity(0.1)).clipShape(Capsule())
                        }
                        .padding(12).frame(maxWidth: .infinity)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.separator).opacity(0.3), lineWidth: 0.5))
                    }.buttonStyle(.plain)
                }
            }.padding(20)
        }
    }
}

// MARK: - English Quiz

struct EnglishQuizView: View {
    let lesson: EnglishLesson
    @State private var questionIndex = 0
    @State private var choices: [LessonCard] = []
    @State private var selected: Int? = nil
    @State private var score = 0
    @State private var total = 0
    @State private var speechEngine = SpeechEngine()

    private var question: LessonCard { lesson.cards[questionIndex % lesson.cards.count] }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Score: \(score)/\(total)").font(.system(size: 14)).foregroundColor(.secondary)
                Spacer()
                Text("\(lesson.emoji) \(lesson.title)").font(.system(size: 13, weight: .semibold)).foregroundColor(Color(hex: lesson.colorHex))
            }.padding(.horizontal, 24)

            // Prompt
            VStack(spacing: 10) {
                Text(question.emoji).font(.system(size: 72))
                Text("What word matches this?")
                    .font(.system(size: 16, weight: .semibold)).foregroundColor(.secondary)
                Text(question.example)
                    .font(.system(size: 15)).foregroundColor(.primary).multilineTextAlignment(.center).padding(.horizontal, 16)
            }
            .padding(20).frame(maxWidth: .infinity)
            .background(Color(hex: lesson.colorHex).opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 24)

            // Choices
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                ForEach(Array(choices.enumerated()), id: \.offset) { i, c in
                    Button {
                        guard selected == nil else { return }
                        selected = i; total += 1
                        let correct = c.id == question.id
                        if correct { score += 1 }
                        speechEngine.speak(correct ? "Correct! \(c.word). \(c.example)" : "Good try. The answer is \(question.word). \(question.example)")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            questionIndex += 1; setupChoices(); selected = nil
                        }
                    } label: {
                        Text(c.word)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(selected == nil ? Color(hex: lesson.colorHex) :
                                            c.id == question.id ? .white :
                                            selected == i ? .white : .secondary)
                            .frame(maxWidth: .infinity).padding(.vertical, 16)
                            .background(selected == nil ? Color(hex: lesson.colorHex).opacity(0.1) :
                                        c.id == question.id ? Color(hex: "#1D9E75") :
                                        selected == i ? Color(hex: "#D85A30") : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }.buttonStyle(.plain)
                }
            }.padding(.horizontal, 24)

            Spacer()
        }
        .padding(.top, 16)
        .onAppear { setupChoices(); speechEngine.speak(question.example) }
    }

    private func setupChoices() {
        let correct = lesson.cards[questionIndex % lesson.cards.count]
        var pool = lesson.cards.filter { $0.id != correct.id }.shuffled().prefix(3)
        choices = (pool + [correct]).shuffled()
    }
}
