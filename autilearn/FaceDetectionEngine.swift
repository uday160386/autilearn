import AVFoundation
import Vision
import SwiftUI
import Combine

// MARK: - Detected face state
struct FaceState {
    var smileIntensity: Float  = 0
    var eyeOpenLeft: Float     = 1
    var eyeOpenRight: Float    = 1
    var browRaiseLeft: Float   = 0
    var browRaiseRight: Float  = 0
    var jawOpen: Float         = 0
    var faceDetected: Bool     = false

    var inferredEmotion: Emotion? {
        guard faceDetected else { return nil }
        if smileIntensity > 0.55 && eyeOpenLeft > 0.4                          { return .happy     }
        if jawOpen > 0.45 && (eyeOpenLeft > 0.75 || browRaiseLeft > 0.4)       { return .surprised }
        if smileIntensity < 0.15 && eyeOpenLeft > 0.75 && browRaiseLeft > 0.3  { return .scared    }
        if smileIntensity < 0.2  && eyeOpenLeft < 0.45                          { return .sad       }
        if smileIntensity < 0.2  && eyeOpenLeft > 0.4 && browRaiseLeft < 0.15  { return .angry     }
        if smileIntensity < 0.35 && eyeOpenLeft > 0.3 && eyeOpenLeft < 0.7     { return .calm      }
        return nil
    }
}

// MARK: - Camera + Vision pipeline

@Observable
final class FaceDetectionEngine: NSObject {

    var faceState         = FaceState()
    var previewLayer      : AVCaptureVideoPreviewLayer?
    var isRunning         = false
    var permissionDenied  = false
    /// True on simulator or any device without a front camera
    var noCameraAvailable = false

    private let smoothingWindow = 8
    private var smileBuffer   : [Float] = []
    private var eyeLeftBuffer : [Float] = []
    private var eyeRightBuffer: [Float] = []
    private var jawBuffer     : [Float] = []
    private var browBuffer    : [Float] = []

    private let session     = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let visionQueue = DispatchQueue(label: "com.auticompanion.vision", qos: .userInteractive)
    private var faceRequest: VNDetectFaceLandmarksRequest!

    override init() {
        super.init()
        faceRequest = VNDetectFaceLandmarksRequest { [weak self] req, _ in
            self?.handleFaceResults(req)
        }
        // Leave revision at default — Vision picks the best available on device
    }

    // MARK: - Lifecycle

    func start() {
        #if targetEnvironment(simulator)
        // Simulator has no real camera — show placeholder UI instead of crashing
        DispatchQueue.main.async { self.noCameraAvailable = true }
        #else
        Task {
            let granted = await requestCameraPermission()
            guard granted else {
                await MainActor.run { self.permissionDenied = true }
                return
            }
            await MainActor.run { self.setupSession() }
        }
        #endif
    }

    func stop() {
        #if !targetEnvironment(simulator)
        session.stopRunning()
        #endif
        isRunning = false
    }

    // MARK: - Setup (real device only)

