import SwiftUI
import WebKit

// MARK: - Social Stories (Video-first)

struct SocialStory: Identifiable {
    let id: Int
    let title: String
    let emoji: String
    let colorHex: String
    let category: String
    let youtubeID: String          // Primary: YouTube video
    let teluguYoutubeID: String    // Telugu version
    let pages: [StoryPage]         // Kept as fallback / summary
}

struct StoryPage: Identifiable {
    let id: Int
    let text: String
    let imageSF: String
    let bgColorHex: String
}

extension SocialStory {
    static let all: [SocialStory] = [
        SocialStory(id: 1, title: "Going to School", emoji: "🏫", colorHex: "#185FA5", category: "School",
            youtubeID: "X0ZrJHmHFnA",    // Visual schedules / going to school
            teluguYoutubeID: "v7fmJ5VlRrA",
            pages: [
                StoryPage(id:1, text:"Every morning I wake up and get ready for school.", imageSF:"sunrise.fill", bgColorHex:"#FAEEDA"),
                StoryPage(id:2, text:"I put on my clothes and eat breakfast.", imageSF:"fork.knife", bgColorHex:"#E1F5EE"),
                StoryPage(id:3, text:"I pack my school bag with my books and pencil case.", imageSF:"bag.fill", bgColorHex:"#EEEDFE"),
                StoryPage(id:4, text:"When I arrive at school, I say \"Good morning\" to my teacher.", imageSF:"hand.wave.fill", bgColorHex:"#E6F1FB"),
                StoryPage(id:5, text:"I sit in my seat and wait quietly for the lesson to start.", imageSF:"chair.fill", bgColorHex:"#EAF3DE"),
                StoryPage(id:6, text:"I try my best and that is always enough. 🌟", imageSF:"star.fill", bgColorHex:"#FAEEDA"),
            ]),

        SocialStory(id: 2, title: "Making a New Friend", emoji: "🤝", colorHex: "#1D9E75", category: "Friends",
            youtubeID: "Ud9i4-LHxlQ",    // How to be a good friend
            teluguYoutubeID: "uKVmQcuDMbU",
            pages: [
                StoryPage(id:1, text:"Sometimes there are people I haven't met yet.", imageSF:"person.2.fill", bgColorHex:"#E1F5EE"),
                StoryPage(id:2, text:"To make a friend, I can walk up and say \"Hi, my name is...\"", imageSF:"bubble.left.fill", bgColorHex:"#EEEDFE"),
                StoryPage(id:3, text:"I can ask them what they like doing.", imageSF:"questionmark.circle.fill", bgColorHex:"#E6F1FB"),
                StoryPage(id:4, text:"I listen carefully when they are speaking.", imageSF:"ear.fill", bgColorHex:"#EAF3DE"),
                StoryPage(id:5, text:"If they want to play, we can take turns and share.", imageSF:"gamecontroller.fill", bgColorHex:"#FAEEDA"),
                StoryPage(id:6, text:"Being a friend means being kind. I can do that!", imageSF:"heart.fill", bgColorHex:"#FAECE7"),
            ]),

        SocialStory(id: 3, title: "When I Feel Angry", emoji: "😠", colorHex: "#D85A30", category: "Feelings",
            youtubeID: "7bxwnXjhXHI",    // Understanding meltdowns
            teluguYoutubeID: "hR8AoJH_2rI",
            pages: [
                StoryPage(id:1, text:"Sometimes things don't go the way I want and I feel angry.", imageSF:"bolt.fill", bgColorHex:"#FAECE7"),
                StoryPage(id:2, text:"Feeling angry is okay. Everyone feels angry sometimes.", imageSF:"checkmark.circle.fill", bgColorHex:"#E1F5EE"),
                StoryPage(id:3, text:"When I feel angry I can take 5 deep slow breaths.", imageSF:"wind", bgColorHex:"#E6F1FB"),
                StoryPage(id:4, text:"I can squeeze a stress ball or hug a pillow tight.", imageSF:"hand.raised.fill", bgColorHex:"#EEEDFE"),
                StoryPage(id:5, text:"I can tell a trusted adult: \"I feel angry because...\"", imageSF:"person.fill", bgColorHex:"#EAF3DE"),
                StoryPage(id:6, text:"After I calm down I feel much better. I am in control. 💪", imageSF:"figure.stand", bgColorHex:"#FAEEDA"),
            ]),

        SocialStory(id: 4, title: "Going to the Doctor", emoji: "🏥", colorHex: "#534AB7", category: "Health",
            youtubeID: "TvUQIKIqKZ0",    // Transitions / new situations
            teluguYoutubeID: "8bKhxP08RFk",
            pages: [
                StoryPage(id:1, text:"Sometimes I need to visit the doctor to make sure I am healthy.", imageSF:"stethoscope", bgColorHex:"#EEEDFE"),
                StoryPage(id:2, text:"The waiting room might have chairs and magazines.", imageSF:"sofa.fill", bgColorHex:"#E6F1FB"),
                StoryPage(id:3, text:"The doctor is a friendly helper. They want me to feel well.", imageSF:"heart.fill", bgColorHex:"#E1F5EE"),
                StoryPage(id:4, text:"The doctor might listen to my heart. It doesn't usually hurt.", imageSF:"ear.badge.checkmark", bgColorHex:"#EEEDFE"),
                StoryPage(id:5, text:"I can tell the doctor if something hurts or feels wrong.", imageSF:"bubble.left.fill", bgColorHex:"#EAF3DE"),
                StoryPage(id:6, text:"After the visit, I feel proud for being so brave. 🌟", imageSF:"star.fill", bgColorHex:"#FAEEDA"),
            ]),

        SocialStory(id: 5, title: "Waiting My Turn", emoji: "⏳", colorHex: "#BA7517", category: "Skills",
            youtubeID: "RMbkfMDgVEE",    // Sharing and taking turns
            teluguYoutubeID: "tJMsyBH_Mvk",
            pages: [
                StoryPage(id:1, text:"Sometimes I have to wait for my turn. This can feel hard.", imageSF:"hourglass", bgColorHex:"#FAEEDA"),
                StoryPage(id:2, text:"When I am in a queue, I stand behind the person in front of me.", imageSF:"person.3.fill", bgColorHex:"#E1F5EE"),
                StoryPage(id:3, text:"While I wait, I can count slowly or think of a happy memory.", imageSF:"brain.head.profile", bgColorHex:"#EEEDFE"),
                StoryPage(id:4, text:"Waiting is something everyone has to do. I am not forgotten.", imageSF:"checkmark.circle.fill", bgColorHex:"#E6F1FB"),
                StoryPage(id:5, text:"Soon it will be my turn and it will feel great!", imageSF:"hand.thumbsup.fill", bgColorHex:"#EAF3DE"),
                StoryPage(id:6, text:"I am patient and that is a superpower. ⭐️", imageSF:"star.fill", bgColorHex:"#FAEEDA"),
            ]),

        SocialStory(id: 6, title: "When Plans Change", emoji: "🔄", colorHex: "#D4537E", category: "Feelings",
            youtubeID: "TvUQIKIqKZ0",
            teluguYoutubeID: "E2X8urRLHLk",
            pages: [
                StoryPage(id:1, text:"Sometimes the plan changes and things don't happen the way I expected.", imageSF:"calendar.badge.exclamationmark", bgColorHex:"#FBEAF0"),
                StoryPage(id:2, text:"It's okay to feel upset or worried when this happens.", imageSF:"heart.fill", bgColorHex:"#E1F5EE"),
                StoryPage(id:3, text:"I can take a breath and ask: \"What is happening now?\"", imageSF:"wind", bgColorHex:"#E6F1FB"),
                StoryPage(id:4, text:"Usually the new plan is also okay. I might even enjoy it!", imageSF:"checkmark.circle.fill", bgColorHex:"#EAF3DE"),
                StoryPage(id:5, text:"I can handle surprises. I am flexible and strong.", imageSF:"figure.walk", bgColorHex:"#EEEDFE"),
                StoryPage(id:6, text:"After a change, things are usually alright in the end. 🌈", imageSF:"sun.max.fill", bgColorHex:"#FAEEDA"),
            ]),

        SocialStory(id: 7, title: "Asking for Help", emoji: "🙋", colorHex: "#5DCAA5", category: "Skills",
            youtubeID: "gHHGovFD2R0",    // Asking for help
            teluguYoutubeID: "wPD4fREjEiU",
            pages: [
                StoryPage(id:1, text:"Everyone needs help sometimes. That includes me and my friends.", imageSF:"person.2.fill", bgColorHex:"#E1F5EE"),
                StoryPage(id:2, text:"If something is too hard, I can raise my hand or walk up to a teacher.", imageSF:"hand.raised.fill", bgColorHex:"#EEEDFE"),
                StoryPage(id:3, text:"I can say: \"Excuse me, I need some help please.\"", imageSF:"bubble.left.fill", bgColorHex:"#E6F1FB"),
                StoryPage(id:4, text:"Asking for help is a brave and clever thing to do.", imageSF:"star.fill", bgColorHex:"#EAF3DE"),
                StoryPage(id:5, text:"The helper will listen and try to make things easier for me.", imageSF:"person.fill.checkmark", bgColorHex:"#FAEEDA"),
                StoryPage(id:6, text:"I am not a bother. My needs are important. 💛", imageSF:"heart.fill", bgColorHex:"#FAECE7"),
            ]),

        SocialStory(id: 8, title: "Playing at the Playground", emoji: "🛝", colorHex: "#3B6D11", category: "Friends",
            youtubeID: "lJqNnv8KRbQ",    // Good manners / playground
            teluguYoutubeID: "J1CWMU9Oo6s",
            pages: [
                StoryPage(id:1, text:"The playground has swings, slides, and lots of space to run.", imageSF:"figure.play", bgColorHex:"#EAF3DE"),
                StoryPage(id:2, text:"If I want to join a game, I can say: \"Can I play too?\"", imageSF:"bubble.left.fill", bgColorHex:"#E1F5EE"),
                StoryPage(id:3, text:"We take turns on the slide and don't push or cut in line.", imageSF:"person.3.fill", bgColorHex:"#EEEDFE"),
                StoryPage(id:4, text:"If someone is upset or crying, I can ask: \"Are you okay?\"", imageSF:"questionmark.circle.fill", bgColorHex:"#FAEEDA"),
                StoryPage(id:5, text:"When it's time to go inside, I go when the teacher calls.", imageSF:"bell.fill", bgColorHex:"#E6F1FB"),
                StoryPage(id:6, text:"Playtime makes me happy and helps me make friends. 🏅", imageSF:"medal.fill", bgColorHex:"#EAF3DE"),
            ]),

        // Telugu Stories
        SocialStory(id: 9, title: "అమ్మ కథ (Amma Story)", emoji: "🌺", colorHex: "#D4537E", category: "Telugu",
            youtubeID: "v7fmJ5VlRrA",
            teluguYoutubeID: "v7fmJ5VlRrA",
            pages: [
                StoryPage(id:1, text:"అమ్మ నన్ను చాలా ప్రేమిస్తుంది.", imageSF:"heart.fill", bgColorHex:"#FBEAF0"),
                StoryPage(id:2, text:"అమ్మ ప్రతి రోజూ నాకు అన్నం వండుతుంది.", imageSF:"fork.knife", bgColorHex:"#E1F5EE"),
                StoryPage(id:3, text:"అమ్మ నాకు పాటలు పాడుతుంది.", imageSF:"music.note", bgColorHex:"#EEEDFE"),
                StoryPage(id:4, text:"నేను అమ్మని చాలా ప్రేమిస్తాను. 💕", imageSF:"star.fill", bgColorHex:"#FAEEDA"),
            ]),

        SocialStory(id: 10, title: "పంచతంత్రం కథ", emoji: "🦁", colorHex: "#BA7517", category: "Telugu",
            youtubeID: "uKVmQcuDMbU",
            teluguYoutubeID: "uKVmQcuDMbU",
            pages: [
                StoryPage(id:1, text:"అడవిలో ఒక సింహం నివసించేది.", imageSF:"figure.walk", bgColorHex:"#FAEEDA"),
                StoryPage(id:2, text:"సింహం చాలా బలమైనది కానీ దయగలది.", imageSF:"heart.fill", bgColorHex:"#E1F5EE"),
                StoryPage(id:3, text:"మంచితనం ఎల్లప్పుడూ గెలుస్తుంది. 🌟", imageSF:"star.fill", bgColorHex:"#EAF3DE"),
            ]),
    ]
}

