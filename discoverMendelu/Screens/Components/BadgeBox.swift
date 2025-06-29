//
//  BadgeBox.swift
//  discoverMendelu
//
//  Created by Macek<3 on 18.06.2025.
//

import SwiftUI

struct BadgeBox<Content: View>: View {
    let title: String?
    let content: Content

    init(title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack {
            content
                .frame(width: 50, height: 50)
            if let title = title {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(title != nil ? Color.accentColor : Color(.systemGray4))
        .cornerRadius(30)
    }
}
