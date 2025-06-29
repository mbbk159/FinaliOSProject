//
//  BaseData.swift
//  discoverMendelu
//
//  Created by Macek<3 on 29.05.2025.
//

struct BaseDataDecode: Decodable {
    let name: String
    let latitude: Double
    let longitude: Double
    let imageName: String
    let story: String
    let question: String
    let locked: Bool
    let qrScanned: Bool
    let answers: [AnswerDecode]
    let completed: Bool
    let hasAnimated: Bool
    let qrScanText: String
}

struct AnswerDecode: Decodable {
    let text: String
    let correct: Bool
}

struct BadgeDecode: Codable {
    let name: String
    let image: String
    let locked: Bool
    let hasAnimated: Bool
}
