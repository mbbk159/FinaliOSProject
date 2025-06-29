//
//  LocationInfoViewModel.swift
//  discoverMendelu
//
//  Created by Macek<3 on 29.05.2025.
//

import SwiftUI
import CoreLocation

@Observable
class LocationInfoViewModel: ObservableObject {
    var showStartupAlert = false
    var state: LocationInfoViewState = LocationInfoViewState()
    
    
    
    var currentLevel: (String) {
        switch  dataManager.countUnlockedBadges() {
        case 2, 3:
            return ("Explorer")
        case 4, 5:
            return ("Green Guru")
        case 6, 7:
            return ("Mendeler Pro")
        case 8:
            return ("Legend of the Campus")
        default:
            return ("Seedling")
        }
    }
    
    private var dataManager: DataManaging
    private var locationManager: LocationManaging
    private var periodicUpdatesRunning = false      // for periodic updates of location

    
    init() {
        dataManager = DIContainer.shared.resolve()
        locationManager = DIContainer.shared.resolve()
    }
    
    func addNewPlace(locationInfo: LocationInfo) {
        let poi = PointOfInterest(context: dataManager.context)
        
        poi.id = locationInfo.id // id of the PoI and MapPlace must be the same!
        poi.name = locationInfo.name
        poi.image = locationInfo.image.jpegData(compressionQuality: 90)
        poi.latitude = locationInfo.coordinates.latitude
        poi.longitude = locationInfo.coordinates.longitude
        poi.story = locationInfo.story
        poi.question = locationInfo.question
        
        dataManager.savePlace(place: poi)
    }
    
    func fetchLocations() {
        let pois: [PointOfInterest] = dataManager.fetchPlaces()
        
        state.locations = pois.map {
            let image: UIImage
            
            if let storedImageData = $0.image {
                image = UIImage(data: storedImageData) ?? UIImage()
            } else {
                image = UIImage()
            }

            
            return LocationInfo(
                id: $0.id ?? UUID(),
                name: $0.name ?? "No name found.",
                image: image,
                coordinates: .init(latitude: $0.latitude, longitude: $0.longitude ),
                story: $0.story ?? "No story found.",
                question: $0.question ?? "No question found.",
                locked: $0.locked,
                qrScanned: $0.qrScanned,
                answers: ($0.answer as? Set<Answer> ?? []).map { answer in
                    AnswerModel(
                        id: answer.id ?? UUID(),
                        text: answer.text ?? "",
                        correct: answer.correct
                    )
                },
                completed: $0.completed,
                hasAnimated: $0.hasAnimated,
                qrScanText: $0.qrScanText ?? ""
            )
        }
    }
    
    func loadDataIfNeeded() {
        dataManager.loadDataIfNeeded()
    }
    
    func syncLocation() {
        state.mapCameraPosition = locationManager.cameraPosition
        state.currentLocation = locationManager.currentLocation
    }

    func startPeriodicLocationUpdate() async {
        if !periodicUpdatesRunning {
            periodicUpdatesRunning.toggle()
            
            while true {
                try? await Task.sleep(nanoseconds: 4_000_000_000)
                syncLocation()
            }
        }
    }
    
    func markLocationAnimated(id: UUID) {
        if let location = dataManager.fetchPlaceWithId(id: id) {
            location.hasAnimated = true
            
            // Update any in-memory state if needed:
            if let index = state.locations.firstIndex(where: { $0.id == id }) {
                state.locations[index].hasAnimated = true
            }
            
            // Save the updated place persistently
            dataManager.savePlace(place: location)
        } else {
            print("Location with id \(id) not found")
        }
    }
    
    func checkIfShouldShowStartupAlert() {
        let lastShown = UserDefaults.standard.object(forKey: "startupAlertShownDate") as? Date
        let isNewDay = lastShown == nil || !Calendar.current.isDateInToday(lastShown!)
        showStartupAlert = isNewDay
    }

    func saveStartupAlertDate() {
        UserDefaults.standard.set(Date(), forKey: "startupAlertShownDate")
    }

}
