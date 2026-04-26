import Foundation
import SwiftUI

// MARK: - Science experiment model

struct ScienceExperiment: Identifiable {
    let id: Int
    let emoji: String
    let colorHex: String
    let title: String
    let tagline: String
    let scienceTag: String
    let tagColorHex: String
    let whyItWorks: String
    let safetyNote: String
    let materials: [String]
    let steps: [String]
    let funFact: String
}

extension ScienceExperiment {
    static let all: [ScienceExperiment] = [

        ScienceExperiment(
            id: 1,
            emoji: "🌋",
            colorHex: "#FAECE7",
            title: "Baking Soda Volcano",
            tagline: "Make a fizzing eruption in your kitchen!",
            scienceTag: "Chemistry",
            tagColorHex: "#D85A30",
            whyItWorks: "Baking soda is a base and vinegar is an acid. When they mix, a chemical reaction makes lots of carbon dioxide gas bubbles — just like a real volcano!",
            safetyNote: "No heat, no sharp tools — totally safe. Do it on a tray to catch the mess!",
            materials: ["Baking soda (3 tablespoons)", "White vinegar (half a cup)", "A bowl or cup", "Red food colouring", "Dish soap (a few drops)", "A tray"],
            steps: [
                "Put the bowl on the tray so spills are easy to clean.",
                "Add 3 big spoons of baking soda to the bowl.",
                "Add a few drops of red food colouring and a drop of dish soap.",
                "Ask a grown-up to slowly pour the vinegar in.",
                "Watch the fizzing eruption! 🌋"
            ],
            funFact: "Real volcanoes erupt because of hot melted rock (magma) moving up, but the fizzing you see is the same idea — gas pushing liquid out!"
        ),

        ScienceExperiment(
            id: 2,
            emoji: "🌈",
            colorHex: "#EEEDFE",
            title: "Walking Rainbow Water",
            tagline: "Watch colours travel between glasses like magic!",
            scienceTag: "Physics",
            tagColorHex: "#534AB7",
            whyItWorks: "Water moves up paper towels by something called capillary action — the same way plants drink water through their roots and stems.",
            safetyNote: "Just water and paper — completely safe for all ages!",
            materials: ["7 glasses or cups", "Water", "Red, yellow, and blue food colouring", "Paper towels (6 strips)"],
            steps: [
                "Line up 7 glasses in a row.",
                "Fill glasses 1, 3, 5, 7 halfway with water.",
                "Add red dye to glass 1, yellow to glass 3, blue to glass 5.",
                "Fold each paper towel lengthways and drape between each glass.",
                "Wait about 1 hour and watch the colours walk! 🌈"
            ],
            funFact: "Trees use capillary action to pull water from the ground all the way up to their leaves — sometimes over 100 metres tall!"
        ),

        ScienceExperiment(
            id: 3,
            emoji: "🧲",
            colorHex: "#E1F5EE",
            title: "Make a Compass",
            tagline: "Find North using a needle and a magnet!",
            scienceTag: "Magnetism",
            tagColorHex: "#1D9E75",
            whyItWorks: "The Earth is a giant magnet with a North and South pole. When you magnetise a needle by stroking it with a magnet, it lines up with Earth's magnetic field.",
            safetyNote: "Use a blunt needle or a sewing needle handled by an adult.",
            materials: ["A needle or pin", "A fridge magnet", "A bowl of water", "A small piece of foam, cork, or leaf", "A real compass (to check)"],
            steps: [
                "Stroke the needle 30–40 times in ONE direction with the magnet.",
                "Always lift the magnet away before each new stroke — don't rub back and forth.",
                "Place the foam or leaf flat on the water surface.",
                "Carefully lay the needle on the foam.",
                "Watch it slowly turn to point North-South! Check with a real compass."
            ],
            funFact: "Birds, bees, and sea turtles have tiny magnetic crystals inside them that work like a built-in compass. They never get lost!"
        ),

        ScienceExperiment(
            id: 4,
            emoji: "🥚",
            colorHex: "#FAEEDA",
            title: "Bouncy Rubber Egg",
            tagline: "Turn an egg rubbery by removing its shell!",
            scienceTag: "Chemistry",
            tagColorHex: "#BA7517",
            whyItWorks: "Eggshells are made of calcium carbonate — the same stuff as chalk. Vinegar (acetic acid) slowly dissolves it, leaving only the stretchy membrane inside.",
            safetyNote: "Takes 2–3 days. Handle gently — it will break if dropped from too high!",
            materials: ["1 raw egg", "White vinegar (enough to cover the egg)", "A tall glass or jar", "2–3 days of patience 😄"],
            steps: [
                "Carefully lower the egg into the glass.",
                "Pour in white vinegar until the egg is fully covered.",
                "Watch the bubbles form on the shell — that's the chemical reaction!",
                "Change the vinegar after 24 hours.",
                "After 2–3 days, rinse gently under water.",
                "Gently squeeze it — it's bouncy! Drop it from 1 cm to test. 🥚"
            ],
            funFact: "Bones are also made of calcium carbonate. That's why drinking vinegar is bad for teeth — it slowly dissolves enamel, which is similar!"
        ),

        ScienceExperiment(
            id: 5,
            emoji: "🌱",
            colorHex: "#EAF3DE",
            title: "Seed in a Bag",
            tagline: "Watch roots and shoots grow day by day!",
            scienceTag: "Biology",
            tagColorHex: "#3B6D11",
            whyItWorks: "Seeds contain food and a baby plant. They need water and warmth to germinate (sprout). Growing in a clear bag lets you see every part of the process!",
            safetyNote: "Completely safe. Bean seeds are the easiest to sprout.",
            materials: ["Zip-lock sandwich bag", "Paper towel", "Bean or sunflower seeds (2–3)", "Water", "Sticky tape", "A sunny window"],
            steps: [
                "Wet the paper towel — damp but not dripping.",
                "Place the seeds on one half of the paper towel, then fold it over.",
                "Slide it into the zip-lock bag and seal it.",
                "Tape it to a sunny window with the seeds showing.",
                "Watch roots appear in 2–3 days, then shoots in 5–7 days! 🌱",
                "Once a shoot appears, plant it in soil to keep growing."
            ],
            funFact: "Roots always grow DOWN (toward gravity) and shoots always grow UP (toward light). Scientists call this gravitropism and phototropism!"
        ),

        ScienceExperiment(
            id: 6,
            emoji: "💡",
            colorHex: "#E6F1FB",
            title: "Lemon Battery",
            tagline: "Make electricity from a lemon!",
            scienceTag: "Electricity",
            tagColorHex: "#185FA5",
            whyItWorks: "The lemon juice is an acidic electrolyte. The copper and zinc react differently with the acid, creating a difference in electric charge — that pushes electrons (electricity!) from one metal to the other.",
            safetyNote: "Use a small LED — it uses very little electricity. Never use mains power. Adult supervision needed for inserting metals.",
            materials: ["A fresh lemon", "A copper coin or copper wire", "A galvanised (zinc-coated) nail", "LED (any colour)", "2 short wires with crocodile clips"],
            steps: [
                "Roll the lemon firmly on a table to get the juice moving inside.",
                "Push the copper coin into one side of the lemon.",
                "Push the zinc nail into the other side — keep them apart, not touching.",
                "Clip one wire to the coin and the other to the nail.",
                "Connect the other ends to the LED's two legs.",
                "The LED should glow faintly! Try 2 lemons in a row for brighter light. 💡"
            ],
            funFact: "The first batteries ever made in 1800 by Alessandro Volta used copper and zinc discs soaked in salty water — basically the same idea as your lemon!"
        ),

        ScienceExperiment(
            id: 7,
            emoji: "🌀",
            colorHex: "#FBEAF0",
            title: "Tornado in a Bottle",
            tagline: "Make a real spinning water tornado!",
            scienceTag: "Physics",
            tagColorHex: "#D4537E",
            whyItWorks: "When water spins in a circle, it creates a vortex — the spinning water is pushed to the outside by centripetal force, leaving a hollow air tunnel in the middle.",
            safetyNote: "Just water — safe and easy to clean up!",
            materials: ["2 plastic bottles (same size)", "Water", "A tornado tube connector (or waterproof tape)", "Optional: glitter or blue food colouring"],
            steps: [
                "Fill one bottle about 2/3 full of water.",
                "Add a few drops of blue food colouring and some glitter for fun.",
                "Connect the two bottles at their openings with the connector or tape.",
                "Make sure it's sealed tightly — flip upside down over a sink to test.",
                "Quickly swirl the top bottle in a circular motion.",
                "Hold it upright and watch the tornado form! 🌀"
            ],
            funFact: "Real tornadoes work the same way — warm air spins around cold air to create a massive vortex. The strongest tornadoes spin faster than 480 km/h!"
        ),

        ScienceExperiment(
            id: 8,
            emoji: "🧊",
            colorHex: "#E6F1FB",
            title: "Instant Ice Cream",
            tagline: "Make ice cream using salt and ice!",
            scienceTag: "Chemistry",
            tagColorHex: "#185FA5",
            whyItWorks: "Salt lowers the freezing point of ice, making it colder than 0°C without a freezer. This cold is enough to freeze cream into ice cream!",
            safetyNote: "Salt is safe, but don't eat the salty outer mixture — only eat the ice cream inside!",
            materials: ["100ml double cream or full-fat milk", "1 tablespoon sugar", "½ teaspoon vanilla extract", "Ice (lots!)", "6 tablespoons rock salt or table salt", "1 small zip-lock bag", "1 large zip-lock bag"],
            steps: [
                "Put the cream, sugar, and vanilla into the small zip-lock bag. Seal tightly.",
                "Fill the large bag halfway with ice cubes.",
                "Add salt to the ice in the large bag.",
                "Put the sealed small bag inside the large bag.",
                "Seal the large bag and shake and squeeze for 5–10 minutes.",
                "Open the small bag — your ice cream is ready! 🍦"
            ],
            funFact: "Before electric freezers were invented (around 1900), ice cream was made exactly this way. People would harvest ice from frozen lakes in winter to use all summer!"
        ),
    ]
}
