; -----------------------------------------------------------------------------
; Orviel_SB-FPad.ahk (v6.16: Full JP)
; -----------------------------------------------------------------------------
; Developed by: kurdoa @ Orviel
; -----------------------------------------------------------------------------

#NoEnv
#SingleInstance Force
SetTitleMatchMode, 2
SendMode Input
DetectHiddenWindows, On

; ==========================================
; 【キー設定 / Key Configuration】
; ==========================================
SubmitKey     := "NumpadEnter"
ShowHideKey   := "^!Space"
TargetSendKey := "^{Enter}"
; ==========================================

; ==========================================
; 【タイミング設定 / Timing Configuration】
; ==========================================
; HideWait   ツール非表示後の待機時間（ms）
; ClearWait  入力欄クリア後の待機時間（ms）
; PasteWait  貼り付け後の待機時間（ms）
; SendWait   送信キー後の待機時間（ms）
; ==========================================
HideWait  := 500
ClearWait := 150
PasteWait := 400
SendWait  := 500

; ==========================================
; 【UI設定 / UI Appearance】
; ==========================================
GuiWidth     := 650
GuiHeight    := 150
BgColor      := "d6c6af"
StatusColor  := "Gray"
LinkColor    := "0055AA"
FontSize     := 11
MaxHistory   := 10
StatusWidth  := 350   ; ステータステキストの幅（小さくすると右側リンクが左寄りになる）
LinkGap      := 10    ; [透明度] と [送信] の間隔（px）

; ==========================================

