Sleep, 1500

; Globals
windowTitle := "Rahool AFK"
itemWanted := 0
amountNeeded := 0
id := 0
targetTitle := ""
DEBUG := False

; Program State
; 0 = Started
; 1 = Options
; 2 = Running
progState := 0

; Hotkeys
Hotkey ^1, select_win
Hotkey ^2, start
Hotkey ^3, stop

Gui, Start:Margin, 40, 40
Gui, Start:Add, Text,, Select D2 window and press Ctrl + 1`nCtrl + 3 to exit at any time
Gui, Start:Show, AutoSize, %windowTitle%
return

select_win:
{
	MouseGetPos,,, id, control
	WinGetTitle, targetTitle, ahk_id %id%
	
	Gui, Start:Destroy
	Gui, Main:New,, %windowTitle%
	Gui, Main:Margin, 10, 10
	
	Gui, Main:Add, Text,, Input which item you want (1, 2, 3, or 4)
	Gui, Main:Add, Edit, vitemWanted
	Gui, Main:Add, UpDown, Range1-4, 1
	
	Gui, Main:Add, Text,, `n
	
	Gui, Main:Add, Text,, Input how much of the item you want. Input the amount you have as`na negative number and it will buy as many to get you near to max.
	Gui, Main:Add, Edit, vamountNeeded
	
	Gui, Main:Add, Text,,
	Gui, Main:Add, Text,, Press Ctrl + 2 to start buying`nPress Ctrl + 3 to exit
	
	if(DEBUG)
	{
		Gui, Main:Add, Text,,
		Gui, Main:Add, Text,, Target: %targetTitle%`, ID: %id%
	}
	
	Gui, Main:Show
	progState := 1
	return
}

start:
{
	Gui, Main:Submit
	Gui, Main:Destroy
	
	Gui, Running:New,, %windowTitle%
	Gui, Running:Margin, 40, 40
	Gui, Running:Add, Text,, Purchasing %amountNeeded% of item %itemWanted%
	Gui, Running:Add, Text,, Press Ctrl + 3 at any time to stop
	
	Gui, Running:Show
	Sleep 10000
	
	progState := 2
	
	WinGetPos, topLeftX, topLeftY, winWidth, winHeight, %targetTitle%

	Switch itemWanted
	{
		Case 1:
			itemX := topLeftX + Round(57*(winWidth/80))
		Case 2:
			itemX := topLeftX + Round(49*(winWidth/64))
		Case 3:
			itemX := topLeftX + Round(131*(winWidth/160))
		Case 4:
			itemX := topLeftX + Round(279*(winWidth/320))
		Default:
			ExitApp
	}

	itemY := topLeftY + Round(7*(winHeight/45))
	itemYMove := topLeftY + Round(winHeight/6)

	loopAmount := amountNeeded > 0 ? Ceil(amountNeeded / 5) : Ceil( (9994 + amountNeeded) / 5 )

	Loop, %loopAmount%
	{
		Sleep, 300
		MouseMove, %itemX%, %itemYMove%, 1
		Sleep, 30
		Click
		Sleep, 300
		MouseMove, %itemX%, %itemY%, 1
	
		;ControlClick, x%itemX% y%itemY%, ahk_id %id%,, Left,, NA
		;Sleep, 300
		;ControlMove,,, -10,,, ahk_id %id%
		;Sleep, 300
	}
	
	Gui, Running:Destroy
	Gui, Done:New,, %windowTitle%
	Gui, Done:Margin, 40, 40
	Gui, Done:Add, Text,, Done purchasing, you may close this window.
	Gui, Done:Show
	Sleep 60000
	ExitApp
	
	return
}

stop:
{
	switch progState
	{
		Case 0:
			Gui, Start:Destroy
		Case 1:
			Gui, Main:Destroy
		Case 2:
			Gui, Running:Destroy
		Default:
			MsgBox, how tf did you even get here
	}
	Gui, ForceStop:New,, %windowTitle%
	Gui, ForceStop:Margin, 40, 40
	Gui, ForceStop:Add, Text,, Program force stopped, you may close this window.
	Gui, ForceStop:Show
	Sleep 10000
	ExitApp
}

StartESC:
StartGuiClose:
StartGuiEscape:
MainESC:
MainGuiClose:
MainGuiEscape:
RunningESC:
RunningGuiClose:
RunningGuiEscape:
DoneESC:
DoneGuiClose:
DoneGuiEscape:
ForceStopESC:
ForceStopGuiClose:
ForceStopGuiEscape:
ExitApp