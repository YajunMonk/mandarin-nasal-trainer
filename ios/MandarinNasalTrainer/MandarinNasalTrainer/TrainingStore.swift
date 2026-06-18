import Foundation

@MainActor
final class TrainingStore: ObservableObject {
    @Published var selectedMode: TrainingMode = .listen {
        didSet { refreshQuestion() }
    }
    @Published var selectedGroupID: String = "all" {
        didSet { refreshQuestion() }
    }
    @Published private(set) var currentQuestion: QuizQuestion
    @Published private(set) var currentRepeatPair: MinimalPair
    @Published private(set) var result: AnswerResult?
    @Published private(set) var stats: TrainingStats

    private let storageKey = "mandarin-nasal-trainer-ios-v1"

    init() {
        let loaded = TrainingStore.loadStats(storageKey: storageKey)
        stats = loaded
        currentQuestion = TrainingStore.makeQuestion(mode: .listen, selectedGroupID: "all")
        currentRepeatPair = TrainingStore.filteredPairs(selectedGroupID: "all").first ?? NasalContent.pairs[0]
    }

    var todayRecord: DailyRecord {
        stats.daily[Self.todayKey] ?? DailyRecord()
    }

    var todayProgress: Double {
        min(Double(todayRecord.answered + todayRecord.repeatClear) / Double(NasalContent.dailyGoal), 1)
    }

    var filteredGroups: [NasalGroup] {
        if selectedGroupID == "all" { return NasalContent.groups }
        return NasalContent.groups.filter { $0.id == selectedGroupID }
    }

    var mistakeList: [MistakeRecord] {
        stats.mistakes.values.sorted { lhs, rhs in
            if lhs.count == rhs.count { return lhs.lastSeen > rhs.lastSeen }
            return lhs.count > rhs.count
        }
    }

    func selectGroup(_ id: String) {
        selectedGroupID = id
    }

    func answer(_ option: AnswerOption) {
        guard result == nil else { return }

        let isCorrect = option.id == currentQuestion.correctOptionID
        result = AnswerResult(
            selectedOptionID: option.id,
            correctOptionID: currentQuestion.correctOptionID,
            isCorrect: isCorrect,
            explanation: currentQuestion.explanation
        )

        stats.totalAnswered += 1
        var day = stats.daily[Self.todayKey] ?? DailyRecord()
        day.answered += 1

        if isCorrect {
            stats.correct += 1
            stats.streak += 1
            stats.bestStreak = max(stats.bestStreak, stats.streak)
            day.correct += 1
        } else {
            stats.streak = 0
            recordMistake(currentQuestion.reviewItem)
        }

        stats.daily[Self.todayKey] = day
        saveStats()
    }

    func nextQuestion() {
        result = nil
        currentQuestion = Self.makeQuestion(mode: selectedMode, selectedGroupID: selectedGroupID)
    }

    func nextRepeatPair() {
        let pairs = Self.filteredPairs(selectedGroupID: selectedGroupID)
        currentRepeatPair = pairs.randomElement() ?? NasalContent.pairs[0]
    }

    func markRepeat(confident: Bool) {
        var day = stats.daily[Self.todayKey] ?? DailyRecord()
        if confident {
            stats.repeatClear += 1
            day.repeatClear += 1
        } else {
            stats.repeatUnstable += 1
            day.repeatUnstable += 1
            recordMistake(ReviewItem(
                text: "\(currentRepeatPair.front.text) / \(currentRepeatPair.back.text)",
                pinyin: "\(currentRepeatPair.front.pinyin) / \(currentRepeatPair.back.pinyin)",
                groupID: currentRepeatPair.groupID,
                nasal: .back,
                note: "跟读时仍然容易混淆"
            ))
        }
        stats.daily[Self.todayKey] = day
        saveStats()
        nextRepeatPair()
    }

    func resetStats() {
        stats = TrainingStats()
        saveStats()
    }

    private func refreshQuestion() {
        result = nil
        currentQuestion = Self.makeQuestion(mode: selectedMode, selectedGroupID: selectedGroupID)
        currentRepeatPair = Self.filteredPairs(selectedGroupID: selectedGroupID).randomElement() ?? NasalContent.pairs[0]
    }

    private func recordMistake(_ item: ReviewItem) {
        let key = "\(item.text)-\(item.pinyin)-\(item.groupID)"
        var record = stats.mistakes[key] ?? MistakeRecord(
            text: item.text,
            pinyin: item.pinyin,
            groupID: item.groupID,
            nasal: item.nasal,
            note: item.note,
            count: 0,
            lastSeen: Self.todayKey
        )
        record.count += 1
        record.lastSeen = Self.todayKey
        stats.mistakes[key] = record
    }

