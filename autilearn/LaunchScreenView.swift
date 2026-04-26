import SwiftUI

// MARK: - Branded splash screen shown for ~2 seconds on launch

struct LaunchScreenView: View {
    @State private var scale:   CGFloat = 0.72
    @State private var opacity: Double  = 0.0
    @State private var starScale: CGFloat = 0.5

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "3A37C9"), Color(hex: "12A07A")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Icon replica
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "3A37C9"), Color(hex: "12A07A")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 128, height: 128)
                        .shadow(color: .black.opacity(0.28), radius: 20, x: 0, y: 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1.5)
                        )

                    VStack(spacing: 2) {
                        Text("🧠").font(.system(size: 54))
                        Text("AL")
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(.white)
                    }
                }
                .scaleEffect(scale)
                .padding(.bottom, 28)

                // App name
                Text("AutiLearn")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("Learning made for every mind")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white.opacity(0.78))
                    .padding(.top, 6)

                // Stars
                HStack(spacing: 10) {
                    ForEach(0..<5, id: \.self) { i in
                        Text("⭐️")
                            .font(.system(size: i == 2 ? 22 : 15))
                            .scaleEffect(starScale)
                            .animation(
                                .spring(response: 0.5, dampingFraction: 0.55)
                                    .delay(Double(i) * 0.06 + 0.3),
                                value: starScale
                            )
                    }
                }
                .padding(.top, 20)
            }
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.68)) {
                scale   = 1.0
                opacity = 1.0
            }
            withAnimation { starScale = 1.0 }
        }
    }
}
