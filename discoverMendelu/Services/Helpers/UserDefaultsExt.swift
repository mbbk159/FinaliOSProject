//
//  UserDefaultsExt.swift
//  discoverMendelu
//
//  Created by Macek<3 on 29.05.2025.
//

import Foundation


extension UserDefaults {
    var isInitialDataLoaded: Bool {
        get { bool(forKey: "isInitialDataLoaded") }
        set { set(newValue, forKey: "isInitialDataLoaded") }
    }
}
