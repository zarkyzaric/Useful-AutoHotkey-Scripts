#Requires Autohotkey v2.0
; If script is running in the background, and you want to start it again, this input makes sure that is executed without a questioning you do you want to shutdown the previous one, but rather exits by default
#SingleInstance Force 
; library for personalized functions:
#Include %A_ScriptDir%\Lib\Functions.ahk
;library for file locations and urls:
#Include <Paths>

;?_______________________________Gui_Design_________________________________________________


;*__________________CUSTOMIZABLES_____________________________________________________________
DurationOfAppearance := 20
GuiOptions := "AlwaysOnTop -caption Border"
Font := "Consolas"
FontColor := "ffe6e6"
FontOptions := "s17 q5"
BGColor := "1e1e1e"

; Not recommended to edit if you don't know AHK language well:
EditBoxOptions := "-E0x200 -VScroll Center x10 w377 h45"
PositionAndSize := "W400 H50 y20"

;*________________Gui_Object______________________________________________________________________

myGui := Gui(GuiOptions)
myGui.BackColor := BGColor   
myGui.SetFont(FontOptions " c" FontColor, Font) 
global Input := myGui.Add("Edit", "Background" BGColor " " EditBoxOptions) ; Adds an Input(Edit) Box in GUI
global WinID := myGui.Hwnd ; Saving Window handle for destroying GUI
myGui.Show(PositionAndSize)

;?________________Input Handling_and_Gui's_Destruction____________________________


Destruction(t,shouldContinue := false) { ;for unknown reasons Destruction has to have 2 variables
    global Input
    userInput := Input.Value
    myGui.Destroy()
    if userInput == "" {
        ExitApp()
    }
    else if shouldContinue = true {
        if !(Terminal_1(userInput)){ ;If not found in first terminal, then go into a second one
            Terminal_2(userInput)
            SetTimer () => ExitApp(), -(DurationOfAppearance * 1000)
        }
    }
}
; If Input Bar exists or is active the following hotkeys will do certain actions
HotIfWinExist("ahk_id " WinID) ; adds {Esc} hotkey if user wants to exit pop up
    Hotkey("Escape",Destruction,"On")
; // HotIfWinExist("ahk_id " WinID) 
; //     Hotkey("RControl",Destruction,"On")
HotIfWinExist("ahk_id " WinID) 
    Hotkey("LButton",Destruction,"On") ; adds Left Mouse Click hotkey if user wants to exit pop up
HotIfWinActive("ahk_id " WinID)
    Hotkey("Enter",Destruction.Bind(,true),"On") ; adds {Enter} hotkey if user wants to send value into execution

