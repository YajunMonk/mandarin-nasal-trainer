const MODES = [
  { id: "study", title: "规律速记", kicker: "Study", desc: "看拼音、听标准、记舌位" },
  { id: "listen", title: "听辨挑战", kicker: "Listen", desc: "先听读音，再选字词" },
  { id: "classify", title: "归类通关", kicker: "Sort", desc: "判断前鼻音或后鼻音" },
  { id: "pinyin", title: "拼音闯关", kicker: "Pinyin", desc: "给字词选正确拼音" },
  { id: "repeat", title: "跟读纠音", kicker: "Repeat", desc: "标准音、录音、识别自测" },
  { id: "mistakes", title: "错题复习", kicker: "Review", desc: "只练最容易混的词" }
];

const FINAL_GROUPS = [
  {
    id: "an-ang",
    label: "an / ang",
    image: "./assets/mouth-an-ang.jpg",
    front: "an",
    back: "ang",
    frontTip: "an 收尾靠前，舌尖抵上齿龈。",
    backTip: "ang 收尾靠后，舌根抬向软腭。",
    examples: [
      ["班", "bān", "帮", "bāng"],
      ["山", "shān", "伤", "shāng"],
      ["担心", "dān xīn", "当心", "dāng xīn"]
    ]
  },
  {
    id: "en-eng",
    label: "en / eng",
    image: "./assets/mouth-en-eng.jpg",
    front: "en",
    back: "eng",
    frontTip: "en 发完上下齿更接近，声音更靠前。",
    backTip: "eng 舌根后缩，嘴巴微开，声音更厚。",
    examples: [
      ["真", "zhēn", "争", "zhēng"],
      ["身", "shēn", "生", "shēng"],
      ["木盆", "mù pén", "木棚", "mù péng"]
    ]
  },
  {
    id: "in-ing",
    label: "in / ing",
    image: "./assets/mouth-in-ing.jpg",
    front: "in",
    back: "ing",
    frontTip: "in 收尾舌尖上抬，不要把舌头往后撤。",
    backTip: "ing 从 i 过渡到 ng，舌头后移但舌位不降低。",
    examples: [
      ["金", "jīn", "京", "jīng"],
      ["新", "xīn", "星", "xīng"],
      ["金星", "jīn xīng", "精心", "jīng xīn"]
    ]
  },
  {
    id: "un-ong",
    label: "un / ong",
    image: "./assets/mouth-un-ong.jpg",
    front: "un",
    back: "ong",
    frontTip: "un 的 n 要收在前面，别直接滑到 ong。",
    backTip: "ong 的 ng 在舌根，口腔后部有收束感。",
    examples: [
      ["村", "cūn", "葱", "cōng"],
      ["春", "chūn", "冲", "chōng"],
      ["昆仑", "kūn lún", "空笼", "kōng lóng"]
    ]
  },
  {
    id: "un-iong",
    label: "ün / iong",
    image: "./assets/mouth-yun-yong.jpg",
    front: "ün / yun",
    back: "iong / yong",
    frontTip: "云、运、群、军这一类收在前鼻音。",
    backTip: "用、涌、穷、熊这一类收在后鼻音。",
    examples: [
      ["运", "yùn", "用", "yòng"],
      ["云", "yún", "涌", "yǒng"],
      ["群", "qún", "穷", "qióng"]
    ]
  }
];

