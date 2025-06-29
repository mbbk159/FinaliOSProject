//
//  CoreDataManager.swift
//  discoverMendelu
//
//  Created by Macek<3 on 29.05.2025.
//

import CoreData
import UIKit

final class CoreDataManager: DataManaging {
    private let container = NSPersistentContainer(name: "discoverMendelu")
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Cannot create persistent store: \(error.localizedDescription)")
            }
        }
    }
    
    func savePlace(place: PointOfInterest) {
        save()
    }
    
    func saveBadge(badge: Badge) {
        save()
    }
    
    func removePlace(place: PointOfInterest) {
        context.delete(place)
        save()
    }
    
    func fetchPlaces() -> [PointOfInterest] {
        let request = NSFetchRequest<PointOfInterest>(entityName: "PointOfInterest")
        request.relationshipKeyPathsForPrefetching = ["answers"]
        var pois: [PointOfInterest] = []
        
        do {
            pois = try context.fetch(request)
        } catch {
            print("Cannot fetch data: \(error.localizedDescription)")
        }
        return pois
    }
    
    func fetchBadges() -> [Badge] {
        let request = NSFetchRequest<Badge>(entityName: "Badge")
        var bdg: [Badge] = []
        
        do {
            bdg = try context.fetch(request)
            print("Helpinka: \(bdg)")
        } catch {
            print("Cannot fetch data: \(error.localizedDescription)")
        }
        return bdg
    }
    
    func   fetchPlaceWithId(id: UUID) -> PointOfInterest? {
        let request = NSFetchRequest<PointOfInterest>(entityName: "PointOfInterest")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        request.relationshipKeyPathsForPrefetching = ["answers"]
        
        var pois: [PointOfInterest] = []
        
        do {
            pois = try context.fetch(request)
        } catch {
            print("Cannot fetch data: \(error.localizedDescription)")
        }
        
        return pois.first
    }
    
    func   fetchLockedPlace() -> PointOfInterest? {
        let request = NSFetchRequest<PointOfInterest>(entityName: "PointOfInterest")
        request.predicate = NSPredicate(format: "locked == true")
        
        var pois: [PointOfInterest] = []
        
        do {
            pois = try context.fetch(request)
        } catch {
            print("Cannot fetch data: \(error.localizedDescription)")
        }
        
        return pois.first
    }
    
    func fetchLockedBadge() -> Badge? {
        let request = NSFetchRequest<Badge>(entityName: "Badge")
        request.predicate = NSPredicate(format: "locked == true")
        
        var bdgs: [Badge] = []
        
        do {
            bdgs = try context.fetch(request)
        } catch {
            print("Cannot fetch data: \(error.localizedDescription)")
        }
        
        return bdgs.first
    }
    
    func countUnlockedLocations() -> Int {
        let request = NSFetchRequest<PointOfInterest>(entityName: "PointOfInterest")
        request.predicate = NSPredicate(format: "locked == false")
        var count = 0

        do {
            count = try context.count(for: request)
        } catch {
            print("Error counting unlocked locations: \(error)")
        }
        return count
    }
    
    func countUnlockedBadges() -> Int {
        let request = NSFetchRequest<Badge>(entityName: "Badge")
        request.predicate = NSPredicate(format: "locked == false")
        var count = 0

        do {
            count = try context.count(for: request)
        } catch {
            print("Error counting unlocked locations: \(error)")
        }
        return count
    }
    
    func   fetchBadgeWithId(id: UUID) -> Badge? {
        let request = NSFetchRequest<Badge>(entityName: "Badge")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        
        var bdg: [Badge] = []
        
        do {
            bdg = try context.fetch(request)
        } catch {
            print("Cannot fetch data: \(error.localizedDescription)")
        }
        
        return bdg.first
    }
    
}

private extension CoreDataManager {
    private func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Cannot save MOC: \(error.localizedDescription)")
            }
        }
    }
}
