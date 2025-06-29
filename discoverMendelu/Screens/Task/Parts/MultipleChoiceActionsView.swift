//
//  MultipleChoiceButtonView.swift
//  discoverMendelu
//
//  Created by Macek<3 on 23.06.2025.
//

import SwiftUI

struct MultipleChoiceAnswersView: View {
    let answers: [AnswerModel]
    @Binding var selectedOption: UUID?
    var onSubmit: () -> Void

    var body: some View {
        ForEach(answers) { answer in
            HStack(spacing: 12) {
                Image(systemName: selectedOption == answer.id ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(.accentColor)
                    .onTapGesture {
                        selectedOption = answer.id
                    }

                Text(answer.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        selectedOption = answer.id
                    }
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
        }
        .padding(.horizontal)

        SubmitButton(label: "Submit", action: onSubmit)
            .padding()
    }
}
