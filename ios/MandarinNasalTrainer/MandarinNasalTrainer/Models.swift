import Foundation

enum NasalKind: String, Codable, CaseIterable, Identifiable {
    case front
    case back

    var id: String { rawValue }

    var title: String {
        switch self {
        case .front: "前鼻音"
        case .back: "后鼻音"
        }
    }

    var mark: String {
        switch self {
        case .front: "-n"
        case .back: "-ng"
        }
    }
}

enum TrainingMode: String, CaseIterable, Identifiable {
    case listen
    case classify
    case pinyin
    case repeatPractice

    var id: String { rawValue }

    var title: String {
        switch self {
        case .listen: "听辨"
        case .classify: "归类"
        case .pinyin: "拼音"
        case .repeatPractice: "跟读"
        }
    }

    var subtitle: String {
        switch self {
        case .listen: "先听标准音，再选字词"
        case .classify: "判断前鼻音还是后鼻音"
        case .pinyin: "给字词选择正确拼音"
        case .repeatPractice: "看口腔图，慢速模仿"
        }
    }

    var symbol: String {
        switch self {
        case .listen: "ear"
        case .classify: "square.grid.2x2"
        case .pinyin: "textformat.abc"
        case .repeatPractice: "waveform"
        }
    }
}

struct WordToken: Identifiable, Hashable, Codable {
    var id: String { text + pinyin + nasal.rawValue }
    let text: String
    let pinyin: String
    let nasal: NasalKind
    let groupID: String
}

struct MinimalPair: Identifiable, Hashable, Codable {
    let id: String
    let groupID: String
    let front: WordToken
    let back: WordToken
}

struct NasalGroup: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let imageName: String
    let frontFinal: String
    let backFinal: String
    let frontTip: String
    let backTip: String
    let examples: [MinimalPair]
}

struct WordItem: Identifiable, Hashable, Codable {
    let id: String
    let text: String
    let pinyin: String
    let groupID: String
    let nasal: NasalKind
    let note: String
}

struct AnswerOption: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
}

struct ReviewItem: Hashable, Codable {
    let text: String
    let pinyin: String
    let groupID: String
    let nasal: NasalKind
    let note: String
}

struct QuizQuestion: Identifiable, Hashable {
    let id = UUID()
    let mode: TrainingMode
    let groupID: String
    let prompt: String
    let spokenText: String
    let targetText: String
    let targetPinyin: String
    let options: [AnswerOption]
    let correctOptionID: String
    let explanation: String
    let reviewItem: ReviewItem
}

struct AnswerResult: Equatable {
    let selectedOptionID: String
    let correctOptionID: String
    let isCorrect: Bool
    let explanation: String
}

struct MistakeRecord: Identifiable, Codable, Hashable {
    var id: String { text + pinyin + groupID }
    let text: String
    let pinyin: String
    let groupID: String
    let nasal: NasalKind
    let note: String
    var count: Int
    var lastSeen: String
}

struct DailyRecord: Codable, Hashable {
    var answered: Int = 0
    var correct: Int = 0
    var repeatClear: Int = 0
    var repeatUnstable: Int = 0
}

struct TrainingStats: Codable, Hashable {
    var totalAnswered: Int = 0
    var correct: Int = 0
    var streak: Int = 0
    var bestStreak: Int = 0
    var repeatClear: Int = 0
    var repeatUnstable: Int = 0
    var daily: [String: DailyRecord] = [:]
    var mistakes: [String: MistakeRecord] = [:]

    var accuracy: Double {
        guard totalAnswered > 0 else { return 0 }
        return Double(correct) / Double(totalAnswered)
    }
}

enum NasalContent {
    static let dailyGoal = 20

