import SwiftUI

struct SessionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var settings: AppSettingsStore
    @EnvironmentObject private var stats: SessionStatsStore

    let pattern: BreathingPattern
    @StateObject private var engine: BreathingSessionEngine
    @State private var hasRecordedCompletion = false

    init(pattern: BreathingPattern) {
        self.pattern = pattern
        _engine = StateObject(wrappedValue: BreathingSessionEngine(pattern: pattern))
    }

    var body: some View {
        ThemeBackground(theme: settings.selectedTheme) {
            Group {
                if engine.isComplete {
                    CompletionView(
                        patternName: pattern.name,
                        durationSeconds: pattern.totalDurationSeconds,
                        currentStreak: stats.currentStreak,
                        doAnother: restart,
                        backHome: { dismiss() }
                    )
                } else {
                    sessionContent
                }
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 24)
        }
        .navigationBarBackButtonHidden(engine.isRunning)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("End") {
                    dismiss()
                }
            }
        }
        .onAppear {
            engine.start()
        }
        .onDisappear {
            engine.pause()
        }
        .onChange(of: engine.phase) { _, _ in
            HapticsService.shared.phaseChanged(enabled: settings.hapticsEnabled)
            SoundCueService.shared.phaseChanged(enabled: settings.soundEnabled)
        }
        .onChange(of: engine.isComplete) { _, isComplete in
            guard isComplete, !hasRecordedCompletion else { return }
            hasRecordedCompletion = true
            stats.recordCompletion(pattern: pattern)
            HapticsService.shared.completed(enabled: settings.hapticsEnabled)
            SoundCueService.shared.completed(enabled: settings.soundEnabled)
        }
    }

    private var sessionContent: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 4)

            VStack(spacing: 8) {
                Text(engine.phase.title)
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)

                Text(engine.phase.guidance)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            ZStack {
                BreathingOrbView(
                    phase: engine.phase,
                    progress: engine.progress,
                    theme: settings.selectedTheme
                )

                VStack(spacing: 6) {
                    Text(timeString(engine.remainingSeconds))
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                    Text("\(engine.phaseRemainingSeconds)s")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }

            Text(pattern.name)
                .font(.headline)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())

            Spacer()

            HStack(spacing: 14) {
                PrimaryButton(
                    title: engine.isRunning ? "Pause" : "Resume",
                    systemImage: engine.isRunning ? "pause.fill" : "play.fill",
                    isProminent: false
                ) {
                    engine.isRunning ? engine.pause() : engine.resume()
                }

                PrimaryButton(title: "End", systemImage: "xmark", isProminent: true) {
                    dismiss()
                }
            }
        }
    }

    private func restart() {
        hasRecordedCompletion = false
        engine.reset()
        engine.start()
    }

    private func timeString(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainder = seconds % 60
        return String(format: "%d:%02d", minutes, remainder)
    }
}
