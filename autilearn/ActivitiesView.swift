import SwiftUI

// MARK: - Activities: Skating, Painting, Drawing, Swimming
// Step-by-step visual lessons with clear numbered instructions.

struct ActivityLesson: Identifiable {
    let id: Int
    let title: String
    let emoji: String
    let colorHex: String
    let category: ActivityCategory
    let tagline: String
    let safetyNote: String
    let equipment: [String]
    let steps: [ActivityStep]
    let tips: [String]
    let funFact: String
}

struct ActivityStep: Identifiable {
    let id: Int
    let title: String
    let instruction: String
    let icon: String          // SF Symbol
    let duration: String      // e.g. "Practice for 5 minutes"
}

enum ActivityCategory: String, CaseIterable, Identifiable {
    case skating  = "Skating"
    case painting = "Painting"
    case drawing  = "Drawing"
    case swimming = "Swimming"
    var id: String { rawValue }
    var colorHex: String {
        switch self { case .skating: return "#185FA5"; case .painting: return "#D4537E"; case .drawing: return "#534AB7"; case .swimming: return "#1D9E75" }
    }
    var icon: String {
        switch self { case .skating: return "figure.skating"; case .painting: return "paintbrush.fill"; case .drawing: return "pencil.tip"; case .swimming: return "figure.pool.swim" }
    }
    var emoji: String {
        switch self { case .skating: return "⛸️"; case .painting: return "🎨"; case .drawing: return "✏️"; case .swimming: return "🏊" }
    }
}

extension ActivityLesson {
    static let all: [ActivityLesson] = skating + painting + drawing + swimming

    // MARK: Skating
    static let skating: [ActivityLesson] = [
        ActivityLesson(id:1, title:"First Steps on Skates", emoji:"⛸️", colorHex:"#185FA5",
            category:.skating, tagline:"Learn to stand, balance and glide safely.",
            safetyNote:"Always wear a helmet, knee pads, and wrist guards before skating.",
            equipment:["Ice skates or roller skates","Helmet","Knee pads","Wrist guards","An adult nearby"],
            steps:[
                ActivityStep(id:1, title:"Put on your gear", instruction:"Put on your helmet first. Then knee pads, then wrist guards. Make sure they fit snugly — not too tight, not too loose.", icon:"shield.fill", duration:"Take 5 minutes"),
                ActivityStep(id:2, title:"Stand up slowly", instruction:"Hold a wall or railing with both hands. Slowly stand up. Keep your knees slightly bent — not straight. This is your 'ready position'.", icon:"figure.stand", duration:"Hold for 30 seconds"),
                ActivityStep(id:3, title:"March in place", instruction:"Still holding the wall, lift one foot then the other, like marching. Feel how the skate moves.", icon:"figure.walk", duration:"March for 1 minute"),
                ActivityStep(id:4, title:"The penguin walk", instruction:"Let go of the wall slowly. Take tiny steps sideways, like a penguin. Point your toes outward slightly.", icon:"figure.walk.motion", duration:"Walk 5 steps"),
                ActivityStep(id:5, title:"Your first glide", instruction:"Push one foot sideways gently and let the other foot glide forward. Arms out for balance. Smile — you're skating!", icon:"figure.skating", duration:"Try 3 glides"),
                ActivityStep(id:6, title:"How to stop safely", instruction:"Turn your toes inward slowly (like a pizza slice or snowplough). Feel the skates slow down. Never try to stop by grabbing something suddenly.", icon:"hand.raised.fill", duration:"Practise stopping 5 times"),
            ],
            tips:["Falling is part of learning — try to fall forward onto your knee pads", "Bend your knees more when you feel wobbly", "Look ahead, not down at your feet", "It is easier to skate slowly at first"],
            funFact:"Ice skating is over 4,000 years old. The earliest skates were made from animal bones!"
        ),
        ActivityLesson(id:2, title:"Roller Skating Basics", emoji:"🛼", colorHex:"#185FA5",
            category:.skating, tagline:"Roll smoothly on four wheels.",
            safetyNote:"Wear full protective gear. Skate on smooth, flat surfaces only at first.",
            equipment:["Roller skates","Helmet","Knee pads","Elbow pads","Wrist guards"],
            steps:[
                ActivityStep(id:1, title:"The T-stop stance", instruction:"Stand with feet shoulder-width apart. One foot forward, one foot at a right angle (T-shape). This is your most stable starting position.", icon:"figure.stand", duration:"Hold 20 seconds"),
                ActivityStep(id:2, title:"Stride and push", instruction:"Push one foot to the side while the other rolls forward. Think: push… glide… push… glide. Keep your arms out for balance.", icon:"figure.walk.motion", duration:"Try 6 pushes"),
                ActivityStep(id:3, title:"Turning gently", instruction:"Lean your body slightly in the direction you want to turn. Don't twist sharply — lean and your skates will follow.", icon:"arrow.uturn.right", duration:"Try 3 gentle turns"),
                ActivityStep(id:4, title:"Stopping with heel brake", instruction:"Most roller skates have a rubber stopper on the front toe. Push that stopper down gently while leaning back slightly.", icon:"hand.raised.fill", duration:"Practise 5 stops"),
            ],
            tips:["Smooth concrete or wooden floors are best for beginners","Wear socks that go above the skate boot","Ask someone to skate beside you when first starting"],
            funFact:"Roller skating was invented in 1760 by a Belgian man who tried to imitate ice skating at a party!"
        ),
    ]

