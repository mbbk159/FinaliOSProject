//
//  LocationView.swift
//  discoverMendelu
//
//  Created by Macek<3 on 29.05.2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var viewModel: LocationInfoViewModel
    @State var isDetailPresented = false
    @Environment(\.colorScheme) var colorScheme

    var strokeColor: Color {
        colorScheme == .light ? .white.opacity(0.8) : .clear
    }

    
    init(viewModel: LocationInfoViewModel) {
        self.viewModel = viewModel
    }
    
    
    
    var body: some View {
        NavigationStack{
            Map(
                position: $viewModel.state.mapCameraPosition,
                interactionModes: [.pan, .zoom]
            ) {
                ForEach(viewModel.state.locations) { location in
                    if !location.locked{
                        
                        Annotation(
                            "",
                            coordinate: location.coordinates
                        ) {
                            ZStack {
                                Circle()
                                    .fill(Color(.systemBackground).opacity(0.5))
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Circle()
                                            .stroke(strokeColor, lineWidth: 1.5)
                                    )

                                Text("💚")
                                    .font(.caption)
                                    .offset(y: -0.1)

                                VStack {
                                    Text(location.name)
                                        .font(.caption2)
                                        .fontWeight(.medium)
                                }
                                .padding(3)
                                .background(
                                    Color(.systemBackground).opacity(0.8)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .offset(y: 28)
                            }
                            .onTapGesture {
                                viewModel.state.selectedLocation = location
                                isDetailPresented = true
                            }
                        }

                    }
                }
            }
            .sheet(isPresented: $isDetailPresented) {
                if let selectedLocation = viewModel.state.selectedLocation {
                    NavigationStack {
                        DetailView(viewModel: DetailViewModel(location: selectedLocation))
                            .presentationDetents([.fraction(0.3), .medium, .large])
                            .toolbar {
                                ToolbarItemGroup(placement: .topBarLeading){
                                    Button("Close") {
                                        isDetailPresented = false
//                                        viewModel.fetchLocations()
                                    }
                                }
                            }
                    }
                }
            }
            .onAppear() {
                viewModel.fetchLocations()
                viewModel.syncLocation()
            }
            .onChange(of: isDetailPresented) { newValue in
                if newValue == false {
                    viewModel.fetchLocations()
                }
            }
            .navigationTitle("Map")
        }
    }
}