// MARK: - Stories home view

struct SocialStoriesHomeView: View {
    private let categories = ["All", "School", "Friends", "Feelings", "Health", "Skills", "Telugu"]
    @State private var selectedCat = "All"
    @State private var selectedStory: SocialStory? = nil
    @State private var teluguMode = false

    private var filtered: [SocialStory] {
        selectedCat == "All" ? SocialStory.all : SocialStory.all.filter { $0.category == selectedCat }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Header
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Social Stories").font(.system(size: 20, weight: .medium))
                        Text("Video stories that teach life skills").font(.system(size: 14)).foregroundColor(.secondary)
                    }
                    Spacer()
                    ZStack {
                        Circle().fill(Color(hex: "534AB7").opacity(0.12)).frame(width: 56, height: 56)
                        Text("🎬").font(.system(size: 28))
                    }
                }
                .padding(16).background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 14)

                // Telugu toggle
                HStack {
                    Toggle(isOn: $teluguMode) {
                        Label("తెలుగు వర్షన్ (Telugu Version)", systemImage: "globe")
                            .font(.system(size: 13))
                    }
                    .toggleStyle(.button)
                    .font(.system(size: 13))
                    .tint(Color(hex: "BA7517"))
                    Spacer()
                }.padding(.horizontal, 20).padding(.bottom, 10)

                // Category chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { cat in
                            Button { withAnimation { selectedCat = cat } } label: {
                                Text(cat)
                                    .font(.system(size: 13, weight: selectedCat == cat ? .semibold : .regular))
                                    .foregroundColor(selectedCat == cat ? .white : Color(hex: "534AB7"))
                                    .padding(.horizontal, 16).padding(.vertical, 8)
                                    .background(selectedCat == cat ? Color(hex: "534AB7") : Color(hex: "534AB7").opacity(0.1))
                                    .clipShape(Capsule())
                            }.buttonStyle(.plain)
                        }
                    }.padding(.horizontal, 20)
                }.padding(.bottom, 16)

                // Story grid
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160, maximum: 240), spacing: 14)], spacing: 14) {
                    ForEach(filtered) { story in
                        StoryCard(story: story) { selectedStory = story }
                    }
                }
                .padding(.horizontal, 20).padding(.bottom, 30)
            }
        }
        .navigationTitle("Stories")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedStory) { story in
            VideoStoryPlayerView(story: story, teluguMode: teluguMode)
        }
    }
}

