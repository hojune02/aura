import SwiftUI

struct CustomPatternView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var settings: AppSettingsStore

    @State private var inhale = 4
    @State private var holdAfterInhale = 2
    @State private var exhale = 6
    @State private var holdAfterExhale = 0
    @State private var duration = 90

    var body: some View {
        Form {
            Section("Pattern") {
                Stepper("Inhale \(inhale)s", value: $inhale, in: 1...12)
                Stepper("Hold \(holdAfterInhale)s", value: $holdAfterInhale, in: 0...12)
                Stepper("Exhale \(exhale)s", value: $exhale, in: 1...16)
                Stepper("Final hold \(holdAfterExhale)s", value: $holdAfterExhale, in: 0...12)
            }

            Section("Duration") {
                Stepper("\(duration / 60)m \(duration % 60)s", value: $duration, in: 30...600, step: 15)
            }

            Section {
                PrimaryButton(title: "Save Custom Reset", systemImage: "checkmark") {
                    settings.customPattern = BreathingPattern.custom(
                        inhale: inhale,
                        holdAfterInhale: holdAfterInhale,
                        exhale: exhale,
                        holdAfterExhale: holdAfterExhale,
                        duration: duration
                    )
                    dismiss()
                }

                if settings.customPattern != nil {
                    Button("Remove Custom Reset", role: .destructive) {
                        settings.resetCustomPattern()
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Custom Reset")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") { dismiss() }
            }
        }
        .onAppear {
            guard let pattern = settings.customPattern else { return }
            inhale = pattern.inhaleSeconds
            holdAfterInhale = pattern.holdAfterInhaleSeconds
            exhale = pattern.exhaleSeconds
            holdAfterExhale = pattern.holdAfterExhaleSeconds
            duration = pattern.totalDurationSeconds
        }
    }
}
