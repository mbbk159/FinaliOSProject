//
//  SpeechRecorderManager.swift
//  discoverMendelu
//
//  Created by HlavMac on 16.06.2025.
//

import AVFoundation

final class SpeechRecordingManager: NSObject, SpeechRecordingManaging {
    private var audioRecorder: AVAudioRecorder?
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true)
            
            let url = getDocumentsDirectory().appendingPathComponent("recording.m4a")
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
        } catch {
            print("Failed to start recording: \(error)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setActive(false) // Deactivate recording session
            try audioSession.setCategory(.playback, mode: .default) // Allow sound playback
            try audioSession.setActive(true)
        } catch {
            print("Failed to switch audio session: \(error)")
        }
    }

    func updateMeters() {
        audioRecorder?.updateMeters()
    }

    func averagePower() -> Float {
        return audioRecorder?.averagePower(forChannel: 0) ?? -160
    }

    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
