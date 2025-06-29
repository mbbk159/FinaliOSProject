//
//  SubmitButton.swift
//  discoverMendelu
//
//  Created by Macek<3 on 30.05.2025.
//

import SwiftUI

struct SubmitButton: View {
    var label: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .cornerRadius(40)
                .bold()
        }
    }
}
