import SwiftUI
import UIKit

struct TaskView: View {
    @State private var viewModel: TaskViewModel
    @State private var selectedOption: UUID? = nil
    @Binding var redirectBack: Bool
    @Environment(\.dismiss) private var dismiss

    @State private var shake = false
    @State private var correctScale: CGFloat = 1.0
    @State private var showAlert = false
    @State private var alertMessage = ""

    init(viewModel: TaskViewModel, redirectBack: Binding<Bool>) {
        self.viewModel = viewModel
        self._redirectBack = redirectBack
        viewModel.state.movementPraying = false
        viewModel.state.movementDrinking = false
    }

    var body: some View {
        ScrollView {
            Text(viewModel.state.locationInfo.question)
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
                .padding(.horizontal)
                .bold()

            let answers = viewModel.state.answers

            if answers.count == 2 {
                TaskActionButtonView(viewModel: viewModel, shake: $shake, correctScale: $correctScale)
            } else {
                MultipleChoiceAnswersView(
                    answers: answers,
                    selectedOption: $selectedOption,
                    onSubmit: handleSubmitMultipleChoice
                )
            }

            if viewModel.userAnswered {
                AnswerFeedbackBanner(
                    isCorrect: viewModel.answerIsCorrect,
                    shake: $shake,
                    correctScale: $correctScale,
                    onUnlock: handleUnlock
                )
            }
        }
        .overlay(
            Group {
                if showAlert {
                    CustomAlertView(
                        title: "Congratulations!",
                        message: alertMessage,
                        description: "View it in the Progress section!",
                        buttonTitle: "OK",
                        onDismiss: {
                            redirectBack = true
                            dismiss()
                        }
                    )
                }
            }
        )
    }

    private func handleSubmitMultipleChoice() {
        let correctAnswer = viewModel.state.answers.first(where: { $0.correct })
        if selectedOption == correctAnswer?.id {
            viewModel.answerIsCorrect = true
            correctScale = 1.08
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                correctScale = 1.0
            }
        } else {
            viewModel.answerIsCorrect = false
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            shake = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                shake = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                shake = false
            }
        }
        viewModel.userAnswered = true
        viewModel.playAnswerSound()
    }

    private func handleUnlock() {
        let alert = viewModel.handleUnlockAndProgress()
        if let alert = alert {
            alertMessage = alert
            showAlert = true
        } else {
            redirectBack = true
            dismiss()
        }
    }
}

