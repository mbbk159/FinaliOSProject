//
//  UnlockingRowVIew.swift
//  discoverMendelu
//
//  Created by Macek<3 on 18.06.2025.
//

import SwiftUI

struct UnlockingRowView: View {
    let location: LocationInfo
    var animationCompleted: () -> Void
    
    @State private var showUnlocked = false
    @State private var started = false
    @State private var bounceScale: CGFloat = 1.0

    var body: some View {
        HStack {
            Text(location.name)
            Spacer()
            Image(systemName: showUnlocked ? "lock.fill" : "lock")
                .foregroundColor(showUnlocked ? .accent : .gray)
                .scaleEffect(bounceScale)
                .animation(.easeInOut(duration: 0.2), value: bounceScale) // Faster bounce
        }
        .onAppear {
            guard !started else { return }
            started = true
            
            // Show locked icon for 1.5s
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation {
                    showUnlocked = true
                }
                
                // Start bounce animation repeating (scale up/down)
                bounceScale = 1.4
                
                // Bounce parameters
                let bounceDuration = 0.2
                let bounceRepeats = 6
                var currentRepeat = 0
                
                Timer.scheduledTimer(withTimeInterval: bounceDuration, repeats: true) { timer in
                    withAnimation(.easeInOut(duration: bounceDuration)) {
                        bounceScale = bounceScale == 1.0 ? 1.4 : 1.0
                    }
                    currentRepeat += 1
                    if currentRepeat >= bounceRepeats {
                        timer.invalidate()
                        animationCompleted()
                    }
                }
            }
        }
    }
}
