#!/usr/bin/env bash
set -u

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT="$ROOT_DIR/MandarinNasalTrainer.xcodeproj"

pass() { printf "✅ %s\n" "$1"; }
fail() { printf "❌ %s\n" "$1"; }
note() { printf "ℹ️  %s\n" "$1"; }

echo "鼻音训练 iOS 安装环境自检"
echo

if [ -d "$PROJECT" ]; then
  pass "Xcode 工程存在：$PROJECT"
else
  fail "找不到 Xcode 工程"
fi

DEVELOPER_DIR="$(xcode-select -p 2>/dev/null || true)"
if [ -n "$DEVELOPER_DIR" ]; then
  note "当前开发者工具目录：$DEVELOPER_DIR"
else
  fail "没有设置开发者工具目录"
fi

if /usr/bin/xcodebuild -version >/tmp/mandarin-xcodebuild-check.txt 2>&1; then
  pass "$(/usr/bin/xcodebuild -version | tr '\n' ' ')"
else
  fail "完整 Xcode 不可用。请先安装 Xcode，并运行：sudo xcode-select -s /Applications/Xcode.app/Contents/Developer"
  sed -n '1,3p' /tmp/mandarin-xcodebuild-check.txt
fi

if /usr/bin/xcrun --find simctl >/dev/null 2>&1; then
  pass "iOS Simulator 工具可用"
else
  fail "iOS Simulator 工具不可用"
fi

IDENTITY_COUNT="$(security find-identity -v -p codesigning 2>/dev/null | awk '/valid identities found/{print $1}' | tail -n 1)"
if [ "${IDENTITY_COUNT:-0}" != "0" ]; then
  pass "检测到 $IDENTITY_COUNT 个可用代码签名证书"
else
  fail "没有可用 iOS 代码签名证书。需要在 Xcode 里登录 Apple ID 并开启自动签名。"
fi

if /usr/bin/xcrun devicectl list devices >/tmp/mandarin-devices-check.txt 2>&1; then
  if grep -Eiq 'iphone|ipad' /tmp/mandarin-devices-check.txt; then
    pass "检测到 iPhone/iPad 设备"
  else
    fail "没有检测到可安装的 iPhone/iPad。请用数据线连接设备并信任这台 Mac。"
  fi
else
  fail "无法读取 iOS 设备列表，通常是因为完整 Xcode 不可用。"
fi

echo
note "如果以上都通过，就可以在 Xcode 里选择真机，然后 Product > Run 安装到手机。"
