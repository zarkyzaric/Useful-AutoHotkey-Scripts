#Requires AutoHotkey v2.0 
#Include <Paths>
;                  FUNCTIONS:

/*          RUN:             */
Open(path, app := "",Keystroke := "", Delay := "") {
    if (app != "") {
        Run(app " " path)
    } else {
        Run(path)
    }
    ;Wait(1)
    ;Send("{F11}")
}
OpenVSC := Open.Bind(,VSC)

Study(appsArray){ ;This is basically the same as MultiOpen but only for Daily.ahk
    Loop appsArray.Length {
        Run(appsArray[A_Index])
    }
    ExitApp()
}
MultiOpen(appsArray) {
    numOfApps := appsArray.Length  ; Count of apps in the array
    if (numOfApps = 0) {
        return
    }
    Loop numOfApps {  ; Corrected Loop syntax
        App := appsArray[A_Index]  ; Get the current app from the array
        if (App == "") {
            continue
        }
        Run(App)
        ; Uncomment the next line if you want to display an error message
        ; MsgBox("Error", "An error occurred!", 16)
    }
}
/*          TIME:            */
Wait(sec := 1, min := 0, h := 0){
    Sleep(sec * 1000 + min*60*1000 + h*3600*1000)
}
SendIn(text, sec){
    Sleep(sec * 1000)
    Send(text)
}
RunSend(App,Key, sec := 2) {
    Run(App)
    Sleep(sec*1000)
    Send(Key)
}
/*       HOTKEY FUNC:        */
F11(sec := 1){
    Sleep(sec * 1000)
    Send("{F11}")
}

; GO THROUGH
GoThrough(Commands,command){
    for key in Commands{
        if (StrCompare(key,command) == 0) {
            if !(IsObject(Commands[key])) {
                Run(Commands[key])
                return 1
            }
            else{
                Commands[key].Call()
                return 1
            } ; or Commands[key]() works the same
        }
    }
    if !(Commands.Has(command)){ ; if it doesn't have corresponding key, it goes into a next terminal
        if UrlSearch(command)
            return 1
        return 0 
    }
}

/*  SEARCH   */

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
    ; If input > 3 and doesn't have spaces, it's treated as url
    if ((StrLen(input) > 7) && !(InStr(input,A_Space))) {
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
