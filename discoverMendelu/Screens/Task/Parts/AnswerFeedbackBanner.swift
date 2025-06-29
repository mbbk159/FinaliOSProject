import SwiftUI

struct AnswerFeedbackBanner: View {
    let isCorrect: Bool
    @Binding var shake: Bool
    @Binding var correctScale: CGFloat
    let onUnlock: () -> Void

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: isCorrect ? "checkmark.circle" : "xmark.circle")
                Text(isCorrect ? "Correct !!!" : "Not exactly :(")
            }
            .font(.largeTitle)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)

            Text(isCorrect ? "You're one step closer to becoming a Legend of the Campus!" : "Sorry, try it again")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            if isCorrect {
                Button(action: onUnlock) {
                    Text("Unlock location")
                        .font(.title2)
                        .foregroundColor(.accentColor)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(40)
                        .bold()
                }
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal, 25)
        .padding(.vertical, 20)
        .background(isCorrect ? Color.accentColor : Color.gray)
        .cornerRadius(30)
        .padding()
        .scaleEffect(correctScale)
        .offset(x: shake && !isCorrect ? -5 : 0)
        .animation(.linear(duration: 0.02).repeatCount(shake ? 6 : 0, autoreverses: true), value: shake)
        .animation(.interpolatingSpring(stiffness: 300, damping: 15), value: correctScale)
    }
}
