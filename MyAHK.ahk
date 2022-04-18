;----------------------------热键与字符串

;------热键


;---字符串
;-账号相关
::196::196156709
::196q::196156709@qq.com
::283::2833613437
::183::18370527825
::3622::362232200201160417
::123::12345678a
::jts::今天是王冠荆棘自学Java的第48天


;-其他
:*:hexoc::
   Send, hexo clean && hexo g && hexo s ;hexo快捷输入
Return

;--------------------------音量快捷键

;---音量键①
;^i:: Send {Volume_Up}
;^k:: Send {Volume_Down}
;break::Send {Volume_Mute}
;return

; 在任务栏上滚动滚轮:增加/减小音量.②
#If MouseIsOver("ahk_class Shell_TrayWnd")
WheelUp::Send {Volume_Up}     ; 在任务栏上滚动滚轮:增加/减小音量.
WheelDown::Send {Volume_Down} ;
MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}
Return