const WORDS = [
  { id: "w001", text: "安全", pinyin: "ān quán", family: "an-ang", nasal: "front", note: "an / uan 都收 -n" },
  { id: "w002", text: "简单", pinyin: "jiǎn dān", family: "an-ang", nasal: "front", note: "dan 收前鼻音" },
  { id: "w003", text: "时间", pinyin: "shí jiān", family: "an-ang", nasal: "front", note: "jian 收前鼻音" },
  { id: "w004", text: "发现", pinyin: "fā xiàn", family: "an-ang", nasal: "front", note: "xian 收前鼻音" },
  { id: "w005", text: "眼前", pinyin: "yǎn qián", family: "an-ang", nasal: "front", note: "yan / qian 都收 -n" },
  { id: "w006", text: "山川", pinyin: "shān chuān", family: "an-ang", nasal: "front", note: "shan / chuan 都收 -n" },
  { id: "w007", text: "阳光", pinyin: "yáng guāng", family: "an-ang", nasal: "back", note: "ang / uang 都收 -ng" },
  { id: "w008", text: "方向", pinyin: "fāng xiàng", family: "an-ang", nasal: "back", note: "fang / xiang 都收 -ng" },
  { id: "w009", text: "希望", pinyin: "xī wàng", family: "an-ang", nasal: "back", note: "wang 收后鼻音" },
  { id: "w010", text: "健康", pinyin: "jiàn kāng", family: "an-ang", nasal: "back", note: "kang 收后鼻音" },
  { id: "w011", text: "商量", pinyin: "shāng liang", family: "an-ang", nasal: "back", note: "shang 收后鼻音" },
  { id: "w012", text: "帮忙", pinyin: "bāng máng", family: "an-ang", nasal: "back", note: "两个字都收 -ng" },

  { id: "w013", text: "认真", pinyin: "rèn zhēn", family: "en-eng", nasal: "front", note: "ren / zhen 都收 -n" },
  { id: "w014", text: "身份", pinyin: "shēn fèn", family: "en-eng", nasal: "front", note: "shen / fen 都收 -n" },
  { id: "w015", text: "本人", pinyin: "běn rén", family: "en-eng", nasal: "front", note: "ben / ren 都收 -n" },
  { id: "w016", text: "门诊", pinyin: "mén zhěn", family: "en-eng", nasal: "front", note: "men / zhen 都收 -n" },
  { id: "w017", text: "根本", pinyin: "gēn běn", family: "en-eng", nasal: "front", note: "gen / ben 都收 -n" },
  { id: "w018", text: "分寸", pinyin: "fēn cùn", family: "en-eng", nasal: "front", note: "fen / cun 都收 -n" },
  { id: "w019", text: "生命", pinyin: "shēng mìng", family: "en-eng", nasal: "back", note: "sheng / ming 都收 -ng" },
  { id: "w020", text: "成功", pinyin: "chéng gōng", family: "en-eng", nasal: "back", note: "cheng / gong 都收 -ng" },
  { id: "w021", text: "风景", pinyin: "fēng jǐng", family: "en-eng", nasal: "back", note: "feng / jing 都收 -ng" },
  { id: "w022", text: "证明", pinyin: "zhèng míng", family: "en-eng", nasal: "back", note: "zheng / ming 都收 -ng" },
  { id: "w023", text: "能力", pinyin: "néng lì", family: "en-eng", nasal: "back", note: "neng 收后鼻音" },
  { id: "w024", text: "等待", pinyin: "děng dài", family: "en-eng", nasal: "back", note: "deng 收后鼻音" },

  { id: "w025", text: "今天", pinyin: "jīn tiān", family: "in-ing", nasal: "front", note: "jin 收前鼻音" },
  { id: "w026", text: "新闻", pinyin: "xīn wén", family: "in-ing", nasal: "front", note: "xin / wen 都收 -n" },
  { id: "w027", text: "人民", pinyin: "rén mín", family: "in-ing", nasal: "front", note: "min 收前鼻音" },
  { id: "w028", text: "拼音", pinyin: "pīn yīn", family: "in-ing", nasal: "front", note: "pin / yin 都收 -n" },
  { id: "w029", text: "亲近", pinyin: "qīn jìn", family: "in-ing", nasal: "front", note: "qin / jin 都收 -n" },
  { id: "w030", text: "信任", pinyin: "xìn rèn", family: "in-ing", nasal: "front", note: "xin 收前鼻音" },
  { id: "w031", text: "北京", pinyin: "běi jīng", family: "in-ing", nasal: "back", note: "jing 收后鼻音" },
  { id: "w032", text: "明星", pinyin: "míng xīng", family: "in-ing", nasal: "back", note: "ming / xing 都收 -ng" },
  { id: "w033", text: "平静", pinyin: "píng jìng", family: "in-ing", nasal: "back", note: "ping / jing 都收 -ng" },
  { id: "w034", text: "经营", pinyin: "jīng yíng", family: "in-ing", nasal: "back", note: "jing / ying 都收 -ng" },
  { id: "w035", text: "情况", pinyin: "qíng kuàng", family: "in-ing", nasal: "back", note: "qing / kuang 都收 -ng" },
  { id: "w036", text: "影星", pinyin: "yǐng xīng", family: "in-ing", nasal: "back", note: "ying / xing 都收 -ng" },

  { id: "w037", text: "春天", pinyin: "chūn tiān", family: "un-ong", nasal: "front", note: "chun 收前鼻音" },
  { id: "w038", text: "农村", pinyin: "nóng cūn", family: "un-ong", nasal: "front", note: "cun 收前鼻音" },
  { id: "w039", text: "昆仑", pinyin: "kūn lún", family: "un-ong", nasal: "front", note: "kun / lun 都收 -n" },
  { id: "w040", text: "标准", pinyin: "biāo zhǔn", family: "un-ong", nasal: "front", note: "zhun 收前鼻音" },
  { id: "w041", text: "顺利", pinyin: "shùn lì", family: "un-ong", nasal: "front", note: "shun 收前鼻音" },
  { id: "w042", text: "讨论", pinyin: "tǎo lùn", family: "un-ong", nasal: "front", note: "lun 收前鼻音" },
  { id: "w043", text: "空中", pinyin: "kōng zhōng", family: "un-ong", nasal: "back", note: "kong / zhong 都收 -ng" },
  { id: "w044", text: "共同", pinyin: "gòng tóng", family: "un-ong", nasal: "back", note: "gong / tong 都收 -ng" },
  { id: "w045", text: "总共", pinyin: "zǒng gòng", family: "un-ong", nasal: "back", note: "zong / gong 都收 -ng" },
  { id: "w046", text: "红色", pinyin: "hóng sè", family: "un-ong", nasal: "back", note: "hong 收后鼻音" },
  { id: "w047", text: "从众", pinyin: "cóng zhòng", family: "un-ong", nasal: "back", note: "cong / zhong 都收 -ng" },
  { id: "w048", text: "运动", pinyin: "yùn dòng", family: "un-ong", nasal: "back", note: "dong 收后鼻音，yùn 收前鼻音" },

  { id: "w049", text: "云南", pinyin: "yún nán", family: "un-iong", nasal: "front", note: "yun 收前鼻音" },
  { id: "w050", text: "允许", pinyin: "yǔn xǔ", family: "un-iong", nasal: "front", note: "yun 收前鼻音" },
  { id: "w051", text: "群众", pinyin: "qún zhòng", family: "un-iong", nasal: "front", note: "qun 收前鼻音" },
  { id: "w052", text: "军训", pinyin: "jūn xùn", family: "un-iong", nasal: "front", note: "jun / xun 都收 -n" },
  { id: "w053", text: "寻找", pinyin: "xún zhǎo", family: "un-iong", nasal: "front", note: "xun 收前鼻音" },
  { id: "w054", text: "训练", pinyin: "xùn liàn", family: "un-iong", nasal: "front", note: "xun 收前鼻音" },
  { id: "w055", text: "用功", pinyin: "yòng gōng", family: "un-iong", nasal: "back", note: "yong / gong 都收 -ng" },
  { id: "w056", text: "穷人", pinyin: "qióng rén", family: "un-iong", nasal: "back", note: "qiong 收后鼻音" },
  { id: "w057", text: "胸口", pinyin: "xiōng kǒu", family: "un-iong", nasal: "back", note: "xiong 收后鼻音" },
  { id: "w058", text: "熊猫", pinyin: "xióng māo", family: "un-iong", nasal: "back", note: "xiong 收后鼻音" },
  { id: "w059", text: "兄弟", pinyin: "xiōng dì", family: "un-iong", nasal: "back", note: "xiong 收后鼻音" },
  { id: "w060", text: "汹涌", pinyin: "xiōng yǒng", family: "un-iong", nasal: "back", note: "xiong / yong 都收 -ng" }
];