    private func saveStats() {
        guard let data = try? JSONEncoder().encode(stats) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private static func loadStats(storageKey: String) -> TrainingStats {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let decoded = try? JSONDecoder().decode(TrainingStats.self, from: data)
        else {
            return TrainingStats()
        }
        return decoded
    }

    private static func makeQuestion(mode: TrainingMode, selectedGroupID: String) -> QuizQuestion {
        switch mode {
        case .listen:
            return makeListenQuestion(selectedGroupID: selectedGroupID)
        case .classify:
            return makeClassifyQuestion(selectedGroupID: selectedGroupID)
        case .pinyin:
            return makePinyinQuestion(selectedGroupID: selectedGroupID)
        case .repeatPractice:
            return makeListenQuestion(selectedGroupID: selectedGroupID)
        }
    }

    private static func makeListenQuestion(selectedGroupID: String) -> QuizQuestion {
        let pair = filteredPairs(selectedGroupID: selectedGroupID).randomElement() ?? NasalContent.pairs[0]
        let target = Bool.random() ? pair.front : pair.back
        let options = [
            AnswerOption(id: pair.front.id, title: pair.front.text, subtitle: pair.front.pinyin),
            AnswerOption(id: pair.back.id, title: pair.back.text, subtitle: pair.back.pinyin)
        ]

        return QuizQuestion(
            mode: .listen,
            groupID: pair.groupID,
            prompt: "听一遍，选你听到的字词",
            spokenText: target.text,
            targetText: target.text,
            targetPinyin: target.pinyin,
            options: options,
            correctOptionID: target.id,
            explanation: "\(target.text) 是 \(target.nasal.title)，拼音是 \(target.pinyin)。",
            reviewItem: ReviewItem(
                text: target.text,
                pinyin: target.pinyin,
                groupID: pair.groupID,
                nasal: target.nasal,
                note: "\(NasalContent.group(for: pair.groupID).title) 混淆组"
            )
        )
    }

    private static func makeClassifyQuestion(selectedGroupID: String) -> QuizQuestion {
        let word = filteredWords(selectedGroupID: selectedGroupID).randomElement() ?? NasalContent.words[0]
        let options = NasalKind.allCases.map {
            AnswerOption(id: $0.rawValue, title: $0.title, subtitle: $0.mark)
        }

        return QuizQuestion(
            mode: .classify,
            groupID: word.groupID,
            prompt: "判断这个词主要练哪类鼻音",
            spokenText: word.text,
            targetText: word.text,
            targetPinyin: word.pinyin,
            options: options,
            correctOptionID: word.nasal.rawValue,
            explanation: "\(word.text) 读 \(word.pinyin)，\(word.note)。",
            reviewItem: ReviewItem(text: word.text, pinyin: word.pinyin, groupID: word.groupID, nasal: word.nasal, note: word.note)
        )
    }

    private static func makePinyinQuestion(selectedGroupID: String) -> QuizQuestion {
        let word = filteredWords(selectedGroupID: selectedGroupID).randomElement() ?? NasalContent.words[0]
        let candidates = NasalContent.words
            .filter { $0.id != word.id && $0.groupID == word.groupID }
            .shuffled()
            .prefix(3)
            .map { $0.pinyin }
        let optionPinyins = Array(Set([word.pinyin] + candidates)).shuffled()
        let options = optionPinyins.map { AnswerOption(id: $0, title: $0, subtitle: "") }

        return QuizQuestion(
            mode: .pinyin,
            groupID: word.groupID,
            prompt: "给这个字词选择正确拼音",
            spokenText: word.text,
            targetText: word.text,
            targetPinyin: word.pinyin,
            options: options,
            correctOptionID: word.pinyin,
            explanation: "\(word.text) 的正确拼音是 \(word.pinyin)，\(word.note)。",
            reviewItem: ReviewItem(text: word.text, pinyin: word.pinyin, groupID: word.groupID, nasal: word.nasal, note: word.note)
        )
    }

    private static func filteredWords(selectedGroupID: String) -> [WordItem] {
        if selectedGroupID == "all" { return NasalContent.words }
        return NasalContent.words.filter { $0.groupID == selectedGroupID }
    }

    private static func filteredPairs(selectedGroupID: String) -> [MinimalPair] {
        if selectedGroupID == "all" { return NasalContent.pairs }
        return NasalContent.pairs.filter { $0.groupID == selectedGroupID }
    }

    private static var todayKey: String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
