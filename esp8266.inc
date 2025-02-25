Sub espLog logMsg$
    If espLogConsole = 1 Then
        If logMsg$ = "" Then
            LongString Print espBuffer%();
        Else
            Print logMsg$;
        EndIf
    EndIf
    If espLogFile = 1 Then
        If logMsg$ = "" Then
            LongString Print #2, espBuffer%();
        Else
            Print #2, logMsg$;
    EndIf
End Sub

Sub espSendReceive(Command$,noCRLF)
    Print #1, Command$;
    If noCRLF = 0 Then
        Print #1
    EndIf
    Pause 20
    espReceive
End Sub

Sub espSend(Command$,noCRLF)
    Print #1, Command$;
    If noCRLF = 0 Then
        Print #1
    EndIf
End Sub

Sub espReceive
    LongString Clear espBuffer%()
    If Loc(#1) <> 0 Then
        Prevchrs = 0
        Chrs = 0
        Do
            Pause 20
            Prevchrs = Chrs
            Chrs = Loc(#1)
        Loop While Chrs <> Prevchrs Or Chrs = 0
        For i = 1 To Chrs
            LongString Append espBuffer%(),Input$(1,#1)
        Next
    EndIf
    espLog
End Sub

Function espFindStr(msgString$)
    espFindStr = LInStr(espBuffer%(),msgString$)
End Function
    
Function espWaitOKError()
    Do While Not (espFindStr("OK") Or espFindStr("ERROR"))
        espReceive
    Loop
    espWaitOKError = (espFindStr("OK") > 0)
End Function

Sub espReset
    espSendReceive("AT+RST")
    Pause 2000
    espReceive
End Sub

Sub espInit
    Open "COM1:115200" As #1
    Open "espLog.txt" For Append As #2
    Dim espBuffer%(2048/8)
    Dim espReceiveData%(2048/8)
    Dim espSendData%(2048/8)
    Dim q$ = Chr$(34)
    Dim espLogFile = 1
    Dim espLogConsole = 1
    Dim espMultiMode
    Dim espConnCurrent
    espReset
    espSendReceive("ATE1")
    espSendReceive("AT+CWMODE=1")
    espMultiRead
    If Not espConnected() Then
        junk = espJoin("WiFi-P69T-(nice)","7112beyapt")
    EndIf
End Sub

Function espConnected()
    espSendReceive("AT+CWJAP?")
    If Not LInstr(espBuffer%(),"No AP") Then
        espConnected = 1
    EndIf
End Function

Sub espIPAddr
    espSendReceive("AT+CIFSR")
End Sub

Sub espSvrStatus
    espSendReceive("AT+CIPSTATUS")
End Sub

Function espJoin(ssid$,pass$)
    espSendReceive("AT+CWJAP="+q$+ssid$+q$+","+q$+pass$+q$)
    espJoin = espWaitOKError()
End Function

Sub espLeave
    espSendReceive("AT+CWQAP")
End Sub

Sub espMultiSet(value)
    espSendReceive("AT+CIPMUX="+Format$(value))
    espMultiMode = value
End Sub

Sub espMultiRead
    espSendReceive("AT+CIPMUX?")
    espMultiMode = (LInstr(espBuffer%(),"+CIPMUX:1") > 0)
End Sub

Sub espOpenServer(portNum)
    espMultiSet(1)
    espSendReceive("AT+CIPSERVER=1,"+Format$(portNum))
End Sub

Sub espCloseServer(portNum)
    espSendReceive("AT+CIPSERVER=0,"+Format$(portNum))
    espReset
End Sub    

Function espConnStart(connID,connType$,connAddr$,connPort)
    If espMultiMode Then
        stringID$ = Format$(connID)+","
    Else
        stringID$ = ""
    EndIf
    espSendReceive("AT+CIPSTART="+stringID$+q$+connType$+q$+","+q$+connAddr$+q$+","+Format$(connPort))
    espConnStart = espWaitOKError()
End Function

Sub espConnReceiveData
    LongString Clear espReceiveData%()
    msgStart = LinStr(espBuffer%(),"+IPD")
    If msgStart Then
        firstComma = LInStr(espBuffer%(),",",msgStart+4)
        secondComma = LinStr(espBuffer%(),",",firstComma+1)
        firstColon = LInStr(espBuffer%(),":",secondComma+1)
        If espMultiMode Then
            espConnCurrent = Val(LGetStr$(espBuffer%(),firstComma+1,secondComma-firstComma-1))
            dataLen = Val(LGetStr$(espBuffer%(),secondComma+1,firstColon-secondComma-1))
        Else
            dataLen = Val(LGetStr$(espBuffer%(),firstComma+1,firstColon-firstComma-1))
        EndIf
        LongString Mid espReceiveData%(),espBuffer%(),firstColon+1,dataLen
    EndIf
End Sub

Sub espConnSendData(connIDSend)
    connSendLen = LLen(espSendData%())
    If espMultiMode Then
        stringID$ = Format$(connIDSend)+","
    Else
        stringID$ = ""
    EndIf
    espSendReceive("AT+CIPSEND="+stringID$+Format$(connSendLen))
    For i = 0 To connSendLen Step 255
        espSend(LGetStr$(espSendData%(),i+1,255),1)
    Next
End Sub

Sub espConnSendFile(filename$,connIDFile)
    Open filename$ For Input As #5
    fileLen = LOF(#5)
    For k = 0 To fileLen-1 Step 2040
        LongString Clear espSendData%()
        For j = 0 To 7
            LongString Append espSendData%(),Input$(255,#5)
            If EOF(#5) Then
                Exit For
            EndIf
        Next
        espConnSendData(connIDFile)
    Next
    Close #5
End Sub

Sub espConnClose(connID)
    If espMultiMode Then
        stringID$ = "="+Format$(connID)
    Else
        stringID$ = ""
    EndIf
    espSendReceive("AT+CIPCLOSE"+stringID$)
End Sub

Sub espClose
    Close #1
End Sub
