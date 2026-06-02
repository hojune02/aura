import Foundation

final class AppSettingsStore: ObservableObject {
    @Published var hapticsEnabled: Bool {
        didSet { defaults.set(hapticsEnabled, forKey: Keys.hapticsEnabled) }
    }

    @Published var soundEnabled: Bool {
        didSet { defaults.set(soundEnabled, forKey: Keys.soundEnabled) }
    }

    @Published var selectedTheme: AppTheme {
        didSet { defaults.set(selectedTheme.rawValue, forKey: Keys.selectedTheme) }
    }

    @Published var customPattern: BreathingPattern? {
        didSet { saveCustomPattern() }
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        hapticsEnabled = defaults.object(forKey: Keys.hapticsEnabled) as? Bool ?? true
        soundEnabled = defaults.object(forKey: Keys.soundEnabled) as? Bool ?? false

        let storedTheme = defaults.string(forKey: Keys.selectedTheme)
        selectedTheme = storedTheme.flatMap(AppTheme.init(rawValue:)) ?? .ocean

        if let data = defaults.data(forKey: Keys.customPattern) {
            customPattern = try? JSONDecoder().decode(BreathingPattern.self, from: data)
        } else {
            customPattern = nil
        }
    }

    func resetCustomPattern() {
        customPattern = nil
    }

    func availableThemes(isPremiumUnlocked: Bool) -> [AppTheme] {
        AppTheme.allCases.filter { !$0.isPremium || isPremiumUnlocked }
    }

    private func saveCustomPattern() {
        guard let customPattern else {
            defaults.removeObject(forKey: Keys.customPattern)
            return
        }

        if let data = try? JSONEncoder().encode(customPattern) {
            defaults.set(data, forKey: Keys.customPattern)
        }
    }

    private enum Keys {
        static let hapticsEnabled = "aura.settings.hapticsEnabled"
        static let soundEnabled = "aura.settings.soundEnabled"
        static let selectedTheme = "aura.settings.selectedTheme"
        static let customPattern = "aura.settings.customPattern"
    }
}
