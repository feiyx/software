#$language = "VBScript"
#$interface = "1.0"

crt.Screen.Synchronous = True

' This automatically generated script may need to be
' edited in order to work correctly.

Sub Main
	crt.Screen.Send chr(27) & "[A" & chr(27) & "[A" & chr(13)
	crt.Screen.WaitForString "[root@master tomcat]# "
	crt.Screen.Send chr(27) & "[A" & chr(27) & "[A" & chr(13)
End Sub
