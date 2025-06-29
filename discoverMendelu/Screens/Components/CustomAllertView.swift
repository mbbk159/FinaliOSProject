//
//  CustomAllert.swift
//  discoverMendelu
//
//  Created by Macek<3 on 18.06.2025.
//

import SwiftUI

struct CustomAlertView: View {
    @Environment(\.colorScheme) private var colorScheme

    let title: String
    let message: String?
    let description: String?
    let buttonTitle: String
    let onDismiss: () -> Void

    init(
        title: String,
        message: String? = nil,
        description: String? = nil,
        buttonTitle: String,
        onDismiss: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.description = description
        self.buttonTitle = buttonTitle
        self.onDismiss = onDismiss
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()

            VStack(spacing: 16) {
                Text(title)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .bold()

                if let message = message, !message.isEmpty {
                    Text(message)
                        .multilineTextAlignment(.center)
                        .font(.title3)
                        .bold()
                }

                if let description = description, !description.isEmpty {
                    Text(description)
                        .multilineTextAlignment(.center)
                        .font(.body)
                }

                Button(action: {
                    onDismiss()
                }) {
                    Text(buttonTitle)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(40)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color(uiColor: .systemBackground))
            )
            .frame(maxWidth: 300)
            .shadow(radius: 10)
            .foregroundColor(Color.primary)
        }
        .transition(.opacity)
        .animation(.easeInOut, value: UUID())
    }
}
