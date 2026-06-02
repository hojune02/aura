import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var settings: AppSettingsStore
    @EnvironmentObject private var stats: SessionStatsStore
    @EnvironmentObject private var purchases: PurchaseStore

    @State private var selectedPattern = BreathingPattern.focusReset
    @State private var activePattern: BreathingPattern?
    @State private var showPaywall = false
    @State private var showCustomPattern = false

    private var presets: [BreathingPattern] {
        var patterns = BreathingPattern.builtInPresets
        if let customPattern = settings.customPattern {
            patterns.append(customPattern)
        }
        return patterns
    }

    var body: some View {
        ThemeBackground(theme: settings.selectedTheme) {
            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    header
                    BreathingOrbView(
                        phase: .inhale,
                        progress: 0,
                        theme: settings.selectedTheme
                    )
                    quickStats
                    PresetPickerView(
                        presets: presets,
                        selectedPattern: $selectedPattern,
                        isPremiumUnlocked: purchases.isPremiumUnlocked,
                        onLockedSelection: { showPaywall = true }
                    )
                    actions
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 26)
            }
        }
        .navigationTitle("aura")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $activePattern) { pattern in
            SessionView(pattern: pattern)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .sheet(isPresented: $showCustomPattern) {
            NavigationStack {
                CustomPatternView()
            }
        }
        .task {
            await purchases.loadProducts()
            if !presets.contains(selectedPattern) {
                selectedPattern = BreathingPattern.focusReset
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Reset your breath.")
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            Text("One minute to calm your body and focus your mind.")
                .font(.title3.weight(.medium))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var quickStats: some View {
        HStack(spacing: 12) {
            compactStat(value: "\(stats.todayCompletedSessions)", label: "Today")
            compactStat(value: "\(stats.currentStreak)", label: "Streak")
            compactStat(value: "\(stats.totalMindfulMinutes)", label: "Minutes")
        }
    }

    private func compactStat(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.bold())
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var actions: some View {
        VStack(spacing: 12) {
            PrimaryButton(title: "Start 60s Reset", systemImage: "play.fill") {
                start(selectedPattern)
            }

            PrimaryButton(
                title: settings.customPattern == nil ? "Create Custom Reset" : "Edit Custom Reset",
                systemImage: "slider.horizontal.3",
                isProminent: false
            ) {
                if purchases.isPremiumUnlocked {
                    showCustomPattern = true
                } else {
                    showPaywall = true
                }
            }
        }
    }

    private func start(_ pattern: BreathingPattern) {
        guard !pattern.isPremium || purchases.isPremiumUnlocked else {
            showPaywall = true
            return
        }
        activePattern = pattern
    }
}
