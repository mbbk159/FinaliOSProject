//
//  LocationInfoViewState.swift
//  discoverMendelu
//
//  Created by Macek<3 on 29.05.2025.
//

import Observation
import MapKit
import SwiftUI

@Observable
final class LocationInfoViewState {
    var locations: [LocationInfo] = []
    
    var selectedLocation: LocationInfo?
    
    var currentLocation: CLLocationCoordinate2D?
    
    var mapCameraPosition: MapCameraPosition = .camera(
        .init(
            centerCoordinate: .init(
                latitude: 49.211955,
                longitude: 16.616451
            ),
            distance: 2000
        )
    )
}
