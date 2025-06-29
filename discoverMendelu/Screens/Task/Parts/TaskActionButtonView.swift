//
//  TaskActionButtonView.swift
//  discoverMendelu
//
//  Created by Macek<3 on 23.06.2025.
//

import SwiftUI

struct TaskActionButtonView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Binding var shake: Bool
    @Binding var correctScale: CGFloat

    var body: some View {
        Group {
            let imageAnswer = viewModel.state.answers.first(where: { $0.correct })!
            let descriptionAnswer = viewModel.state.answers.first(where: { !$0.correct })!

            Image(uiImage: UIImage(named: imageAnswer.text) ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 250)
                .cornerRadius(20)
                .padding()

            Text(descriptionAnswer.text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            switch imageAnswer.text {
            case "Speak":
                if (viewModel.state.isRecording){
                        Text("Recording...")
                }else{
                    Text("Please start recording")
                }
                SubmitButton(label: viewModel.state.isRecording ? "Stop Recording" : "Start Recording") {
                    if viewModel.state.isRecording {
                        viewModel.stopRecording()
                        viewModel.determineSpeaking()
                    } else {
                        viewModel.startRecording()
                    }

                    feedback(success: viewModel.userAnswered && viewModel.state.spoke)
                }.padding()

            case "Praying":
                SubmitButton(label: !viewModel.state.isPraying ? "Start praying" : "Praying...") {
                    viewModel.state.isPraying = true
                    viewModel.startDetection()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
                        viewModel.stopDetection()
                        feedback(success: !viewModel.state.movementPraying)
                        viewModel.state.isPraying = false
                    }
                }.padding()

            case "Drink":
                SubmitButton(label: !viewModel.state.isDrinking ? "Take a shot!" : "Hydrating...") {
                    viewModel.state.isDrinking = true
                    viewModel.startDetection()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        viewModel.stopDetection()
                        viewModel.determineDrining()
                        feedback(success: viewModel.state.movementDrinking)
                        viewModel.state.isDrinking = false
                    }
                }.padding()

            default:
                EmptyView()
            }
        }
    }

    private func feedback(success: Bool) {
        if success {
            correctScale = 1.08
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                correctScale = 1.0
            }
        } else {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            shake = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { shake = false }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) { shake = false }
        }
    }
}
