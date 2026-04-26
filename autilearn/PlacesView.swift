import SwiftUI
import MapKit
import CoreLocation
import WebKit

// MARK: - Places Home
// Full Google Maps via WKWebView with live GPS tracking + place markers.
// Requires NSLocationWhenInUseUsageDescription in Info.plist.

struct PlacesHomeView: View {
    @State private var selectedCountry: PlaceCountry = .india
    @State private var selectedPlace: TouristPlace?  = nil
    @State private var speechEngine  = SpeechEngine()
    @State private var mapMode: MapMode = .google
    @StateObject private var locationManager = LiveLocationManager()

    enum MapMode: String, CaseIterable {
        case google = "Google Maps"
        case apple  = "Apple Maps"
    }

    private var places: [TouristPlace] {
        TouristPlace.all.filter { $0.country == selectedCountry }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                headerCard
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 12)

                // Country chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(PlaceCountry.allCases) { country in
                            CountryChip(country: country, isSelected: selectedCountry == country) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedCountry = country
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 12)

                // Map mode toggle
                Picker("Map", selection: $mapMode) {
                    ForEach(MapMode.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                .padding(.bottom, 12)

                // Map
                Group {
                    if mapMode == .google {
                        GoogleMapsView(
                            center: selectedCountry.mapCenter,
                            places: places,
                            userLocation: locationManager.coordinate,
                            onPlaceTapped: { selectedPlace = $0 }
                        )
                    } else {
                        AppleMiniMap(
                            center: selectedCountry.mapCenter,
                            places: places,
                            userLocation: locationManager.coordinate,
                            onPlaceTapped: { selectedPlace = $0 }
                        )
                    }
                }
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.separator).opacity(0.3), lineWidth: 0.5))
                .padding(.horizontal, 20)
                .padding(.bottom, 16)

                // Live location status bar
                if locationManager.isTracking {
                    LocationStatusBar(manager: locationManager)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)
                }

                // Place cards
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 340, maximum: 600), spacing: 14)],
                    spacing: 14
                ) {
                    ForEach(places) { place in
                        PlaceRowCard(place: place) { selectedPlace = place }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Explore the World")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    locationManager.toggleTracking()
                } label: {
                    Image(systemName: locationManager.isTracking
                          ? "location.fill" : "location")
                    .foregroundColor(locationManager.isTracking ? .blue : .secondary)
                }
            }
        }
        .sheet(item: $selectedPlace) { place in
            PlaceDetailSheet(place: place, userLocation: locationManager.coordinate)
        }
        .onAppear { locationManager.requestPermission() }
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
                Circle().fill(Color(hex: "#185FA5").opacity(0.12)).frame(width: 56, height: 56)
                Text("🗺️").font(.system(size: 28))
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Google Maps WKWebView