    static let groups: [NasalGroup] = [
        NasalGroup(
            id: "an-ang",
            title: "an / ang",
            imageName: "mouth-an-ang",
            frontFinal: "an",
            backFinal: "ang",
            frontTip: "an 收尾靠前，舌尖抵上齿龈，声音停在口腔前部。",
            backTip: "ang 收尾靠后，舌根抬向软腭，后腔共鸣更明显。",
            examples: [
                pair("班", "bān", "帮", "bāng", "an-ang"),
                pair("山", "shān", "伤", "shāng", "an-ang"),
                pair("担心", "dān xīn", "当心", "dāng xīn", "an-ang")
            ]
        ),
        NasalGroup(
            id: "en-eng",
            title: "en / eng",
            imageName: "mouth-en-eng",
            frontFinal: "en",
            backFinal: "eng",
            frontTip: "en 发完上下齿更接近，舌尖向前收。",
            backTip: "eng 舌根后缩，嘴巴微开，声音更厚。",
            examples: [
                pair("真", "zhēn", "争", "zhēng", "en-eng"),
                pair("身", "shēn", "生", "shēng", "en-eng"),
                pair("木盆", "mù pén", "木棚", "mù péng", "en-eng")
            ]
        ),
        NasalGroup(
            id: "in-ing",
            title: "in / ing",
            imageName: "mouth-in-ing",
            frontFinal: "in",
            backFinal: "ing",
            frontTip: "in 收尾舌尖上抬，不要把舌头往后撤。",
            backTip: "ing 从 i 滑向 ng，舌根抬起但舌位不要塌。",
            examples: [
                pair("金", "jīn", "京", "jīng", "in-ing"),
                pair("新", "xīn", "星", "xīng", "in-ing"),
                pair("金星", "jīn xīng", "精心", "jīng xīn", "in-ing")
            ]
        ),
        NasalGroup(
            id: "un-ong",
            title: "un / ong",
            imageName: "mouth-un-ong",
            frontFinal: "un",
            backFinal: "ong",
            frontTip: "un 的 n 收在前面，嘴唇圆但舌尖要有收束。",
            backTip: "ong 的 ng 在舌根，后口腔有明显收束感。",
            examples: [
                pair("村", "cūn", "葱", "cōng", "un-ong"),
                pair("春", "chūn", "冲", "chōng", "un-ong"),
                pair("昆仑", "kūn lún", "空笼", "kōng lóng", "un-ong")
            ]
        ),
        NasalGroup(
            id: "un-iong",
            title: "ün / iong",
            imageName: "mouth-yun-yong",
            frontFinal: "ün / yun",
            backFinal: "iong / yong",
            frontTip: "云、运、群、军这一类收前鼻音，舌尖别放掉。",
            backTip: "用、涌、穷、熊这一类收后鼻音，舌根要抬起。",
            examples: [
                pair("运", "yùn", "用", "yòng", "un-iong"),
                pair("云", "yún", "涌", "yǒng", "un-iong"),
                pair("群", "qún", "穷", "qióng", "un-iong")
            ]
        )
    ]

