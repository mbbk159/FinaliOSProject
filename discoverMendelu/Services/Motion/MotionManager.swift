//
//  MotionManager.swift
//  discoverMendelu
//
//  Created by HlavMac on 18.06.2025.
//

import Foundation
import CoreMotion

final class MotionManager: ObservableObject, MotionManaging {
    private var motion = CMMotionManager()
    @Published private(set) var data: (rool: Double, pitch: Double, yaw: Double) = (0,0,0)
    
    var dataPublisher: Published<(rool: Double, pitch: Double, yaw: Double)>.Publisher { $data }
    
    func startDetection() {
        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 1.0 / 60.0
            motion.showsDeviceMovementDisplay = true
            motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: .main) { [weak self] data, _ in
                if let attitude = data?.attitude {
                    self?.data = (attitude.roll, attitude.pitch, attitude.yaw)
                }
            }
        }
    }
    
    func stopDetection() {
        motion.stopDeviceMotionUpdates()
    }
}

