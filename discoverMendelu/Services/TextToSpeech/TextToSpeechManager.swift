import AVFoundation

final class TextToSpeechManager: NSObject, TextToSpeechManaging {
    
    private let synthesizer = AVSpeechSynthesizer()
    var onFinishedSpeaking: (() -> Void)?
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }

    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    func pauseSpeaking() {
        synthesizer.pauseSpeaking(at: .immediate)
    }
    
    func continueSpeaking() {
        synthesizer.continueSpeaking()
    }
}

extension TextToSpeechManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.onFinishedSpeaking?()
        }
    }
}
