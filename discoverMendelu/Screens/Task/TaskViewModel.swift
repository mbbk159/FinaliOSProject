//
//  TaskViewModel.swift
//  discoverMendelu
//
//  Created by Macek<3 on 30.05.2025.
//

import SwiftUI
import CoreLocation
import Combine
import AVFoundation

@Observable
class TaskViewModel: ObservableObject {
    var state: TaskViewState
    private var dataManager: DataManaging
    private var speechRecorder: SpeechRecordingManaging
    private var motingDetector: MotionManaging
    
    private var maxPower: Float = -160
    
    private var recordingTimer: Timer?
    private var recordingDuration: TimeInterval = 0
    
    private var cancellables = Set<AnyCancellable>()
    var audioPlayer: AVAudioPlayer?
    var answerIsCorrect = false
    var userAnswered = false
    
    
    init(location: LocationInfo) {
        dataManager = DIContainer.shared.resolve()
        speechRecorder = DIContainer.shared.resolve()
        motingDetector = DIContainer.shared.resolve()
        state = TaskViewState(locationInfo: location)
        
        motingDetector.dataPublisher
            .sink { [weak self] newData in
                self?.state.detectedMotionValues = newData
            }
            .store(in: &cancellables)
    }
    
    
    func startRecording() {
        guard !state.isRecording else { return }
        speechRecorder.startRecording()
        recordingDuration = 0
        maxPower = -160
        
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.speechRecorder.updateMeters()
            let currentPower = self.speechRecorder.averagePower()
            if currentPower > self.maxPower {
                self.maxPower = currentPower
            }
        }
        
        state.isRecording = true
        state.recordingFinished = false
    }
    
    func stopRecording() {
        guard state.isRecording else { return }
        speechRecorder.stopRecording()
        recordingTimer?.invalidate()
        recordingTimer = nil
        state.isRecording = false
        
        if maxPower > -15 {
            print("User spoke, max power: \(maxPower)")
            state.spoke = true
        } else {
            print("User did not speak or recording was silent")
            state.spoke = false
        }
        state.recordingFinished = true
    }
    
    func startDetection(){
        state.movementPraying = false
        state.movementDrinking = false
        motingDetector.startDetection()
    }
    
    func stopDetection(){
        motingDetector.stopDetection()
        determinePraying()
    }
    
    func determineSpeaking(){
        userAnswered = true
        print("spoke \(state.spoke)")
        if (state.spoke){
            answerIsCorrect = true
        }else {
            answerIsCorrect = false
        }
        playAnswerSound()
    }
    func determinePraying(){
        userAnswered = true
        if (state.movementPraying){
            answerIsCorrect = false
        }else {
            answerIsCorrect = true
        }
        playAnswerSound()
    }
    func determineDrining(){
        userAnswered = true
        if (state.movementDrinking){
            answerIsCorrect = true
        }else {
            answerIsCorrect = false
        }
        playAnswerSound()
    }
}

extension TaskViewModel {
    func unlockLocation(){
        if let poi = dataManager.fetchLockedPlace(){
            poi.locked = false
            dataManager.savePlace(place: poi)
        }else{
            print("Location not found")
        }
    }
    
    func changeLocationStatus(){
        if let poi = dataManager.fetchPlaceWithId(id: state.locationInfo.id) {
            poi.completed = true
            dataManager.savePlace(place: poi)
        }else{
            print("Location not found")
        }
    }
    
    func changeBadgesStatus(){
        let count = dataManager.countUnlockedLocations()
        if let bdg = dataManager.fetchLockedBadge(){
            if (count == 3 || count == 4 || count == 6 || count == 7 || count == 8 || count == 11 || count == 12 || count == 14){
                bdg.locked = false
                dataManager.saveBadge(badge: bdg)
            }
        }
    }
    
    func handleUnlockAndProgress() -> String? {
        let previousBadgeCount = dataManager.countUnlockedBadges()
        let previousLevel = getLevelName(for: previousBadgeCount)

        changeBadgesStatus()
        changeLocationStatus()
        unlockLocation()

        let newBadgeCount = dataManager.countUnlockedBadges()
        let newLevel = getLevelName(for: newBadgeCount)

        let earnedNewBadge = newBadgeCount > previousBadgeCount
        let leveledUp = newLevel != previousLevel

        if earnedNewBadge && leveledUp {
            playSound(named: "progress")
            return "You have become \(newLevel) and earned a new badge."
        } else if earnedNewBadge {
            playSound(named: "progress")
            return "You have earned a new badge."
        } else {
            return nil
        }
    }

    private func getLevelName(for count: Int) -> String {
        switch count {
        case 2, 3:
            return "an Explorer"
        case 4, 5:
            return "a Green Guru"
        case 6, 7:
            return "a Mendeler Pro"
        case 8:
            return "a Legend of the Campus"
        default:
            return "a Seedling"
        }
    }
    
    func playAnswerSound() {
        if answerIsCorrect {
            DispatchQueue.main.async {
                self.playSound(named: "correct")
            }
        }else{
            DispatchQueue.main.async {
                self.playSound(named: "incorrect")
            }
        }
        print(answerIsCorrect)
    }
    
    func playSound(named name: String) {
           guard let soundURL = Bundle.main.url(forResource: name, withExtension: "mp3") else {
               print("Sound file not found.")
               return
           }
           do {
               audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
               audioPlayer?.play()
           } catch {
               print("Failed to play sound: \(error.localizedDescription)")
           }
       }

}
