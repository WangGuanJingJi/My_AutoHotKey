;管理员运行
if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%" 
   ExitApp
}

;无环境变量
#NoEnv

;高进程
Process Priority,,High

;一直关闭 Capslock
SetCapsLockState, AlwaysOff  

; CapsLock -> Esc
CapsLock::
Send {Esc}
return
			

; 光标移动&&&



; 指针移动
CapsLock & i::
Send {Up}
return
CapsLock & k::
Send {Down}
return
CapsLock & j::
Send {Left}
return
CapsLock & l::
    Send {right}
return

; 行首行尾
CapsLock & h::
Send {home}
return
CapsLock & n::
Send {end}{enter}
return


; 左右删除
CapsLock & b::
Send {BS}
return


; 撤销重做
CapsLock & z::
Send ^{z}
return


; Capslock + 数字  -->  切换桌面
; Capslock + Shift + 数字  -->  把当前窗口带到某桌面
; [Switch to desktop] OR [Move the current window to the X-th desktop]

Capslock & 1:: 
If GetKeyState("Shift")
MoveActiveWindowToDesktop(1) 
else SwitchToDesktop(1)
Return
Capslock & 2:: 
If GetKeyState("Shift")
MoveActiveWindowToDesktop(2) 
else SwitchToDesktop(2)
Return
Capslock & 3:: 
If GetKeyState("Shift")
MoveActiveWindowToDesktop(3) 
else SwitchToDesktop(3)
Return
Capslock & 4:: 
If GetKeyState("Shift")
MoveActiveWindowToDesktop(4) 
else SwitchToDesktop(4)
Return
Capslock & 5:: 
If GetKeyState("Shift")
MoveActiveWindowToDesktop(5) 
else SwitchToDesktop(5)
Return
Capslock & 6:: 
If GetKeyState("Shift")
MoveActiveWindowToDesktop(6) 
else SwitchToDesktop(6)
Return
Capslock & 7:: 
If GetKeyState("Shift")
MoveActiveWindowToDesktop(7) 
else SwitchToDesktop(7)
Return
Capslock & 8:: 
If GetKeyState("Shift")
MoveActiveWindowToDesktop(8) 
else SwitchToDesktop(8)
Return
Capslock & 9:: 
If GetKeyState("Shift")
MoveActiveWindowToDesktop(9) 
else SwitchToDesktop(9)
Return
Capslock & 0:: 
If GetKeyState("Shift")
MoveActiveWindowToDesktop(10) 
else SwitchToDesktop(1)
Return
; Capslock & -:: 
;If GetKeyState("Shift")
;MoveActiveWindowToDesktop(11) 
;else SwitchToDesktop(1)
;Return
; Capslock & =:: 
;If GetKeyState("Shift")
;MoveActiveWindowToDesktop(12) 
;else SwitchToDesktop(1)
;Return
 
SwitchToDesktop(idx){
    if (!SwitchToDesktopByInternalAPI(idx)){
        TrayTip , WARN, SwitchToDesktopByHotkey
        SwitchToDesktopByHotkey(idx)
    }
}
SwitchToDesktopByHotkey(idx){
    SendInput ^#{Left 10}
    idx -= 1
    Loop %idx% {
        SendInput ^#{Right}
    }
}
 
SwitchToDesktopByInternalAPI(idx){
    succ := 0
    IServiceProvider := ComObjCreate("{C2F03A33-21F5-47FA-B4BB-156362A2F239}", "{6D5140C1-7436-11CE-8034-00AA006009FA}")
    IVirtualDesktopManagerInternal := ComObjQuery(IServiceProvider, "{C5E0CDCA-7B6E-41B2-9FC4-D93975CC467B}", "{F31574D6-B682-4CDC-BD56-1827860ABEC6}")
    ObjRelease(IServiceProvider)
    if (IVirtualDesktopManagerInternal){
        GetCount := vtable(IVirtualDesktopManagerInternal, 3)
        GetDesktops := vtable(IVirtualDesktopManagerInternal, 7)
        SwitchDesktop := vtable(IVirtualDesktopManagerInternal, 9)
        ; TrayTip, , % IVirtualDesktopManagerInternal
        pDesktopIObjectArray := 0
        DllCall(GetDesktops, "Ptr", IVirtualDesktopManagerInternal, "Ptr*", pDesktopIObjectArray)
        if (pDesktopIObjectArray){
            GetDesktopCount := vtable(pDesktopIObjectArray, 3)
            GetDesktopAt := vtable(pDesktopIObjectArray, 4)
            DllCall(GetDesktopCount, "Ptr", IVirtualDesktopManagerInternal, "UInt*", DesktopCount)
            ; if idx-th desktop doesn't exists then create a new desktop
            if (idx > DesktopCount){
                diff := idx - DesktopCount
                loop %diff% {
                    Send ^#d
                }
                succ := 1
            }
            GetGUIDFromString(IID_IVirtualDesktop, "{FF72FFDD-BE7E-43FC-9C03-AD81681E88E4}")
            DllCall(GetDesktopAt, "Ptr", pDesktopIObjectArray, "UInt", idx - 1, "Ptr", &IID_IVirtualDesktop, "Ptr*", VirtualDesktop)
            ObjRelease(pDesktopIObjectArray)
            if (VirtualDesktop){
                DllCall(SwitchDesktop, "Ptr", IVirtualDesktopManagerInternal, "Ptr", VirtualDesktop)
                ObjRelease(VirtualDesktop)
                succ := 1
            }
        }
        ObjRelease(IVirtualDesktopManagerInternal)
    }
    Return succ
}
vtable(ptr, n){
    ; NumGet(ptr+0) Returns the address of the object's virtual function
    ; table (vtable for short). The remainder of the expression retrieves
    ; the address of the nth function's address from the vtable.
    Return NumGet(NumGet(ptr+0), n*A_PtrSize)
}
GetGUIDFromString(ByRef GUID, sGUID) ; Converts a string to a binary GUID
{
    VarSetCapacity(GUID, 16, 0)
    DllCall("ole32\CLSIDFromString", "Str", sGUID, "Ptr", &GUID)
}
 
