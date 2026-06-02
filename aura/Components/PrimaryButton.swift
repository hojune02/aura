import SwiftUI

struct PrimaryButton: View {
    var title: String
    var systemImage: String?
    var isProminent: Bool = true
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.headline)
                }
                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .padding(.horizontal, 18)
            .background(background)
            .foregroundStyle(isProminent ? Color.white : Color.primary)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: shadowColor, radius: isProminent ? 16 : 0, x: 0, y: 8)
        }
        .buttonStyle(.plain)
    }

    private var background: some ShapeStyle {
        if isProminent {
            return AnyShapeStyle(LinearGradient(
                colors: [Color.primary.opacity(0.86), Color.primary.opacity(0.62)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
        }
        return AnyShapeStyle(.ultraThinMaterial)
    }

    private var shadowColor: Color {
        isProminent ? Color.black.opacity(0.18) : .clear
    }
}
