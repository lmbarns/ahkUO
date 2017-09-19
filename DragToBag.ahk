IniFile := "E:\ahkUO\DragPosition.txt"   ;File to store x, y, location variable
FileGetSize, size, %IniFile%
    if (size = "") {
        MsgBox Setting up
        IniWrite, 1300, %IniFile%, Loot, xdest ; --- destination x pos
        IniWrite, 700, %IniFile%, Loot, ydest ; --- destination y pos
    } else {
        IniRead, xdest, %IniFile%, Loot, xdest ; --- destination x pos
        IniRead, ydest, %IniFile%, Loot, ydest ; --- destination y pos
    }
CoordMode, Pixel

;CNTRL Left Click to Drag to bag
$^Lbutton::
	MouseGetPos, x1, y1

		Send {Shift down}
		Sleep 10
		MouseClickDrag, left, x1, y1, xdest, ydest, 2
		Send {Shift up}
		MouseMove, x1, y1, 0 
return

;Alt + Right Click to set drag destination
$!Rbutton::
    MouseGetPos, xdest, ydest
    IniWrite, %xdest%, %IniFile%, Loot, xdest
    IniWrite, %ydest%, %IniFile%, Loot, ydest
return


$;::  ;While ; key is down, click repeatedly
While GetKeyState(";","P")
  {
    Click
    Sleep, 10 ; every 10 miliseconds
	Send {;}
  }
return

;Single quote hotkey to search area around mouse x, y, and click if it finds a sign
;This hotkey is for SALLOS, has a 5px offset on where the mouse clicks that razor doesn't need4

$'::
MouseGetPos, x1, y1
Send {'}
FileList =
Loop, Files, E:\ahkUO\ahkuo\Images\*.bmp, FD  
    FileList = %FileList%%A_LoopFileTimeModified%`t%A_LoopFileName%`n
Sort, FileList  ; Sort by date.
Loop, Parse, FileList, `n
{
	; Omit the last linefeed (blank item) at the end of the list.
		if A_LoopField =  
			continue
	; Split into two parts at the tab char.
		StringSplit, FileItem, A_LoopField, %A_Tab%  

	;Add 250px offset to mouse position to speed up search speed x 20 signs to look for
	ImageSearch, FoundX, FoundY, (x1 - 250),(y1-250), (x1+250), (y1+250), E:\AHKUO\ahkUO\Images\%FileItem2% ;searches a 500px x 500px around the mouse position
	if (ErrorLevel = 0){ 
		FoundX := FoundX + 5
		FoundY := FoundY + 5
		Click, %FoundX%, %FoundY%
		Sleep 25
		MouseMove, x1, y1, 0
	}
}
return

;Same idea but with no offset, this works in Razor but not Sallos
;Hotkey is Shift + '
$+'::  
MouseGetPos, x1, y1  ;get current mouse position to return the mouse to after searching
Send {'} ;pass on the actual hotkey in case we're typing
FileList =
Loop, Files, E:\ahkUO\ahkuo\Images\*.bmp, FD  
    FileList = %FileList%%A_LoopFileTimeModified%`t%A_LoopFileName%`n
Sort, FileList  ; Sort by date.
Loop, Parse, FileList, `n
{
		if A_LoopField =  
			continue
		StringSplit, FileItem, A_LoopField, %A_Tab%  

	ImageSearch, FoundX, FoundY, (x1 - 250),(y1-250), (x1+250), (y1+250), E:\ahkUO\ahkUO\Images\%FileItem2%
	if (ErrorLevel = 0){ 
		FoundX := FoundX
		FoundY := FoundY
		Click, %FoundX%, %FoundY%
		sleep 300
		MouseMove, x1, y1, 0
	}
}
return



