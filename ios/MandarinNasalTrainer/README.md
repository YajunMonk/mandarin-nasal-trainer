# 鼻音训练 iOS

这是 `普通话前后鼻音训练仪` 的原生 SwiftUI 版本。

## 已包含

- `训练`：听辨、前后鼻音归类、拼音选择、跟读练习。
- `图谱`：五组重做的口腔侧剖插画，覆盖 `an/ang`、`en/eng`、`in/ing`、`un/ong`、`ün/iong`。
- `复盘`：本地保存正确率、连对、跟读稳定度和高频错题。
- `朗读`：使用 iOS 系统中文语音朗读标准读音，支持慢速跟读。

## 打开方式

用 Xcode 打开：

```bash
open ios/MandarinNasalTrainer/MandarinNasalTrainer.xcodeproj
```

当前工程最低系统版本为 iOS 17，Bundle ID 为 `com.yajunmonk.MandarinNasalTrainer`。

## 本机限制

当前机器只启用了 Command Line Tools，没有完整 Xcode 和 iOS Simulator。需要安装完整 Xcode 后，才能在模拟器或真机上完成最终运行验证。

可以先运行：

```bash
bash check-installability.sh
```

它会检查完整 Xcode、签名证书和连接设备是否已经准备好。
