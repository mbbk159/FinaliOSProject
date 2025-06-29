import SwiftUI

struct BadgeStatCard: View {
    let icon: String
    let count: Int
    let text: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)

            VStack(alignment: .leading, spacing: 2) {
                Text("\(count)")
                    .font(.headline)
                    .foregroundColor(.white)

                Text(text)
                    .font(.caption2)
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 50)
        .padding(8)
        .background(Color.accentColor)
        .cornerRadius(30)
    }
}
