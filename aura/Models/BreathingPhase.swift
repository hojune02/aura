import Foundation

enum BreathingPhase: String, CaseIterable, Codable, Equatable {
    case inhale
    case holdAfterInhale
    case exhale
    case holdAfterExhale

    var title: String {
        switch self {
        case .inhale:
            return "Inhale"
        case .holdAfterInhale, .holdAfterExhale:
            return "Hold"
        case .exhale:
            return "Exhale"
        }
    }

    var guidance: String {
        switch self {
        case .inhale:
            return "Draw air in slowly."
        case .holdAfterInhale:
            return "Let the breath settle."
        case .exhale:
            return "Release with control."
        case .holdAfterExhale:
            return "Rest before the next breath."
        }
    }

    var orbScale: CGFloat {
        switch self {
        case .inhale:
            return 1.16
        case .holdAfterInhale:
            return 1.18
        case .exhale:
            return 0.74
        case .holdAfterExhale:
            return 0.72
        }
    }
}
