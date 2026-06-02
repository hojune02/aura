import Foundation

enum PremiumFeature: String, CaseIterable, Identifiable {
    case sleep478
    case interviewCalm
    case examStressReset
    case customDuration
    case extraThemes
    case detailedStats

    var id: String { rawValue }

    var title: String {
        switch self {
        case .sleep478:
            return "Sleep 4-7-8"
        case .interviewCalm:
            return "Interview Calm"
        case .examStressReset:
            return "Exam Stress Reset"
        case .customDuration:
            return "Custom sessions"
        case .extraThemes:
            return "Extra themes"
        case .detailedStats:
            return "Detailed stats"
        }
    }

    var detail: String {
        switch self {
        case .sleep478:
            return "A slower pattern designed for winding down."
        case .interviewCalm:
            return "A focused reset for high-pressure moments."
        case .examStressReset:
            return "Long exhales for study and exam breaks."
        case .customDuration:
            return "Save your own timing and session length."
        case .extraThemes:
            return "Unlock Sunset and Forest visual themes."
        case .detailedStats:
            return "See longer streaks, averages, and recent sessions."
        }
    }
}
