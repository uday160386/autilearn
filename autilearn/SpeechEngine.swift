import os
import AVFoundation

@Observable
class SpeechEngine: NSObject {
    private let synthesizer = AVSpeechSynthesizer()
    var isSpeaking = false

    override init() {
        super.init()
        synthesizer.delegate = self

        // Configure audio session for playback even on silent mode
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback, mode: .spokenAudio, options: .duckOthers
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            os_log(.error, "Audio session setup failed: %@", error.localizedDescription)
        }
    }

    /// Speak a single word — called on every symbol tap
    func speakSymbol(_ symbol: AACSymbol) {
        speak(symbol.word)
    }

    /// Speak the full sentence strip
    func speakSentence(_ symbols: [AACSymbol]) {
        guard !symbols.isEmpty else { return }
        let text = symbols.map(\.word).joined(separator: " ")
        speak(text)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }

    // MARK: - Internal (accessible to views that need to speak arbitrary strings)

    func speak(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)

        let utterance = AVSpeechUtterance(string: text)

        // Prefer a natural English voice — iOS 17+ has enhanced neural voices
        if let enhanced = AVSpeechSynthesisVoice.speechVoices().first(where: {
            $0.language.hasPrefix("en") && $0.quality == .enhanced
        }) {
            utterance.voice = enhanced
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                ?? AVSpeechSynthesisVoice(language: "en-US")
        }

        utterance.rate          = 0.42   // slower than default — clearer for ASD
        utterance.pitchMultiplier = 1.1  // friendlier tone
        utterance.volume        = 1.0
        utterance.preUtteranceDelay = 0.1

        isSpeaking = true
        synthesizer.speak(utterance)
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension SpeechEngine: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { self.isSpeaking = false }
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { self.isSpeaking = false }
    }
}
