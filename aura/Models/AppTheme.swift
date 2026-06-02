import SwiftUI

enum AppTheme: String, CaseIterable, Codable, Identifiable {
    case ocean
    case sunset
    case forest
    case midnight

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .ocean:
            return "Ocean"
        case .sunset:
            return "Sunset"
        case .forest:
            return "Forest"
        case .midnight:
            return "Midnight"
        }
    }

    var isPremium: Bool {
        switch self {
        case .ocean, .midnight:
            return false
        case .sunset, .forest:
            return true
        }
    }

    var accent: Color {
        switch self {
        case .ocean:
            return Color(red: 0.16, green: 0.55, blue: 0.72)
        case .sunset:
            return Color(red: 0.86, green: 0.38, blue: 0.27)
        case .forest:
            return Color(red: 0.18, green: 0.48, blue: 0.34)
        case .midnight:
            return Color(red: 0.48, green: 0.44, blue: 0.82)
        }
    }

    var gradientColors: [Color] {
        switch self {
        case .ocean:
            return [
                Color(red: 0.86, green: 0.96, blue: 0.98),
                Color(red: 0.66, green: 0.84, blue: 0.91),
                Color(red: 0.30, green: 0.59, blue: 0.72)
            ]
        case .sunset:
            return [
                Color(red: 1.00, green: 0.88, blue: 0.69),
                Color(red: 0.94, green: 0.55, blue: 0.46),
                Color(red: 0.45, green: 0.28, blue: 0.57)
            ]
        case .forest:
            return [
                Color(red: 0.87, green: 0.94, blue: 0.82),
                Color(red: 0.47, green: 0.68, blue: 0.49),
                Color(red: 0.13, green: 0.33, blue: 0.30)
            ]
        case .midnight:
            return [
                Color(red: 0.10, green: 0.12, blue: 0.20),
                Color(red: 0.20, green: 0.23, blue: 0.39),
                Color(red: 0.44, green: 0.39, blue: 0.73)
            ]
        }
    }

    var foreground: Color {
        switch self {
        case .midnight:
            return .white
        case .ocean, .sunset, .forest:
            return Color(red: 0.08, green: 0.10, blue: 0.14)
        }
    }
}
