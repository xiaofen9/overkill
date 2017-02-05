; <COMPILER: v1.1.24.01>
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
guif:
#NoEnv
#SingleInstance force
SkinForm(Apply, A_ScriptDir . "\USkin.dll", A_ScriptDir . "\Milikymac.msstyles")
Firing := 0
Gui Add, Text, x220 y25 w130 h30, Small Screen [F1]
Gui Add, Text, x220 y45 w110 h30, Large Screen [F2]
Gui Add, Text, x220 y65 w160 h30, Restart Program [F3]
Gui Add, Text, x220 y85 w110 h30, Pause/Resume [F4]


Gui Add, GroupBox, x10 y120 w160 h45, Speed
Gui Add, GroupBox, x10 y10 w180 h100, Intro
Gui Add, Text, x20 y30 w165 h25, Overkill aimming assitant
Gui Add, Text, x20 y55 w165 h25, Active when Capslock were pressed


Gui Add, Text, x40 y144 w35 h20, rx:
Gui Add, Edit, x80 y140 w50 h20 vrx, 5
Gui Add, Button, x230 y210 w100 h20 gsub1, How-to
Gui Add, Button, x230 y240 w100 h20 gsub2, Get lastest ver
Gui Add, GroupBox, x8 y265 w187 h210, Misc
Gui Add, CheckBox, x16 y288 w160 h20 voverlayActive, Overlay
Gui Add, CheckBox, x16 y328 w160 h20 vreaper, Reaper Fast Reload
Gui Add, Text, x16 y428 w160 h20, LtoRaddendOffset:
Gui Add, Edit, x16 y448 w160 h20 vLtoRaddendOffset, 1.2
Gui Add, Text, x16 y200 w33 h20, x-axis:
Gui Add, Slider,x48 y200 w130 h25 vxrange Invert Tickinterval1 range1-4, 4
Gui Add, Text, x16 y224 w35 h19, y-axis:
Gui Add, Slider,x48 y224 w130 h25 vyrange Invert Tickinterval1 range1-4, 4
Gui Add, Edit, x315 y140 w30 h20 vya, 0
Gui Add, Text, x280 y140 w35 h20, Y:
Gui Add, Text, x208 y140 w35 h20, X:
Gui Add, Edit, x240 y140 w35 h20 vxa, 0
Gui Add, GroupBox, x205 y120 w160 h45, Shoot 
Gui Add, Text, x220 y300 w130 h150, `n`nThe software is just for fun`n`nYou should only use it for legal propose`n`n
Gui Show, w372 h480, Overkill
Loop {
Gui, Submit, NoHide
Sleep -1
}
Return


#If bunny=1
*~$Space::
sleep 20
loop
{
GetKeyState, SpaceState, Space, P
if SpaceState = U
break
Sleep 1
Send, {Blind}{Space}
}
Return
#If
Return
Return