    // MARK: Painting
    static let painting: [ActivityLesson] = [
        ActivityLesson(id:3, title:"Watercolour Basics", emoji:"🎨", colorHex:"#D4537E",
            category:.painting, tagline:"Create beautiful washes of colour with water and paint.",
            safetyNote:"Watercolour paints are safe and non-toxic. Protect your clothes with an apron.",
            equipment:["Watercolour paints (set of 12+)","Watercolour paper (thicker is better)","3 paintbrushes (thin, medium, thick)","Two jars of water","An old cloth or kitchen paper","Apron or old clothes"],
            steps:[
                ActivityStep(id:1, title:"Set up your space", instruction:"Put newspaper or a plastic sheet on the table. Fill two water jars — one for rinsing your brush, one for mixing clean water with paint.", icon:"square.and.pencil", duration:"5 minutes setup"),
                ActivityStep(id:2, title:"Wet your paper", instruction:"Use your thick brush dipped in clean water and paint big strokes across the paper. This is called 'wet on wet' — it makes colours spread beautifully.", icon:"drop.fill", duration:"Wet the whole paper"),
                ActivityStep(id:3, title:"Mix your first colour", instruction:"Dip your brush in water, then touch it gently to a paint colour. The amount of water changes how light or dark the colour looks. More water = lighter.", icon:"paintbrush.fill", duration:"Try 3 colours"),
                ActivityStep(id:4, title:"Paint your sky", instruction:"While the paper is still wet, sweep your wet brush with blue paint across the top third of the paper. Watch how it spreads softly — that's the magic of watercolour!", icon:"cloud.fill", duration:"Fill the sky"),
                ActivityStep(id:5, title:"Add the ground", instruction:"While the top dries slightly, paint the bottom third green or brown. Let the colours meet in the middle for a blended horizon.", icon:"leaf.fill", duration:"Add the ground"),
                ActivityStep(id:6, title:"Add details when dry", instruction:"Wait for the painting to dry completely. Then use a thin brush to add small details: a tree, a house, a bird. These are called 'wet on dry' marks and stay crisp.", icon:"pencil.tip", duration:"10 minutes for details"),
            ],
            tips:["Always rinse your brush between colours so they stay bright","If the colour is too dark, add more water","Let your painting dry flat so it doesn't buckle","Your first painting doesn't need to look perfect — enjoy the process!"],
            funFact:"Watercolour has been used by artists for over 500 years. Albrecht Dürer was one of the first masters of watercolour in the 1490s!"
        ),
        ActivityLesson(id:4, title:"Finger Painting", emoji:"🖐️", colorHex:"#D4537E",
            category:.painting, tagline:"Create art with your fingers — no brushes needed!",
            safetyNote:"Use non-toxic, washable finger paints. Cover the table with newspaper.",
            equipment:["Finger paints (washable)","Thick paper or cardboard","A tray or plate for paint","Wet wipes or a bowl of water","Apron or old clothes"],
            steps:[
                ActivityStep(id:1, title:"Squeeze paint onto tray", instruction:"Put small blobs of different colours on a tray or plate. Leave space between colours so they don't mix before you're ready.", icon:"square.and.pencil", duration:"Setup"),
                ActivityStep(id:2, title:"Try different fingers", instruction:"Dip your index finger in a colour and press it onto the paper. Try your thumb — it makes a different shape. Try your whole palm!", icon:"hand.point.up.fill", duration:"Explore for 3 minutes"),
                ActivityStep(id:3, title:"Make patterns", instruction:"Press fingerprints in a line to make a caterpillar. Use your thumb to make the sun. Use your pinky for tiny dots.", icon:"circle.grid.3x3.fill", duration:"Make 3 patterns"),
                ActivityStep(id:4, title:"Blend colours", instruction:"Put two different colours side by side on the paper, then drag your finger through both to blend them.", icon:"paintbrush.fill", duration:"Try blending"),
                ActivityStep(id:5, title:"Add a background", instruction:"Use your whole flat hand to spread a light colour across the paper as your background. Then add details with individual fingers.", icon:"rectangle.fill", duration:"Paint the background"),
            ],
            tips:["Darker colours go on top of lighter ones","Keep a wet wipe nearby to clean fingers between colours","Try making animals: a thumbprint elephant, a fingerprint fish","It is okay to get messy — that's part of the fun!"],
            funFact:"Cave painters 40,000 years ago used their fingers and hands to create art on cave walls. You are carrying on an ancient tradition!"
        ),
    ]