MoveActiveWindowToDesktop(idx){
    activeWin := WinActive("A")
    WinHide ahk_id %activeWin%
    SwitchToDesktop(idx)
    WinShow ahk_id %activeWin%
    WinActivate ahk_id %activeWin%
}

;-------------------------模拟鼠标增强
!CapsLock:: CapsLock
#If GetKeyState("CapsLock", "P")


a:: ta := (ta ? ta : QPC()), mTick()
d:: td := (td ? td : QPC()), mTick()
w:: tw := (tw ? tw : QPC()), mTick()
s:: ts := (ts ? ts : QPC()), mTick()
	a Up:: ta := 0, mTick()
	d Up:: td := 0, mTick()
	w Up:: tw := 0, mTick()
	s Up:: ts := 0, mTick()

e:: RButton
q:: LButton

r:: tr := (tr ? tr : QPC()), sTicky()
f:: tf := (tf ? tf : QPC()), sTicky()
r Up:: tr := 0, sTicky()
f Up:: tf := 0, sTicky()



CoordMode, Mouse, Screen

;-----------鼠标模式选择
ma(t){
	 Return ma2(t) ; 二次函数运动模型
	; Return ma3(t) ; 三次函数运动模型
	; 指数函数运动模型
	;return maPower(t)
}
ma2(t){
	; x-t 二次曲线加速运动模型
	; 跟现实世界的运动一个感觉
	If(0 == t)
	return 0
	If(t > 0)
	return  6
	else
		return -6

}

ma3(t){
	; x-t 三次曲线函数运动模型
	; 与现实世界不同，
	; 这个模型会让人感觉鼠标比较“重”
	;
	If(0 == t)
	return 0
	If(t > 0)
	return t * 12
	else
		return t * 12
}

maPower(t){
	; x-t 指数曲线运动的简化模型
	; 这个模型可以满足精确定位需求，也不会感到鼠标“重”
	; 但是因为跟现实世界的运动曲线不一样，凭直觉比较难判断落点，需要一定练习才能掌握。
	;
	If(0 == t)
	return 0
	If(t > 0)
	return  ( Exp( t) - 0.95 ) * 16
	else
		return -( Exp(-t) - 0.95 ) * 16
}

QPF()
{
	DllCall("QueryPerformanceFrequency", "Int64*", QuadPart)
	return QuadPart
}

QPC()
{
	DllCall("QueryPerformanceCounter", "Int64*", Counter)
	return Counter
}

; 时间计算
dt(t, tNow){
	return t ? (tNow - t) / QPF() : 0
}


MoCaLi(v, a){ ; 摩擦力
	If((a > 0 And v > 0) Or (a < 0 And v < 0))
	return v
	; 简单粗暴倍数降速
	v *= 0.8
	If(v > 0)
	v -= 1
	If(v < 0)
	v += 1
	v //= 1
	return v
}


; 鼠标加速度微分对称模型，每秒误差 2.5ms 以内
global ta := 0, td := 0, tw := 0, ts := 0, mvx := 0, mvy := 0

; 滚轮加速度微分对称模型（不要在意名字hhhh
global tr := 0, tf := 0, tz := 0, tc := 0, svx := 0, svy := 0

; 鼠标运动处理
mm:
	tNow := QPC()
	; 计算用户操作时间
	tda := dt(ta, tNow)
	tdd := dt(td, tNow)
	tdw := dt(tw, tNow)
	tds := dt(ts, tNow)

	; 计算加速度
	max := ma(tdd - tda)
	may := ma(tds - tdw)

	; 摩擦力不阻碍用户意志
	mvx := MoCaLi(mvx + max, max)
	mvy := MoCaLi(mvy + may, may)

	MouseMove, %mvx%, %mvy%, 0, R

	If(0 == mvx And 0 == mvy)
	SetTimer, mm, Off
return

; 时间处理
mTick(){
	SetTimer, mm, 1
}
mouseWheel_lParam(x, y){
	return x | (y << 16)
}

; 滚轮运动处理
msx:
	tNow := QPC()
	; 计算用户操作时间
	tdz := dt(tz, tNow)
	tdc := dt(tc, tNow)
	; 计算加速度
	sax := ma(tdc - tdz)
	svx := MoCaLi(svx + sax, sax)

	MouseGetPos, mouseX, mouseY, wid, fcontrol
	wParam := svx << 16 ;zDelta
	lParam := mouseWheel_lParam(mouseX, mouseY)
	PostMessage, 0x20E, %wParam%, %lParam%, %fcontrol%, ahk_id %wid%

	If(0 == svx)
	SetTimer, msx, Off
return
msy:
	tNow := QPC()
	; 计算用户操作时间
	tdr := dt(tr, tNow)
	tdf := dt(tf, tNow)
	; 计算加速度
	say := ma(tdr - tdf)
	svy := MoCaLi(svy + say, say)

	MouseGetPos, mouseX, mouseY, id, fcontrol
	wParam := svy << 16 ;zDelta
	lParam := mouseWheel_lParam(mouseX, mouseY)
	PostMessage, 0x20A, %wParam%, %lParam%, %fcontrol%, ahk_id %id%

	If(0 == svy)
	SetTimer, msy, Off
return

; 时间处理
sTickx(){
	SetTimer, msx, 1
}
sTicky(){
	SetTimer, msy, 1
}









