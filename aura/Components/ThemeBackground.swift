import SwiftUI

struct ThemeBackground<Content: View>: View {
    var theme: AppTheme
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            LinearGradient(
                colors: theme.gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Rectangle()
                .fill(.ultraThinMaterial.opacity(0.28))
                .ignoresSafeArea()

            content
        }
        .foregroundStyle(theme.foreground)
        .environment(\.colorScheme, theme == .midnight ? .dark : .light)
    }
}
