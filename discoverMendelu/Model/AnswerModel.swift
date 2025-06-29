//
//  Task.swift
//  discoverMendelu
//
//  Created by Macek<3 on 30.05.2025.
//

import UIKit


struct AnswerModel: Identifiable, Hashable {
    var id: UUID
    var text: String
    var correct: Bool
//    var location: LocationInfo
    
    
    static let sampleAnswer1 = AnswerModel(
        id: UUID(),
        text: "answer 1",
        correct: false
//        location: LocationInfo.sample1
    )
    
    static let sampleAnswer2 = AnswerModel(
        id: UUID(),
        text: "answer 2",
        correct: true
//        location: LocationInfo.sample1
    )
    
    static let samples = [sampleAnswer1, sampleAnswer2]
}
