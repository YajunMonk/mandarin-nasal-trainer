# 普通话前后鼻音训练仪

面向甘肃口音的普通话前后鼻音专项训练 HTML 工具。

现在仓库同时包含两个版本：

- `index.html`：可直接打开或通过 GitHub Pages 使用的网页原型。
- `ios/MandarinNasalTrainer`：原生 SwiftUI iOS App 工程，包含重做插画、系统朗读、训练、图谱和复盘。

## 功能

- 常见前后鼻音字词表，全部带拼音。
- 一键朗读标准读音，使用浏览器 `speechSynthesis` 的中文语音。
- 听辨挑战、归类通关、拼音闯关、跟读纠音、错题复习。
- 跟读模式支持录音回放；支持的浏览器可用语音识别做粗略自测。
- 训练统计保存在浏览器本地 `localStorage`。

## 训练范围

第一版聚焦前后鼻音：

- `an / ang`
- `en / eng`
- `in / ing`
- `un / ong`
- `ün、yun / iong、yong`

内容参考了普通话前后鼻音发音规律、普通话水平测试训练材料，以及甘肃/兰州口音常见混淆点。工具里的字词经过重新筛选和组合，不是直接复制资料。

## 本地运行

直接打开 `index.html` 即可。若要测试录音或语音识别，建议使用本地服务器或 GitHub Pages 的 HTTPS 环境。

## iOS App

用 Xcode 打开：

```bash
open ios/MandarinNasalTrainer/MandarinNasalTrainer.xcodeproj
```

当前本机只启用了 Command Line Tools，没有完整 Xcode 和 iOS Simulator。安装完整 Xcode 后即可继续做模拟器/真机运行验证。
