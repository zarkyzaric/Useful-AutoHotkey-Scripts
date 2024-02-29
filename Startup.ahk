#Requires AutoHotkey v2.0
#Include <Functions>
Sleep(10000)

; OpenVSC(*Path to Your Directory*) ; Opens desired directory

; Shuts down your PC if your local time is past 10 PM
ShutdownCheck() 

;___________________________________________________________________________________-
ShutdownCheck() {
    Sleep(1000)
    Loop 50
    {
        ; Get the current hour
        CurrentHour := A_Hour
        if CurrentHour < 10 {
            ; SetTimer () => MsgBox("Have fun!", "",), -1000
            break
        }
        ; Check if it's past 9 PM
        if ((CurrentHour >= 22) && (CurrentHour <= 5))
        {
                Shutdown(1)  ; Shut down the computer
                ExitApp()    ; Exit the script
        }
        ; Wait for 10 minutes before checking again
        Sleep(600000) ; MsgBox("`"Shutdown check was successful.`"")
    }
}

