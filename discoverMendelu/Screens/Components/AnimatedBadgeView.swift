//
//  AnimatedBadgeView.swift
//  discoverMendelu
//
//  Created by Macek<3 on 18.06.2025.
//

import SwiftUI

struct AnimatedBadgeView: View {
    let badge: BadgeModel
    let onAnimated: () -> Void
    
    @State private var showUnlocked = false
    @State private var bounceScale: CGFloat = 1.0
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(showUnlocked ? Color.accentColor : Color(.systemGray4))
                    .frame(height: 120)
                    .animation(.easeInOut(duration: 0.3), value: showUnlocked)
                
                VStack {
                    if showUnlocked || badge.hasAnimated {
                        Image("symbol")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .padding(.top, 10)

                        Text(badge.name)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                    } else {
                        Image(systemName: "questionmark")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .scaleEffect(bounceScale)
                            .animation(.easeInOut(duration: 0.3), value: bounceScale)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .onAppear {
            if badge.hasAnimated {
                showUnlocked = true
            } else {
                playBounceAndReveal()
            }
        }
    }
    
    func playBounceAndReveal() {
        let bounceDuration = 0.3
        let bounceRepeats = 5
        var currentRepeat = 0
        
        func bounceStep() {
            withAnimation(.easeInOut(duration: bounceDuration)) {
                bounceScale = bounceScale == 1.0 ? 1.4 : 1.0
            }
            currentRepeat += 1
            
            if currentRepeat < bounceRepeats {
                DispatchQueue.main.asyncAfter(deadline: .now() + bounceDuration) {
                    bounceStep()
                }
            } else {
                withAnimation {
                    showUnlocked = true
                }
                onAnimated()
            }
        }
        
        bounceStep()
    }
}