    static let words: [WordItem] = [
        word("w001", "安全", "ān quán", "an-ang", .front, "an / uan 都收 -n"),
        word("w002", "简单", "jiǎn dān", "an-ang", .front, "dan 收前鼻音"),
        word("w003", "时间", "shí jiān", "an-ang", .front, "jian 收前鼻音"),
        word("w004", "发现", "fā xiàn", "an-ang", .front, "xian 收前鼻音"),
        word("w005", "眼前", "yǎn qián", "an-ang", .front, "yan / qian 都收 -n"),
        word("w006", "山川", "shān chuān", "an-ang", .front, "shan / chuan 都收 -n"),
        word("w007", "阳光", "yáng guāng", "an-ang", .back, "ang / uang 都收 -ng"),
        word("w008", "方向", "fāng xiàng", "an-ang", .back, "fang / xiang 都收 -ng"),
        word("w009", "希望", "xī wàng", "an-ang", .back, "wang 收后鼻音"),
        word("w010", "健康", "jiàn kāng", "an-ang", .back, "kang 收后鼻音"),
        word("w011", "商量", "shāng liang", "an-ang", .back, "shang 收后鼻音"),
        word("w012", "帮忙", "bāng máng", "an-ang", .back, "两个字都收 -ng"),
        word("w013", "认真", "rèn zhēn", "en-eng", .front, "ren / zhen 都收 -n"),
        word("w014", "身份", "shēn fèn", "en-eng", .front, "shen / fen 都收 -n"),
        word("w015", "本人", "běn rén", "en-eng", .front, "ben / ren 都收 -n"),
        word("w016", "门诊", "mén zhěn", "en-eng", .front, "men / zhen 都收 -n"),
        word("w017", "根本", "gēn běn", "en-eng", .front, "gen / ben 都收 -n"),
        word("w018", "分寸", "fēn cùn", "en-eng", .front, "fen / cun 都收 -n"),
        word("w019", "生命", "shēng mìng", "en-eng", .back, "sheng / ming 都收 -ng"),
        word("w020", "成功", "chéng gōng", "en-eng", .back, "cheng / gong 都收 -ng"),
        word("w021", "风景", "fēng jǐng", "en-eng", .back, "feng / jing 都收 -ng"),
        word("w022", "证明", "zhèng míng", "en-eng", .back, "zheng / ming 都收 -ng"),
        word("w023", "能力", "néng lì", "en-eng", .back, "neng 收后鼻音"),
        word("w024", "等待", "děng dài", "en-eng", .back, "deng 收后鼻音"),
        word("w025", "今天", "jīn tiān", "in-ing", .front, "jin 收前鼻音"),
        word("w026", "新闻", "xīn wén", "in-ing", .front, "xin / wen 都收 -n"),
        word("w027", "人民", "rén mín", "in-ing", .front, "min 收前鼻音"),
        word("w028", "拼音", "pīn yīn", "in-ing", .front, "pin / yin 都收 -n"),
        word("w029", "亲近", "qīn jìn", "in-ing", .front, "qin / jin 都收 -n"),
        word("w030", "信任", "xìn rèn", "in-ing", .front, "xin 收前鼻音"),
        word("w031", "北京", "běi jīng", "in-ing", .back, "jing 收后鼻音"),
        word("w032", "明星", "míng xīng", "in-ing", .back, "ming / xing 都收 -ng"),
        word("w033", "平静", "píng jìng", "in-ing", .back, "ping / jing 都收 -ng"),
        word("w034", "经营", "jīng yíng", "in-ing", .back, "jing / ying 都收 -ng"),
        word("w035", "情况", "qíng kuàng", "in-ing", .back, "qing / kuang 都收 -ng"),
        word("w036", "影星", "yǐng xīng", "in-ing", .back, "ying / xing 都收 -ng"),
        word("w037", "春天", "chūn tiān", "un-ong", .front, "chun 收前鼻音"),
        word("w038", "农村", "nóng cūn", "un-ong", .front, "cun 收前鼻音"),
        word("w039", "昆仑", "kūn lún", "un-ong", .front, "kun / lun 都收 -n"),
        word("w040", "标准", "biāo zhǔn", "un-ong", .front, "zhun 收前鼻音"),
        word("w041", "顺利", "shùn lì", "un-ong", .front, "shun 收前鼻音"),
        word("w042", "讨论", "tǎo lùn", "un-ong", .front, "lun 收前鼻音"),
        word("w043", "空中", "kōng zhōng", "un-ong", .back, "kong / zhong 都收 -ng"),
        word("w044", "共同", "gòng tóng", "un-ong", .back, "gong / tong 都收 -ng"),
        word("w045", "总共", "zǒng gòng", "un-ong", .back, "zong / gong 都收 -ng"),
        word("w046", "红色", "hóng sè", "un-ong", .back, "hong 收后鼻音"),
        word("w047", "从众", "cóng zhòng", "un-ong", .back, "cong / zhong 都收 -ng"),
        word("w048", "运动", "yùn dòng", "un-ong", .back, "dong 收后鼻音，yùn 收前鼻音"),
        word("w049", "云南", "yún nán", "un-iong", .front, "yun 收前鼻音"),
        word("w050", "允许", "yǔn xǔ", "un-iong", .front, "yun 收前鼻音"),
        word("w051", "群众", "qún zhòng", "un-iong", .front, "qun 收前鼻音"),
        word("w052", "军训", "jūn xùn", "un-iong", .front, "jun / xun 都收 -n"),
        word("w053", "寻找", "xún zhǎo", "un-iong", .front, "xun 收前鼻音"),
        word("w054", "训练", "xùn liàn", "un-iong", .front, "xun 收前鼻音"),
        word("w055", "用功", "yòng gōng", "un-iong", .back, "yong / gong 都收 -ng"),
        word("w056", "穷人", "qióng rén", "un-iong", .back, "qiong 收后鼻音"),
        word("w057", "胸口", "xiōng kǒu", "un-iong", .back, "xiong 收后鼻音"),
        word("w058", "熊猫", "xióng māo", "un-iong", .back, "xiong 收后鼻音"),
        word("w059", "兄弟", "xiōng dì", "un-iong", .back, "xiong 收后鼻音"),
        word("w060", "汹涌", "xiōng yǒng", "un-iong", .back, "xiong / yong 都收 -ng")
    ]

