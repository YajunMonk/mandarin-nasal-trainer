import SwiftUI

struct ContentView: View {
    @StateObject private var store = TrainingStore()
    @StateObject private var speech = SpeechService()

    var body: some View {
        TabView {
            PracticeView()
                .tabItem { Label("训练", systemImage: "target") }

            AtlasView()
                .tabItem { Label("图谱", systemImage: "book.pages") }

            ReviewView()
                .tabItem { Label("复盘", systemImage: "chart.line.uptrend.xyaxis") }
        }
        .environmentObject(store)
        .environmentObject(speech)
        .tint(AppTheme.teal)
    }
}

struct PracticeView: View {
    @EnvironmentObject private var store: TrainingStore
    @EnvironmentObject private var speech: SpeechService

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    PracticeHeader()
                    ModeStrip()
                    GroupStrip()

                    if store.selectedMode == .repeatPractice {
                        RepeatPracticeCard()
                    } else {
                        QuizPracticeCard()
                    }

                    StatsCard()
                }
                .padding(18)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("鼻音训练")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        speech.stop()
                    } label: {
                        Image(systemName: "speaker.slash")
                    }
                    .accessibilityLabel("停止朗读")
                }
            }
        }
    }
}

private struct PracticeHeader: View {
    @EnvironmentObject private var store: TrainingStore

    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("普通话前后鼻音")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(AppTheme.ink)
                        Text("今天先把最容易混的 n / ng 稳住。")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.muted)
                    }
                    Spacer()
                    ProgressRing(progress: store.todayProgress)
                }

                ProgressView(value: store.todayProgress)
                    .tint(AppTheme.teal)

                HStack(spacing: 14) {
                    MetricBlock(value: "\(store.todayRecord.answered)", label: "今日答题")
                    MetricBlock(value: "\(store.stats.streak)", label: "连续正确")
                    MetricBlock(value: "\(Int(store.stats.accuracy * 100))%", label: "总正确率")
                }
            }
        }
    }
}

private struct ProgressRing: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.line, lineWidth: 8)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(AppTheme.teal, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(Int(progress * 100))%")
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.ink)
        }
        .frame(width: 58, height: 58)
    }
}

private struct ModeStrip: View {
    @EnvironmentObject private var store: TrainingStore

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(TrainingMode.allCases) { mode in
                    Button {
                        store.selectedMode = mode
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: mode.symbol)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(mode.title)
                                    .font(.subheadline.weight(.bold))
                                Text(mode.subtitle)
                                    .font(.caption2)
                                    .lineLimit(1)
                            }
                        }
                        .foregroundStyle(store.selectedMode == mode ? .white : AppTheme.ink)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(store.selectedMode == mode ? AppTheme.ink : AppTheme.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(AppTheme.line.opacity(0.7), lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal, 1)
        }
    }
}

private struct GroupStrip: View {
    @EnvironmentObject private var store: TrainingStore

    private var groupIDs: [String] {
        ["all"] + NasalContent.groups.map(\.id)
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(groupIDs, id: \.self) { id in
                    let title = id == "all" ? "全部" : NasalContent.group(for: id).title
                    Button {
                        store.selectGroup(id)
                    } label: {
                        Text(title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(store.selectedGroupID == id ? .white : AppTheme.ink)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 9)
                            .background(store.selectedGroupID == id ? AppTheme.teal : AppTheme.surface)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(AppTheme.line.opacity(0.65), lineWidth: 1))
                    }
                }
            }
        }
    }
}

private struct QuizPracticeCard: View {
    @EnvironmentObject private var store: TrainingStore
    @EnvironmentObject private var speech: SpeechService