const PAIRS = [
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
];

function pair(frontText, frontPinyin, backText, backPinyin, family) {
  const baseId = `${family}-${frontText}-${backText}`;
  return {
    id: baseId,
    family,
    left: { id: `${baseId}-front`, text: frontText, pinyin: frontPinyin, nasal: "front", family },
    right: { id: `${baseId}-back`, text: backText, pinyin: backPinyin, nasal: "back", family }
  };
}

const STORAGE_KEY = "mandarin-nasal-trainer-v1";
const DAILY_GOAL = 20;
const TODAY = new Date().toISOString().slice(0, 10);

let state = {
  mode: "study",
  familyFilter: "all",
  mouthGroup: "an-ang",
  currentQuestion: null,
  answered: false,
  mediaRecorder: null,
  audioChunks: [],
  recognition: null,
  stats: loadStats()
};

const els = {
  modeList: document.querySelector("#modeList"),
  stageBody: document.querySelector("#stageBody"),
  modeTitle: document.querySelector("#modeTitle"),
  modeKicker: document.querySelector("#modeKicker"),
  accuracy: document.querySelector("#accuracy"),
  streak: document.querySelector("#streak"),
  mistakeCount: document.querySelector("#mistakeCount"),
  dailyBar: document.querySelector("#dailyBar"),
  dailyText: document.querySelector("#dailyText"),
  shuffleBtn: document.querySelector("#shuffleBtn"),
  resetBtn: document.querySelector("#resetBtn"),
  mouthGroupTabs: document.querySelector("#mouthGroupTabs"),
  mouthImage: document.querySelector("#mouthImage"),
  mouthTip: document.querySelector("#mouthTip")
};