    static let pairs: [MinimalPair] = [
        pair("班", "bān", "帮", "bāng", "an-ang"),
        pair("山", "shān", "伤", "shāng", "an-ang"),
        pair("三", "sān", "桑", "sāng", "an-ang"),
        pair("兰", "lán", "狼", "láng", "an-ang"),
        pair("盘", "pán", "旁", "páng", "an-ang"),
        pair("反", "fǎn", "访", "fǎng", "an-ang"),
        pair("担心", "dān xīn", "当心", "dāng xīn", "an-ang"),
        pair("真", "zhēn", "争", "zhēng", "en-eng"),
        pair("身", "shēn", "生", "shēng", "en-eng"),
        pair("陈", "chén", "成", "chéng", "en-eng"),
        pair("跟", "gēn", "耕", "gēng", "en-eng"),
        pair("分", "fēn", "风", "fēng", "en-eng"),
        pair("木盆", "mù pén", "木棚", "mù péng", "en-eng"),
        pair("人参", "rén shēn", "人生", "rén shēng", "en-eng"),
        pair("金", "jīn", "京", "jīng", "in-ing"),
        pair("新", "xīn", "星", "xīng", "in-ing"),
        pair("林", "lín", "零", "líng", "in-ing"),
        pair("民", "mín", "明", "míng", "in-ing"),
        pair("亲", "qīn", "青", "qīng", "in-ing"),
        pair("进", "jìn", "静", "jìng", "in-ing"),
        pair("信", "xìn", "性", "xìng", "in-ing"),
        pair("金星", "jīn xīng", "精心", "jīng xīn", "in-ing"),
        pair("村", "cūn", "葱", "cōng", "un-ong"),
        pair("春", "chūn", "冲", "chōng", "un-ong"),
        pair("昆", "kūn", "空", "kōng", "un-ong"),
        pair("尊", "zūn", "宗", "zōng", "un-ong"),
        pair("存", "cún", "从", "cóng", "un-ong"),
        pair("顿", "dùn", "动", "dòng", "un-ong"),
        pair("昆仑", "kūn lún", "空笼", "kōng lóng", "un-ong"),
        pair("运", "yùn", "用", "yòng", "un-iong"),
        pair("云", "yún", "涌", "yǒng", "un-iong"),
        pair("群", "qún", "穷", "qióng", "un-iong"),
        pair("寻", "xún", "熊", "xióng", "un-iong"),
        pair("军", "jūn", "窘", "jiǒng", "un-iong"),
        pair("运完", "yùn wán", "用完", "yòng wán", "un-iong")
    ]

    static func group(for id: String) -> NasalGroup {
        groups.first { $0.id == id } ?? groups[0]
    }

    private static func pair(_ frontText: String, _ frontPinyin: String, _ backText: String, _ backPinyin: String, _ groupID: String) -> MinimalPair {
        MinimalPair(
            id: "\(groupID)-\(frontText)-\(backText)",
            groupID: groupID,
            front: WordToken(text: frontText, pinyin: frontPinyin, nasal: .front, groupID: groupID),
            back: WordToken(text: backText, pinyin: backPinyin, nasal: .back, groupID: groupID)
        )
    }

    private static func word(_ id: String, _ text: String, _ pinyin: String, _ groupID: String, _ nasal: NasalKind, _ note: String) -> WordItem {
        WordItem(id: id, text: text, pinyin: pinyin, groupID: groupID, nasal: nasal, note: note)
    }
}
