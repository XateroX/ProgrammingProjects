#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Run, notepad output.txt
FileDelete, %A_WorkingDir%\output.txt
FileAppend, This is a blank line`n, %A_WorkingDir%\output.txt
MouseMove, 1500,540 [,0]
Click
Send ^A