    // MARK: Drawing
    static let drawing: [ActivityLesson] = [
        ActivityLesson(id:5, title:"Drawing with Shapes", emoji:"✏️", colorHex:"#534AB7",
            category:.drawing, tagline:"Everything can be drawn using circles, squares and triangles.",
            safetyNote:"Use pencils and crayons safely. Sharpen pencils with adult help.",
            equipment:["Pencil","Eraser","Ruler","Crayons or coloured pencils","Plain white paper"],
            steps:[
                ActivityStep(id:1, title:"The magic three shapes", instruction:"Draw a circle, a square, and a triangle on your paper. Study them. Almost every object in the world can be built from these three shapes.", icon:"triangle.fill", duration:"2 minutes"),
                ActivityStep(id:2, title:"Draw a house", instruction:"Draw a square for the walls. Add a triangle on top for the roof. Add a small rectangle in the square for a door. A small square for a window. You drew a house!", icon:"house.fill", duration:"5 minutes"),
                ActivityStep(id:3, title:"Draw a person", instruction:"Circle for the head. Rectangle for the body. Two long rectangles for legs. Two smaller rectangles for arms. A stick figure uses the same shapes — just thinner!", icon:"figure.stand", duration:"5 minutes"),
                ActivityStep(id:4, title:"Draw a cat face", instruction:"Large circle for the face. Two small triangles on top for ears. Two ovals for eyes. A small triangle for a nose. Curved lines for a mouth and whiskers.", icon:"cat.fill", duration:"5 minutes"),
                ActivityStep(id:5, title:"Draw a tree", instruction:"Draw a thick rectangle for the trunk. Add a big fluffy cloud shape on top for the leaves. Add small circles inside the leaves for apples or oranges if you like.", icon:"tree.fill", duration:"5 minutes"),
                ActivityStep(id:6, title:"Colour your drawing", instruction:"Choose 3–4 colours. Colour slowly in the same direction to fill without gaps. Press lightly for a soft look, press hard for a bright strong colour.", icon:"paintbrush.fill", duration:"10 minutes"),
            ],
            tips:["Use light pencil lines first so you can erase mistakes","Draw what you see, not what you think it should look like","There is no wrong way to draw — your style is unique","Practice a little every day and you will improve quickly"],
            funFact:"Leonardo da Vinci filled over 13,000 pages of notebooks with drawings. He said drawing was his way of thinking."
        ),
        ActivityLesson(id:6, title:"Drawing Faces & Expressions", emoji:"😊", colorHex:"#534AB7",
            category:.drawing, tagline:"Learn to draw human faces showing different feelings.",
            safetyNote:"Great for practising recognising emotions too!",
            equipment:["Pencil and eraser","Blank paper","Mirror (optional — to look at your own face for reference)","Coloured pencils"],
            steps:[
                ActivityStep(id:1, title:"Draw the head shape", instruction:"Draw a large oval for the head. Not a perfect circle — slightly wider at the top and narrower at the chin.", icon:"circle.fill", duration:"2 minutes"),
                ActivityStep(id:2, title:"Add the cross guide lines", instruction:"Draw a light horizontal line halfway down the oval — eyes go here. Draw a light vertical line down the middle for symmetry. Erase these later.", icon:"plus", duration:"1 minute"),
                ActivityStep(id:3, title:"Place the eyes", instruction:"On the horizontal line, draw two almond shapes. Leave a gap of one eye-width between them. Add a circle inside each for the iris.", icon:"eye.fill", duration:"3 minutes"),
                ActivityStep(id:4, title:"Add nose and mouth", instruction:"The nose sits halfway between eyes and chin. Draw a small curve or two small dots. The mouth is halfway between nose and chin — a curved line for a smile.", icon:"face.smiling", duration:"3 minutes"),
                ActivityStep(id:5, title:"Draw eyebrows", instruction:"Eyebrows show feelings! Flat = calm. Raised = surprised. Slanted down toward nose = angry. Slanted up = sad. Try all four.", icon:"eyebrow", duration:"3 minutes"),
                ActivityStep(id:6, title:"Add ears and hair", instruction:"Ears sit between the eye line and nose line on each side. Hair can be any shape — curly, straight, short, long. Make it your own!", icon:"figure.child", duration:"5 minutes"),
            ],
            tips:["Look in a mirror and notice how YOUR face changes for each feeling","Eyes and eyebrows carry the most emotion in a face","Everyone's face is different — there is no one right way to draw a face","Start with pencil so you can make changes easily"],
            funFact:"Scientists say humans can recognise up to 10,000 different facial expressions. Drawing faces helps your brain get better at reading them too!"
        ),
    ]

