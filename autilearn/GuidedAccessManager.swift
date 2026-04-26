import SwiftUI
import UIKit

// MARK: - Guided Access / Kiosk Mode Manager
// Prevents child from leaving AutiLearn while using the app.
// Three protection layers:
//   1. KioskLockOverlay  – full-screen PIN pad (cannot be dismissed without passcode)
//   2. UIRequiresFullScreen – blocks iPad Slide Over / Split View (set in Info.plist)
//   3. iOS Guided Access – OS-level triple-click lock (parents set up in Settings)

@Observable
final class GuidedAccessManager {

    static let shared = GuidedAccessManager()

    /// Whether the iOS Guided Access session is currently active
    var isGuidedAccessEnabled: Bool = UIAccessibility.isGuidedAccessEnabled

    /// 4-digit passcode parents use to unlock. Stored in memory only.
    var parentPasscode: String = "1234"

    /// Set to true to show the full-screen KioskLockOverlay
    var showUnlockOverlay: Bool = false

    private var observer: NSObjectProtocol?

    private init() {
        observer = NotificationCenter.default.addObserver(
            forName: UIAccessibility.guidedAccessStatusDidChangeNotification,
            object: nil, queue: .main
        ) { [weak self] _ in
            self?.isGuidedAccessEnabled = UIAccessibility.isGuidedAccessEnabled
        }
    }

    deinit {
        if let o = observer { NotificationCenter.default.removeObserver(o) }
    }

    func requestGuidedAccessEnable() {
        UIAccessibility.requestGuidedAccessSession(enabled: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.isGuidedAccessEnabled = UIAccessibility.isGuidedAccessEnabled
            }
        }
    }

    func requestGuidedAccessDisable() {
        UIAccessibility.requestGuidedAccessSession(enabled: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.isGuidedAccessEnabled = UIAccessibility.isGuidedAccessEnabled
            }
        }
    }
}

// MARK: - App Foreground Enforcer

final class AppForegroundEnforcer {
    static let shared = AppForegroundEnforcer()
    private var active = false
    private var tokens: [NSObjectProtocol] = []
    private init() {}

    func start() {
        guard !active else { return }
        active = true
        // Keep screen on at all times while app is in use
        UIApplication.shared.isIdleTimerDisabled = true
    }
    func stop() {
        active = false
        UIApplication.shared.isIdleTimerDisabled = false
        tokens.forEach { NotificationCenter.default.removeObserver($0) }
        tokens.removeAll()
    }
}

// MARK: - Kiosk Lock Overlay
// Full-screen PIN entry. Nothing beneath is tappable.
// The child cannot exit without entering the correct 4-digit passcode.

struct KioskLockOverlay: View {
    let passcode: String
    let onUnlock: () -> Void

    @State private var entered   = ""
    @State private var shake: CGFloat = 0
    @State private var errorMsg  = ""

    var body: some View {
        ZStack {
            // Blurred + dimmed backdrop — content hidden on app switcher
            Rectangle().fill(.ultraThinMaterial).ignoresSafeArea()
            Color.black.opacity(0.65).ignoresSafeArea()

            VStack(spacing: 36) {

                // Lock icon + heading
                VStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "534AB7").opacity(0.30))
                            .frame(width: 96, height: 96)
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 46))
                            .foregroundColor(.white)
                    }
                    Text("AutiLearn is locked")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                    Text("Ask a parent or carer to unlock")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.72))
                }

                // PIN dots
                HStack(spacing: 22) {
                    ForEach(0..<4, id: \.self) { i in
                        Circle()
                            .fill(i < entered.count ? Color.white : Color.white.opacity(0.28))
                            .frame(width: 22, height: 22)
                            .scaleEffect(i < entered.count ? 1.2 : 1.0)
                            .animation(.spring(response: 0.18, dampingFraction: 0.55), value: entered.count)
                    }
                }
                .offset(x: shake)

                // Error label
                if !errorMsg.isEmpty {
                    Text(errorMsg)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "FF6B6B"))
                        .transition(.opacity.combined(with: .scale))
                }

                // Number pad  ─ 3×3 + bottom row
                let rows = [[1,2,3],[4,5,6],[7,8,9]]
                VStack(spacing: 16) {
                    ForEach(rows, id: \.self) { row in
                        HStack(spacing: 20) {
                            ForEach(row, id: \.self) { d in PinButton(digit: d, onTap: { append(d) }) }
                        }
                    }
                    HStack(spacing: 20) {
                        Color.clear.frame(width: 80, height: 80)
                        PinButton(digit: 0, onTap: { append(0) })
                        Button { if !entered.isEmpty { entered.removeLast(); errorMsg = "" } } label: {
                            ZStack {
                                Circle().fill(Color.white.opacity(0.12)).frame(width: 80, height: 80)
                                Image(systemName: "delete.left").font(.system(size: 24)).foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 44)
        }
        .allowsHitTesting(true)   // absorbs ALL touches — nothing passes through
        .onTapGesture { }         // extra safety
    }

    private func append(_ digit: Int) {
        guard entered.count < 4 else { return }
        errorMsg = ""
        entered.append(String(digit))
        if entered.count == 4 { verify() }
    }

    private func verify() {
        if entered == passcode {
            withAnimation(.easeOut(duration: 0.3)) { onUnlock() }
        } else {
            withAnimation {
                errorMsg = "Wrong passcode — try again"
                shake = 14
            }
            withAnimation(.interpolatingSpring(stiffness: 300, damping: 10).delay(0.05)) {
                shake = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                entered = ""
            }
        }
    }
}

private struct PinButton: View {
    let digit: Int; let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle().fill(Color.white.opacity(0.14)).frame(width: 80, height: 80)
                Text("\(digit)").font(.system(size: 32, weight: .light)).foregroundColor(.white)
            }
        }.buttonStyle(.plain)
    }
}
