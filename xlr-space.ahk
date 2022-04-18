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
 

;-------------------------------------空格快捷键

;---输入一个space打印一个space,及相关系统 space键
space::Send {space}
!space::Send !{space}
^space::Send ^{space}
#space::Send #{space}
^#space::Send ^#{space}
^!space::Send ^!{space}



;--- space + Num 代替 shift+Num
space & 1::Send {!}
space & 2::Send {@}
space & 3::Send {#}
space & 4::Send {$}
space & 5::Send {`%}
space & 6::Send {^}
space & 7::Send {&}
space & 8::Send {*}
space & 9::Send {(}
space & 0::Send {)}
space & -::Send {_}
space & =::Send {+}



;---space快捷键2
space & c:: Send ^c
space & x:: Send ^x
space & v:: Send ^v
space & z:: Send ^z
space & y:: Send ^y


;---space光标快捷键
#if GetKeyState("space", "P")

  ;   -space+ijkl ,o,,h,n上下左右，上页，下页，行首，行尾，
  i:: Send {up}
  j:: Send {left}
  k:: Send {down}
  l:: Send {right}
  o:: Send {Pgup}
  ,:: Send {Pgdn}
  h:: Send {home}
  n:: Send {end}
  b:: Send {Backspace}    ;删除
  g:: Enter         ;回车
  a::return
  f::return

  ;-  space+s+ijkl 代替shift+up，left，down，right
  s & i:: Send +{up}
  s & j:: Send +{left}
  s & k:: Send +{down}
  s & l:: Send +{right}

  ;-  space+c+ijkl 代替 ctrl+up，left，down，right
  c & i:: Send ^{up}
  c & j:: Send ^{left}
  c & k:: Send ^{down}
  c & l:: Send ^{right}

  ;-  space+f+ijkl 代替 ctrl+shift+up，left，down，right
  f & i:: Send ^+{up}
  f & j:: Send ^+{left}
  f & k:: Send ^+{down}  
  f &  l:: Send ^+{right}

  ;------文本空格快捷键
  ;---删除一行
  t & d::Send {Home}{ShiftDown}{End}{Right}{ShiftUp}{Del} 

  ;---复制整行
  t & g::
    Send {Home}{ShiftDown}{End}{Right}{ShiftUp}
    SendInput, ^c
    Send {Home}
  Return

  ;---空格+a  为我大部分快捷操作
  ;---空格+a+字母 启动程序

  a & e::send #e  ;打开文件管理器
  a & d::send #d  ;回到桌面

  ;---space快捷键3音量键控制
  a & w:: Send {Volume_Up}
  a & s:: Send {Volume_Down}
  
  ;关闭程序
  a & x:: Send !{F4}
  ;---加强复制，复制后返回 win2
  ; a & c:: 
    ; Send,^c
    ; Send,#2
  ; return
  
  
  ;启动程序
  a & j::run C:\Program Files\Google\Chrome\Application\chrome.exe
  a & k::run D:\APP\Tools\Text tool\wolai\wolai.exe
  a & l::run D:\APP\Tools\OtherTool\Clash\Clash for Windows\Clash for Windows.exe 
  a & `;::run C:\Drcom\DrUpdateClient\DrMain.exe  
  a & '::
    run C:\Program Files\Google\Chrome\Application\chrome.exe
    run D:\APP\Tools\Text tool\wolai\wolai.exe
    run D:\APP\Tools\OtherTool\Clash\Clash for Windows\Clash for Windows.exe 
  Return

  ;---空格+u+数字 切换窗口
  a & r::#1
  a & f::#2
  a & c::#3
  a & t::#4
  a & g::#5
  
  ;space + u + 数字 代替F1...
  u & 1:: Send {F1}
  u & 3:: Send {F3}
  u & 5:: Send {F5}
  u & 9:: Send {F9}

Return




