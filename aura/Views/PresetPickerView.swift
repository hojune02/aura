import SwiftUI

struct PresetPickerView: View {
    var presets: [BreathingPattern]
    @Binding var selectedPattern: BreathingPattern
    var isPremiumUnlocked: Bool
    var onLockedSelection: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Breathing reset")
                .font(.headline)

            VStack(spacing: 10) {
                ForEach(presets) { preset in
                    Button {
                        if preset.isPremium && !isPremiumUnlocked {
                            onLockedSelection()
                        } else {
                            selectedPattern = preset
                        }
                    } label: {
                        HStack(spacing: 14) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(preset.name)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.primary)
                                Text("\(preset.shortDescription) \(preset.formattedDuration)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }

                            Spacer(minLength: 8)

                            if preset.isPremium && !isPremiumUnlocked {
                                Image(systemName: "lock.fill")
                                    .foregroundStyle(.secondary)
                            } else if preset.id == selectedPattern.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.primary)
                            }
                        }
                        .padding(16)
                        .background(background(for: preset))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func background(for preset: BreathingPattern) -> some ShapeStyle {
        if preset.id == selectedPattern.id {
            return AnyShapeStyle(.regularMaterial)
        }
        return AnyShapeStyle(.ultraThinMaterial)
    }
}
