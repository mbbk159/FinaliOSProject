//
//  DetailViewState.swift
//  discoverMendelu
//
//  Created by Macek<3 on 29.05.2025.
//

import Observation
import MapKit
import SwiftUI

@Observable
final class DetailViewState {
    var locationInfo: LocationInfo
    var reading: Bool = false
    var paused: Bool = false
    var finished: Bool = false

    init(locationInfo: LocationInfo) {
        self.locationInfo = locationInfo
    }
}
