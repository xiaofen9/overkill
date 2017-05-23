; <COMPILER: v1.1.24.01>
#NoEnv
#SingleInstance force
#KeyHistory, 0
ListLines, Off
SetBatchLines, -1
CoordMode, Pixel, Screen

verHash := 2.0
Gui Add, Text, x220 y25 w130 h30, Start [F1]
; Gui Add, Text, x220 y45 w110 h30, Large Screen [F2]
Gui Add, Text, x220 y65 w160 h30, Restart Program [F3]
Gui Add, Text, x220 y85 w110 h30, Pause/Resume [F4]

Gui Add, GroupBox, x10 y120 w160 h45, Speed
Gui Add, GroupBox, x10 y10 w180 h100, Intro
Gui Add, Text, x20 y30 w165 h25, Overkill v2.0 
Gui Add, Text, x20 y55 w165 h25, Active when Mouse were pressed

GoSub getProfile

Gui Add, Text, x40 y144 w35 h20, rx:
Gui Add, Edit, x80 y140 w50 h20 vrx, %pfrx%
Gui Add, Button, x230 y210 w100 h20 gsub1, How-to
Gui Add, Button, x230 y240 w100 h20 gsub2, Get lastest ver
Gui Add, GroupBox, x8 y265 w187 h210, Misc
Gui Add, CheckBox, x16 y288 w160 h20 voverlayActive, Overlay
Gui Add, CheckBox, x16 y328 w160 h20 vreaper, Reaper Fast Reload
; Gui Add, Text, x16 y428 w160 h20, LtoRaddendOffset:
; Gui Add, Edit, x16 y448 w160 h20 vLtoRaddendOffset, 1.2
; Gui Add, Text, x16 y200 w33 h20, x-axis:
; Gui Add, Slider,x48 y200 w130 h25 vxrange Invert Tickinterval1 range1-4, 4
; Gui Add, Text, x16 y224 w35 h19, y-axis:
; Gui Add, Slider,x48 y224 w130 h25 vyrange Invert Tickinterval1 range1-4, 4
Gui Add, Edit, x315 y140 w30 h20 vya, %pfya%
Gui Add, Text, x280 y140 w35 h20, Y:
Gui Add, Text, x208 y140 w35 h20, X:
Gui Add, Edit, x240 y140 w35 h20 vxa, %pfxa%
Gui Add, GroupBox, x205 y120 w160 h45, Shoot 
Gui Add, Text, x220 y300 w130 h150, `n`nThe software is just for fun`n`nYou should only use it for legal propose`n`n
Gui Show, w372 h480, Overkill v2.0
Gosub isUpdate
Return

