//
//  ProgressViewModel.swift
//  discoverMendelu
//
//  Created by Macek<3 on 30.05.2025.
//


import SwiftUI
import CoreLocation

@Observable
class ProgressViewModel: ObservableObject {
    var showProgressAlert = false
    var state: ProgressViewState = ProgressViewState()
    
    private var dataManager: DataManaging

    
    init() {
        dataManager = DIContainer.shared.resolve()
    }
}

extension ProgressViewModel {
    func fetchBadges() {
        let bdg: [Badge] = dataManager.fetchBadges()
        state.unlockedLocationCount = dataManager.countUnlockedLocations()
        state.unlockedBadgesCount = dataManager.countUnlockedBadges()
        
        state.badges = bdg.map {
            let image: UIImage
            
            if let storedImageData = $0.image {
                image = UIImage(data: storedImageData) ?? UIImage()
            } else {
                image = UIImage()
            }
            
            return BadgeModel(
                id: $0.id ?? UUID(),
                name: $0.name ?? "No named bagde",
                locked: $0.locked,
                image: image,
                hasAnimated: $0.hasAnimated)
        }
    }
    func markBadgeAnimated(id: UUID) {
        if let badge = dataManager.fetchBadgeWithId(id: id) {
            badge.hasAnimated = true
            
            if let index = state.badges.firstIndex(where: { $0.id == id }) {
                state.badges[index].hasAnimated = true
            }
            

            dataManager.saveBadge(badge: badge)
        } else {
            print("Badge with id \(id) not found")
        }
    }
    
    func checkIfShouldShowProgressAlert() {
        let lastShown = UserDefaults.standard.object(forKey: "progressAlertShownDate") as? Date
        let isNewDay = lastShown == nil || !Calendar.current.isDateInToday(lastShown!)
        showProgressAlert = isNewDay
    }

    func saveProgressAlertDate() {
        UserDefaults.standard.set(Date(), forKey: "progressAlertShownDate")
    }
}
