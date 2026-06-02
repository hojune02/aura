import SwiftUI

struct BreathingOrbView: View {
    var phase: BreathingPhase
    var progress: Double
    var theme: AppTheme

    @State private var shimmer = false

    var body: some View {
        ZStack {
            Circle()
                .fill(theme.accent.opacity(0.14))
                .frame(width: 260, height: 260)
                .blur(radius: 18)
                .scaleEffect(shimmer ? 1.08 : 0.94)

            Circle()
                .strokeBorder(Color.white.opacity(0.42), lineWidth: 1)
                .background(
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.92),
                                    theme.accent.opacity(0.56),
                                    theme.accent.opacity(0.22)
                                ],
                                center: .topLeading,
                                startRadius: 18,
                                endRadius: 150
                            )
                        )
                )
                .frame(width: 210, height: 210)
                .scaleEffect(phase.orbScale)
                .shadow(color: theme.accent.opacity(0.38), radius: 28, x: 0, y: 18)

            ProgressRingView(progress: progress, lineWidth: 8, tint: theme.accent)
                .frame(width: 252, height: 252)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .animation(.easeInOut(duration: 1.05), value: phase)
        .animation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true), value: shimmer)
        .onAppear { shimmer = true }
    }
}
