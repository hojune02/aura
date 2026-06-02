import SwiftUI

@main
struct AuraApp: App {
    @StateObject private var settingsStore = AppSettingsStore()
    @StateObject private var statsStore = SessionStatsStore()
    @StateObject private var purchaseStore = PurchaseStore()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(settingsStore)
                .environmentObject(statsStore)
                .environmentObject(purchaseStore)
        }
    }
}