init();

function init() {
  renderModes();
  renderMouthPanel();
  renderStats();
  renderStage();
  bindGlobalActions();
}

function loadStats() {
  const fallback = {
    attempts: 0,
    correct: 0,
    streak: 0,
    bestStreak: 0,
    mistakes: {},
    daily: { date: TODAY, count: 0 }
  };

  try {
    const parsed = JSON.parse(localStorage.getItem(STORAGE_KEY));
    if (!parsed) return fallback;
    if (!parsed.daily || parsed.daily.date !== TODAY) parsed.daily = { date: TODAY, count: 0 };
    parsed.mistakes ||= {};
    return { ...fallback, ...parsed };
  } catch {
    return fallback;
  }
}

function saveStats() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(state.stats));
}

function bindGlobalActions() {
  els.shuffleBtn.addEventListener("click", () => {
    if (state.mode === "study") {
      state.familyFilter = nextFamilyFilter();
    } else {
      state.currentQuestion = null;
      state.answered = false;
    }
    renderStage();
  });

  els.resetBtn.addEventListener("click", () => {
    state.stats = {
      attempts: 0,
      correct: 0,
      streak: 0,
      bestStreak: 0,
      mistakes: {},
      daily: { date: TODAY, count: 0 }
    };
    saveStats();
    renderStats();
    renderStage();
  });

}

function renderMouthPanel() {
  const group = FINAL_GROUPS.find((item) => item.id === state.mouthGroup) || FINAL_GROUPS[0];
  els.mouthGroupTabs.innerHTML = FINAL_GROUPS.map((item) => `
    <button class="mouth-tab ${item.id === group.id ? "active" : ""}" data-mouth-group="${item.id}" type="button">
      ${item.label}
    </button>
  `).join("");
  els.mouthImage.src = group.image;
  els.mouthImage.alt = `${group.front} 和 ${group.back} 发音口腔侧面图`;
  els.mouthTip.textContent = `左图：${group.front} 前鼻音，${group.frontTip} 右图：${group.back} 后鼻音，${group.backTip}`;
  els.mouthGroupTabs.querySelectorAll("[data-mouth-group]").forEach((button) => {
    button.addEventListener("click", () => {
      state.mouthGroup = button.dataset.mouthGroup;
      renderMouthPanel();
    });
  });
}

function renderModes() {
  els.modeList.innerHTML = MODES.map((mode) => `
    <button class="mode-button ${mode.id === state.mode ? "active" : ""}" type="button" data-mode="${mode.id}">
      <strong>${mode.title}</strong>
      <span>${mode.desc}</span>
    </button>
  `).join("");

  els.modeList.querySelectorAll(".mode-button").forEach((button) => {
    button.addEventListener("click", () => {
      state.mode = button.dataset.mode;
      state.currentQuestion = null;
      state.answered = false;
      renderModes();
      renderStage();
    });
  });
}

function renderStats() {
  const accuracy = state.stats.attempts ? Math.round((state.stats.correct / state.stats.attempts) * 100) : 0;
  const mistakeCount = Object.values(state.stats.mistakes).filter((count) => count > 0).length;
  const dailyCount = state.stats.daily?.count || 0;
  els.accuracy.textContent = `${accuracy}%`;
  els.streak.textContent = String(state.stats.streak || 0);
  els.mistakeCount.textContent = String(mistakeCount);
  els.dailyText.textContent = `${Math.min(dailyCount, DAILY_GOAL)} / ${DAILY_GOAL}`;
  els.dailyBar.style.width = `${Math.min(100, (dailyCount / DAILY_GOAL) * 100)}%`;
}