// MARK: - Story card (video-first)

struct StoryCard: View {
    let story: SocialStory
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // YouTube thumbnail
                ZStack {
                    AsyncImage(url: URL(string: "https://img.youtube.com/vi/\(story.youtubeID)/hqdefault.jpg")) { phase in
                        switch phase {
                        case .success(let img): img.resizable().scaledToFill().frame(height: 80).clipped()
                        default: Rectangle().fill(Color(hex: story.colorHex).opacity(0.15)).frame(height: 80)
                            .overlay(Text(story.emoji).font(.system(size: 36)))
                        }
                    }
                    ZStack {
                        Circle().fill(Color.black.opacity(0.45)).frame(width: 32, height: 32)
                        Image(systemName: "play.fill").font(.system(size: 12)).foregroundColor(.white).offset(x: 1)
                    }
                }.frame(height: 80).clipped()

                VStack(spacing: 6) {
                    Text(story.title).font(.system(size: 13, weight: .semibold)).foregroundColor(.primary)
                        .lineLimit(2).multilineTextAlignment(.center)
                    Text(story.category).font(.system(size: 10, weight: .medium)).foregroundColor(Color(hex: story.colorHex))
                        .padding(.horizontal, 10).padding(.vertical, 3).background(Color(hex: story.colorHex).opacity(0.12)).clipShape(Capsule())
                }.padding(10).frame(maxWidth: .infinity)
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.separator).opacity(0.3), lineWidth: 0.5))
        }.buttonStyle(.plain)
    }
}

