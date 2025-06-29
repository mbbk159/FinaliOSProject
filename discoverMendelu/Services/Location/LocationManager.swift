//
//  LocationManager.swift
//  discoverMendelu
//
//  Created by Macek<3 on 29.05.2025.
//

import MapKit
import SwiftUI
import CoreLocation

@Observable
final class LocationManager: NSObject, LocationManaging, CLLocationManagerDelegate {
    private var manager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    var cameraPosition: MapCameraPosition = .camera(
        .init(
            centerCoordinate: .init(
                latitude: 49.211955,
                longitude: 16.616451
            ),
            distance: 2000
        )
    )
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let actLocation = locations.last {
            let coords = actLocation.coordinate
            cameraPosition = .camera(
                .init(
                    centerCoordinate: .init(
                        latitude: coords.latitude,
                        longitude: coords.longitude
                    ),
                    distance: 2000
                )
            )
            
            currentLocation = coords
        }
    }
    
    func getCurrentDistance(to: CLLocationCoordinate2D) -> Double? {
        if let actLocation = currentLocation {
            let fromLocation: CLLocation = .init(
                latitude: actLocation.latitude,
                longitude: actLocation.longitude
            )
            
            let toLocation: CLLocation = .init(
                latitude: to.latitude,
                longitude: to.longitude
            )
            
            return fromLocation.distance(from: toLocation)
        } else {
            return nil
        }
    }
    
    
}
