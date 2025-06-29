//
//  ProgressView.swift
//  discoverMendelu
//
//  Created by Macek<3 on 30.05.2025.
//

import SwiftUI

struct ProgressView: View {
    @State private var viewModel: ProgressViewModel
    
    @State private var showAlert = false
    
    init(viewModel: ProgressViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack {
                        var badgeInfo: (title: String, iconName: String) {
                            switch viewModel.state.unlockedBadgesCount {
                            case 2,3:
                                return ("Explorer", "magnifyingglass")
                            case 4,5:
                                return ("Green Guru", "graduationcap")
                            case 6,7:
                                return ("Mendeler Pro", "checkmark.seal.fill")
                            case 8:
                                return ("Legend of the Campus", "trophy")
                            default:
                                return ("Seedling", "leaf")
                            }
                        }
                        Image(systemName: badgeInfo.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.white)
                            .padding(.top, 16)
                        Text(badgeInfo.title)
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.bottom, 16)
                    }
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .background(Color.accentColor)
                    .cornerRadius(30)
                    .padding(.horizontal)
                    // Stats badges
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        BadgeStatCard(icon: "rosette", count: viewModel.state.unlockedBadgesCount, text: "Badges collected")
                        BadgeStatCard(icon: "rosette", count: viewModel.state.unlockedLocationCount, text: "Locations discovered")
                    }
                    .padding(.horizontal)
                    .frame(height: 80)
                    // Grid badges
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(viewModel.state.badges) { badge in
                            BadgeView(badge: badge) {
                                viewModel.markBadgeAnimated(id: badge.id)
                            }
                        }
                    }
                    .padding(.horizontal)
         
                    Spacer()
                }
            }
            .navigationTitle("Progress")
            .onAppear {
                viewModel.fetchBadges()
                if (viewModel.state.unlockedBadgesCount == 8){
                    showAlert = true
                }
                viewModel.checkIfShouldShowProgressAlert()
            }
            .overlay(
                Group {
                    if viewModel.showProgressAlert && showAlert {
                        CustomAlertView(
                            title: "Congratulations!",
                            message: "Well done, explorer! You’ve completed the game and revealed all the hidden spots. From now on, you shall be known as the Legend of the Campus!",
                            buttonTitle: "Wow",
                            onDismiss: {
                                viewModel.showProgressAlert = false
                                viewModel.saveProgressAlertDate()
                            }
                        )
                    }
                }
            )
        }
    }
}


