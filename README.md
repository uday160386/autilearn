# AutiLearn

**Learning Companion for Children with Autism**

> iOS & iPadOS · Swift 5.10 · SwiftUI · SwiftData · iOS 17+

AutiLearn is a comprehensive, parent-controlled learning companion designed for children with autism and developmental differences. It combines emotion learning, academic subjects, cultural content, physical activities, and AI-powered voice chat in a single safe iOS environment — ad-free, fully in-app, and built for Indian families.

---

## Features

| Module | Highlights |
|---|---|
| Dashboard | Profile card, memories strip, quick-access tiles, today's stars |
| Emotions | Mirror Mode, Identify Mode, Voice Chat, 6-Second Rule |
| Study | Math, English, Science, Currency, Measurements |
| Activities | Yoga, Social Skills, Cooking, Sports, Physical Activities |
| Videos | 450+ curated YouTube videos across 51 categories |
| AAC Board | Symbol communication board with sentence strip |
| Languages | Stories & devotional content in 9 Indian languages |
| Places | Interactive map with live GPS and curated safe places |
| Schedule | Weekly planner + monthly calendar with festival markers |
| Calm Corner | 4 interactive breathing exercises with animations |
| Rewards | Star chart with daily tracking and history |
| Memories | Photo & video memory book with mood tracking |
| Parent Mode | PIN-protected kiosk lock, symbol management, progress |

---

## Navigation Structure


### iPad — Full sidebar navigation

Six collapsible sections with direct `NavigationLink` to every screen:
**Dashboard · Emotions · Study · Activities · Explore · Daily Life**

---

## Modules

### 1. Dashboard

- **Profile card** — name, age, avatar photo, today's star count
- **Quick-access grid** — 6 one-tap tiles (Emotions, Study, Activities, Videos, Calm Corner, Schedule)
- **Memories strip** — horizontal scroll of recent memory thumbnails
- **Stars today** — live star count tapping into full Rewards chart

---

### 2. Emotions Module

#### Emotion Trainer
Photo grid of 20 emotions. Tapping opens a detail sheet with an embedded YouTube video, description, and read-aloud button.

**Emotions:** happy · sad · angry · scared · surprised · calm · excited · proud · worried · bored · grateful · lonely · disgusted · confused · embarrassed · jealous · frustrated · hopeful · shy · tired

#### Mirror Mode
- Live camera via `AVCaptureSession`
- Real-time facial expression detection using Apple Vision (`VNDetectFaceExpressionsRequest`)
- Child holds the target expression for 2 seconds → animated ring turns green → earns a star

#### Identify Mode
- Scenario-based quiz with short story prompt
- Pick the correct emotion from 4 illustrated choices
- Score tracked and saved to SwiftData

#### Voice Chat *(AI-powered)*
- `SFSpeechRecognizer` + `AVAudioEngine` for on-device speech-to-text
- Live transcript preview while recording
- Animated three-dot thinking bubble while AI generates reply
- Reply read aloud via `AVSpeechSynthesizer`
- API key fetched securely from Supabase — never bundled in the app

#### Emotion Progress
- Per-emotion accuracy chart
- Correct/incorrect attempt history from SwiftData

#### 6-Second Rule
- Interactive breathing and counting technique
- Animated visual timer for emotional regulation

---

### 3. Study Module

#### Math & Numbers
- 4 operations: Addition, Subtraction, Multiplication, Division
- Problem-by-problem practice with visual feedback
- 1 star per 3 correct answers
- Progress chart per operation

#### English Lessons
- Flashcard, Quiz, and All Words views
- Beginner and Intermediate levels
- Each word includes phonetic guide, image keyword, and audio

#### Science
- Curated experiment cards with step-by-step visual instructions
- Adaptive grid layout (2 cols on iPhone, 3–4 on iPad)

#### Currency
- Indian Rupee (INR) and Singapore Dollar (SGD)
- Visual coins and notes with real-life shopping examples

#### Measurements
- 8 video tutorials: length, weight, volume, temperature, time, metric system, area, units

---

### 4. Activities Module

| Activity | Description |
|---|---|
| Yoga & Exercise | 10 Cosmic Kids Yoga and GoNoodle sessions — breathing, balance, mindfulness |
| Social Skills | 7 animated video lessons on manners, sharing, friendship, inclusivity |
| Cooking | 5 kid-friendly recipe videos — pancakes, sandwiches, fruit salad |
| Sports | 5 tutorials — freestyle swimming, soccer dribbling for beginners |
| Physical Activities | Skating, painting, drawing, swimming — step-by-step text + icon guides |

---

### 5. AAC Communication Board

*Augmentative and Alternative Communication*

