import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var purchases: PurchaseStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("aura Premium")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                        Text("A one-time unlock for deeper resets, extra themes, and richer local stats.")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 12) {
                        ForEach(PremiumFeature.allCases) { feature in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundStyle(.green)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(feature.title)
                                        .font(.subheadline.weight(.semibold))
                                    Text(feature.detail)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            .padding(14)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                    }

                    if let message = purchases.purchaseMessage {
                        Text(message)
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 12) {
                        PrimaryButton(title: purchaseTitle, systemImage: "sparkles") {
                            Task { await purchases.purchasePremium() }
                        }
                        PrimaryButton(title: "Restore Purchases", systemImage: "arrow.clockwise", isProminent: false) {
                            Task { await purchases.restorePurchases() }
                        }
                    }
                }
                .padding(22)
            }
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .task {
                await purchases.loadProducts()
            }
        }
    }

    private var purchaseTitle: String {
        if purchases.isPremiumUnlocked {
            return "Premium Unlocked"
        }
        if let product = purchases.premiumProduct {
            return "Unlock for \(product.displayPrice)"
        }
        return "Unlock Premium"
    }
}
