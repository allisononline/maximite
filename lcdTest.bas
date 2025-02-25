#DEFINE "LCD_RS","5"
#DEFINE "LCD_RW","7"
#DEFINE "LCD_OE","8"
#DEFINE "LCD_D0","21"
#DEFINE "LCD_D1","22"
#DEFINE "LCD_D2","23"
#DEFINE "LCD_D3","24"
#DEFINE "LCD_D4","26"
#DEFINE "LCD_D5","27"
#DEFINE "LCD_D6","28"
#DEFINE "LCD_D7","29"

Sub lcdInit
    SetPin LCD_RS,DOUT: Pin(LCD_RS) = 0
    SetPin LCD_RW,DOUT: Pin(LCD_RW) = 0
    SetPin LCD_OE,DOUT: Pin(LCD_OE) = 0
    lcdPortWrite
    lcd8BitMode
End Sub

Sub lcd4BitMode
    For i = 0 To 2
        lcdWrite8Bit(&H30,0)
    Next
    lcdWrite8Bit(&H20,0)
End Sub

Sub lcd8BitMode
    For i = 0 To 2
        lcdWrite8Bit(&H30,0)
    Next
End Sub

Function lcdCodeFunction(bits,lines,dots)
    lcdCodeFunction = &H20+((bits = 8) << 4)+((lines = 2) << 3)+((dots = 10) << 2)
End Function

Function lcdCodeDisplay(disp,curs,blink)
    lcdCodeDisplay = &H08+((disp = 1) << 2)+((curs = 1) << 1)+(blink = 1)
End Function

Function lcdCodeClear()
    lcdCodeClear = &H01
End Function

Function lcdCodeReturn()
    lcdCodeReturn = &H02
End Function

Function lcdCodeGoto(column,row)
    lcdCodeGoto = &H80+(&H40*(row = 2))+column-1
End Function

Function lcdCodeEntry(dir,shift)
    lcdCodeEntry = &H04+((dir = 1) << 1)+(shift = 1)
End Function

Sub lcdPortWrite
    SetPin LCD_D0,DOUT
    SetPin LCD_D1,DOUT
    SetPin LCD_D2,DOUT
    SetPin LCD_D3,DOUT
    SetPin LCD_D4,DOUT
    SetPin LCD_D5,DOUT
    SetPin LCD_D6,DOUT
    SetPin LCD_D7,DOUT
    Port(LCD_D0,4,LCD_D4,4) = 0
End Sub

Sub lcdPortRead
    SetPin LCD_D0,DIN
    SetPin LCD_D1,DIN
    SetPin LCD_D2,DIN
    SetPin LCD_D3,DIN
    SetPin LCD_D4,DIN
    SetPin LCD_D5,DIN
    SetPin LCD_D6,DIN
    SetPin LCD_D7,DIN
End Sub

Sub lcdWrite8Bit(lcdData,lcdRS)
    lcdPortWrite
    Pin(LCD_RS) = lcdRS
    Pin(LCD_RW) = 0
    Port(LCD_D0,4,LCD_D4,4) = lcdData
    lcdPulseClock
End Sub

Sub lcdWrite4Bit(lcdData,lcdRS)
    lcdPortWrite
    Pin(LCD_RS) = lcdRS
    Pin(LCD_RW) = 0
    Port(LCD_D0,4) = 0
    Port(LCD_D4,4) = (lcdData >> 4) And &HF
    lcdPulseClock
    Port(LCD_D4,4) = lcdData And &HF
    lcdPulseClock
End Sub

Function lcdRead4Bit(lcdRS)
    lcdPortRead
    Pin(LCD_RS) = lcdRS
    Pin(LCD_RW) = 1
    lcdPulseClock
    lcdRead4Bit = Port(LCD_D4,4)
    lcdPulseClock
    lcdRead4Bit = (lcdRead4Bit << 4) + Port(LCD_D4,4)
End Function

Function lcdRead8Bit(lcdRS)
    lcdPortRead
    Pin(LCD_RS) = lcdRS
    Pin(LCD_RW) = 1
    lcdPulseClock
    lcdRead8Bit = Port(LCD_D0,4,LCD_D4,4)
End Function

Sub lcdPulseClock
    Pin(LCD_OE) = 0
    Pulse LCD_OE,1
    Pause 2
End Sub

Sub lcdPrint(lcdLine, lcdPos, lcdText$)
    chars = Len(lcdText$)
    If chars > 16 Then
        chars = 16
    EndIf
    lcdWrite8Bit(lcdCodeGoto(lcdLine, lcdPos), 0)
    For i = 1 To chars
        lcdWrite8Bit(Asc(Mid$(lcdText$, i, 1)), 1)
    Next
End Sub

Sub lcdTest
    lcdInit
    lcdWrite8Bit(lcdCodeEntry(1,0),0)
    lcdWrite8Bit(lcdCodeDisplay(1,1,1),0)
    lcdWrite8Bit(lcdCodeFunction(8,2,8),0)
    lcdWrite8Bit(lcdCodeClear(),0)
    lcdWrite8Bit(lcdCodeGoto(1,1),0)
    lcdPrint(1, 1, "Welcome.")
End Sub

Sub lcdMemDump
'    lcdInit
    For i = &HC0 To &HC0+&H10
        lcdWrite8Bit(i,0)
        lcdWrite8Bit(&H61)
    Next
End Sub

lcdTest