    private var question: QuizQuestion { store.currentQuestion }

    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    CapsuleBadge(title: NasalContent.group(for: question.groupID).title, tint: AppTheme.teal)
                    Spacer()
                    SpeakerButton(text: question.spokenText)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(question.prompt)
                        .font(.headline)
                        .foregroundStyle(AppTheme.muted)
                    Text(question.mode == .listen ? "请先听，不急着看答案" : question.targetText)
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.ink)
                    if question.mode != .listen {
                        Text(question.targetPinyin)
                            .font(.title3.weight(.medium))
                            .foregroundStyle(AppTheme.teal)
                    }
                }

                VStack(spacing: 10) {
                    ForEach(question.options) { option in
                        Button {
                            store.answer(option)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(option.title)
                                        .font(.headline)
                                    if !option.subtitle.isEmpty {
                                        Text(option.subtitle)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Spacer()
                                resultIcon(for: option)
                            }
                            .foregroundStyle(optionForeground(for: option))
                            .padding(15)
                            .background(optionBackground(for: option))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .disabled(store.result != nil)
                    }
                }

                if let result = store.result {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(result.isCorrect ? "答对了" : "这里容易混")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(result.isCorrect ? AppTheme.teal : AppTheme.coral)
                        Text(result.explanation)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.muted)
                        Button {
                            store.nextQuestion()
                            if store.selectedMode == .listen {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    speech.speak(store.currentQuestion.spokenText)
                                }
                            }
                        } label: {
                            Label("下一题", systemImage: "arrow.right")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(AppTheme.ink)
                    }
                    .padding(.top, 4)
                }
            }
        }
    }

    @ViewBuilder
    private func resultIcon(for option: AnswerOption) -> some View {
        if let result = store.result {
            if option.id == result.correctOptionID {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(AppTheme.teal)
            } else if option.id == result.selectedOptionID {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(AppTheme.coral)
            }
        }
    }

    private func optionForeground(for option: AnswerOption) -> Color {
        guard let result = store.result else { return AppTheme.ink }
        if option.id == result.correctOptionID { return AppTheme.teal }
        if option.id == result.selectedOptionID { return AppTheme.coral }
        return AppTheme.muted
    }

    private func optionBackground(for option: AnswerOption) -> Color {
        guard let result = store.result else { return AppTheme.background }
        if option.id == result.correctOptionID { return AppTheme.teal.opacity(0.12) }
        if option.id == result.selectedOptionID { return AppTheme.coral.opacity(0.12) }
        return AppTheme.background.opacity(0.65)
    }
}

private struct RepeatPracticeCard: View {
    @EnvironmentObject private var store: TrainingStore

    private var pair: MinimalPair { store.currentRepeatPair }
    private var group: NasalGroup { NasalContent.group(for: pair.groupID) }

    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    CapsuleBadge(title: group.title, tint: AppTheme.gold)
                    Spacer()
                    Button {
                        store.nextRepeatPair()
                    } label: {
                        Image(systemName: "shuffle")
                    }
                    .buttonStyle(.bordered)
                }

                Image(group.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 210)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(alignment: .topLeading) {
                        Text("左前鼻音  /  右后鼻音")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(AppTheme.ink)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .padding(12)
                    }

                HStack(spacing: 12) {
                    RepeatTokenView(token: pair.front, title: "前鼻音")
                    RepeatTokenView(token: pair.back, title: "后鼻音")
                }

                Text("跟读时先慢速读三遍，再正常速度读一遍。前鼻音找舌尖，后鼻音找舌根。")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.muted)

                HStack(spacing: 10) {
                    Button {
                        store.markRepeat(confident: true)
                    } label: {
                        Label("读稳了", systemImage: "checkmark")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.teal)

                    Button {
                        store.markRepeat(confident: false)
                    } label: {
                        Label("还会混", systemImage: "arrow.counterclockwise")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(AppTheme.coral)
                }
            }
        }
    }
}

private struct RepeatTokenView: View {
    let token: WordToken
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(token.nasal == .front ? AppTheme.teal : AppTheme.coral)
                Spacer()
                SpeakerButton(text: token.text, slow: true)
                    .scaleEffect(0.82)
                    .frame(width: 38, height: 38)
            }
            Text(token.text)
                .font(.title.weight(.bold))
                .foregroundStyle(AppTheme.ink)
            Text(token.pinyin)
                .font(.headline)
                .foregroundStyle(AppTheme.muted)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.background)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

private struct StatsCard: View {
    @EnvironmentObject private var store: TrainingStore

    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 14) {
                Text("训练复盘")
                    .font(.headline.weight(.bold))
                HStack(spacing: 12) {
                    MetricBlock(value: "\(store.stats.bestStreak)", label: "最佳连对")
                    MetricBlock(value: "\(store.stats.repeatClear)", label: "跟读稳了")
                    MetricBlock(value: "\(store.mistakeList.count)", label: "错题词")
                }
            }
        }
    }
}