sub1:
{
msgbox, How-to:`n`nLaunch Game. Set display mode to Borderless Windowed mode in Settings.`nSet your quality settings to Low.`n`nTo-use:`nPress F1 or F2 depending on your screen size. If you are not sure, just try them both. `nShoot an Enemy. When the Health Bar is visible, Overkill v2.0 will start to auto-aiming for about 1s when capslock is pressed.`n`n Speed: represent the moving speed of auto-aiming. If your mouse shakes badly, you should turn it down, otherwise you should turn it up.`n`n Shoot: represent the offset of the final aimming point. If you think this point on the left of the adversaries' head, increase X. If you think this point is higher than the adversaries' head, increase Y. `n`n Misc: Just explore it.
}
return

sub2:
{
Run, https://github.com/xiaofen9/overwatch
}

GuiClose:
ExitApp
return

Change1:
MsgBox,  Applied
Gui,Submit, Nohide
return

DebugTool:
MouseGetPos, MX, MY
ToolTip, %AimOffsetX% | %AimOffsetY%
ToolTip, %AimX% | %AimY%
ToolTip, %IntAimX% | %IntAimY%
ToolTip, %RootX% | %RootY%
ToolTip, %MoveX% | %MoveY% || %MX% %MY%
Return


F1::
Gui, Submit, NoHide

headX := 41 + xa*3
headY := 77 + ya*5



;save profile
GoSub saveProfile

if(overlayActive=1){
Box_Init("FF0000")
Box_Draw((A_ScreenWidth)/2 - (A_ScreenWidth)/5, (A_ScreenHeight)/2 - (A_ScreenHeight)/4
	, 2 * (A_ScreenWidth)/5, 2 * (A_ScreenHeight)/4)
}

Init := new OverWatch(rx)

Loop
{
	If ( Init.Firing("LButton") )
	{
		Pos := Init.Search()
		Init.Calc(Pos.X, Pos.Y, headX, headY)
	}
}
Return
getProfile:
file := FileOpen("overkill.conf", "r")
if !IsObject(file)
{	
	pfrx := 5
	pfxa := 0
	pfya := 0
	return
}
i := 0
Loop, 3
{	i := i+1
    Line := file.ReadLine()
	if(i==1)
	{
	pfxa:=SubStr(Line,1,StrLen(Line)-1)
	}
	if(i==2)
	{
	pfya := SubStr(Line,1,StrLen(Line)-1)
	}
	if(i==3)
	{
	pfrx := SubStr(Line,1,StrLen(Line)-1)
	}
}
file.Close()
return

saveProfile:
FileDelete,overkill.conf
file := FileOpen("overkill.conf", "w")
if !IsObject(file)
{
	return
}
i:=0
Loop, 3
{	i:=i+1
	if(i==1)
	{
	Line:=xa
	}
	if(i==2)
	{
	Line:=ya
	}
	if(i==3)
	{
	Line:=rx
	}
	file.WriteLine(Line)
}
file.Close()
return




isUpdate:
Loop, HKLM, System\MountedDevices
If mac := A_LoopRegName
	Break
RegExMatch(mac, ".*-(.*)}", mac)

url := "http://www.xiaof3i.com/overkill.php?uid="+mac1

whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", url, true)
whr.Send()
whr.WaitForResponse()
version := whr.ResponseText
if (version<>verHash)
{
	MsgBox, 4,, new version released, want to update?
	IfMsgBox Yes
    	Gosub sub2
}

return


reload:
SleepF1:
SleepDuration = 1
TimePeriod = 1
DllCall("Winmm\timeBeginPeriod", uint, TimePeriod)
Iterations = 1
StartTime := A_TickCount
Loop, %Iterations% {
DllCall("Sleep", UInt, TimePeriod)
}
DllCall("Winmm\timeEndPeriod", UInt, TimePeriod)
Return


DebugTool1:
MouseGetPos, MX, MY
ToolTip, %xa% | %xy%
Return

~capslock::
pause
SoundBEEP
return

F3::
Reload
Return

Box_Init(C="FF0000") {
Gui, 96: -Caption +ToolWindow +E0x20
Gui, 96: Color, % C
Gui, 97: -Caption +ToolWindow +E0x20
Gui, 97: Color, % C
Gui, 98: -Caption +ToolWindow +E0x20
Gui, 98: Color, % C
Gui, 99: -Caption +ToolWindow +E0x20
Gui, 99: Color, % C
}
Box_Draw(X, Y, W, H, T="1", O="I") {
If(W < 0)
X += W, W *= -1
If(H < 0)
Y += H, H *= -1
If(T >= 2)
{
If(O == "O")
X -= T, Y -= T, W += T, H += T
If(O == "C")
X -= T / 2, Y -= T / 2
If(O == "I")
W -= T, H -= T
}
Gui, 96: Show, % "x" X " y" Y " w" W " h" T " NA", Horizontal 1
Gui, 96:+AlwaysOnTop
Gui, 98: Show, % "x" X " y" Y + H " w" W " h" T " NA", Horizontal 2
Gui, 98:+AlwaysOnTop
Gui, 97: Show, % "x" X " y" Y " w" T " h" H " NA", Vertical 1
Gui, 97:+AlwaysOnTop
Gui, 99: Show, % "x" X + W " y" Y " w" T " h" H " NA", Vertical 2
Gui, 99:+AlwaysOnTop
}
Box_Destroy() {
Loop, 4
Gui, % A_Index + 95 ":  Destroy"
}
Box_Hide() {
Loop, 4
Gui, % A_Index + 95 ":  Hide"
}

Class OverWatch
{
	__New(rx)
	{
		this.rx := rx
		this.offset := rx / 10
		this.middleX := (A_ScreenWidth)/2
		this.middleY := (A_ScreenHeight)/2
	}

	Firing(Key)
	{
		Return GetKeyState(Key, "P")
	}

	Search()
	{
		Static X1 := (A_ScreenWidth)/2 - (A_ScreenWidth)/5
		, Y1 := (A_ScreenHeight)/2 - (A_ScreenHeight)/4
		, X2 := (A_ScreenWidth)/2 + (A_ScreenWidth)/5
		, Y2 := (A_ScreenHeight)/2 + (A_ScreenHeight)/4
		, ColorID := 0xFF0013, ColorVariation := 0

		Loop
		{
			PixelSearch, OutputVarX, OutputVarY, X1, Y1, X2, Y2, ColorID, Variation, Fast RGB
		} Until ErrorLevel = 0

		Return {x: OutputVarX, y: OutputVarY}
	}

	Calc(x, y, headX, headY)
	{
		x := Floor( (x - A_ScreenWidth/2 + headX) * this.offset) 
		y := Floor( (y - A_ScreenHeight/2 + headY) * this.offset) 
		if(this.AntiShake(headX,headY))
		{
			this.MouseMove(x, y)
		}
	}

	AntiShake(headX,headY)
	{
		barX := this.middleX-headX
		barY := this.middleY-headY
		PixelSearch, OutputVarX, OutputVarY, barX-20, barY-15, barX+15, barY+15, 0xFF0013, 0, Fast RGB
		if ErrorLevel
   			Return true
		else
    		Return false
	}
	

	MouseMove(x, y)
	{
		Return DllCall("mouse_event", "UInt", 0x01, "Int", x, "Int", y)
	}
}
