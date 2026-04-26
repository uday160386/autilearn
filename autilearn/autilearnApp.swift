import SwiftUI
import SwiftData
import UIKit

@main
struct autilearnApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    let modelContainer: ModelContainer = {
        let schema = Schema([
            AACSymbol.self,
            EmotionAttempt.self,
            RewardToken.self,
            MathAttempt.self,
            RoutineTask.self,
            StarEntry.self,
            ChildProfile.self,
            MediaRecording.self,
            TimeSlot.self,
            VideoWatchRecord.self,
            Memory.self,
        ])
        let cfg = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do    { return try ModelContainer(for: schema, configurations: [cfg]) }
        catch { fatalError("ModelContainer failed: \(error)") }
    }()

    var body: some Scene {
        WindowGroup { RootView() }
            .modelContainer(modelContainer)
    }
}

// MARK: - Root view: splash → app + kiosk overlay

struct RootView: View {
    @State private var showSplash = true
    private var ga: GuidedAccessManager { GuidedAccessManager.shared }

    var body: some View {
        ZStack {
            // Main app (always in hierarchy so SwiftData context is ready)
            MainTabView()
                .opacity(showSplash ? 0 : 1)

            // Branded splash
            if showSplash {
                LaunchScreenView()
                    .transition(.opacity)
                    .zIndex(10)
            }

            // Kiosk lock — zIndex 999 ensures it sits above everything including sheets
            if ga.showUnlockOverlay {
                KioskLockOverlay(passcode: ga.parentPasscode) {
                    ga.showUnlockOverlay = false
                }
                .transition(.opacity)
                .zIndex(999)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: showSplash)
        .animation(.easeInOut(duration: 0.22), value: ga.showUnlockOverlay)
        .onAppear {
            AppForegroundEnforcer.shared.start()
            RemoteConfig.shared.load()
            VideoAvailabilityStore.shared.refresh()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                withAnimation { showSplash = false }
            }
        }
    }
}

// MARK: - App Delegate

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        return true
    }

    // Support all orientations on both iPhone and iPad
    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask { .all }

    // Block youtube://, vnd.youtube://, and itms:// from opening external apps.
    // WKWebView sometimes hands these to UIApplication before the navigation
    // delegate fires — intercepting here is the last line of defence.
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        let scheme = url.scheme?.lowercased() ?? ""
        let blocked = ["youtube", "itms", "itms-apps", "itms-services"]
        if blocked.contains(scheme) || scheme.hasPrefix("vnd.youtube") {
            return false   // silently ignore — video keeps playing in WKWebView
        }
        return true
    }
}
