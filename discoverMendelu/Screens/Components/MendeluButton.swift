//
//  MendeluButton.swift
//  discoverMendelu
//
//  Created by Macek<3 on 30.05.2025.
//

import SwiftUICore
import SwiftUI

//struct MendeluButton<Destination: View>: View {
//    var label: String
//    var destination: Destination
//    var color: Color
//    var textColor: Color
//    var action: () -> Void = {}
//
//    var body: some View {
//        NavigationLink(destination: destination) {
//            Text(label)
//                .font(.title2)
//                .foregroundColor(textColor)
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(color)
//                .cornerRadius(40)
//                .bold()
//        }.onTapGesture {
//            action()
//        }
//    }
//}


struct MendeluButton<Destination: View>: View {
    var label: String
    var destination: Destination
    var color: Color
    var textColor: Color
    var action: () -> Void = {}

    @State private var isActive = false

    var body: some View {
        VStack {
            Button(action: {
                action()
                isActive = true
            }) {
                Text(label)
                    .font(.title2)
                    .foregroundColor(textColor)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(color)
                    .cornerRadius(40)
                    .bold()
            }

            NavigationLink(destination: destination, isActive: $isActive) {
                EmptyView()
            }
        }
    }
}


