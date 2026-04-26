import SwiftUI
import SwiftData
import PhotosUI
import AVFoundation

// MARK: - Profile models

@Model
class ChildProfile {
    var id: UUID
    var name: String
    var age: Int
    var photoData: Data?
    var favoriteColor: String
    var interests: [String]
    var notes: String
    var createdAt: Date

    init(name: String, age: Int) {
        self.id            = UUID()
        self.name          = name
        self.age           = age
        self.favoriteColor = "#1D9E75"
        self.interests     = []
        self.notes         = ""
        self.createdAt     = Date()
    }
}

@Model
class MediaRecording {
    var id: UUID
    var title: String
    var type: String       // "video" | "photo" | "audio"
    var data: Data?
    var thumbnailData: Data?
    var createdAt: Date
    var tag: String        // "routine" | "story" | "general" | "task"

    init(title: String, type: String, data: Data?, tag: String = "general") {
        self.id            = UUID()
        self.title         = title
        self.type          = type
        self.data          = data
        self.thumbnailData = nil
        self.createdAt     = Date()
        self.tag           = tag
    }
}

// MARK: - Profile Home

struct ProfileHomeView: View {
    @Environment(\.modelContext) private var context
    @Query private var profiles: [ChildProfile]
    @Query(sort: \MediaRecording.createdAt, order: .reverse) private var recordings: [MediaRecording]
    @State private var showEditProfile = false
    @State private var showMediaPicker = false
    @State private var selectedTab     = 0

    private var profile: ChildProfile? { profiles.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Profile card
                profileCard
                    .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 20)

                // Tabs
                Picker("", selection: $selectedTab) {
                    Text("Photos").tag(0)
                    Text("Videos").tag(1)
                    Text("About Me").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20).padding(.bottom, 16)

