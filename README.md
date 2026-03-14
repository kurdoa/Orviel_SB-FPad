---

# Orviel SB-FPad

軽量・常駐型の **外部入力ワークスペースユーティリティ**

---

# 日本語

## 概要

**Orviel SB-FPad** は
Claude Desktop・LINE PC・Discord などのチャットツールで発生する

* Enterキーによる意図しない送信
* 日本語IME確定時の誤送信
* 長文入力中の入力事故

を回避するために開発された **外部入力ワークスペース型ユーティリティ**です。

チャットアプリの入力欄に直接入力するのではなく
本ツールの専用ウィンドウで文章を作成し
完成した内容を送信します。

これにより

* 誤送信の防止
* 安定した日本語入力
* 思考の中断防止

を実現します。

Orvielプロジェクトの思想である

**「軽量・常駐・思考を妨げない道具」**

をコンセプトに設計されています。

---

## 言語バージョン

このツールは以下の2つのスクリプトとして提供されています。

| Language        | File                    | Version |
| --------------- | ----------------------- | ------- |
| 日本語版            | `Orviel_SB-FPad.ahk`    | v6.16   |
| English version | `Orviel_SB-FPad_en.ahk` | v6.15   |

機能は同一で、UIメッセージと言語のみが異なります。
各バージョンは独立して更新されるため、バージョン番号が異なる場合があります。

---

## ツール名について

SB-FPad は以下の意味を持っています。

**SB = Send Buffer**
送信前の文章を一時的に保持するバッファ

**FPad = Float Pad**
デスクトップ上に浮かぶ入力パッド

つまり本ツールは

**送信前の文章を一時的に保管するフローティング入力ワークスペース**

として機能します。

---

## 開発背景

Claude Desktop では、日本語IMEの変換確定時に

**Enterキーがそのまま送信として扱われる場合**

があります。

長文入力中に誤送信が発生すると

* 文章が途中で送信される
* 再入力が必要になる
* 思考が中断される

といった問題が発生します。

この問題を回避するため
チャットツールの入力欄を直接使用しない

**外部入力ワークスペース方式**

を採用しました。

---

## 主な機能

### 外部入力ワークスペース

チャットツールの入力欄ではなく
専用ウィンドウで文章を作成します。

送信キーを押すと

1. 入力欄を全消去
2. 作成した文章を貼り付け
3. 送信

が自動実行されます。

---

### 送信キーのカスタマイズ

送信キーは **Enter以外のキー** で自由に設定できます。
```
SubmitKey := "NumpadEnter"   ; テンキーEnterで送信（推奨・テスト済み）
SubmitKey := "^Enter"        ; Ctrl+Enterで送信
SubmitKey := "+Enter"        ; Shift+Enterで送信
```

> **注意**
> `SubmitKey := "Enter"` は設定できません。
> Enterを送信キーにすると改行ができなくなるため、起動時にエラーになります。

AutoHotkeyキー記号
```
^  Ctrl
+  Shift
!  Alt
#  Win
```

---

### 召喚キー

デフォルトの召喚キーは `Ctrl+Alt+Space` です。
```
ShowHideKey := "^!Space"
```

召喚キーを押した瞬間に
その時アクティブなウィンドウが **送信先として自動設定** されます。

---

### 送信コマンド設定

送信先アプリに送るキー操作を設定できます。
```
TargetSendKey := "^{Enter}"
```

| 設定         | 動作           |
| ---------- | ------------ |
| `{Enter}`  | Enter送信      |
| `^{Enter}` | Ctrl+Enter送信 |
| `!{Enter}` | Alt+Enter送信  |

---

### タイミング設定

環境や文章の長さによって送信が不安定な場合は
以下の値を調整してください。
調整できるのはこの4項目のみです。
```
HideWait  := 500   ; ツール非表示後の待機時間（ms）
ClearWait := 150   ; 入力欄クリア後の待機時間（ms）
PasteWait := 400   ; 貼り付け後の待機時間（ms）
SendWait  := 500   ; 送信キー後の待機時間（ms）
```

* `HideWait` が短すぎると送信先ウィンドウが前面に来る前に操作してしまう場合があります
* `PasteWait` を短くすると動作が速くなりますが、長文で不安定になる場合は増やしてください
* `SendWait` が短すぎると送信完了前にツールが戻ってきてしまう場合があります

---

### 外観カスタマイズ

