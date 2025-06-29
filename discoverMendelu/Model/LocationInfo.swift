//
//  Location.swift
//  discoverMendelu
//
//  Created by Macek<3 on 29.05.2025.
//

import UIKit
import CoreLocation


struct LocationInfo: Identifiable {
    var id: UUID
    var name: String
    var image: UIImage
    var coordinates: CLLocationCoordinate2D
    var story: String
    var question: String
    var locked: Bool
    var qrScanned: Bool
    var answers: [AnswerModel]
    var completed: Bool
    var hasAnimated: Bool
    var qrScanText: String
}