    // MARK: Swimming
    static let swimming: [ActivityLesson] = [
        ActivityLesson(id:7, title:"Water Safety First", emoji:"🏊", colorHex:"#1D9E75",
            category:.swimming, tagline:"Learn the rules that keep you safe in water.",
            safetyNote:"Always swim with an adult present. Never swim alone.",
            equipment:["Swimsuit","Towel","Swimming goggles","Swim cap (optional)","Sunscreen if outdoors"],
            steps:[
                ActivityStep(id:1, title:"The golden rules", instruction:"1. Never swim alone. 2. Always tell an adult where you are. 3. Get in slowly — never push people in. 4. Walk (do not run) at the pool.", icon:"checkmark.shield.fill", duration:"Learn and remember"),
                ActivityStep(id:2, title:"Getting used to water", instruction:"Sit on the pool steps. Splash water on your arms and face gently. Let your body feel the temperature. Breathe slowly.", icon:"drop.fill", duration:"5 minutes"),
                ActivityStep(id:3, title:"Blowing bubbles", instruction:"Hold the pool edge with both hands. Take a breath, put your face in the water, and blow bubbles out of your mouth. Try for 3 counts before coming up.", icon:"bubbles.and.sparkles.fill", duration:"Practise 5 times"),
                ActivityStep(id:4, title:"Floating on your back", instruction:"With an adult holding your head, slowly lean back. Spread your arms out, let your ears go in the water. Breathe slowly. Feel the water holding you.", icon:"figure.water.fitness", duration:"Hold for 10 seconds"),
                ActivityStep(id:5, title:"Kicking your legs", instruction:"Hold the pool edge or a float board with both hands. Kick your legs up and down alternately. Keep your legs straight-ish, like scissors. Kick from your hips, not your knees.", icon:"figure.pool.swim", duration:"Kick for 30 seconds"),
            ],
            tips:["Goggles help you open your eyes underwater which builds confidence","Start in the shallow end where you can touch the floor","Tell the teacher if water gets in your ears or nose","Drinking water accidentally is normal — just spit it out calmly"],
            funFact:"Swimming uses almost every muscle in your body at the same time, making it one of the best exercises possible!"
        ),
        ActivityLesson(id:8, title:"Learning Freestyle", emoji:"🏅", colorHex:"#1D9E75",
            category:.swimming, tagline:"The basic forward swimming stroke step by step.",
            safetyNote:"Learn this with a qualified swim teacher in a supervised pool.",
            equipment:["Swimsuit","Goggles","Swim float (kickboard)","Pool with lanes"],
            steps:[
                ActivityStep(id:1, title:"Body position", instruction:"Face the water. Stretch your body long and flat. Imagine being a pencil — straight from head to toes. This streamlined position makes you move faster.", icon:"figure.pool.swim", duration:"Practise on land"),
                ActivityStep(id:2, title:"Arm movement", instruction:"One arm reaches forward and enters the water, then pulls back like you're pulling the water behind you. Then the other arm does the same. It's like climbing a ladder underwater.", icon:"figure.arms.open", duration:"Practise arm movement standing"),
                ActivityStep(id:3, title:"Leg kick", instruction:"Kick from your hips with legs fairly straight. Fast small kicks are more efficient than big slow ones. Your feet should make the water 'frothy' on the surface.", icon:"figure.walk", duration:"Kick with a board for 1 length"),
                ActivityStep(id:4, title:"Breathing", instruction:"When one arm is pulling back, turn your head to that side to breathe. Open your mouth, breathe in quickly, then turn your face back in. Breathe out slowly underwater.", icon:"wind", duration:"Practise with teacher"),
                ActivityStep(id:5, title:"Put it all together", instruction:"Arms pulling, legs kicking, head turning to breathe every 3 strokes. It takes time to coordinate — be patient with yourself. Every swimmer felt like this at first!", icon:"figure.pool.swim", duration:"Try one full length"),
            ],
            tips:["Count your strokes to help you focus","Look down at the bottom of the pool, not ahead — this keeps your body flat","Relax your hands — cupped slightly, not tight fists","Rest when you need to — it's a workout!"],
            funFact:"Olympic swimmers can reach speeds of 9 km/h. The cheetah of the water world is the sailfish, which swims at 110 km/h!"
        ),
    ]
}