以下の項目で外観を自由に変更できます。
```
GuiWidth    := 650       ; ウィンドウ幅（px）
GuiHeight   := 150       ; ウィンドウ高さ（px）
BgColor     := "d6c6af"  ; 背景色（16進数カラーコード）
StatusColor := "Gray"    ; ステータステキストの色
LinkColor   := "0055AA"  ; [透明度] [送信] の色
FontSize    := 11        ; フォントサイズ
StatusWidth := 350       ; ステータステキストの幅（小さくすると右側リンクが左寄りになる）
LinkGap     := 10        ; [透明度] と [送信] の間隔（px）
```

縦長に使いたい場合は `GuiWidth` を小さく、`GuiHeight` を大きく、`StatusWidth` を小さく設定してください。

---

### 送信先ターゲット設定

召喚キーを押した瞬間に直前のアクティブウィンドウが自動設定されます。

手動で固定・解除する場合は右クリックメニューから操作できます。

| メニュー項目  | 動作                   |
| ------- | -------------------- |
| 送信先を固定  | 送信先を現在の窓に固定          |
| 固定を解除   | 固定を解除（自動設定に戻る）       |

---

### 履歴機能

送信した内容の直近 **10件** を保存。
右クリックメニューの `履歴` から再利用できます。

---

### タイムスタンプ

`Ctrl + :` で現在時刻を挿入します。

`now` と入力してもタイムスタンプへ変換されます。

---

### 透明度切替

`[透明度]` をクリックすると
入力ウィンドウの透明度を3段階で切り替えられます。

---

### 送信

`[送信]` をクリックすると
キーボードを使わずにマウスだけで送信できます。

---

## テスト済み構成

以下の構成でテストを行っています。

| SubmitKey      | TargetSendKey | 送信先         |
| -------------- | ------------- | -------------- |
| `NumpadEnter`  | `^{Enter}`    | Claude Desktop |

**その他のキー設定や送信先については未テストです。**
動作しない場合は `PasteWait` / `SendWait` の調整や
`TargetSendKey` の変更をお試しください。

---

## 動作環境

* Windows
* AutoHotkey v1.1

