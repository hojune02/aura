import Foundation

struct BreathingPattern: Identifiable, Codable, Equatable, Hashable {
    let id: String
    var name: String
    var shortDescription: String
    var inhaleSeconds: Int
    var holdAfterInhaleSeconds: Int
    var exhaleSeconds: Int
    var holdAfterExhaleSeconds: Int
    var totalDurationSeconds: Int
    var isPremium: Bool

    var cycleDurationSeconds: Int {
        inhaleSeconds + holdAfterInhaleSeconds + exhaleSeconds + holdAfterExhaleSeconds
    }

    var phaseDurations: [(phase: BreathingPhase, duration: Int)] {
        [
            (.inhale, inhaleSeconds),
            (.holdAfterInhale, holdAfterInhaleSeconds),
            (.exhale, exhaleSeconds),
            (.holdAfterExhale, holdAfterExhaleSeconds)
        ]
        .filter { $0.duration > 0 }
    }

    var formattedDuration: String {
        let minutes = totalDurationSeconds / 60
        let seconds = totalDurationSeconds % 60
        if seconds == 0 {
            return "\(minutes)m"
        }
        return "\(minutes)m \(seconds)s"
    }

    static let focusReset = BreathingPattern(
        id: "focus-reset-60",
        name: "60s Focus Reset",
        shortDescription: "A steady one-minute reset for focus.",
        inhaleSeconds: 4,
        holdAfterInhaleSeconds: 2,
        exhaleSeconds: 6,
        holdAfterExhaleSeconds: 0,
        totalDurationSeconds: 60,
        isPremium: false
    )

    static let boxBreathing = BreathingPattern(
        id: "box-breathing",
        name: "Box Breathing",
        shortDescription: "Even pacing for calm attention.",
        inhaleSeconds: 4,
        holdAfterInhaleSeconds: 4,
        exhaleSeconds: 4,
        holdAfterExhaleSeconds: 4,
        totalDurationSeconds: 120,
        isPremium: false
    )

    static let sleep478 = BreathingPattern(
        id: "sleep-478",
        name: "Sleep 4-7-8",
        shortDescription: "Longer exhales for winding down.",
        inhaleSeconds: 4,
        holdAfterInhaleSeconds: 7,
        exhaleSeconds: 8,
        holdAfterExhaleSeconds: 0,
        totalDurationSeconds: 120,
        isPremium: true
    )

    static let interviewCalm = BreathingPattern(
        id: "interview-calm",
        name: "Interview Calm",
        shortDescription: "Composure before high-pressure moments.",
        inhaleSeconds: 5,
        holdAfterInhaleSeconds: 2,
        exhaleSeconds: 7,
        holdAfterExhaleSeconds: 0,
        totalDurationSeconds: 90,
        isPremium: true
    )

    static let examStressReset = BreathingPattern(
        id: "exam-stress-reset",
        name: "Exam Stress Reset",
        shortDescription: "Slower release for study and test stress.",
        inhaleSeconds: 4,
        holdAfterInhaleSeconds: 4,
        exhaleSeconds: 8,
        holdAfterExhaleSeconds: 0,
        totalDurationSeconds: 120,
        isPremium: true
    )

    static let builtInPresets: [BreathingPattern] = [
        .focusReset,
        .boxBreathing,
        .sleep478,
        .interviewCalm,
        .examStressReset
    ]

    static func custom(
        inhale: Int,
        holdAfterInhale: Int,
        exhale: Int,
        holdAfterExhale: Int,
        duration: Int
    ) -> BreathingPattern {
        BreathingPattern(
            id: "custom-pattern",
            name: "Custom Reset",
            shortDescription: "Your saved breathing pattern.",
            inhaleSeconds: max(1, inhale),
            holdAfterInhaleSeconds: max(0, holdAfterInhale),
            exhaleSeconds: max(1, exhale),
            holdAfterExhaleSeconds: max(0, holdAfterExhale),
            totalDurationSeconds: max(30, duration),
            isPremium: true
        )
    }
}