function renderStage() {
  const mode = MODES.find((item) => item.id === state.mode);
  els.modeTitle.textContent = mode.title;
  els.modeKicker.textContent = mode.kicker;

  if (state.mode === "study") renderStudy();
  if (state.mode === "listen") renderListen();
  if (state.mode === "classify") renderClassify();
  if (state.mode === "pinyin") renderPinyin();
  if (state.mode === "repeat") renderRepeat();
  if (state.mode === "mistakes") renderMistakes();
}

function renderStudy() {
  const filtered = state.familyFilter === "all"
    ? WORDS
    : WORDS.filter((word) => word.family === state.familyFilter);

  els.stageBody.innerHTML = `
    <div class="pill-row">
      ${filterButtons()}
    </div>
    <div class="rule-grid">
      ${FINAL_GROUPS.map(renderRuleCard).join("")}
    </div>
    <div class="word-grid">
      ${filtered.map(renderWordCard).join("")}
    </div>
    <p class="source-note">训练重点来自普通话前后鼻音发音规律，并按甘肃、兰州口音常见混淆点整理：en/eng、in/ing、un/ong、ün/iong。</p>
  `;
  bindSpeakButtons();
  bindFilterButtons();
}

function renderRuleCard(group) {
  const example = group.examples[0];
  return `
    <article class="rule-card">
      <div class="rule-title">
        <strong>${group.front} / ${group.back}</strong>
        <span class="tag">${group.id}</span>
      </div>
      <figure class="rule-visual">
        <img src="${group.image}" alt="${group.front} 和 ${group.back} 发音口腔侧面图" loading="lazy">
        <figcaption>
          <span class="front-label">左：${group.front} / -n</span>
          <span class="back-label">右：${group.back} / -ng</span>
        </figcaption>
      </figure>
      <div class="rule-pairs">
        <button class="sound-chip front" type="button" data-speak="${example[0]}">
          <b>${example[0]}</b><span>${example[1]}</span>
        </button>
        <span>vs</span>
        <button class="sound-chip back" type="button" data-speak="${example[2]}">
          <b>${example[2]}</b><span>${example[3]}</span>
        </button>
      </div>
      <p>${group.frontTip}<br>${group.backTip}</p>
    </article>
  `;
}

function renderWordCard(word) {
  return `
    <article class="word-card">
      <div class="word-main">
        <strong>${word.text}</strong>
        <span class="pinyin">${word.pinyin}</span>
        <small>${word.nasal === "front" ? "前鼻音 -n" : "后鼻音 -ng"} · ${word.note}</small>
      </div>
      ${speakButton(word.text)}
    </article>
  `;
}

function filterButtons() {
  const buttons = [{ id: "all", label: "全部" }, ...FINAL_GROUPS.map((group) => ({ id: group.id, label: group.id }))];
  return buttons.map((button) => `
    <button class="pill-button ${state.familyFilter === button.id ? "active" : ""}" type="button" data-filter="${button.id}">
      ${button.label}
    </button>
  `).join("");
}

function bindFilterButtons() {
  els.stageBody.querySelectorAll("[data-filter]").forEach((button) => {
    button.addEventListener("click", () => {
      state.familyFilter = button.dataset.filter;
      renderStudy();
    });
  });
}

function renderListen() {
  const question = getQuestion("listen");
  els.stageBody.innerHTML = `
    <div class="quiz-shell">
      <article class="drill-card">
        <div class="toolbar">
          <button class="primary-button" type="button" data-speak="${question.target.text}">播放题目</button>
          <button class="ghost-button" type="button" data-speak-slow="${question.target.text}">慢速</button>
        </div>
        <div class="option-grid">
          ${question.options.map((item) => optionButton(item, item.id === question.target.id)).join("")}
        </div>
        <div id="feedback" class="feedback">听完以后，选你听到的字词。每个选项都带拼音。</div>
      </article>
    </div>
  `;
  bindSpeakButtons();
  bindOptionButtons(question);
}