- Symbol grid with 5 categories: **Feelings · Actions · Needs · People · Places**
- Tap any symbol → spoken immediately via TTS
- Drag symbols into sentence strip → tap "Speak sentence" for full phrase
- Parent mode: add, edit, delete, reorder symbols
- Optional YouTube video linked per symbol
- Symbols stored in SwiftData with position ordering

---

### 6. Social Stories

- Video-first format with English and Telugu YouTube videos per story
- Topics: going to school, making friends, visiting the doctor, supermarket, playground
- Text pages as fallback if video unavailable

---

### 7. Daily Routine Builder

- Visual schedule with drag-to-reorder support
- Tap-to-complete with checkmark animation
- Each task: icon, title, duration, optional time
- Speech support — tap any task to hear it read aloud
- Stored in SwiftData with position ordering

---

### 8. Schedule & Calendar

- Weekly time-slot planner (7 days + "every day" option)
- Monthly calendar with current date highlighted
- India and Singapore festival markers
- Tap a slot to navigate directly to that app feature

---

### 9. Calming Tools

- **4 breathing exercises:** Box Breathing · 4-7-8 Breathing · Star Breathing · Bear Breathing
- Animated visual guides — expanding/contracting shapes
- Each phase labelled: Breathe In · Hold · Breathe Out
- Sensory tool suggestions and calming technique library

---

### 10. Rewards & Star Chart

- Stars earned for correct answers in Math, Emotions, and English
- Daily star count displayed on Dashboard
- Full history log with date, reason, and emoji
- Manual star entry with custom reasons
- Motivational messages based on streak

---

### 11. Memories Book

- Photo and video memories with title, date, and mood emoji
- Camera capture or photo library import
- Thumbnail strip on Dashboard
- Full gallery view with date grouping

---

### 12. Places & Map

- Interactive map using iOS 17 `Map` API with `Annotation`
- Country selector: India / Singapore
- Curated safe public places (parks, libraries, hospitals, schools)
- Live GPS tracking via `CLLocationManager` — blue dot on map
- Distance shown in detail sheet when location is active
- Reverse geocoded address shown in status bar

---

### 13. Video Modeling

- Structured video guides for daily living skills
- Each model: primary YouTube video + numbered step list
- Designed for imitation-based learning

---

## Indian Language Support

Stories and devotional content available in **9 regional Indian languages**:

| Language | Script | Stories | Devotional |
|---|---|---|---|
| Telugu | తెలుగు | ✅ | ✅ |
| Hindi | हिन्दी | ✅ | ✅ |
| Tamil | தமிழ் | ✅ | ✅ |
| Kannada | ಕನ್ನಡ | ✅ | ✅ |
| Malayalam | മലയാളം | ✅ | ✅ |
| Marathi | मराठी | ✅ | ✅ |
| Bengali | বাংলা | ✅ | ✅ |
| Gujarati | ગુજરાતી | ✅ | ✅ |
| Punjabi | ਪੰਜਾਬੀ | ✅ | ✅ |

Each language includes: alphabet and numbers, nursery rhymes, moral stories, Panchatantra fables, and devotional stotrams / bhajans.

---

## Video Library

- **452 curated videos** across **51 categories**
- All sourced from embedding-friendly YouTube channels
- Videos load directly in `WKWebView` — never in an external browser or YouTube app
- Availability checked via YouTube oEmbed API on launch (cached 24 hours)

### Categories

```
General Education          Language — Stories         Language — Devotional
───────────────────        ──────────────────         ─────────────────────
Autism Support             Telugu / Hindi / Tamil     Telugu / Hindi / Tamil
Yoga & Exercise            Kannada / Malayalam        Kannada / Malayalam
Social Skills              Marathi / Bengali          Marathi / Bengali
Communication              Gujarati / Punjabi         Gujarati / Punjabi
Cooking
Sports                     Sports                     Activities
───────                    ──────                     ──────────
Math                       Cricket                    Chess
Science                    Badminton                  Gymnastics
Experiments                Swimming                   Dance
Music & Relax              Ice Skating                Singing
Art & Crafts               Roller Skating             Photography
Measurements               Athletics                  Coding & Robotics
                           Basketball                 Reading Club
                           Table Tennis               Drama & Theatre
                           Kabaddi                    Debate & Speaking
                           Martial Arts               Gardening
```


## Parent Mode & Safety

### PIN Protection
- 4-digit passcode (default: `1234`)
- Guards all parent controls and settings

### Parent Controls
- Toggle app lock on/off
- Change PIN
- Add / edit / delete / reorder AAC symbols
- View Guided Access setup instructions

---


## License

© 2025 Vuktales. All rights reserved.

---

*AutiLearn — Safe, ad-free, and always in-app.*
