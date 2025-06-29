//
//  SpeechRecorderManaging.swift
//  discoverMendelu
//
//  Created by HlavMac on 16.06.2025.
//

protocol SpeechRecordingManaging {
    func startRecording()
    func stopRecording()
    func updateMeters()
    func averagePower() -> Float
}
