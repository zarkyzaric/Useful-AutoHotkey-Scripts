#Requires Autohotkey v2.0
#SingleInstance Force
;*JUST RUN!!!!!!!!!!!
;* NO EXTERNAL FILES REQUIRED!!!!!!!!!!!!!!!
;* ENJOY!!!!!!!!!!!

;Gui Design
;*__________________CUSTOMIZE______________________________________________________________
DurationOfAppearance := 20
GuiOptions := "AlwaysOnTop -caption Border"
Font := "Consolas"
FontColor := "ffe6e6"
FontOptions := "s17 q5"
BGColor := "1e1e1e"
EditBoxOptions := "-E0x200 -VScroll Center x10 w377 h45"
PositionAndSize := "W400 H50 y20"

;*________________Gui_Object______________________________________________________________________

myGui := Gui(GuiOptions)
myGui.BackColor := BGColor   
myGui.SetFont(FontOptions " c" FontColor, Font) 
global Input := myGui.Add("Edit", "Background" BGColor " " EditBoxOptions) ; Adds an Input(Edit) Box in GUI
global WinID := myGui.Hwnd ; Saving Window handle for destroying GUI
myGui.Show(PositionAndSize)

;Input Handling  and Gui's Destruction
Destruction(t,shouldContinue := false) { ;for unknown reasons Destruction has to have 2 variables
    global Input
    userInput := Input.Value
    myGui.Destroy()
    if userInput == "" {
        ;// myGui.Destroy()
        ExitApp()
    }
    else if shouldContinue = true {
        ;//myGui.Destroy()
        if !(Terminal_1(userInput)){ ;If not found in first terminal, then go into a second one
            Terminal_2(userInput)
            SetTimer () => ExitApp(), -(DurationOfAppearance * 1000)
        }
    }
}
; If Input Bar exists or is active the following hotkeys will do certain actions
HotIfWinExist("ahk_id " WinID) 
    Hotkey("Escape",Destruction,"On")
; // HotIfWinExist("ahk_id " WinID) 
; //     Hotkey("RControl",Destruction,"On")
HotIfWinExist("ahk_id " WinID) 
    Hotkey("LButton",Destruction,"On") ; adds {Esc} hotkey if user wants to exit pop up
HotIfWinActive("ahk_id " WinID)
    Hotkey("Enter",Destruction.Bind(,true),"On") ; adds {Enter} hotkey if user wants to send value into execution



Terminal_1(Input) { ; Handles one-word, unique location/url commands

    if Input==""
        return

    static Solos := Map(
    "docs", A_MyDocuments,
    "wa", "https://web.whatsapp.com/",
    "h", "https://www.autohotkey.com/docs/v2/FAQ.htm",
    "h", "https://www.autohotkey.com/docs/v2/FAQ.htm",
    "trans", "https://translate.google.com/",
    "duo", "https://www.duolingo.com/",
    "chess", "https://www.chess.com/play",
    )
    if !(Solos.Has(Input)) ; if it doesn't have corresponding key, it goes onto a next terminal
        return 0
    GoThrough(Solos,Input)
    return 1
}

Terminal_2(Input) { ; Handles function calls and Maps in Maps 

    if Input==""
        return

    spacePos := InStr(Input, " ") ; returns 0 if not found
    if !(spacePos)
        return
    else{
        prefix := SubStr(Input, 1, spacePos - 1)
        command := SubStr(Input, spacePos + 1)
    }
    static FuncCalls := Map(  
        "y",    YTSearch.Bind(command), 
        "git",  GitRep.Bind(command),
        "s",    Search.Bind(command),
        "url",  UrlSearch.Bind(command),
        "gm",   Gmail.Bind(command),
        "gmail",Gmail.Bind(command),
        "mail", Gmail.Bind(command),
        "shutdown", () => (Sleep((Integer(command))*1000),Shutdown(1),ExitApp()),
        "sleep", () => (Sleep((Integer(command))*1000),Shutdown(0),ExitApp()),
        "bin", PasteBin.Bind(command),   
        "pb", PasteBin.Bind(command),
        )

    GoThrough(FuncCalls,prefix) 

    Static Clrs := Map(
        "hex", "https://www.w3schools.com/colors/colors_hex.asp",
        "picker", "https://www.w3schools.com/colors/colors_picker.asp",
        "mixer", "https://www.w3schools.com/colors/colors_mixer.asp",
        "converter", "https://www.w3schools.com/colors/colors_converter.asp",
        "scheme", "https://www.w3schools.com/colors/colors_schemes.asp",
    )
    static GPTs := Map(
        "ahk", "",
        "o", "",
        "word", "",
        "py", "",
        "c", "",
        "latex", "",
        "gimp", "",
        "ink", "",
    )
    static Prefixes := Map(
        "g", GPTs,
        "c", Clrs,
    )

    if !(Prefixes.Has(prefix)) ; if prefix is not contained in Map, it exists program
        return
    for key in Prefixes { ; for loop for searching in for key matching with prefix
        if (key == prefix) { 
            Commands := Prefixes[key]
            for com in Commands { ; for loop for searching a command that should be executed
                if (com == command)
                    Run(Commands[com])
            } 
        }  
    }
}

;!FUNCTIONS_____________________________________________________________________________
YTSearch(input) {
    Run("https://www.youtube.com/results?search_query=" . StrReplace(input, A_Space, "+"))
}
GitRep(input){
    Run("https://github.com/search?q=" . StrReplace(input, A_Space, "+") . "&type=repositories")
}
Search(input){
    if input == "c"
        input := A_Clipboard
    Run("https://duckduckgo.com/?t=ffab&q=" . StrReplace(input, A_Space, "+") . "&atb=v403-1&ia=web")
}
UrlSearch(input){
    ; If input > 10 and doesn't have spaces, it's treated as url

    if ((StrLen(input) > 3) && !(InStr(input,A_Space))) {
        if (InStr(input,"https://"))
            Run(input)
        else
            Run("https://" . input)
        return 1
    }
    return 0
}
Gmail(input){
    Run("https://mail.google.com/mail/u/" input "/#inbox")
}
PasteBin(input) {
    Run("https://pastebin.com/" input) 
}
GoThrough(Commands,command){
    for key in Commands{
        if (StrCompare(key,command) == 0) {
            if !(IsObject(Commands[key])) {
                Run(Commands[key])
                return
            }
            else{
                Commands[key].Call()
                return
            } ; or Commands[key]() works the same
        }
    }
}