[https://www.autohotkey.com/](https://www.autohotkey.com/)

---

## インストール

1. AutoHotkey v1.1 をインストール
2. `Orviel_SB-FPad.ahk` を実行

---

## スタートアップ登録（任意）

自動起動する場合
```
Win + R
shell:startup
```

を開き `Orviel_SB-FPad.ahk` のショートカットを配置します。

---

## 送信処理の仕組み

送信時に以下の操作を自動実行します。

1. 入力内容をクリップボードにコピー
2. 送信先ウィンドウをアクティブ化（`HideWait` 待機）
3. `Ctrl+A` → `Backspace` で入力欄をクリア（`ClearWait` 待機）
4. `Ctrl+V` で貼り付け（`PasteWait` 待機）
5. `TargetSendKey` を送信（`SendWait` 待機）
6. ツールウィンドウを前面に戻す

---

## 注意事項

このツールは

**チャット入力欄を対象とした入力補助ツール**

です。

以下の前提で動作します。

* 入力欄がアクティブである
* `Ctrl+A` が全選択として機能する
* 貼り付けが許可されている

以下のアプリケーションはこの前提を満たさないため **動作しません**。

* コマンドプロンプト（cmd）
* PowerShell
* Windows Terminal
* Linuxターミナル
* Git Bash

ターミナル向けには別ツール **Orviel SB-FPad-T**（開発予定）を予定しています。

---

## ライセンス

MIT License

---

# English

## Overview

**Orviel SB-FPad** is a lightweight floating input workspace designed to prevent accidental message sending in chat applications.

Instead of typing directly in a chat application's input field,
you write your message inside SB-FPad and send it when ready.

This helps prevent:

* accidental sends caused by Enter
* unintended sends during IME confirmation
* interruptions while writing long messages

---

## Language versions

This tool is provided as two script versions.

| Language | File                    | Version |
| -------- | ----------------------- | ------- |
| Japanese | `Orviel_SB-FPad.ahk`    | v6.16   |
| English  | `Orviel_SB-FPad_en.ahk` | v6.15   |

Both versions have the same functionality.
Only the UI messages and language differ.
Each version is updated independently, so version numbers may differ.

---

## Concept

SB-FPad stands for

**Send Buffer – Float Pad**

It provides a temporary writing space before sending messages to another application.

---

## Features

* Floating external input workspace
* Customizable submit key (Enter excluded)
* Configurable show/hide hotkey with automatic target detection
* Configurable send command
* Configurable timing (HideWait / ClearWait / PasteWait / SendWait)
* Customizable appearance (colors, size, layout)
* Manual target window locking
* Mouse-clickable send link
* Input history (last 10 entries)
* Timestamp helper
* Adjustable window transparency

---

## Submit Key

The submit key can be set to **any key except Enter**.
```
SubmitKey := "NumpadEnter"   ; NumpadEnter to send (recommended, tested)
SubmitKey := "^Enter"        ; Ctrl+Enter to send
SubmitKey := "+Enter"        ; Shift+Enter to send
```

> **Note**
> `SubmitKey := "Enter"` is not allowed.
> Setting Enter as the submit key disables newlines and will cause an error on startup.

---

## Show/Hide Key

The default show/hide hotkey is `Ctrl+Alt+Space`.
```
ShowHideKey := "^!Space"
```

When the tool is shown, the currently active window is **automatically set as the send target**.

---

## Send Command

Configure the key sent to the target application.
```
TargetSendKey := "^{Enter}"
```

| Value      | Action     |
| ---------- | ---------- |
| `{Enter}`  | Enter      |
| `^{Enter}` | Ctrl+Enter |
| `!{Enter}` | Alt+Enter  |

---

## Timing Configuration

If sending is unstable, adjust these values.
Only these four settings can be adjusted.
```
HideWait  := 500   ; Wait after hiding the tool window (ms)
ClearWait := 150   ; Wait after clearing the input field (ms)
PasteWait := 400   ; Wait after paste (ms)
SendWait  := 500   ; Wait after send key (ms)
```

* If `HideWait` is too short, the target window may not be ready in time
* Reducing `PasteWait` speeds things up but may cause instability with long messages
* If `SendWait` is too short, the tool may return before sending completes

---

## Appearance

The following settings can be customized freely.
```
GuiWidth    := 650       ; Window width (px)
GuiHeight   := 150       ; Window height (px)
BgColor     := "d6c6af"  ; Background color (hex)
StatusColor := "Gray"    ; Status text color
LinkColor   := "0055AA"  ; [Transparency] and [Send] link color
FontSize    := 11        ; Font size
StatusWidth := 350       ; Status text width (smaller = links move left)
LinkGap     := 10        ; Gap between [Transparency] and [Send] (px)
```

For vertical use, set `GuiWidth` smaller, `GuiHeight` larger, and `StatusWidth` smaller.

---

## Target Window

When the tool is shown via the hotkey, the currently active window is automatically set as the send target.

You can also lock or unlock the target manually via the right-click menu.

| Menu item   | Action                             |
| ----------- | ---------------------------------- |
| Lock Target | Lock send target to current window |
| Unlock      | Release lock (auto-detect resumes) |

---

## Tested Configuration

The following configuration has been tested.

| SubmitKey     | TargetSendKey | Target         |
| ------------- | ------------- | -------------- |
| `NumpadEnter` | `^{Enter}`    | Claude Desktop |

**Other key configurations and target applications have not been tested.**
If sending is unstable, try adjusting `PasteWait` / `SendWait` or changing `TargetSendKey`.

---

## Requirements

* Windows
* AutoHotkey v1.1

[https://www.autohotkey.com/](https://www.autohotkey.com/)

---

## Installation

1. Install AutoHotkey v1.1
2. Run `Orviel_SB-FPad.ahk`

---

## Startup Registration (Optional)

To launch automatically on Windows startup:
```
Win + R
shell:startup
```

Place a shortcut to `Orviel_SB-FPad.ahk` in the folder that opens.

---

## How Sending Works

When the submit key is pressed:

1. Input content is copied to clipboard
2. Target window is activated (waits `HideWait` ms)
3. `Ctrl+A` → `Backspace` clears the input field (waits `ClearWait` ms)
4. `Ctrl+V` pastes the content (waits `PasteWait` ms)
5. `TargetSendKey` is sent (waits `SendWait` ms)
6. Tool window returns to front

---

## Notes

This tool is designed for **chat input fields**.

It requires:

* The input field to be active
* `Ctrl+A` to select all
* Paste to be permitted

The following applications do not meet these requirements and are **not supported**.

* Command Prompt (cmd)
* PowerShell
* Windows Terminal
* Linux terminals
* Git Bash

A separate tool **Orviel SB-FPad-T** is planned for terminal environments.

---

## License

MIT License

---

# 開発

kurdoa @ Orviel

---