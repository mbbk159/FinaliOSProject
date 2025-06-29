//
//  BadgeView.swift
//  discoverMendelu
//
//  Created by Macek<3 on 18.06.2025.
//

import SwiftUI

struct BadgeView: View {
    let badge: BadgeModel
    let onUnlock: () -> Void

    var body: some View {
        if badge.locked {
            BadgeBox {
                Image(systemName: "questionmark")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        } else {
            AnimatedBadgeView(badge: badge, onAnimated: onUnlock)
        }
    }
}
