import SwiftUI
import AVFoundation

/// Bridges AVCaptureVideoPreviewLayer into SwiftUI
struct CameraPreviewView: UIViewRepresentable {
    let engine: FaceDetectionEngine

    func makeUIView(context: Context) -> PreviewUIView {
        let view = PreviewUIView()
        view.backgroundColor = .black
        return view
    }

    func updateUIView(_ uiView: PreviewUIView, context: Context) {
        if let layer = engine.previewLayer {
            uiView.setPreviewLayer(layer)
        }
    }

    class PreviewUIView: UIView {
        private var previewLayer: AVCaptureVideoPreviewLayer?

        func setPreviewLayer(_ layer: AVCaptureVideoPreviewLayer) {
            guard layer !== previewLayer else { return }
            previewLayer?.removeFromSuperlayer()
            previewLayer = layer
            layer.frame = bounds
            self.layer.insertSublayer(layer, at: 0)
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            previewLayer?.frame = bounds
        }
    }
}

/// Animated face overlay — shows detected face landmarks as a gentle guide ring
struct FaceOverlayView: View {
    let faceDetected: Bool
    let emotion: Emotion?
    @State private var pulse = false

    var body: some View {
        ZStack {
            // Guide ring — pulses green when face is detected
            Circle()
                .stroke(
                    faceDetected
                        ? (emotion != nil ? emotion!.color : Color(hex: "#1D9E75"))
                        : Color.white.alpha(0.3),
                    lineWidth: faceDetected ? 3 : 1.5
                )
                .scaleEffect(pulse ? 1.04 : 1.0)
                .animation(
                    faceDetected
                        ? .easeInOut(duration: 1.2).repeatForever(autoreverses: true)
                        : .default,
                    value: pulse
                )
                .padding(20)

            if !faceDetected {
                VStack(spacing: 8) {
                    Image(systemName: "face.dashed")
                        .font(.system(size: 32))
                        .foregroundColor(.white.alpha(0.7))
                    Text("Position your face here")
                        .font(.system(size: 13))
                        .foregroundColor(.white.alpha(0.7))
                }
            }
        }
        .onAppear { pulse = true }
    }
}
