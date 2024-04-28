#Requires AutoHotkey v2.0
#SingleInstance Force
; Script from: https://github.com/AiSatan/AutoHotKeyAutoCorrect
; Ctrl+Alt+c autocorrect selected text
^!c::
{
    clipback := ClipboardAll()
    A_Clipboard := ""
    Send("^c")
    ClipWait

    variable := "https://www.google.com/search?hl=en&q=" . A_Clipboard
    whr := ComObject("WinHttp.WinHttpRequest.5.1")

    whr.Open("GET", variable, true)
    whr.SetRequestHeader("Content-type", "text/html; charset=UTF-8")
    whr.SetRequestHeader("User-Agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)")
    whr.SetRequestHeader("Accept-Language", "en-US,en;q=0.5")
    whr.Send()
    whr.WaitForResponse()
    contents := whr.ResponseText

    if (RegExMatch(contents, "(Showing results for|Did you mean:).*?q=.*?>(.*?)<\/a>", &match)) {
        A_Clipboard := StrReplace(match[2], "<b><i>")
        A_Clipboard := StrReplace(A_Clipboard, "</i></b>")
        A_Clipboard := RegExReplace(A_Clipboard, "&#39;", "'")
        A_Clipboard := RegExReplace(A_Clipboard, "&amp;", "&")
    }
    Send("^v")
    Sleep(500)
    A_Clipboard := clipback
    return
}