if (SubmitKey = "Enter") {
    MsgBox, 48, Orviel エラー, EnterをSubmitKeyにすると改行ができなくなります。`nNumpadEnterなど、別のキーを指定してください。
    ExitApp
}

HistoryArray := []
OpacityList  := [220, 150, 80]
OpacityIdx   := 1
TargetID     := 0
TargetName   := "未設定"
LastActiveID := 0

Gui, +AlwaysOnTop +Caption +Border +Resize +HwndOrvielHwnd
Gui, Color, %BgColor%
Gui, Font, s%FontSize%, Meiryo
Gui, Add, Edit, w%GuiWidth% h%GuiHeight% vMyInput Multi HScroll VScroll WantTab,
Gui, Font, s9, Meiryo
Gui, Add, Text, x10 y+10 w%StatusWidth% vStatusText c%StatusColor%, Send:%SubmitKey% | Target:%TargetName%
Gui, Add, Text, x+%LinkGap% c%LinkColor% gToggleOpacity, [透明度]
Gui, Add, Text, x+%LinkGap% c%LinkColor% gSubmitProcess, [送信]

Hotkey, IfWinActive, ahk_id %OrvielHwnd%
Hotkey, %SubmitKey%, SubmitProcess
Hotkey, IfWinActive
Hotkey, %ShowHideKey%, ToggleWindow

Gosub, UpdateStatus
Gui, Show, , Orviel SB-FPad
WinSet, Transparent, % OpacityList[OpacityIdx], ahk_id %OrvielHwnd%
SetTimer, WatchActiveWindow, 200
Return

ToggleWindow:
    if DllCall("IsWindowVisible", "Ptr", OrvielHwnd) {
        Gui, Hide
    } else {
        currentWin := WinExist("A")
        if (currentWin && currentWin != OrvielHwnd) {
            TargetID := currentWin
            WinGetTitle, TargetName, ahk_id %TargetID%
            if (TargetName = "")
                TargetName := "タイトルなし"
            if (StrLen(TargetName) > 15)
                TargetName := SubStr(TargetName, 1, 15) "..."
            Gosub, UpdateStatus
        }
        Gui, Show
        WinActivate, ahk_id %OrvielHwnd%
    }
return

UpdateStatus:
    StatusMsg := "Send:" SubmitKey " | Target:" TargetName
    GuiControl, , StatusText, %StatusMsg%
return

SubmitProcess:
    ControlGetText, MyInput, Edit1, ahk_id %OrvielHwnd%
    if (MyInput = "")
        return

    tmpBackup := ClipboardAll
    Clipboard := ""
    Clipboard := MyInput
    ClipWait, 1
    if (ErrorLevel) {
        MsgBox, 48, エラー, クリップボードへの転送に失敗しました。
        Clipboard := tmpBackup
        return
    }

    HistoryArray.InsertAt(1, MyInput)
    if (HistoryArray.Length() > MaxHistory)
        HistoryArray.Pop()

    finalTarget := (TargetID && WinExist("ahk_id " TargetID)) ? TargetID : LastActiveID
    if (!finalTarget || !WinExist("ahk_id " finalTarget)) {
        MsgBox, 48, エラー, 送信先のウィンドウが見つかりません。
        Clipboard := tmpBackup
        return
    }

    Gui, Hide
    Sleep, %HideWait%

    WinActivate, ahk_id %finalTarget%
    WinWaitActive, ahk_id %finalTarget%, , 2

    if (!ErrorLevel) {
        Send, ^a{Backspace}
        Sleep, %ClearWait%
        Send, ^v
        Sleep, %PasteWait%
        Send, %TargetSendKey%
        Sleep, %SendWait%
        GuiControl, , MyInput,
    }

    Gui, Show
    WinSet, Transparent, % OpacityList[OpacityIdx], ahk_id %OrvielHwnd%
    Clipboard := tmpBackup
return

WatchActiveWindow:
    currentWin := WinExist("A")
    WinGetClass, activeClass, ahk_id %currentWin%
    if (currentWin && currentWin != OrvielHwnd && activeClass != "#32770") {
        LastActiveID := currentWin
    }
return

#If WinActive("ahk_id " OrvielHwnd)
^vkBA::
    FormatTime, CurrentDateTime,, yyyy/MM/dd HH:mm
    Send, %CurrentDateTime%
return
:*:now::
    FormatTime, CurrentDateTime,, yyyy/MM/dd HH:mm
    Send, %CurrentDateTime%
return
#If

GuiContextMenu:
    Menu, MyMenu, Add, 送信先を固定, SetTarget
    Menu, MyMenu, Add, 固定を解除, ClearTarget
    Menu, MyMenu, Add
    if (HistoryArray.Length() > 0) {
        Loop % HistoryArray.Length() {
            txt := StrLen(HistoryArray[A_Index]) > 20 ? SubStr(HistoryArray[A_Index], 1, 20) "..." : HistoryArray[A_Index]
            txt := RegExReplace(txt, "\R", " ")
            Menu, HistoryMenu, Add, % A_Index ": " txt, RecallHistory
        }
        Menu, MyMenu, Add, 履歴, :HistoryMenu
    }
    Menu, MyMenu, Show
    Menu, MyMenu, DeleteAll
    if (HistoryArray.Length() > 0)
        Menu, HistoryMenu, DeleteAll
return

SetTarget:
    if (LastActiveID) {
        TargetID := LastActiveID
        WinGetTitle, TargetName, ahk_id %TargetID%
        if (TargetName = "")
            TargetName := "タイトルなし"
        if (StrLen(TargetName) > 15)
            TargetName := SubStr(TargetName, 1, 15) "..."
    }
    Gosub, UpdateStatus
return

ClearTarget:
    TargetID := 0
    TargetName := "未設定"
    Gosub, UpdateStatus
return

ToggleOpacity:
    OpacityIdx := (OpacityIdx = OpacityList.MaxIndex()) ? 1 : OpacityIdx + 1
    WinSet, Transparent, % OpacityList[OpacityIdx], ahk_id %OrvielHwnd%
    Gosub, UpdateStatus
return

RecallHistory:
    idx := RegExReplace(A_ThisMenuItem, "^(\d+):.*", "$1")
    GuiControl, , MyInput, % HistoryArray[idx]
return

GuiClose:
    Gui, Hide
return