                switch selectedTab {
                case 0: photoGrid
                case 1: videoGrid
                default: aboutMeView
                }
            }
        }
        .navigationTitle("My Profile")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 12) {
                    // Quick lock button
                    Button {
                        GuidedAccessManager.shared.showUnlockOverlay = true
                    } label: {
                        Image(systemName: "lock.fill")
                            .foregroundColor(Color(hex: "D85A30"))
                    }
                    Button { showEditProfile = true } label: { Image(systemName: "pencil.circle") }
                }
            }
        }
        .sheet(isPresented: $showEditProfile) {
            EditProfileSheet(profile: profile) { name, age, color, interests, notes, photoData in
                saveProfile(name: name, age: age, color: color, interests: interests, notes: notes, photo: photoData)
            }
        }
        .onAppear { if profile == nil { context.insert(ChildProfile(name: "My Child", age: 8)) } }
    }

    // MARK: Profile card

    private var profileCard: some View {
        HStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color(hex: profile?.favoriteColor ?? "#1D9E75").opacity(0.15))
                    .frame(width: 80, height: 80)
                if let data = profile?.photoData, let ui = UIImage(data: data) {
                    Image(uiImage: ui).resizable().scaledToFill()
                        .frame(width: 80, height: 80).clipShape(Circle())
                } else {
                    Text("👦").font(.system(size: 40))
                }
            }
            .onTapGesture { showEditProfile = true }

            VStack(alignment: .leading, spacing: 4) {
                Text(profile?.name ?? "My Child")
                    .font(.system(size: 22, weight: .bold))
                if let age = profile?.age {
                    Text("Age \(age)").font(.system(size: 14)).foregroundColor(.secondary)
                }
                if let interests = profile?.interests, !interests.isEmpty {
                    Text(interests.prefix(3).joined(separator: " · "))
                        .font(.system(size: 12)).foregroundColor(Color(hex: profile?.favoriteColor ?? "#1D9E75"))
                }
            }
            Spacer()

            VStack(spacing: 4) {
                Text("\(recordings.count)").font(.system(size: 24, weight: .bold)).foregroundColor(Color(hex: profile?.favoriteColor ?? "#1D9E75"))
                Text("Media").font(.system(size: 11)).foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: Photo grid

    private var photoGrid: some View {
        let photos = recordings.filter { $0.type == "photo" }
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Photos (\(photos.count))").font(.system(size: 15, weight: .semibold)).padding(.horizontal, 20)
                Spacer()
                NavigationLink(destination: AddMediaView(mediaType: "photo")) {
                    Label("Add", systemImage: "plus").font(.system(size: 13)).foregroundColor(Color(hex: "#1D9E75"))
                }.padding(.trailing, 20)
            }
            if photos.isEmpty {
                emptyState(icon: "photo.on.rectangle", text: "No photos yet. Tap Add to take or upload a photo.")
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 140), spacing: 4)], spacing: 4) {
                    ForEach(photos) { rec in
                        MediaThumb(recording: rec)
                    }
                }.padding(.horizontal, 20)
            }
        }.padding(.bottom, 30)
    }

    // MARK: Video grid

    private var videoGrid: some View {
        let videos = recordings.filter { $0.type == "video" }
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recordings (\(videos.count))").font(.system(size: 15, weight: .semibold)).padding(.horizontal, 20)
                Spacer()
                NavigationLink(destination: AddMediaView(mediaType: "video")) {
                    Label("Record", systemImage: "video.badge.plus").font(.system(size: 13)).foregroundColor(Color(hex: "#534AB7"))
                }.padding(.trailing, 20)
            }
            if videos.isEmpty {
                emptyState(icon: "video.slash", text: "No recordings yet. Record task demonstrations or social stories.")
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(videos) { rec in
                        VideoRecordingRow(recording: rec)
                    }
                }.padding(.horizontal, 20)
            }
        }.padding(.bottom, 30)
    }

    // MARK: About me

    private var aboutMeView: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let notes = profile?.notes, !notes.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Notes", systemImage: "note.text").font(.system(size: 14, weight: .semibold))
                    Text(notes).font(.system(size: 14)).foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
            }

            if let interests = profile?.interests, !interests.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Interests", systemImage: "heart.fill").font(.system(size: 14, weight: .semibold))
                    FlowLayout(items: interests) { i in
                        Text(i).font(.system(size: 13))
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(Color(hex: profile?.favoriteColor ?? "#1D9E75").opacity(0.12))
                            .clipShape(Capsule())
                    }
                }
                .padding(14).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button { showEditProfile = true } label: {
                Label("Edit Profile", systemImage: "pencil")
                    .font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                    .background(Color(hex: profile?.favoriteColor ?? "#1D9E75")).clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }.padding(.horizontal, 20).padding(.bottom, 30)
    }

    private func emptyState(icon: String, text: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon).font(.system(size: 40)).foregroundColor(.secondary)
            Text(text).font(.system(size: 14)).foregroundColor(.secondary).multilineTextAlignment(.center)
        }.frame(maxWidth: .infinity).padding(40)
    }

    private func saveProfile(name: String, age: Int, color: String, interests: [String], notes: String, photo: Data?) {
        if let p = profile {
            p.name = name; p.age = age; p.favoriteColor = color
            p.interests = interests; p.notes = notes
            if let d = photo { p.photoData = d }
        } else {
            let p = ChildProfile(name: name, age: age)
            p.favoriteColor = color; p.interests = interests; p.notes = notes
            if let d = photo { p.photoData = d }
            context.insert(p)
        }
        try? context.save()
    }
}

// MARK: - Media thumbnail

struct MediaThumb: View {
    let recording: MediaRecording
    var body: some View {
        ZStack {
            Rectangle().fill(Color(.secondarySystemBackground)).aspectRatio(1, contentMode: .fill)
            if let data = recording.thumbnailData ?? recording.data,
               let ui = UIImage(data: data) {
                Image(uiImage: ui).resizable().scaledToFill()
            } else {
                Image(systemName: recording.type == "photo" ? "photo" : "video.fill")
                    .font(.system(size: 24)).foregroundColor(.secondary)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct VideoRecordingRow: View {
    let recording: MediaRecording
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#534AB7").opacity(0.12)).frame(width: 60, height: 60)
                Image(systemName: "play.fill").font(.system(size: 22)).foregroundColor(Color(hex: "#534AB7"))
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(recording.title).font(.system(size: 14, weight: .medium))
                Text(recording.tag.capitalized).font(.system(size: 12)).foregroundColor(.secondary)
                Text(recording.createdAt, style: .relative).font(.system(size: 11)).foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(12).background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.separator).opacity(0.3), lineWidth: 0.5))
    }
}

// MARK: - Add media view

struct AddMediaView: View {
    let mediaType: String
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var title = ""
    @State private var tag   = "general"
    @State private var data: Data? = nil
    @State private var preview: UIImage? = nil

