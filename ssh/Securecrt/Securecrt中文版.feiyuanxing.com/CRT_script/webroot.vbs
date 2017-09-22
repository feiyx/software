#$language = "VBScript"
#$interface = "1.0"

crt.Screen.Synchronous = True

' This automatically generated script may need to be
' edited in order to work correctly.

Sub Main
	crt.Screen.Send "cd /l" & chr(8) & "ho" & chr(9) & "webr" & chr(9) & chr(13)
	crt.Screen.WaitForString "[root@master webroot]# "
	crt.Screen.Send "ll" & chr(13)
End Sub
