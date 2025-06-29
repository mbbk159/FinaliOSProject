//
//  LocationManaging.swift
//  discoverMendelu
//
//  Created by Macek<3 on 29.05.2025.
//

import MapKit
import SwiftUI

protocol LocationManaging {
    var cameraPosition: MapCameraPosition { get }
    var currentLocation: CLLocationCoordinate2D? { get }
    func getCurrentDistance(to: CLLocationCoordinate2D) -> Double?
}