;?______________________________________________________________________T1_______________________
Terminal_1(Input) { ; Handles one-word, unique location/url inputs
    if Input==""
        return 0
    
    static Singletons := Map(
    "h",        () => (Run(Help), Sleep(2000), Send("{F11}")),
    "o",        () => Open(Obsidian),
    "v",        () => OpenVSC(""), ; Fill in with your Working Directory
    "note",     "notepad.exe","notepad",() => Run("notepad.exe"),
    "insta",    "http://www.instagram.com/",
    "github",   "https://github.com",
    "kp",       "https://www.kupujemprodajem.com/",
    "g",        "https://chat.openai.com",
    "trans",    "https://translate.google.com/",
    "duo",      "https://www.duolingo.com/",
    "chess",    "www.chess.com/play",
    "disc",     "https://discord.com/channels/@me",
    "wa",       "https://web.whatsapp.com/",
    "gimp",     GIMP,
    "ink",      Inkscape,
    "cmd",      Cmd,
    "krita",    "C:\Program Files\Krita (x64)\bin\krita.exe",
    "docs",     A_MyDocuments,
    ; "latex",    "", ; Latex Documentation
    "sup",      Startup,
    "rem",      RemNote,
    "fox",      Firefox,
    "sc",       Search.Bind(A_Clipboard), ; Searches your Clipboard in Browser
    )

    if GoThrough(Singletons,Input)
        return 1
    return 0
}
;?____________________________________________________________________T2_________________________
Terminal_2(Input) { ; Handles function calls and Maps in Maps 

    if Input==""
        return

    spacePos := InStr(Input, " ") 
    if !(spacePos) ; returns 0 if not found
        return
    else{
        prefix := SubStr(Input, 1, spacePos - 1)
        input := SubStr(Input, spacePos + 1)
    }
    static FuncCalls := Map(  
        "y",    YTSearch.Bind(input), 
        "git",  GitRep.Bind(input),
        "s",    Search.Bind(input),
        "url",  UrlSearch.Bind(input),
        "gm",   Gmail.Bind(input), "gmail",Gmail.Bind(input), "mail", Gmail.Bind(input),
        "getlink", () => ((A_Clipboard := input),Run("GetLink.ahk")), 
        "shutdown", () => (Sleep((Integer(input))*1000),Shutdown(1),ExitApp()),
        "sleep", () => (Sleep((Integer(input))*1000),Shutdown(0),ExitApp()),
        "bin", PasteBin.Bind(input), "pb", PasteBin.Bind(input),
        )
    GoThrough(FuncCalls,prefix) 


    static GPTs := Map(
        ; ;! This obviously won't work for your account so you have to put your own
        ; "random", "https://chat.openai.com/c/2d6ba617-40be-496c-ad7d-05a851a44caf",
        ; "train", "https://chat.openai.com/c/db135fa0-c150-4954-ab67-470ad279e961",
        ; "gimp", "https://chat.openai.com/c/b95f1ec5-1e58-4d56-ad16-94271c9c7d19",
        ; "o", "https://chat.openai.com/c/d3176c4f-be9a-4807-a8e2-09896a3f35ca",
        ; "work", "",
    )
    static AITools := Map(
        "leonardo", "https://app.leonardo.ai",
        "leonardo realtime", "https://app.leonardo.ai/realtime-gen",
        "pixverse", "https://app.pixverse.ai/create/video",
        "pixverse my", "https://app.pixverse.ai/create/history",
        "restore","https://replicate.com/tencentarc/gfpgan",
        "object remover","https://objectremover.com/",
        "sharpener","https://imglarger.com/Sharpener",
        "upscale","https://imglarger.com/ImageUpscaler",

    )
    static Clrs := Map(
        "hex",      "https://www.w3schools.com/colors/colors_hex.asp",
        "picker",   "https://www.w3schools.com/colors/colors_picker.asp",
        "mixer",    "https://www.w3schools.com/colors/colors_mixer.asp",
        "converter","https://www.w3schools.com/colors/colors_converter.asp",
        "scheme",   "https://www.w3schools.com/colors/colors_schemes.asp",
        "findfont", "https://www.fontspring.com/matcherator?matcherator_img=a7kxiyy1ocrm916n#scroll_to_matches",
        "remove bg", "https://www.remove.bg/",
        "fonts", "https://fonts.google.com/",
    )
    
    static Prefixes := Map(
        "g", GPTs,
        "im", Clrs,
        "ai", AITools,
    )

    if !(Prefixes.Has(prefix)) ; if prefix is not contained in Map, it exists program
        return
    for key in Prefixes { ; for loop for searching in for key matching with prefix
        if (key == prefix) { 
            Commands := Prefixes[key]
            if input == "opt" {
                AllOpt := ""
                for opt in Commands{
                    AllOpt := AllOpt . opt "`n"
                }
                ;! Replace "Terminal.ahk" with full path to Terminal if it doesn't work
                SetTimer () => (ToolTip(AllOpt,960,60),Sleep(5000),Run("Terminal.ahk")), -1
                return
            }
            for com in Commands { ; for loop for searching a input that should be executed
                if (com == input){
                    Run(Commands[com])
                    return
                }
            } 
        }  
    }
    return
}