function renderClassify() {
  const question = getQuestion("classify");
  els.stageBody.innerHTML = `
    <div class="quiz-shell">
      <article class="drill-card">
        <div class="question-word">
          <div>
            <strong>${question.target.text}</strong>
            <span class="pinyin">${question.target.pinyin}</span>
          </div>
          ${speakButton(question.target.text)}
        </div>
        <div class="option-grid">
          <button class="option-button" type="button" data-choice="front" data-correct="${question.target.nasal === "front"}">
            <strong>前鼻音</strong><span>-n：an / en / in / un / ün</span>
          </button>
          <button class="option-button" type="button" data-choice="back" data-correct="${question.target.nasal === "back"}">
            <strong>后鼻音</strong><span>-ng：ang / eng / ing / ong / iong</span>
          </button>
        </div>
        <div id="feedback" class="feedback">看拼音和字形，判断主要训练点属于哪一类。</div>
      </article>
    </div>
  `;
  bindSpeakButtons();
  bindOptionButtons(question);
}

function renderPinyin() {
  const question = getQuestion("pinyin");
  els.stageBody.innerHTML = `
    <div class="quiz-shell">
      <article class="drill-card">
        <div class="question-word">
          <div>
            <strong>${question.target.text}</strong>
            <span class="pinyin">${question.target.nasal === "front" ? "前鼻音待选" : "后鼻音待选"}</span>
          </div>
          ${speakButton(question.target.text)}
        </div>
        <div class="option-grid">
          ${question.options.map((item) => `
            <button class="option-button" type="button" data-choice="${item.id}" data-correct="${item.id === question.target.id}">
              <strong>${item.pinyin}</strong><span>${item.nasal === "front" ? "前鼻音 -n" : "后鼻音 -ng"}</span>
            </button>
          `).join("")}
        </div>
        <div id="feedback" class="feedback">给这个字词选正确拼音。</div>
      </article>
    </div>
  `;
  bindSpeakButtons();
  bindOptionButtons(question);
}

function renderRepeat() {
  const question = getQuestion("repeat");
  const recognitionSupported = Boolean(window.SpeechRecognition || window.webkitSpeechRecognition);
  els.stageBody.innerHTML = `
    <div class="quiz-shell">
      <article class="drill-card">
        <div class="question-word">
          <div>
            <strong>${question.target.text}</strong>
            <span class="pinyin">${question.target.pinyin}</span>
          </div>
          ${speakButton(question.target.text)}
        </div>
        <div class="toolbar">
          <button class="primary-button" type="button" data-speak="${question.target.text}">标准音</button>
          <button class="ghost-button" type="button" data-speak-slow="${question.target.text}">慢速</button>
          <button id="recordBtn" class="ghost-button" type="button">录音</button>
          <button id="stopRecordBtn" class="ghost-button" type="button" disabled>停止</button>
          <button id="recognizeBtn" class="ghost-button" type="button" ${recognitionSupported ? "" : "disabled"}>识别检测</button>
        </div>
        <div class="recorder-panel">
          <audio id="recordedAudio" controls hidden></audio>
          <div id="feedback" class="feedback">${recognitionSupported ? "跟读后可用浏览器识别结果做一次粗略自测。" : "当前浏览器不支持语音识别，仍可录音回放对比标准音。"}</div>
        </div>
      </article>
      <div class="result-grid">
        ${neighborCards(question.target).map((item) => `
          <article class="result-card">
            <strong>${item.text}</strong>
            <span>${item.pinyin} · ${item.nasal === "front" ? "前鼻音" : "后鼻音"}</span>
          </article>
        `).join("")}
      </div>
    </div>
  `;
  bindSpeakButtons();
  bindRecorder(question);
}

function renderMistakes() {
  const mistakes = Object.entries(state.stats.mistakes)
    .filter(([, count]) => count > 0)
    .sort((a, b) => b[1] - a[1])
    .map(([id, count]) => ({ item: findItemById(id), count }))
    .filter((row) => row.item);

  if (!mistakes.length) {
    els.stageBody.innerHTML = `
      <article class="drill-card">
        <h3>暂时没有错题</h3>
        <p class="feedback">完成几轮听辨、归类或拼音题后，这里会自动收集最容易混淆的字词。</p>
        <button class="primary-button" type="button" id="startMistakeSeed">开始一题</button>
      </article>
    `;
    document.querySelector("#startMistakeSeed").addEventListener("click", () => {
      state.mode = "listen";
      renderModes();
      renderStage();
    });
    return;
  }

  els.stageBody.innerHTML = `
    <div class="word-grid">
      ${mistakes.map(({ item, count }) => `
        <article class="word-card">
          <div class="word-main">
            <strong>${item.text}</strong>
            <span class="pinyin">${item.pinyin}</span>
            <small>错 ${count} 次 · ${item.nasal === "front" ? "前鼻音 -n" : "后鼻音 -ng"}</small>
          </div>
          ${speakButton(item.text)}
        </article>
      `).join("")}
    </div>
  `;
  bindSpeakButtons();
}

