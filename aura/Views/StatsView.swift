import SwiftUI

struct StatsView: View {
    @EnvironmentObject private var settings: AppSettingsStore
    @EnvironmentObject private var stats: SessionStatsStore
    @EnvironmentObject private var purchases: PurchaseStore
    @State private var showPaywall = false

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ThemeBackground(theme: settings.selectedTheme) {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Your rhythm")
                        .font(.system(size: 38, weight: .bold, design: .rounded))

                    LazyVGrid(columns: columns, spacing: 12) {
                        StatCard(title: "Today", value: "\(stats.todayCompletedSessions)", systemImage: "sun.max.fill")
                        StatCard(title: "Total sessions", value: "\(stats.totalSessions)", systemImage: "checklist.checked")
                        StatCard(title: "Current streak", value: "\(stats.currentStreak)", systemImage: "flame.fill")
                        StatCard(title: "Longest streak", value: "\(stats.longestStreak)", systemImage: "crown.fill")
                        StatCard(title: "Mindful minutes", value: "\(stats.totalMindfulMinutes)", systemImage: "timer")
                    }

                    if purchases.isPremiumUnlocked {
                        detailedStats
                    } else {
                        lockedDetails
                    }
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 26)
            }
        }
        .navigationTitle("Stats")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }

    private var detailedStats: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Recent sessions")
                .font(.headline)

            StatCard(
                title: "Average length",
                value: timeString(stats.averageSessionSeconds),
                systemImage: "waveform.path.ecg"
            )

            VStack(spacing: 10) {
                ForEach(stats.records.prefix(6)) { record in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(record.patternName)
                                .font(.subheadline.weight(.semibold))
                            Text(record.completedAt, style: .date)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(timeString(record.durationSeconds))
                            .font(.subheadline.weight(.semibold))
                    }
                    .padding(16)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
        }
    }

    private var lockedDetails: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Detailed stats")
                .font(.headline)

            Text("Unlock averages and recent-session history with aura Premium.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            PrimaryButton(title: "Unlock Premium", systemImage: "sparkles") {
                showPaywall = true
            }
        }
        .padding(18)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func timeString(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainder = seconds % 60
        if minutes == 0 {
            return "\(remainder)s"
        }
        if remainder == 0 {
            return "\(minutes)m"
        }
        return "\(minutes)m \(remainder)s"
    }
}
