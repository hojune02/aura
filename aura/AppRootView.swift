import SwiftUI

struct AppRootView: View {
    @EnvironmentObject private var settings: AppSettingsStore

    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Reset", systemImage: "circle.hexagongrid.fill")
            }

            NavigationStack {
                StatsView()
            }
            .tabItem {
                Label("Stats", systemImage: "chart.bar.xaxis")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
        }
        .tint(settings.selectedTheme.accent)
    }
}