struct GoogleMapsView: UIViewRepresentable {
    let center: CLLocationCoordinate2D
    let places: [TouristPlace]
    let userLocation: CLLocationCoordinate2D?
    let onPlaceTapped: (TouristPlace) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(places: places, onTap: onPlaceTapped) }

    private func makeHTML() -> String {
        let lat = center.latitude
        let lng = center.longitude

        var markersJS = ""
        for place in places {
            let escaped = place.name.replacingOccurrences(of: "'", with: "\\'")
            markersJS += """
            addMarker(\(place.coordinate.latitude), \(place.coordinate.longitude), '\(escaped)', '\(place.emoji)', '\(place.id)');
            """
        }

        var userMarkerJS = ""
        if let ul = userLocation {
            userMarkerJS = "addUserMarker(\(ul.latitude), \(ul.longitude));"
        }

        return """
        <!DOCTYPE html><html>
        <head>
        <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no">
        <style>
          * { margin:0; padding:0; }
          html,body,#map { width:100%; height:100%; }
        </style>
        </head>
        <body>
        <div id="map"></div>
        <script>
        var map, markers = {};
        function initMap() {
          map = new google.maps.Map(document.getElementById('map'), {
            center: {lat:\(lat), lng:\(lng)},
            zoom: 5,
            mapTypeControl: false,
            streetViewControl: false,
            fullscreenControl: false,
            zoomControl: true,
            gestureHandling: 'greedy'
          });
          \(markersJS)
          \(userMarkerJS)
        }
        function addMarker(lat, lng, name, emoji, id) {
          var m = new google.maps.Marker({
            position: {lat:lat, lng:lng},
            map: map,
            title: name,
            label: { text: emoji, fontSize: '18px' },
            icon: {
              path: google.maps.SymbolPath.CIRCLE,
              scale: 20,
              fillColor: '#ffffff',
              fillOpacity: 1,
              strokeColor: '#534AB7',
              strokeWeight: 2
            }
          });
          m.addListener('click', function() {
            webkit.messageHandlers.placeTapped.postMessage(id);
          });
          markers[id] = m;
        }
        function addUserMarker(lat, lng) {
          new google.maps.Marker({
            position: {lat:lat, lng:lng},
            map: map,
            title: 'You are here',
            icon: {
              path: google.maps.SymbolPath.CIRCLE,
              scale: 10,
              fillColor: '#4285F4',
              fillOpacity: 1,
              strokeColor: '#ffffff',
              strokeWeight: 2
            }
          });
          map.setCenter({lat:lat, lng:lng});
          map.setZoom(12);
        }
        function updateUserLocation(lat, lng) {
          addUserMarker(lat, lng);
        }
        </script>
        <script async defer src="https://maps.googleapis.com/maps/api/js?key=YOUR_GOOGLE_MAPS_API_KEY&callback=initMap"></script>
        </body></html>
        """
    }

    func makeUIView(context: Context) -> WKWebView {
        let cfg = WKWebViewConfiguration()
        cfg.userContentController.add(context.coordinator, name: "placeTapped")

        let wv = WKWebView(frame: .zero, configuration: cfg)
        wv.navigationDelegate = context.coordinator
        wv.scrollView.isScrollEnabled = false
        wv.backgroundColor = .systemBackground
        wv.loadHTMLString(makeHTML(), baseURL: URL(string: "https://maps.googleapis.com"))
        return wv
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Update live location dot on the map
        if let ul = userLocation {
            let js = "if(typeof updateUserLocation==='function'){updateUserLocation(\(ul.latitude),\(ul.longitude));}"
            uiView.evaluateJavaScript(js, completionHandler: nil)
        }
    }

    // MARK: Coordinator
    final class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        let places: [TouristPlace]
        let onTap: (TouristPlace) -> Void
        init(places: [TouristPlace], onTap: @escaping (TouristPlace) -> Void) {
            self.places = places; self.onTap = onTap
        }
        func userContentController(_ ucc: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "placeTapped",
                  let idStr = message.body as? String,
                  let place = places.first(where: { $0.id.uuidString == idStr })
            else { return }
            DispatchQueue.main.async { self.onTap(place) }
        }
        func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            let scheme = action.request.url?.scheme?.lowercased() ?? ""
            if ["itms","itms-apps"].contains(scheme) { decisionHandler(.cancel); return }
            decisionHandler(.allow)
        }
    }
}

// MARK: - Apple Maps fallback

struct AppleMiniMap: View {
    let center: CLLocationCoordinate2D
    let places: [TouristPlace]
    let userLocation: CLLocationCoordinate2D?
    let onPlaceTapped: (TouristPlace) -> Void

    var body: some View {
        Map(initialPosition: .region(
            MKCoordinateRegion(center: center,
                               span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
        )) {
            ForEach(places) { place in
                Annotation(place.name, coordinate: place.coordinate) {
                    VStack(spacing: 2) {
                        Text(place.emoji)
                            .font(.system(size: 20)).padding(6)
                            .background(Color.white).clipShape(Circle()).shadow(radius: 2)
                        Text(place.name)
                            .font(.system(size: 9, weight: .medium)).foregroundColor(.white)
                            .padding(.horizontal, 5).padding(.vertical, 2)
                            .background(Color.black.opacity(0.6)).clipShape(Capsule())
                    }
                    .onTapGesture { onPlaceTapped(place) }
                }
            }
            if let ul = userLocation {
                Annotation("You", coordinate: ul) {
                    ZStack {
                        Circle().fill(Color.blue.opacity(0.2)).frame(width: 28, height: 28)
                        Circle().fill(Color.blue).frame(width: 14, height: 14)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }
                }
            }
        }
    }
}

// MARK: - Location Status Bar

struct LocationStatusBar: View {
    @ObservedObject var manager: LiveLocationManager

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "location.fill")
                .font(.system(size: 12))
                .foregroundColor(.blue)
            if manager.address.isEmpty {
                Text("Getting location…")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            } else {
                Text(manager.address)
                    .font(.system(size: 12))
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
            Spacer()
            Button { manager.stopTracking() } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Color.blue.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue.opacity(0.2), lineWidth: 1))
    }
}

// MARK: - Country chip (unchanged)

struct CountryChip: View {
    let country: PlaceCountry
    let isSelected: Bool
    let action: () -> Void
    private var accent: Color { Color(hex: country.colorHex) }
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(country.flag).font(.system(size: 16))
                Text(country.rawValue).font(.system(size: 13, weight: isSelected ? .medium : .regular))
            }
            .foregroundColor(isSelected ? .white : accent)
            .padding(.horizontal, 14).padding(.vertical, 8)
            .background(isSelected ? accent : accent.opacity(0.1))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Place row card (unchanged)

