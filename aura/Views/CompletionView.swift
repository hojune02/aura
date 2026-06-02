import SwiftUI

struct CompletionView: View {
    var patternName: String
    var durationSeconds: Int
    var currentStreak: Int
    var doAnother: () -> Void
    var backHome: () -> Void

    var body: some View {
        VStack(spacing: 26) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72))
                .symbolRenderingMode(.hierarchical)

            VStack(spacing: 10) {
                Text("Nice reset.")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                Text("\(patternName) complete")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                summary(value: "\(durationSeconds / 60)m", label: "Duration")
                summary(value: "\(currentStreak)", label: "Streak")
            }

            Spacer()

            VStack(spacing: 12) {
                PrimaryButton(title: "Do another", systemImage: "arrow.clockwise", action: doAnother)
                PrimaryButton(title: "Back home", systemImage: "house.fill", isProminent: false, action: backHome)
            }
        }
    }

    private func summary(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title.bold())
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