    private let tags = ["general","routine","story","task","celebration"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("e.g. Washing hands", text: $title)
                }
                Section("Category") {
                    Picker("Category", selection: $tag) {
                        ForEach(tags, id: \.self) { Text($0.capitalized).tag($0) }
                    }
                }
                Section("Media") {
                    PhotosPicker(selection: $selectedItem,
                                 matching: mediaType == "photo" ? .images : .videos) {
                        Label(data == nil ? "Choose \(mediaType)" : "Change \(mediaType)",
                              systemImage: mediaType == "photo" ? "photo" : "video.badge.plus")
                    }
                    .onChange(of: selectedItem) { _, item in
                        Task {
                            data = try? await item?.loadTransferable(type: Data.self)
                            if mediaType == "photo", let d = data { preview = UIImage(data: d) }
                        }
                    }
                    if let img = preview {
                        Image(uiImage: img).resizable().scaledToFit().frame(maxHeight: 200).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .navigationTitle("Add \(mediaType.capitalized)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading)  { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        guard !title.isEmpty else { return }
                        context.insert(MediaRecording(title: title, type: mediaType, data: data, tag: tag))
                        try? context.save()
                        dismiss()
                    }
                    .disabled(title.isEmpty).fontWeight(.medium)
                }
            }
        }
    }
}

// MARK: - Edit profile sheet

struct EditProfileSheet: View {
    let profile: ChildProfile?
    let onSave: (String, Int, String, [String], String, Data?) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var name      = ""
    @State private var age       = 8
    @State private var color     = "#1D9E75"
    @State private var interests = ""
    @State private var notes     = ""
    @State private var photoItem: PhotosPickerItem? = nil
    @State private var photoData: Data? = nil
    @State private var preview:   UIImage? = nil

    private let colors = ["#1D9E75","#185FA5","#534AB7","#D85A30","#BA7517","#D4537E","#5DCAA5"]
    private let interestSuggestions = ["Trains","Dinosaurs","Space","Animals","Minecraft","Drawing","Music","Swimming","Lego","Cooking","Reading","Soccer"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Photo") {
                    HStack {
                        if let img = preview {
                            Image(uiImage: img).resizable().scaledToFill()
                                .frame(width: 70, height: 70).clipShape(Circle())
                        } else if let data = profile?.photoData, let ui = UIImage(data: data) {
                            Image(uiImage: ui).resizable().scaledToFill()
                                .frame(width: 70, height: 70).clipShape(Circle())
                        } else {
                            Circle().fill(Color(hex: color).opacity(0.15)).frame(width: 70, height: 70)
                                .overlay(Text("👦").font(.system(size: 36)))
                        }
                        PhotosPicker(selection: $photoItem, matching: .images) {
                            Text("Choose photo").foregroundColor(Color(hex: "#1D9E75"))
                        }
                        .onChange(of: photoItem) { _, item in
                            Task {
                                photoData = try? await item?.loadTransferable(type: Data.self)
                                if let d = photoData { preview = UIImage(data: d) }
                            }
                        }
                    }
                }
                Section("Name & Age") {
                    TextField("Child's name", text: $name)
                    Stepper("Age: \(age)", value: $age, in: 2...18)
                }
                Section("Favourite colour") {
                    HStack(spacing: 12) {
                        ForEach(colors, id: \.self) { c in
                            Circle().fill(Color(hex: c)).frame(width: 32, height: 32)
                                .overlay(Circle().stroke(color == c ? Color.primary : Color.clear, lineWidth: 2.5))
                                .onTapGesture { color = c }
                        }
                    }
                }
                Section("Interests (comma separated)") {
                    TextField("e.g. trains, space, swimming", text: $interests)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(interestSuggestions, id: \.self) { s in
                                Button { interests = interests.isEmpty ? s : interests + ", " + s } label: {
                                    Text(s).font(.system(size: 12))
                                        .padding(.horizontal, 10).padding(.vertical, 5)
                                        .background(Color(hex: "#1D9E75").opacity(0.1)).clipShape(Capsule())
                                        .foregroundColor(Color(hex: "#1D9E75"))
                                }.buttonStyle(.plain)
                            }
                        }
                    }
                }
                Section("Parent notes") {
                    TextField("Anything else to remember...", text: $notes, axis: .vertical).lineLimit(3, reservesSpace: true)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading)  { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let list = interests.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                        onSave(name, age, color, list, notes, photoData)
                        dismiss()
                    }.disabled(name.isEmpty).fontWeight(.medium)
                }
            }
            .onAppear {
                name = profile?.name ?? ""; age = profile?.age ?? 8
                color = profile?.favoriteColor ?? "#1D9E75"
                interests = profile?.interests.joined(separator: ", ") ?? ""
                notes = profile?.notes ?? ""
            }
        }
    }
}