struct PlaceRowCard: View {
    let place: TouristPlace
    let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                AsyncImage(url: URL(string: place.photoURL)) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable().scaledToFill().frame(width: 80, height: 80).clipped()
                    default:
                        Rectangle().fill(Color(hex: place.country.colorHex).opacity(0.12))
                            .frame(width: 80, height: 80).overlay(Text(place.emoji).font(.system(size: 36)))
                    }
                }
                .frame(width: 80, height: 80).clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 5) {
                    Text(place.name).font(.system(size: 15, weight: .medium)).foregroundColor(.primary)
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill").font(.system(size: 11)).foregroundColor(Color(hex: place.country.colorHex))
                        Text(place.city).font(.system(size: 12)).foregroundColor(.secondary)
                    }
                    Text(place.type.rawValue).font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(hex: place.type.colorHex))
                        .padding(.horizontal, 8).padding(.vertical, 2)
                        .background(Color(hex: place.type.colorHex).opacity(0.1)).clipShape(Capsule())
                    Text(place.headline).font(.system(size: 12)).foregroundColor(.secondary).lineLimit(2)
                }
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 12)).foregroundColor(.secondary)
            }
            .padding(14).background(Color(.systemBackground)).clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.separator).opacity(0.35), lineWidth: 0.5))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Place detail sheet

struct PlaceDetailSheet: View {
    let place: TouristPlace
    let userLocation: CLLocationCoordinate2D?
    @Environment(\.dismiss) private var dismiss
    @State private var speechEngine = SpeechEngine()

    private var distanceText: String? {
        guard let ul = userLocation else { return nil }
        let from = CLLocation(latitude: ul.latitude, longitude: ul.longitude)
        let to   = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let km   = from.distance(from: to) / 1000
        if km < 1    { return "Less than 1 km away" }
        if km < 1000 { return String(format: "%.0f km away", km) }
        return String(format: "%.0f,000 km away", km / 1000)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    AsyncImage(url: URL(string: place.photoURL)) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable().scaledToFill().frame(height: 220).clipped()
                        default:
                            Rectangle().fill(Color(hex: place.country.colorHex).opacity(0.15))
                                .frame(height: 220).overlay(Text(place.emoji).font(.system(size: 80)))
                        }
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Text(place.country.flag + " " + place.city)
                                    .font(.system(size: 13)).foregroundColor(.secondary)
                                Spacer()
                                Text(place.type.rawValue).font(.system(size: 11, weight: .medium))
                                    .foregroundColor(Color(hex: place.type.colorHex))
                                    .padding(.horizontal, 8).padding(.vertical, 3)
                                    .background(Color(hex: place.type.colorHex).opacity(0.1)).clipShape(Capsule())
                            }
                            Text(place.name).font(.system(size: 24, weight: .bold))
                            Text(place.headline).font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color(hex: place.country.colorHex))
                            if let dist = distanceText {
                                Label(dist, systemImage: "location.fill")
                                    .font(.system(size: 12)).foregroundColor(.blue)
                            }
                        }

                        Divider()
                        Text(place.description).font(.system(size: 15)).lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)

                        Button { speechEngine.speak(place.headline + ". " + place.description) } label: {
                            Label("Hear about this place", systemImage: "speaker.wave.2")
                                .font(.system(size: 14)).foregroundColor(Color(hex: place.country.colorHex))
                        }
                        Divider()

                        Text("Quick Facts").font(.system(size: 14, weight: .medium)).foregroundColor(.secondary)
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                            ForEach(place.facts, id: \.label) { fact in
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(fact.label).font(.system(size: 11)).foregroundColor(.secondary)
                                    Text(fact.value).font(.system(size: 13, weight: .medium))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(12).background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }

                        Text("Location").font(.system(size: 14, weight: .medium)).foregroundColor(.secondary)
                        Map(initialPosition: .region(MKCoordinateRegion(
                            center: place.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        ))) {
                            Annotation(place.name, coordinate: place.coordinate) {
                                VStack(spacing: 2) {
                                    Text(place.emoji).font(.system(size: 28)).padding(8)
                                        .background(Color.white).clipShape(Circle()).shadow(radius: 3)
                                }
                            }
                            if let ul = userLocation {
                                Annotation("You", coordinate: ul) {
                                    ZStack {
                                        Circle().fill(Color.blue.opacity(0.2)).frame(width: 28, height: 28)
                                        Circle().fill(Color.blue).frame(width: 14, height: 14)
                                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    }
                                }
                            }
                        }
                        .frame(height: 180).clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(20)
                }
            }
            .navigationTitle(place.name).navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarLeading) { Button("Done") { dismiss() } } }
            .ignoresSafeArea(edges: .top)
        }
    }
}
