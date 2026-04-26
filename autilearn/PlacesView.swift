import SwiftUI
import MapKit

// MARK: - Places Home
// Uses the new Map API (iOS 17+). Falls back gracefully on older OS.

struct PlacesHomeView: View {
    @State private var selectedCountry: PlaceCountry = .india
    @State private var selectedPlace: TouristPlace? = nil
    @State private var speechEngine = SpeechEngine()

    private var places: [TouristPlace] {
        TouristPlace.all.filter { $0.country == selectedCountry }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                headerCard
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 16)

                // Country selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(PlaceCountry.allCases) { country in
                            CountryChip(
                                country: country,
                                isSelected: selectedCountry == country
                            ) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedCountry = country
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 16)

                // Mini map
                miniMap
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)

                // Place cards — 1 col iPhone, 2 col iPad
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 340, maximum: 600), spacing: 14)],
                    spacing: 14
                ) {
                    ForEach(places) { place in
                        PlaceRowCard(place: place) {
                            selectedPlace = place
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)

                Spacer(minLength: 30)
            }
        }
        .navigationTitle("Explore the World")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedPlace) { place in
            PlaceDetailSheet(place: place)
        }
    }

    private var headerCard: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Famous places!")
                    .font(.system(size: 20, weight: .medium))
                Text("Tap any place to learn about it")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(Color(hex: "#185FA5").alpha(0.12))
                    .frame(width: 56, height: 56)
                Text("🗺️")
                    .font(.system(size: 28))
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var miniMap: some View {
        Map(initialPosition: .region(
            MKCoordinateRegion(
                center: selectedCountry.mapCenter,
                span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            )
        )) {
            ForEach(places) { place in
                Annotation(place.name, coordinate: place.coordinate) {
                    VStack(spacing: 2) {
                        Text(place.emoji)
                            .font(.system(size: 20))
                            .padding(6)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                        Text(place.name)
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Capsule())
                    }
                    .onTapGesture { selectedPlace = place }
                }
            }
        }
        .id(selectedCountry)   // force Map to re-centre when country changes
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.separator).alpha(0.3), lineWidth: 0.5)
        )
    }
}

// MARK: - Country chip

struct CountryChip: View {
    let country: PlaceCountry
    let isSelected: Bool
    let action: () -> Void

    private var accent: Color { Color(hex: country.colorHex) }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(country.flag)
                    .font(.system(size: 16))
                Text(country.rawValue)
                    .font(.system(size: 13, weight: isSelected ? .medium : .regular))
            }
            .foregroundColor(isSelected ? .white : accent)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? accent : accent.alpha(0.1))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

// MARK: - Place row card

struct PlaceRowCard: View {
    let place: TouristPlace
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // Photo or emoji fallback
                AsyncImage(url: URL(string: place.photoURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipped()
                    case .failure, .empty:
                        Rectangle()
                            .fill(Color(hex: place.country.colorHex).alpha(0.12))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text(place.emoji)
                                    .font(.system(size: 36))
                            )
                    @unknown default:
                        Rectangle()
                            .fill(Color(.secondarySystemBackground))
                            .frame(width: 80, height: 80)
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 5) {
                    Text(place.name)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.primary)

                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: place.country.colorHex))
                        Text(place.city)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }

                    Text(place.type.rawValue)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(hex: place.type.colorHex))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color(hex: place.type.colorHex).alpha(0.1))
                        .clipShape(Capsule())

                    Text(place.headline)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(Color.secondary.alpha(0.5))
            }
            .padding(14)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.separator).alpha(0.35), lineWidth: 0.5)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Place detail sheet

struct PlaceDetailSheet: View {
    let place: TouristPlace
    @Environment(\.dismiss) private var dismiss
    @State private var speechEngine = SpeechEngine()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // Hero photo
                    AsyncImage(url: URL(string: place.photoURL)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 220)
                                .clipped()
                        default:
                            Rectangle()
                                .fill(Color(hex: place.country.colorHex).alpha(0.15))
                                .frame(height: 220)
                                .overlay(
                                    Text(place.emoji)
                                        .font(.system(size: 80))
                                )
                        }
                    }

                    VStack(alignment: .leading, spacing: 16) {

                        // Title + badges
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Text(place.country.flag + " " + place.city)
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(place.type.rawValue)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(Color(hex: place.type.colorHex))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color(hex: place.type.colorHex).alpha(0.1))
                                    .clipShape(Capsule())
                            }

                            Text(place.name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.primary)

                            Text(place.headline)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color(hex: place.country.colorHex))
                        }

                        Divider()

                        // Description
                        Text(place.description)
                            .font(.system(size: 15))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineSpacing(4)

                        // Hear description
                        Button {
                            speechEngine.speak(place.headline + ". " + place.description)
                        } label: {
                            Label("Hear about this place", systemImage: "speaker.wave.2")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: place.country.colorHex))
                        }

                        Divider()

                        // Fact grid
                        Text("Quick Facts")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)

                        LazyVGrid(
                            columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
                            spacing: 10
                        ) {
                            ForEach(place.facts, id: \.label) { fact in
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(fact.label)
                                        .font(.system(size: 11))
                                        .foregroundColor(.secondary)
                                    Text(fact.value)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.primary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(12)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }

                        // Mini map showing the place
                        Text("Location")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)

                        Map(initialPosition: .region(
                            MKCoordinateRegion(
                                center: place.coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            )
                        )) {
                            Annotation(place.name, coordinate: place.coordinate) {
                                VStack(spacing: 2) {
                                    Text(place.emoji)
                                        .font(.system(size: 28))
                                        .padding(8)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .shadow(radius: 3)
                                    Text(place.name)
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.black.opacity(0.65))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                    }
                    .padding(20)
                }
            }
            .navigationTitle(place.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
            .ignoresSafeArea(edges: .top)
        }
    }
}
