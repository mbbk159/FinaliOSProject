//
//  TaskViewState.swift
//  discoverMendelu
//
//  Created by Macek<3 on 30.05.2025.
//

import Observation
import MapKit
import SwiftUI

@Observable
final class TaskViewState {
    var answers: [AnswerModel]
    var locationInfo: LocationInfo
    var isRecording: Bool = false
    var isPraying: Bool = false
    var isDrinking: Bool = false
    var recordingFinished: Bool = false
    var spoke: Bool = false
    var movementPraying: Bool = false
    var movementDrinking: Bool = false
    
    private let movementPrayingHappend = 0.03
    private let movementDrinkingHappend = 0.4
    var detectedMotionValues: (rool: Double, pitch: Double, yaw: Double) = (0.0,0.0,0.0) {
        didSet{
            print(detectedMotionValues.rool)
            print(detectedMotionValues.pitch)
            print(detectedMotionValues.yaw)
            print("-----------------------")
            if (abs(oldValue.pitch - detectedMotionValues.pitch) > movementPrayingHappend && abs(oldValue.rool - detectedMotionValues.rool) > movementPrayingHappend && abs(oldValue.yaw - detectedMotionValues.yaw) > movementPrayingHappend){
                movementPraying = true
            }
            if(abs(oldValue.rool - detectedMotionValues.rool) > movementDrinkingHappend){
                movementDrinking = true
            }
//            else{
//                movement = false
//            }
        }
    }
    
    init(locationInfo: LocationInfo) {
        self.answers = locationInfo.answers
        self.locationInfo = locationInfo
    }
}



