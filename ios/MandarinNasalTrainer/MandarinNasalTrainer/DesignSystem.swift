import SwiftUI

enum AppTheme {
    static let background = Color(red: 0.965, green: 0.958, blue: 0.94)
    static let surface = Color(red: 1.0, green: 0.995, blue: 0.982)
    static let ink = Color(red: 0.08, green: 0.095, blue: 0.11)
    static let muted = Color(red: 0.42, green: 0.45, blue: 0.47)
    static let line = Color(red: 0.86, green: 0.84, blue: 0.80)
    static let teal = Color(red: 0.02, green: 0.56, blue: 0.58)
    static let coral = Color(red: 0.88, green: 0.34, blue: 0.26)
    static let gold = Color(red: 0.72, green: 0.52, blue: 0.18)
}

struct CardContainer<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(18)
            .background(AppTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(AppTheme.line.opacity(0.65), lineWidth: 1)
            )
            .shadow(color: AppTheme.ink.opacity(0.06), radius: 18, x: 0, y: 10)
    }
}

struct CapsuleBadge: View {
    let title: String
    let tint: Color

    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(tint)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(tint.opacity(0.1))
            .clipShape(Capsule())
    }
}

struct MetricBlock: View {
    let value: String
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title3.weight(.bold))
                .foregroundStyle(AppTheme.ink)
            Text(label)
                .font(.caption)
                .foregroundStyle(AppTheme.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SpeakerButton: View {
    let text: String
    var slow = false
    @EnvironmentObject private var speech: SpeechService

    var body: some View {
        Button {
            speech.speak(text, slow: slow)
        } label: {
            Image(systemName: slow ? "speaker.wave.1.fill" : "speaker.wave.2.fill")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 46, height: 46)
                .background(slow ? AppTheme.gold : AppTheme.ink)
                .clipShape(Circle())
        }
        .accessibilityLabel(slow ? "慢速朗读 \(text)" : "朗读 \(text)")
    }
}
