
#Requires AutoHotkey v2.0 
#Include <Functions> 
#Include <Paths>

/* GUIDE AND REMINDER

; this is going to execute without pressing {Space}
:*:hotstring::

; in other hand this one requires {Space}
::hotstring::

Characters that you type instead of keys:
# - Windows
! - Alt
+ - Shift
^ - Ctrl

Examples:
^!w:: ; Ctrl+Alt+W ==> Open RemNote 
{ 
    global RemNote
    AppTab := "RemNote | Your Notes"
    If WinExist("AppTab")
        WinActivate()
    else
        Run(RemNote)
}
*/

;! Button for Running Terminal
; RControl::Run(A_ScriptDir "\Terminal.ahk")

^!g::Run("https://chat.openai.com") ; ChatGPT


;? Other Optional Customizable Hotkeys 
;? (UNCOMMENT IF YOU WANT TO USE THEM)

; ; RAlt +j/k ==> Switching trought tabs
; RAlt & k::AltTab    
; RAlt & j::ShiftAltTab

; ;? Place mouse on file you want to edit and press Ctrl+E / same effect as Right Click and Edit
; #HotIf !WinActive("ahk_class Chrome_WidgetWin_1")
; ^e::Send("{RButton}e")

; ;? Show/Hide Desktop icons (works only when desktop is active)
; #HotIf WinActive("ahk_class WorkerW")
; f7:: 
; {
;     SendIn("{RButton}",0.001)
;     SendIn("{Down}",0.001)
;     SendIn("{Right}",0.001)
;     Loop 5 {
;         SendIn("{Down}",0.001)
;     }
;     SendIn("{Enter}",0.001)
; }
; #HotIf

; ;? Runs AHK help File
; #z::Run(Help)  ; Win+Z

; !4::Send("!{F4}") ; Alt + 4 == Alt + F4 

; ^!k:: ; Gets Mouse Position
; {
;     MouseGetPos &x, &y
;     MsgBox("X: " x "`nY: " y)
;     A_Clipboard := " " x . " , " y " "  
; }

; ^!+k::{ ; Gets Win x,y,ID,Class,Control,Title
;     WatchCursor(Duration := 4){
;         MouseGetPos &x, &y, &id, &control
;         ToolTip
;         (
;             "x: " x " y: " y
;             "`nahk id " id "
;             ahk class: " WinGetClass(id) "
;             itle:" WinGetTitle(id) "
;             Control: " control
;         )
;         SetTimer () => ToolTip(), -(Duration * 1000)

;         myGui := Gui("AlwaysOnTop -caption")
;         BGColor := myGui.BackColor := "5d5d5f"
;         myGui.SetFont("s23 bold q5 c0xC5C5C5","Consolas")
;         global Input := myGui.Add("Edit", "Background" BGColor "  Center w100 h45"), WinID := myGui.Hwnd
;         myGui.Show("y60")

;         HotIfWinExist("ahk_id " WinID), Hotkey("Escape",Destruction,"On")
;         HotIfWinActive("ahk_id " WinID), Hotkey("Enter",Destruction.Bind(,true),"On")
;         HotIfWinExist("ahk_id " WinID)
;             SetTimer () => myGui.Destroy(), -(Duration * 1000)
;         ChoiceCase(Choice){
;             static Options := Map(
;             "class",  "ahk_class " . WinGetClass(id),
;             "id",     "ahk_id " . id,
;             "title",  WinGetTitle(id),
;             "control", control,
;             "position",    " " x " , " y " ",
;             "ctrl",   control,
;             "pos",    " " x " , " y " ",
;             "xy",     " " x " , " y " ",
;             "x",      x,
;             "y",      y,
;             )
;             for key in Options
;                 if Choice == key
;                     A_Clipboard := Options[key]
;         }
;         Destruction(t,shouldContinue := false) { ;for unknown reasons Destruction has to have 2 variables
;             global Input
;             if shouldContinue == true 
;                 ChoiceCase(Input.Value)
;             myGui.Destroy() 
;             ;HotIfWinExist("ahk_id " WinID)
;             ;Hotkey("Escape","Off")
;             ;Hotkey("Enter","Off")
;         }
;     }
;     WatchCursor()
; }

; ;? Fast Terminal
; RAlt:: ; Fast Terminal
; {
; GuiOptions := "AlwaysOnTop -caption Border"
; Font := "Consolas"
; FontColor := "ffe6e6"
; FontOptions := "s17 q5 bold"
; BGColor := "1e1e1e"
; SizeAndPosition := "w40 h38 x960 y700"
; EditBoxOptions := "-E0x200 -VScroll Center w35 h30 x1 y5.5"

; myGui := Gui(GuiOptions)
; myGui.BackColor := BGColor 
; myGui.SetFont(FontOptions " c" FontColor , Font) 
; global Input := myGui.Add("Edit", "Background" BGColor " " EditBoxOptions) ; Adds an Input(Edit) Box in GUI
; global WinID := myGui.Hwnd ; Saving Window handle for destroying GUI

; Destruction(t,shouldContinue := false) { ;for unknown reasons Destruction has to have 2 variables
;     myGui.Destroy()
; }
; ; If Input Bar exists or is active the following hotkeys will do certain actions
; HotIfWinExist("ahk_id " WinID) 
;     Hotkey("Escape",Destruction,"On") ; adds {Esc} hotkey if user wants to exit pop up
; HotIfWinActive("ahk_id " WinID)
;     Hotkey("Enter",Destruction.Bind(,true),"On")
; myGui.Show(SizeAndPosition)

; IH := InputHook("L1 T0.5 V1",A_Space),IH.Start(),IH.Wait(),input := IH.Input
; SetTimer () => myGui.Destroy(), -50
; Fast := Map(
;     "h", () => (Run(Help), Sleep(2000), Send("{F11}")),
;     "o", () => Send("^!o"),
;     "v", () => OpenVSC(AHK), ;! replace AHK with main working directory's path
;     "i", "http://www.instagram.com/",
;     "m", "https://www.youtube.com/watch?v=Q6MemVxEquE&t=272s",
;     "w", "https://web.whatsapp.com",
;     "s", "https://www.chess.com/play",
;     "g", "https://chat.openai.com",
;     "d", "https://www.duolingo.com/",
;     "t", "https://translate.google.com/",
;     "c", Search.Bind(A_Clipboard),
;     )
; GoThrough(Fast,input)

; GoThrough(Commands,command){
;     for key in Commands{
;         if (StrCompare(key,command) == 0) {
;             if !(IsObject(Commands[key]))
;                 Run(Commands[key])
;             else
;                 Commands[key].Call()
;             return ; or Commands[key]() works the same
;             }
;         }
;     } 
;     return 
; }