function getQuestion(type) {
  if (state.currentQuestion) return state.currentQuestion;

  if (type === "listen" || type === "pinyin") {
    const pairItem = sample(PAIRS);
    const target = Math.random() > 0.5 ? pairItem.left : pairItem.right;
    state.currentQuestion = {
      type,
      pair: pairItem,
      target,
      options: shuffle([pairItem.left, pairItem.right])
    };
    return state.currentQuestion;
  }

  const mistakeItems = mistakeDeck();
  const pool = mistakeItems.length && Math.random() > 0.35 ? mistakeItems : WORDS;
  state.currentQuestion = {
    type,
    target: sample(pool)
  };
  return state.currentQuestion;
}

function optionButton(item, isCorrect) {
  return `
    <button class="option-button" type="button" data-choice="${item.id}" data-correct="${isCorrect}">
      <strong>${item.text}</strong><span>${item.pinyin} · ${item.nasal === "front" ? "前鼻音 -n" : "后鼻音 -ng"}</span>
    </button>
  `;
}

function bindOptionButtons(question) {
  els.stageBody.querySelectorAll(".option-button").forEach((button) => {
    button.addEventListener("click", () => {
      if (state.answered) return;
      state.answered = true;
      const correct = button.dataset.correct === "true";
      const feedback = document.querySelector("#feedback");
      els.stageBody.querySelectorAll(".option-button").forEach((item) => {
        item.disabled = true;
        if (item.dataset.correct === "true") item.classList.add("correct");
      });
      if (!correct) button.classList.add("wrong");
      recordAnswer(correct, question.target);
      feedback.className = `feedback ${correct ? "good" : "bad"}`;
      feedback.innerHTML = feedbackText(question, correct);

      const next = document.createElement("button");
      next.className = "primary-button";
      next.type = "button";
      next.textContent = "下一题";
      next.addEventListener("click", () => {
        state.currentQuestion = null;
        state.answered = false;
        renderStage();
      });
      feedback.appendChild(document.createElement("br"));
      feedback.appendChild(next);
    });
  });
}

function feedbackText(question, correct) {
  const target = question.target;
  const family = FINAL_GROUPS.find((group) => group.id === target.family);
  const nasalText = target.nasal === "front" ? "前鼻音 -n" : "后鼻音 -ng";
  const tip = target.nasal === "front" ? family?.frontTip : family?.backTip;
  return `${correct ? "正确。" : "这一题要改过来。"}${target.text}，${target.pinyin}，${nasalText}。${tip || ""}`;
}

function recordAnswer(correct, item) {
  state.stats.attempts += 1;
  state.stats.daily.count += 1;
  if (correct) {
    state.stats.correct += 1;
    state.stats.streak += 1;
    state.stats.bestStreak = Math.max(state.stats.bestStreak || 0, state.stats.streak);
    if (state.stats.mistakes[item.id]) state.stats.mistakes[item.id] -= 1;
  } else {
    state.stats.streak = 0;
    state.stats.mistakes[item.id] = (state.stats.mistakes[item.id] || 0) + 1;
  }
  saveStats();
  renderStats();
}

