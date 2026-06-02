import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: AppSettingsStore
    @EnvironmentObject private var purchases: PurchaseStore
    @State private var showPaywall = false

    var body: some View {
        ThemeBackground(theme: settings.selectedTheme) {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    settingsSection("Session cues") {
                        settingToggleRow(title: "Haptics", isOn: $settings.hapticsEnabled)
                        settingDivider
                        settingToggleRow(
                            title: "Sound",
                            subtitle: "Soft cues for phase changes",
                            isOn: $settings.soundEnabled
                        )
                    }

                    settingsSection("Theme") {
                        ForEach(AppTheme.allCases) { theme in
                            themeRow(theme)

                            if theme != AppTheme.allCases.last {
                                settingDivider
                            }
                        }
                    }

                    settingsSection("Premium") {
                        Button {
                            showPaywall = true
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "sparkles")
                                    .font(.headline)
                                Text("Manage aura Premium")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.footnote.weight(.bold))
                                    .foregroundStyle(secondaryText)
                            }
                            .foregroundStyle(settings.selectedTheme.foreground)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }

                    settingsSection("Support") {
                        linkRow(title: "Privacy Policy", systemImage: "doc.text", destination: AppLinks.privacyPolicy)
                        settingDivider
                        linkRow(title: "Get Support", systemImage: "questionmark.circle", destination: AppLinks.support)
                    }
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 26)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(settings.selectedTheme == .midnight ? .dark : .light, for: .navigationBar)
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }

    private var secondaryText: Color {
        settings.selectedTheme.foreground.opacity(0.68)
    }

    private var settingDivider: some View {
        Rectangle()
            .fill(settings.selectedTheme.foreground.opacity(0.12))
            .frame(height: 1)
    }

    private func settingsSection<Content: View>(
        _ title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(settings.selectedTheme.foreground)

            VStack(spacing: 12) {
                content()
            }
            .padding(18)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
    }

    private func settingToggleRow(title: String, subtitle: String? = nil, isOn: Binding<Bool>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(settings.selectedTheme.foreground)

                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(secondaryText)
                }
            }

            Spacer()

            Toggle(title, isOn: isOn)
                .labelsHidden()
                .tint(settings.selectedTheme.accent)
        }
        .frame(minHeight: 42)
    }

    private func linkRow(title: String, systemImage: String, destination: URL) -> some View {
        Link(destination: destination) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.headline)
                    .frame(width: 24)

                Text(title)
                    .font(.headline)

                Spacer()

                Image(systemName: "arrow.up.right")
                    .font(.footnote.weight(.bold))
                    .foregroundStyle(secondaryText)
            }
            .foregroundStyle(settings.selectedTheme.foreground)
            .contentShape(Rectangle())
        }
        .frame(minHeight: 44)
    }

    private func themeRow(_ theme: AppTheme) -> some View {
        Button {
            if theme.isPremium && !purchases.isPremiumUnlocked {
                showPaywall = true
            } else {
                settings.selectedTheme = theme
            }
        } label: {
            HStack(spacing: 14) {
                Circle()
                    .fill(theme.accent)
                    .frame(width: 24, height: 24)

                VStack(alignment: .leading, spacing: 3) {
                    Text(theme.displayName)
                        .font(.headline)
                        .foregroundStyle(settings.selectedTheme.foreground)

                    if theme.isPremium && !purchases.isPremiumUnlocked {
                        Text("Premium")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(secondaryText)
                    }
                }

                Spacer()

                if theme.isPremium && !purchases.isPremiumUnlocked {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(secondaryText)
                } else if settings.selectedTheme == theme {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.headline)
                        .foregroundStyle(settings.selectedTheme.accent)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .frame(minHeight: 46)
    }
}
