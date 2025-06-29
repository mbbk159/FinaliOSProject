//
//  TextToSpeachManaging.swift
//  discoverMendelu
//
//  Created by HlavMac on 13.06.2025.
//

import AVFoundation

protocol TextToSpeechManaging {
    func speak(_ text: String)
    func stopSpeaking()
    func pauseSpeaking()
    func continueSpeaking()
    var onFinishedSpeaking: (() -> Void)? { get set }
}