sub1:
{
msgbox, How-to:`n`nLaunch Game. Set display mode to Borderless Windowed mode in Settings.`nSet your quality settings to Low.`n`nTo-use:`nPress F1 or F2 depending on your screen size. If you are not sure, just try them both. `nShoot an Enemy. When the Health Bar is visible, overkill will start to auto-aiming for about 1s when capslock is pressed.`n`n Speed: represent the moving speed of auto-aiming. If your mouse shakes badly, you should turn it down, otherwise you should turn it up.`n`n Shoot: represent the offset of the final aimming point. If you think this point on the left of the adversaries' head, increase X. If you think this point is higher than the adversaries' head, increase Y. `n`n Misc: Just explore it.
}
return

sub2:
{
Run, https://github.com/xiaofen9/overwatch
}

GuiClose:
ExitApp
return
SkinForm(Param1 = "Apply", DLL = "", SkinName = ""){
if(Param1 = Apply){
DllCall("LoadLibrary", str, DLL)
DllCall(DLL . "\USkinInit", Int,0, Int,0, AStr, SkinName)
}else  if(Param1 = 0) {
DllCall(DLL . "\USkinExit")
}}
Change1:
MsgBox,  Applied
Gui,Submit, Nohide
return

F1::
#Persistent
#KeyHistory, 0
#NoEnv
#HotKeyInterval 1
#MaxHotkeysPerInterval 127
#InstallKeybdHook
#UseHook
#SingleInstance, Force
SetKeyDelay,-1, 8
SetControlDelay, -1
SetMouseDelay, 0
SetWinDelay,-1
SendMode, InputThenPlay
SetBatchLines,-1
ListLines, Off
CoordMode, Mouse, Screen
PID := DllCall("GetCurrentProcessId")
Process, Priority, %PID%, Normal
ZeroX := 640
ZeroY := 360
CFovX := 320
CFovY := 200
ScanL := 500
ScanR := 800
ScanT := 180
ScanB := 400

;UI parameters
GuiControlget, rx
GuiControlget, xa
GuiControlget, ya
GuiControlget, xrange
GuiControlget, yrange

;detection box
LargeX1 := 0 + (A_Screenwidth * (xrange/10))
LargeY1 := 0 + (A_Screenheight * (yrange/10))-40
LargeX2 := A_Screenwidth - (A_Screenwidth * (xrange/10))
LargeY2 := A_Screenheight - (A_Screenheight * (yrange / 10))-75
SmallX1 := LargeX1 + 40
SmallY1 := LargeY1 
SmallX2 := LargeX2 - 40
SmallY2 := LargeY2 - 55

;parameters used for pixel search, ideal ColVn should be 0, meaning that EMCol is the exact color of health bar
EMCol := 0xFF0013
ColVn := 2
FoundFlag :=false
Cnt:=0
if(overlayActive=1){
Box_Init("FF0000")
Box_Draw(LargeX1, LargeY1 , LargeX2-LargeX1, LargeY2-LargeY1)
}

Loop, {
Gui,Submit, Nohide


GetKeyState, CapLck, CapsLock, P
if ( CapLck == "D" ) {
Cnt:=60
}

while(Cnt>=0){
GoSub SearchBot
GoSub GetAimOffset
GoSub GetAimMoves
GoSub MouseMoves
Cnt--
}




}

MouseMoves:
GetKeyState, Mouse1, LButton, P
If ( Mouse1 == "D" ) {
DllCall("mouse_event", uint, 1, int, MoveX, int, MoveY, uint, 0, int, 0)
}
Return



GetAimOffset:
Gui,Submit, Nohide
headX :=1+xa
headY := 19+ya*5
AimX := AimPixelX - ZeroX +headX
AimY := AimPixelY - ZeroY +headY
If ( AimX+5 > 0) {
DirX := rx / 10
}
If ( AimX+5 < 0) {
DirX := (-rx) / 10
}
If ( AimY+2 > 0 ) {
DirY := rx /10
}
If ( AimY+2 < 0 ) {
DirY := (-rx) /10
}
AimOffsetX := AimX * DirX
AimOffsetY := AimY * DirY
Return



GetAimMoves:
RootX :=  AimOffsetX 
RootY :=  AimOffsetY 
MoveX := RootX * DirX
MoveY := RootY * DirY
Return

SleepF:
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

DebugTool:
MouseGetPos, MX, MY
ToolTip, %AimOffsetX% | %AimOffsetY%
ToolTip, %AimX% | %AimY%
ToolTip, %IntAimX% | %IntAimY%
ToolTip, %RootX% | %RootY%
ToolTip, %MoveX% | %MoveY% || %MX% %MY%
Return


F2::
#Persistent
#KeyHistory, 0
#NoEnv
#HotKeyInterval 1
#MaxHotkeysPerInterval 2000
#InstallKeybdHook
#UseHook
#SingleInstance, Force
SetKeyDelay,-1, 8
SetControlDelay, -1
SetMouseDelay, 0
SetWinDelay,-1
SendMode, InputThenPlay
SetBatchLines,-1
ListLines, Off
CoordMode, Mouse, client
PID := DllCall("GetCurrentProcessId")
Process, Priority, %PID%, Normal
ZeroX := 960
ZeroY := 540
CFovX := 80
CFovY := 200
ScanL := 660
ScanR := 1250
ScanT := 280
ScanB := 610

;UI parameters
GuiControlget, rX
GuiControlget, xa
GuiControlget, ya
GuiControlget, xrange
GuiControlget, yrange

;detection box
LargeX1 := 0 + (A_Screenwidth * (xrange/10))
LargeY1 := 0 + (A_Screenheight * (yrange/10))-40
LargeX2 := A_Screenwidth - (A_Screenwidth * (xrange/10))
LargeY2 := A_Screenheight - (A_Screenheight * (yrange / 10))-75
SmallX1 := LargeX1 + 60
SmallY1 := LargeY1 
SmallX2 := LargeX2 - 60
SmallY2 := LargeY2 - 55


;parameters used for pixel search, ideal ColVn should be 0, meaning that EMCol is the exact color of health bar
EMCol := 0xFF0013
ColVn := 1
FoundFlag :=false
Cnt:=0
if(overlayActive=1){
Box_Init("FF0000")
Box_Draw(LargeX1, LargeY1 , LargeX2-LargeX1, LargeY2-LargeY1)
}

Loop, {
Gui,Submit, Nohide


GetKeyState, CapLck, CapsLock, P
if ( CapLck == "D" ) {
Cnt:=65
}

while(Cnt>=0){
GoSub SearchBot
GoSub GetAimOffset1
GoSub GetAimMoves1
GoSub MouseMoves1
Cnt--
}
}







MouseMoves1:
GetKeyState, Mouse1, LButton, P
If ( Mouse1 == "D" ) {
DllCall("mouse_event", uint, 1, int, MoveX, int, MoveY, uint, 0, int, 0)
}
Return



SearchBot:
if ( not FoundFlag ) {
	PixelSearch, AimPixelX, AimPixelY, LargeX1, LargeY1, LargeX2, LargeY2, EMCol, ColVn, Fast RGB
	if ErrorLevel = 1  
		FoundFlag := false
	else 
		FoundFlag := true
}
else {
	PixelSearch, AimPixelX, AimPixelY, SmallX1, SmallY1, SmallX2, SmallY2, EMCol, ColVn, Fast RGB
	;PixelSearch, AimPixelX, AimPixelY, LargeX1, LargeY1, LargeX2, LargeY2, EMCol, ColVn, Fast RGB
	if ErrorLevel = 1
		FoundFlag := false		
}
Return



GetAimOffset1:
Gui,Submit, Nohide
moveToRight := 0
headX := 42+xa*3
headY := 90+ya*5
AimX := AimPixelX - ZeroX +headX
AimY := AimPixelY - ZeroY +headY
If ( AimX+4 > 0) {
DirX := rx / 10
moveToRight := 1
}
If ( AimX+4 < 0) {
DirX := (-rx) / 10
}
If ( AimY+2 > 0 ) {
DirY := rX /10 
}
If ( AimY+2 < 0 ) {
DirY := (-rx) /10 
}
AimOffsetX := AimX * DirX
AimOffsetY := AimY * DirY
Return

GetAimMoves1:
;RootX := Ceil(AimOffsetX)
;RootY := Ceil(AimOffsetY)
RootX := AimOffsetX
RootY := AimOffsetY
if (moveToRight)
{
	MoveX := RootX * DirX + LtoRaddendOffset ;tested with 15 sensitivity, the addend should be larger than 1.3 when sensitivity is smaller than 15
	;MoveX := RootX * (DirX + 0.5) 
}
else
{
	MoveX := RootX * DirX
}
;MoveX := RootX * DirX
MoveY := RootY * DirY
;GoSub DebugTool1
Return





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

~F4::
pause
SoundBEEP
return

F3::
Reload
Return