// MARK: - Activities Home View

struct ActivitiesHomeView: View {
    @State private var selectedCat: ActivityCategory? = nil
    @State private var selectedLesson: ActivityLesson? = nil

    private var filtered: [ActivityLesson] {
        guard let cat = selectedCat else { return ActivityLesson.all }
        return ActivityLesson.all.filter { $0.category == cat }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Activities")
                            .font(.system(size: 20, weight: .medium))
                        Text("Skating, painting, drawing and swimming")
                            .font(.system(size: 14)).foregroundColor(.secondary)
                    }
                    Spacer()
                    Text("🏅").font(.system(size: 36))
                }
                .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 14)

                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        catChip(nil, label: "All", emoji: "🌟", color: "#888888")
                        ForEach(ActivityCategory.allCases) { cat in
                            catChip(cat, label: cat.rawValue, emoji: cat.emoji, color: cat.colorHex)
                        }
                    }.padding(.horizontal, 20)
                }.padding(.bottom, 16)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 170, maximum: 240), spacing: 14)], spacing: 14) {
                    ForEach(filtered) { lesson in
                        ActivityCard(lesson: lesson) { selectedLesson = lesson }
                    }
                }.padding(.horizontal, 20).padding(.bottom, 30)
            }
        }
        .navigationTitle("Activities")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedLesson) { lesson in
            ActivityDetailSheet(lesson: lesson)
        }
    }

    private func catChip(_ cat: ActivityCategory?, label: String, emoji: String, color: String) -> some View {
        Button { withAnimation { selectedCat = cat } } label: {
            HStack(spacing: 6) {
                Text(emoji).font(.system(size: 15))
                Text(label).font(.system(size: 13, weight: selectedCat == cat ? .semibold : .regular))
                    .foregroundColor(selectedCat == cat ? .white : Color(hex: color))
            }
            .padding(.horizontal, 14).padding(.vertical, 8)
            .background(selectedCat == cat ? Color(hex: color) : Color(hex: color).opacity(0.1))
            .clipShape(Capsule())
        }.buttonStyle(.plain)
    }
}

struct ActivityCard: View {
    let lesson: ActivityLesson
    let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 12).fill(Color(hex: lesson.colorHex).opacity(0.12)).frame(height: 80)
                    Text(lesson.emoji).font(.system(size: 40)).padding(8)
                }
                Text(lesson.title).font(.system(size: 14, weight: .semibold)).foregroundColor(.primary).lineLimit(2)
                Text(lesson.tagline).font(.system(size: 11)).foregroundColor(.secondary).lineLimit(2)
                HStack(spacing: 6) {
                    Text(lesson.category.rawValue)
                        .font(.system(size: 10, weight: .medium)).foregroundColor(Color(hex: lesson.colorHex))
                        .padding(.horizontal, 8).padding(.vertical, 3).background(Color(hex: lesson.colorHex).opacity(0.1)).clipShape(Capsule())
                    Spacer()
                    Text("\(lesson.steps.count) steps")
                        .font(.system(size: 10)).foregroundColor(.secondary)
                }
            }
            .padding(14).frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.separator).opacity(0.3), lineWidth: 0.5))
        }.buttonStyle(.plain)
    }
}

// MARK: - Activity detail sheet