    private func setupSession() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            noCameraAvailable = true
            return
        }
        guard let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else { return }

        session.beginConfiguration()
        session.sessionPreset = .medium
        session.addInput(input)

        videoOutput.setSampleBufferDelegate(self, queue: visionQueue)
        videoOutput.alwaysDiscardsLateVideoFrames = true
        if session.canAddOutput(videoOutput) { session.addOutput(videoOutput) }

        if let conn = videoOutput.connection(with: .video) {
            conn.automaticallyAdjustsVideoMirroring = false
            conn.isVideoMirrored = true
        }
        session.commitConfiguration()

        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        layer.connection?.automaticallyAdjustsVideoMirroring = false
        layer.connection?.isVideoMirrored = true
        previewLayer = layer

        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
            DispatchQueue.main.async { self.isRunning = true }
        }
    }

    // MARK: - Vision results

    private func handleFaceResults(_ request: VNRequest) {
        guard let results = request.results as? [VNFaceObservation],
              let face = results.first else {
            DispatchQueue.main.async { self.faceState.faceDetected = false }
            return
        }
        let smile = face.landmarks?.innerLips != nil ? estimateSmile(face) : 0
        let eyeL  = face.leftEyeOpenness
        let eyeR  = face.rightEyeOpenness
        let jaw   = face.landmarks?.outerLips != nil ? estimateJawOpen(face) : 0
        let brow  = estimateBrowRaise(face)

        let sSmile = smooth(&smileBuffer,    value: smile)
        let sEyeL  = smooth(&eyeLeftBuffer,  value: eyeL)
        let sEyeR  = smooth(&eyeRightBuffer, value: eyeR)
        let sJaw   = smooth(&jawBuffer,      value: jaw)
        let sBrow  = smooth(&browBuffer,     value: brow)

        DispatchQueue.main.async {
            self.faceState = FaceState(
                smileIntensity: sSmile, eyeOpenLeft: sEyeL, eyeOpenRight: sEyeR,
                browRaiseLeft: sBrow, browRaiseRight: sBrow, jawOpen: sJaw, faceDetected: true
            )
        }
    }

    // MARK: - Landmark geometry helpers

    private func estimateSmile(_ face: VNFaceObservation) -> Float {
        guard let lips = face.landmarks?.outerLips else { return 0 }
        let pts = lips.normalizedPoints
        guard pts.count >= 8 else { return 0 }
        let leftCorner  = pts[0]
        let rightCorner = pts[pts.count / 2]
        let topMid      = pts[pts.count / 4]
        let cornerAvgY  = (leftCorner.y + rightCorner.y) / 2
        return max(0, min(1, Float(cornerAvgY - topMid.y) * 6 + 0.3))
    }

    private func estimateJawOpen(_ face: VNFaceObservation) -> Float {
        guard let outer = face.landmarks?.outerLips else { return 0 }
        let pts = outer.normalizedPoints
        guard pts.count >= 6 else { return 0 }
        let topY    = pts.map(\.y).max() ?? 0
        let bottomY = pts.map(\.y).min() ?? 0
        return Float(min(1, (topY - bottomY) * 5))
    }

    private func estimateBrowRaise(_ face: VNFaceObservation) -> Float {
        guard let leftBrow = face.landmarks?.leftEyebrow,
              let leftEye  = face.landmarks?.leftEye else { return 0 }
        let browY = leftBrow.normalizedPoints.map(\.y).max() ?? 0
        let eyeY  = leftEye.normalizedPoints.map(\.y).max()  ?? 0
        return Float(min(1, max(0, (browY - eyeY) * 8)))
    }

    private func smooth(_ buffer: inout [Float], value: Float) -> Float {
        buffer.append(value)
        if buffer.count > smoothingWindow { buffer.removeFirst() }
        return buffer.reduce(0, +) / Float(buffer.count)
    }

    private func requestCameraPermission() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:          return true
        case .notDetermined:       return await AVCaptureDevice.requestAccess(for: .video)
        case .denied, .restricted: return false
        @unknown default:          return false
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension FaceDetectionEngine: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                            orientation: .leftMirrored, options: [:])
        try? handler.perform([faceRequest])
    }
}

// MARK: - VNFaceObservation helpers
extension VNFaceObservation {
    var leftEyeOpenness: Float {
        guard let eye = landmarks?.leftEye else { return 0.5 }
        let pts = eye.normalizedPoints
        guard pts.count >= 4,
              let maxY = pts.map(\.y).max(),
              let minY = pts.map(\.y).min() else { return 0.5 }
        return Float(min(1, abs(maxY - minY) * 12))
    }

    var rightEyeOpenness: Float {
        guard let eye = landmarks?.rightEye else { return 0.5 }
        let pts = eye.normalizedPoints
        guard pts.count >= 4,
              let maxY = pts.map(\.y).max(),
              let minY = pts.map(\.y).min() else { return 0.5 }
        return Float(min(1, abs(maxY - minY) * 12))
    }
}
