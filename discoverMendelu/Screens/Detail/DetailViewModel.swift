//
//  DetailViewModel.swift
//  discoverMendelu
//
//  Created by Macek<3 on 29.05.2025.
//

import SwiftUI
import CoreLocation

@Observable
class DetailViewModel: ObservableObject {
    var state: DetailViewState
    private var dataManager: DataManaging
    private var textToSpeachManager: TextToSpeechManaging

    init(location: LocationInfo) {
        dataManager = DIContainer.shared.resolve()
        textToSpeachManager = DIContainer.shared.resolve()
        state = DetailViewState(locationInfo: location)
        textToSpeachManager.onFinishedSpeaking = {
            print("Finished speaking")
            self.state.reading = false
            self.state.paused = false
            print(self.state.reading)
        }
    }
    
    func changeScanToTrue(){
        if let poi = dataManager.fetchPlaceWithId(id: state.locationInfo.id){
            state.locationInfo.qrScanned = true
            poi.qrScanned = true
            poi.id = state.locationInfo.id // id of the PoI and MapPlace must be the same!
            poi.name = state.locationInfo.name
            poi.image = state.locationInfo.image.jpegData(compressionQuality: 90)
            poi.latitude = state.locationInfo.coordinates.latitude
            poi.longitude = state.locationInfo.coordinates.longitude
            poi.story = state.locationInfo.story
            poi.question = state.locationInfo.question
            poi.qrScanText = state.locationInfo.qrScanText
            dataManager.savePlace(place: poi)
        }else{
            print("Hledám id: \(state.locationInfo.id)")
            print("V databázi mám: \(dataManager.fetchPlaces().map { $0.id })")
            print("Location not found")
        }
    }
    
    func read(){
        textToSpeachManager.speak(state.locationInfo.story)
        state.reading = true
        state.paused = false
        print("Reading...")
    }
    
    func stopReading(){
        textToSpeachManager.stopSpeaking()
        state.reading = false
        state.paused = false
        print("Stopped")
    }
    
    func pauseReading(){
        textToSpeachManager.pauseSpeaking()
        state.reading = false
        state.paused = true
        print("Paused")
    }
    
    func continueReading(){
        textToSpeachManager.continueSpeaking()
        state.paused = false
        state.reading = true
        print("Continuing...")
    }
}