function bindRecorder(question) {
  const recordBtn = document.querySelector("#recordBtn");
  const stopBtn = document.querySelector("#stopRecordBtn");
  const recognizeBtn = document.querySelector("#recognizeBtn");
  const audio = document.querySelector("#recordedAudio");
  const feedback = document.querySelector("#feedback");

  recordBtn.addEventListener("click", async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      state.audioChunks = [];
      state.mediaRecorder = new MediaRecorder(stream);
      state.mediaRecorder.addEventListener("dataavailable", (event) => {
        if (event.data.size) state.audioChunks.push(event.data);
      });
      state.mediaRecorder.addEventListener("stop", () => {
        const blob = new Blob(state.audioChunks, { type: "audio/webm" });
        audio.src = URL.createObjectURL(blob);
        audio.hidden = false;
        stream.getTracks().forEach((track) => track.stop());
        feedback.className = "feedback good";
        feedback.textContent = "录音已生成。先听标准音，再听自己的录音，对比尾音落在舌尖还是舌根。";
      });
      state.mediaRecorder.start();
      recordBtn.disabled = true;
      stopBtn.disabled = false;
      feedback.className = "feedback";
      feedback.textContent = "正在录音。";
    } catch {
      feedback.className = "feedback bad";
      feedback.textContent = "无法打开麦克风。GitHub Pages 的 HTTPS 环境通常可以录音，本地 file 打开时可能受浏览器限制。";
    }
  });

  stopBtn.addEventListener("click", () => {
    if (state.mediaRecorder?.state === "recording") {
      state.mediaRecorder.stop();
      recordBtn.disabled = false;
      stopBtn.disabled = true;
    }
  });

  recognizeBtn.addEventListener("click", () => {
    const Recognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    if (!Recognition) return;
    const recognition = new Recognition();
    recognition.lang = "zh-CN";
    recognition.interimResults = false;
    recognition.maxAlternatives = 3;
    recognition.addEventListener("result", (event) => {
      const results = Array.from(event.results[0]).map((item) => item.transcript.trim());
      const matched = results.some((text) => text.includes(question.target.text));
      const confused = neighborCards(question.target).find((item) => results.some((text) => text.includes(item.text)));
      feedback.className = `feedback ${matched ? "good" : "bad"}`;
      if (matched) {
        feedback.textContent = `识别结果包含“${question.target.text}”。这一轮先算通过，再继续保持尾音位置。`;
      } else if (confused) {
        feedback.textContent = `浏览器更像听成了“${confused.text}”。重点检查 ${question.target.pinyin} 的鼻音尾：${question.target.nasal === "front" ? "舌尖收 -n" : "舌根收 -ng"}。`;
      } else {
        feedback.textContent = `识别结果：${results.join(" / ")}。重新听标准音后再跟读一次。`;
      }
    });
    recognition.addEventListener("error", () => {
      feedback.className = "feedback bad";
      feedback.textContent = "识别没有成功。可以继续使用标准音和录音回放做对比。";
    });
    feedback.className = "feedback";
    feedback.textContent = "正在识别。";
    recognition.start();
  });
}

function speakButton(text) {
  return `
    <button class="speak-button" type="button" data-speak="${text}" title="朗读 ${text}">
      <span class="speak-icon" aria-hidden="true"><span></span><span></span><span></span></span>
      <span class="sr-only">朗读 ${text}</span>
    </button>
  `;
}

function bindSpeakButtons() {
  els.stageBody.querySelectorAll("[data-speak]").forEach((button) => {
    button.addEventListener("click", () => speak(button.dataset.speak));
  });
  els.stageBody.querySelectorAll("[data-speak-slow]").forEach((button) => {
    button.addEventListener("click", () => speak(button.dataset.speakSlow, 0.58));
  });
}

function speak(text, rate = 0.82) {
  if (!("speechSynthesis" in window)) return;
  window.speechSynthesis.cancel();
  const utterance = new SpeechSynthesisUtterance(text);
  utterance.lang = "zh-CN";
  utterance.rate = rate;
  utterance.pitch = 1;
  const voices = window.speechSynthesis.getVoices();
  const voice = voices.find((item) => /zh-CN|Chinese|Mandarin|普通话/.test(`${item.lang} ${item.name}`));
  if (voice) utterance.voice = voice;
  window.speechSynthesis.speak(utterance);
}

function neighborCards(target) {
  const pairItem = PAIRS.find((item) => item.left.id === target.id || item.right.id === target.id);
  if (pairItem) return [pairItem.left, pairItem.right];
  const sameFamily = WORDS.filter((word) => word.family === target.family && word.nasal !== target.nasal);
  return [target, sample(sameFamily)];
}

function mistakeDeck() {
  return Object.entries(state.stats.mistakes)
    .filter(([, count]) => count > 0)
    .map(([id]) => findItemById(id))
    .filter(Boolean);
}

function findItemById(id) {
  const words = [...WORDS, ...PAIRS.flatMap((item) => [item.left, item.right])];
  return words.find((item) => item.id === id);
}

function nextFamilyFilter() {
  const ids = ["all", ...FINAL_GROUPS.map((group) => group.id)];
  const index = ids.indexOf(state.familyFilter);
  return ids[(index + 1) % ids.length];
}

function sample(items) {
  return items[Math.floor(Math.random() * items.length)];
}

function shuffle(items) {
  return [...items].sort(() => Math.random() - 0.5);
}
