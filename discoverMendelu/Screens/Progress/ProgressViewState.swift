//
//  ProgressViewState.swift
//  discoverMendelu
//
//  Created by Macek<3 on 30.05.2025.
//

import Observation
import MapKit
import SwiftUI

@Observable
final class ProgressViewState {
    var badges: [BadgeModel] = []
    var unlockedLocationCount: Int = 0
    var unlockedBadgesCount: Int = 0
}