struct AtlasView: View {
    @EnvironmentObject private var speech: SpeechService

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(NasalContent.groups) { group in
                        AtlasGroupCard(group: group)
                    }
                }
                .padding(18)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("口腔图谱")
        }
    }
}

private struct AtlasGroupCard: View {
    let group: NasalGroup

    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(group.title)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(AppTheme.ink)
                    Spacer()
                    CapsuleBadge(title: "左 n / 右 ng", tint: AppTheme.teal)
                }

                Image(group.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 190)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                HStack(alignment: .top, spacing: 12) {
                    TipColumn(title: group.frontFinal, kind: .front, text: group.frontTip)
                    TipColumn(title: group.backFinal, kind: .back, text: group.backTip)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("最小对照")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.muted)
                    ForEach(group.examples) { pair in
                        HStack {
                            PairToken(token: pair.front)
                            Image(systemName: "arrow.left.arrow.right")
                                .foregroundStyle(AppTheme.muted)
                            PairToken(token: pair.back)
                        }
                    }
                }
            }
        }
    }
}

private struct TipColumn: View {
    let title: String
    let kind: NasalKind
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CapsuleBadge(title: "\(title) \(kind.mark)", tint: kind == .front ? AppTheme.teal : AppTheme.coral)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(AppTheme.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(12)
        .background(AppTheme.background.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

private struct PairToken: View {
    let token: WordToken

    var body: some View {
        HStack(spacing: 8) {
            SpeakerButton(text: token.text)
                .scaleEffect(0.7)
                .frame(width: 30, height: 30)
            VStack(alignment: .leading, spacing: 1) {
                Text(token.text)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.ink)
                Text(token.pinyin)
                    .font(.caption)
                    .foregroundStyle(AppTheme.muted)
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ReviewView: View {
    @EnvironmentObject private var store: TrainingStore
    @State private var confirmReset = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    CardContainer {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("本地复盘")
                                .font(.title3.weight(.bold))
                            HStack(spacing: 12) {
                                MetricBlock(value: "\(store.stats.totalAnswered)", label: "累计答题")
                                MetricBlock(value: "\(store.stats.correct)", label: "累计正确")
                                MetricBlock(value: "\(Int(store.stats.accuracy * 100))%", label: "正确率")
                            }
                            HStack(spacing: 12) {
                                MetricBlock(value: "\(store.stats.repeatClear)", label: "跟读稳定")
                                MetricBlock(value: "\(store.stats.repeatUnstable)", label: "跟读不稳")
                                MetricBlock(value: "\(store.stats.bestStreak)", label: "最佳连对")
                            }
                        }
                    }

                    CardContainer {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("高频错题")
                                    .font(.headline.weight(.bold))
                                Spacer()
                                Button("清空") {
                                    confirmReset = true
                                }
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(AppTheme.coral)
                            }

                            if store.mistakeList.isEmpty {
                                Text("还没有错题。先去完成几轮听辨或拼音题。")
                                    .font(.subheadline)
                                    .foregroundStyle(AppTheme.muted)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 18)
                            } else {
                                ForEach(store.mistakeList) { item in
                                    MistakeRow(item: item)
                                }
                            }
                        }
                    }
                }
                .padding(18)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("复盘")
            .confirmationDialog("清空所有训练记录？", isPresented: $confirmReset, titleVisibility: .visible) {
                Button("清空记录", role: .destructive) {
                    store.resetStats()
                }
                Button("取消", role: .cancel) {}
            }
        }
    }
}

private struct MistakeRow: View {
    let item: MistakeRecord

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.text)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(AppTheme.ink)
                Text("\(item.pinyin) · \(NasalContent.group(for: item.groupID).title)")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.muted)
                Text(item.note)
                    .font(.caption)
                    .foregroundStyle(AppTheme.muted)
            }
            Spacer()
            VStack(spacing: 8) {
                CapsuleBadge(title: "\(item.count) 次", tint: AppTheme.coral)
                SpeakerButton(text: item.text, slow: true)
                    .scaleEffect(0.76)
                    .frame(width: 34, height: 34)
            }
        }
        .padding(.vertical, 10)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(AppTheme.line.opacity(0.6))
                .frame(height: 1)
        }
    }
}

#Preview {
    ContentView()
}