struct ActivityDetailSheet: View {
    let lesson: ActivityLesson
    @Environment(\.dismiss) private var dismiss
    @State private var speechEngine = SpeechEngine()
    @State private var completedSteps: Set<Int> = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Hero
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16).fill(Color(hex: lesson.colorHex).opacity(0.15)).frame(width: 80, height: 80)
                            Text(lesson.emoji).font(.system(size: 44))
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(lesson.category.rawValue)
                                .font(.system(size: 11, weight: .medium)).foregroundColor(Color(hex: lesson.colorHex))
                                .padding(.horizontal, 8).padding(.vertical, 2).background(Color(hex: lesson.colorHex).opacity(0.1)).clipShape(Capsule())
                            Text(lesson.tagline).font(.system(size: 14)).foregroundColor(.secondary).fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    // Safety
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.shield.fill").font(.system(size: 18)).foregroundColor(Color(hex: "#1D9E75"))
                        Text(lesson.safetyNote).font(.system(size: 13)).foregroundColor(.primary).fixedSize(horizontal: false, vertical: true)
                    }.padding(12).background(Color(hex: "#1D9E75").opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 12))

                    // Equipment
                    VStack(alignment: .leading, spacing: 8) {
                        Label("What you need", systemImage: "bag.fill").font(.system(size: 14, weight: .semibold))
                        FlowLayout(items: lesson.equipment) { item in
                            Text(item).font(.system(size: 12)).padding(.horizontal, 12).padding(.vertical, 6)
                                .background(Color(.secondarySystemBackground)).clipShape(Capsule())
                                .overlay(Capsule().stroke(Color(.separator).opacity(0.4), lineWidth: 0.5))
                        }
                    }

                    // Steps
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Steps", systemImage: "list.number").font(.system(size: 14, weight: .semibold))
                        ForEach(lesson.steps) { step in
                            ActivityStepRow(step: step, color: lesson.colorHex,
                                isCompleted: completedSteps.contains(step.id)) {
                                if completedSteps.contains(step.id) { completedSteps.remove(step.id) }
                                else { completedSteps.insert(step.id); speechEngine.speak(step.instruction) }
                            }
                        }
                    }

                    // Tips
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Tips", systemImage: "lightbulb.fill").font(.system(size: 14, weight: .semibold)).foregroundColor(Color(hex: "#BA7517"))
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(Array(lesson.tips.enumerated()), id: \.offset) { _, tip in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("•").foregroundColor(Color(hex: "#BA7517"))
                                    Text(tip).font(.system(size: 13)).foregroundColor(.primary).fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }.padding(12).background(Color(hex: "#BA7517").opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    // Fun fact
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Fun fact!", systemImage: "star.fill").font(.system(size: 14, weight: .semibold)).foregroundColor(Color(hex: "#534AB7"))
                        Text(lesson.funFact).font(.system(size: 13)).foregroundColor(.primary).fixedSize(horizontal: false, vertical: true)
                    }.padding(12).background(Color(hex: "#534AB7").opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 12))

                    Spacer(minLength: 20)
                }
                .padding(20)
            }
            .navigationTitle(lesson.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Close") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { speechEngine.speak(lesson.steps.first?.instruction ?? "") } label: {
                        Image(systemName: "speaker.wave.2")
                    }
                }
            }
        }
    }
}

struct ActivityStepRow: View {
    let step: ActivityStep
    let color: String
    let isCompleted: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle().fill(isCompleted ? Color(hex: "#1D9E75") : Color(hex: color).opacity(0.15)).frame(width: 36, height: 36)
                    if isCompleted {
                        Image(systemName: "checkmark").font(.system(size: 14, weight: .bold)).foregroundColor(.white)
                    } else {
                        Text("\(step.id)").font(.system(size: 13, weight: .bold)).foregroundColor(Color(hex: color))
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(step.title).font(.system(size: 14, weight: .semibold)).foregroundColor(.primary)
                    Text(step.instruction).font(.system(size: 13)).foregroundColor(.secondary).fixedSize(horizontal: false, vertical: true)
                    HStack(spacing: 4) {
                        Image(systemName: "clock").font(.system(size: 10)).foregroundColor(Color(hex: color).opacity(0.7))
                        Text(step.duration).font(.system(size: 11)).foregroundColor(Color(hex: color).opacity(0.7))
                    }
                }
                Spacer()
                Image(systemName: "speaker.wave.1").font(.system(size: 12)).foregroundColor(Color(hex: color).opacity(0.5))
            }
            .padding(12)
            .background(isCompleted ? Color(hex: "#1D9E75").opacity(0.07) : Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(
                isCompleted ? Color(hex: "#1D9E75").opacity(0.3) : Color(.separator).opacity(0.3), lineWidth: 0.5))
        }.buttonStyle(.plain)
    }
}
