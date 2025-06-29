//
//  DataManaging.swift
//  discoverMendelu
//
//  Created by Macek<3 on 29.05.2025.
//

import CoreData
import UIKit

protocol DataManaging {
    var context: NSManagedObjectContext { get }
    
    func savePlace(place: PointOfInterest)
    func saveBadge(badge: Badge)
    func removePlace(place: PointOfInterest)
    func fetchPlaces() -> [PointOfInterest]
    func fetchPlaceWithId(id: UUID) -> PointOfInterest?
    func fetchLockedPlace() -> PointOfInterest?
    func fetchLockedBadge() -> Badge?
    func fetchBadges() -> [Badge]
    func fetchBadgeWithId(id: UUID) -> Badge?
    func countUnlockedLocations() -> Int
    func countUnlockedBadges() -> Int
//    func fetchAnswersForLocation(location: LocationInfo) -> [Answer]
    
    func loadDataIfNeeded()
}

extension DataManaging {
    func loadDataIfNeeded() {
        if !UserDefaults.standard.isInitialDataLoaded {
            loadDataFromJSON()
            loadBadgesFromJSON()
            UserDefaults.standard.isInitialDataLoaded = true
            print("Sample data loaded from JSON.")
        } else {
            print("Data already loaded. Skipping JSON import.")
        }
    }

    
    func loadDataFromJSON() {
        guard let url = Bundle.main.url(forResource: "BaseData", withExtension: "json") else {
            print("❌ JSON soubor nebyl nalezen v bundlu.")
            return
        }

        guard let data = try? Data(contentsOf: url) else {
            print("❌ Nepodařilo se načíst data ze souboru.")
            return
        }

        do {
            let pointDataList = try JSONDecoder().decode([BaseDataDecode].self, from: data)

            for pointData in pointDataList {
                let point = PointOfInterest(context: context)
                point.id = UUID()
                point.name = pointData.name
                point.latitude = pointData.latitude
                point.longitude = pointData.longitude
                point.image = UIImage(named: pointData.imageName)?.jpegData(compressionQuality: 0.9)
                point.story = pointData.story
                print(pointData.story)
                point.question = pointData.question
                point.locked = pointData.locked
                point.qrScanned = pointData.qrScanned
                point.completed = pointData.completed
                point.hasAnimated = pointData.hasAnimated
                point.qrScanText = pointData.qrScanText

                // Uložení odpovědí (Answer) s vazbou na PointOfInterest
                for answerData in pointData.answers {
                    let answer = Answer(context: context)
                    answer.id = UUID()
                    answer.text = answerData.text
                    answer.correct = answerData.correct
                    answer.pointOfInterest = point
                }

                // Uložení bodu zájmu i s odpověďmi
                do {
                    try context.save()
                    print("✅ Uloženo: \(point.name ?? "Neznámý název")")
                } catch {
                    print("❌ Chyba při ukládání: \(error.localizedDescription)")
                }
            }

        } catch {
            print("❌ Chyba při dekódování JSON: \(error.localizedDescription)")
        }
    }
 
    func loadBadgesFromJSON() {
        guard let url = Bundle.main.url(forResource: "BadgeData", withExtension: "json") else {
            print("❌ Badge JSON soubor nebyl nalezen v bundlu.")
            return
        }

        guard let data = try? Data(contentsOf: url) else {
            print("❌ Nepodařilo se načíst badge data ze souboru.")
            return
        }

        do {
            let badgeList = try JSONDecoder().decode([BadgeDecode].self, from: data)

            for badgeData in badgeList {
                let badge = Badge(context: context)
                badge.id = UUID()
                badge.name = badgeData.name
                badge.image = UIImage(named: badgeData.image)?.jpegData(compressionQuality: 0.9)
                badge.locked = badgeData.locked
                badge.hasAnimated = badgeData.hasAnimated

                do {
                    try context.save()
                    print("✅ Badge uloženo: \(badge.name ?? "Neznámý badge")")
                } catch {
                    print("❌ Chyba při ukládání badge: \(error.localizedDescription)")
                }
            }
        } catch {
            print("❌ Chyba při dekódování badge JSON: \(error.localizedDescription)")
        }
    }


}
