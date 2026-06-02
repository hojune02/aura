import Foundation
import StoreKit

@MainActor
final class PurchaseStore: ObservableObject {
    static let premiumProductID = "com.aura.premium"

    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs: Set<String> = []
    @Published var purchaseMessage: String?

    private var updatesTask: Task<Void, Never>?

    var premiumProduct: Product? {
        products.first { $0.id == Self.premiumProductID }
    }

    var isPremiumUnlocked: Bool {
        purchasedProductIDs.contains(Self.premiumProductID)
    }

    init() {
        updatesTask = listenForTransactions()
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }

    deinit {
        updatesTask?.cancel()
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: [Self.premiumProductID])
            purchaseMessage = products.isEmpty ? "Purchases are not configured for this run yet." : nil
        } catch {
            products = []
            purchaseMessage = "StoreKit products could not be loaded."
        }
    }

    func purchasePremium() async {
        guard let premiumProduct else {
            purchaseMessage = "Purchases are not configured in this simulator yet."
            return
        }

        do {
            let result = try await premiumProduct.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await updatePurchasedProducts()
                await transaction.finish()
                purchaseMessage = "Premium is unlocked."
            case .userCancelled:
                purchaseMessage = nil
            case .pending:
                purchaseMessage = "Purchase is pending approval."
            @unknown default:
                purchaseMessage = "Purchase finished with an unknown status."
            }
        } catch {
            purchaseMessage = "Purchase could not be completed."
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
            purchaseMessage = isPremiumUnlocked ? "Premium is restored." : "No premium purchase was found."
        } catch {
            purchaseMessage = "Restore could not be completed."
        }
    }

    func updatePurchasedProducts() async {
        var purchased = Set<String>()

        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.revocationDate == nil {
                purchased.insert(transaction.productID)
            }
        }

        purchasedProductIDs = purchased
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task { [weak self] in
            for await result in Transaction.updates {
                guard case .verified(let transaction) = result else { continue }
                await self?.updatePurchasedProducts()
                await transaction.finish()
            }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw StoreError.failedVerification
        }
    }

    private enum StoreError: Error {
        case failedVerification
    }
}
