# 生成可直接安装的 iOS App 还缺什么

当前仓库里的 SwiftUI App 已经完成，但这台 Mac 还缺 iOS 构建和安装环境。

## 目前缺失

1. 完整 Xcode
   - 当前只有 Command Line Tools。
   - 需要从 Apple 官方页面或 App Store 安装 Xcode。

2. iOS 签名证书
   - 当前钥匙串里没有可用代码签名证书。
   - 需要在 Xcode 里登录 Apple ID，并给项目设置 Team。

3. 可安装目标
   - 当前没有检测到连接的 iPhone/iPad。
   - 需要用数据线连接设备，并在手机上点“信任这台电脑”。

4. 最终构建验证
   - 当前缺少 `xcodebuild`、`simctl`、`devicectl`，所以还不能生成 `.app` 或安装到手机。

## Xcode 安装后要做什么

在项目根目录运行：

```bash
cd ios/MandarinNasalTrainer
bash check-installability.sh
```

全部通过后，用 Xcode 打开：

```bash
open MandarinNasalTrainer.xcodeproj
```

然后：

1. 选择项目 `MandarinNasalTrainer`。
2. 进入 `Signing & Capabilities`。
3. 勾选 `Automatically manage signing`。
4. 选择你的 Apple ID Team。
5. 连接 iPhone 后，选择真机作为运行目标。
6. 点击 `Run`，App 会直接安装到手机。

## 代码状态

- Swift 语法解析已通过。
- Xcode 工程文件已通过 plist 校验。
- 资源 JSON/XML 已通过解析。
- 五张口腔教学插画已放入 Asset Catalog。
