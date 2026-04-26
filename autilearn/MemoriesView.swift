import SwiftUI
import SwiftData
import PhotosUI
import AVFoundation

// MARK: - Memory SwiftData model

@Model
class Memory {
    var id: UUID
    var title: String
    var note: String
    var mood: String          // emoji
    var mediaData: Data?      // photo or video data
    var mediaType: String     // "photo" | "video"
    var thumbnailData: Data?
    var createdAt: Date
    var tags: [String]

    init(title: String, note: String = "", mood: String = "😊", mediaType: String = "photo") {
        self.id           = UUID()
        self.title        = title
        self.note         = note
        self.mood         = mood
        self.mediaType    = mediaType
        self.createdAt    = Date()
        self.tags         = []
    }
}

// MARK: - Memories Home

struct MemoriesHomeView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Memory.createdAt, order: .reverse) private var memories: [Memory]
    @State private var showAdd = false
    @State private var selectedMemory: Memory? = nil
    @State private var speechEngine = SpeechEngine()

    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 12)]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Header
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("My Memories").font(.system(size: 20, weight: .medium))
                        Text("Photos and videos of my favourite moments").font(.system(size: 14)).foregroundColor(.secondary)
                    }
                    Spacer()
                    ZStack {
                        Circle().fill(Color(hex: "D4537E").opacity(0.12)).frame(width: 56, height: 56)
                        Text("🎞️").font(.system(size: 28))
                    }
                }
                .padding(16).background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 16)

                // Add button
                Button { showAdd = true } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "plus.circle.fill").font(.system(size: 20)).foregroundColor(Color(hex: "D4537E"))
                        Text("Add a Memory").font(.system(size: 15, weight: .medium)).foregroundColor(Color(hex: "D4537E"))
                        Spacer()
                        Image(systemName: "photo.on.rectangle.angled").font(.system(size: 16)).foregroundColor(Color(hex: "D4537E").opacity(0.6))
                    }
                    .padding(14).background(Color(hex: "D4537E").opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 14))
                }.buttonStyle(.plain).padding(.horizontal, 20).padding(.bottom, 16)

                if memories.isEmpty {
                    VStack(spacing: 16) {
                        Text("🎞️").font(.system(size: 56))
                        Text("No memories yet!").font(.system(size: 16, weight: .medium))
                        Text("Tap \"Add a Memory\" to save a photo or video of something special.").font(.system(size: 14)).foregroundColor(.secondary).multilineTextAlignment(.center)
                    }.padding(40)
                } else {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(memories) { memory in
                            MemoryCard(memory: memory) { selectedMemory = memory }
                        }
                    }.padding(.horizontal, 20).padding(.bottom, 30)
                }
            }
        }
        .navigationTitle("Memories")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showAdd) { AddMemoryView() }
        .sheet(item: $selectedMemory) { mem in MemoryDetailView(memory: mem) }
    }
}

// MARK: - Memory card

struct MemoryCard: View {
    let memory: Memory
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                ZStack {
                    if let data = memory.thumbnailData ?? memory.mediaData,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage).resizable().scaledToFill().frame(height: 110).clipped()
                    } else {
                        Rectangle().fill(Color(hex: "D4537E").opacity(0.1)).frame(height: 110)
                            .overlay(Text(memory.mood).font(.system(size: 44)))
                    }
                    if memory.mediaType == "video" {
                        VStack { Spacer(); HStack { Spacer()
                            Image(systemName: "video.fill").font(.system(size: 14)).foregroundColor(.white)
                                .padding(6).background(Color.black.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 6)).padding(6)
                        }}
                    }
                }.frame(height: 110).clipped()

                VStack(alignment: .leading, spacing: 4) {
                    Text(memory.title).font(.system(size: 13, weight: .semibold)).lineLimit(1)
                    Text(memory.createdAt, style: .date).font(.system(size: 11)).foregroundColor(.secondary)
                }.padding(10).frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.separator).opacity(0.3), lineWidth: 0.5))
        }.buttonStyle(.plain)
    }
}

// MARK: - Add Memory

struct AddMemoryView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var note = ""
    @State private var mood = "😊"
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var mediaType = "photo"

    let moods = ["😊","🥰","😄","🤩","😌","😢","😠","😴","🤔","😎","🎉","💪"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Memory") {
                    TextField("What is this memory about?", text: $title)
                    TextField("Add a note (optional)", text: $note, axis: .vertical).lineLimit(3)
                }
                Section("Mood") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(moods, id: \.self) { m in
                                Text(m).font(.system(size: 28))
                                    .padding(8)
                                    .background(mood == m ? Color.yellow.opacity(0.3) : Color.clear)
                                    .clipShape(Circle())
                                    .onTapGesture { mood = m }
                            }
                        }
                    }
                }
                Section("Photo or Video") {
                    PhotosPicker(selection: $selectedPhotoItem, matching: .any(of: [.images, .videos])) {
                        if let data = selectedImageData, let img = UIImage(data: data) {
                            Image(uiImage: img).resizable().scaledToFit().frame(maxHeight: 160).clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            Label("Choose from Library", systemImage: "photo.on.rectangle").foregroundColor(Color(hex: "D4537E"))
                        }
                    }
                    .onChange(of: selectedPhotoItem) { item in
                        Task {
                            if let data = try? await item?.loadTransferable(type: Data.self) {
                                await MainActor.run { selectedImageData = data; mediaType = "photo" }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Memory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        guard !title.isEmpty else { return }
                        let memory = Memory(title: title, note: note, mood: mood, mediaType: mediaType)
                        memory.mediaData = selectedImageData
                        context.insert(memory)
                        try? context.save()
                        dismiss()
                    }.disabled(title.isEmpty).fontWeight(.medium)
                }
            }
        }
    }
}

// MARK: - Memory Detail

struct MemoryDetailView: View {
    let memory: Memory
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var speechEngine = SpeechEngine()
    @State private var confirmDelete = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Media
                    if let data = memory.mediaData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage).resizable().scaledToFit().frame(maxHeight: 340)
                            .clipShape(RoundedRectangle(cornerRadius: 0))
                    } else {
                        Rectangle().fill(Color(hex: "D4537E").opacity(0.1)).frame(height: 200)
                            .overlay(Text(memory.mood).font(.system(size: 80)))
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(memory.mood).font(.system(size: 32))
                            VStack(alignment: .leading, spacing: 3) {
                                Text(memory.title).font(.system(size: 22, weight: .bold))
                                Text(memory.createdAt, style: .date).font(.system(size: 13)).foregroundColor(.secondary)
                            }
                            Spacer()
                            Button { speechEngine.speak("\(memory.title). \(memory.note)") } label: {
                                Image(systemName: "speaker.wave.2.fill").font(.system(size: 20)).foregroundColor(Color(hex: "D4537E"))
                            }
                        }

                        if !memory.note.isEmpty {
                            Text(memory.note).font(.system(size: 15)).foregroundColor(.primary).lineSpacing(4)
                                .padding(14).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        Button { confirmDelete = true } label: {
                            Label("Delete Memory", systemImage: "trash").font(.system(size: 14))
                                .foregroundColor(.red).frame(maxWidth: .infinity).padding(.vertical, 12)
                                .background(Color.red.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }.padding(20)
                }
            }
            .navigationTitle("Memory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } }
            }
            .confirmationDialog("Delete this memory?", isPresented: $confirmDelete, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    context.delete(memory)
                    try? context.save()
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}
