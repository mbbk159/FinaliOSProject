//
//  MotionManaging.swift
//  discoverMendelu
//
//  Created by HlavMac on 18.06.2025.
//

import Combine

protocol MotionManaging {
    func startDetection()
    func stopDetection()
    var data: (rool: Double, pitch: Double, yaw: Double) { get }
    var dataPublisher: Published<(rool: Double, pitch: Double, yaw: Double)>.Publisher { get }
}