// MARK: - Video story player

struct VideoStoryPlayerView: View {
    let story: SocialStory
    let teluguMode: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var speechEngine = SpeechEngine()
    @State private var showTextBackup = false

    var videoID: String { teluguMode ? story.teluguYoutubeID : story.youtubeID }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Video player
                    if let url = URL(string: "https://www.youtube.com/embed/\(videoID)?playsinline=1&autoplay=0&rel=0&modestbranding=1") {
                        GeometryReader { geo in
                            VideoWebView(url: url).frame(height: 240)
                        }.frame(height: 240)
                    }

                    // Info
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(story.emoji).font(.system(size: 32))
                            VStack(alignment: .leading, spacing: 3) {
                                Text(story.title).font(.system(size: 20, weight: .bold))
                                Text(story.category).font(.system(size: 12)).foregroundColor(Color(hex: story.colorHex))
                            }
                            Spacer()
                            if teluguMode {
                                Text("🇮🇳 తెలుగు").font(.system(size: 12)).foregroundColor(Color(hex: "BA7517"))
                                    .padding(.horizontal, 8).padding(.vertical, 4).background(Color(hex: "BA7517").opacity(0.1)).clipShape(Capsule())
                            }
                        }

                        // Open in YouTube
                        if let url = URL(string: "https://www.youtube.com/watch?v=\(videoID)") {
                            Link(destination: url) {
                                HStack {
                                    Image(systemName: "arrow.up.right.square")
                                    Text("Open in YouTube")
                                }.font(.system(size: 14, weight: .medium)).foregroundColor(.white)
                                .frame(maxWidth: .infinity).padding(.vertical, 12)
                                .background(Color.red).clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }

                        // Story pages as summary
                        Button { withAnimation { showTextBackup.toggle() } } label: {
                            HStack {
                                Text("Story Summary").font(.system(size: 14, weight: .medium))
                                Spacer()
                                Image(systemName: showTextBackup ? "chevron.up" : "chevron.down").font(.system(size: 12))
                            }.foregroundColor(Color(hex: story.colorHex))
                        }

                        if showTextBackup {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(story.pages) { page in
                                    HStack(alignment: .top, spacing: 10) {
                                        Image(systemName: page.imageSF).font(.system(size: 16))
                                            .foregroundColor(Color(hex: story.colorHex)).frame(width: 24)
                                        Text(page.text).font(.system(size: 14)).foregroundColor(.primary).fixedSize(horizontal: false, vertical: true)
                                        Spacer()
                                        Button { speechEngine.speak(page.text) } label: {
                                            Image(systemName: "speaker.wave.1").font(.system(size: 11)).foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(10).background(Color(hex: page.bgColorHex)).clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                    }.padding(20)
                }
            }
            .navigationTitle(story.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Close") { dismiss() } }
            }
        }
    }
}
