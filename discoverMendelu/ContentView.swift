//
//  ContentView.swift
//  discoverMendelu
//
//  Created by Macek<3 on 29.05.2025.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(
                "List",
                systemImage: "list.bullet.circle",
                value: 0
            ){
                ListView(viewModel: LocationInfoViewModel())
            }
            
            Tab(
                "Map",
                systemImage: "map.circle",
                value: 1)
            {
                MapView(viewModel: LocationInfoViewModel())
            }
            
            Tab(
                "Progress",
                systemImage: "medal",
                value: 1)
            {
                ProgressView(viewModel: ProgressViewModel())
            }
        }
    }
}

#Preview {
    ContentView()
}
