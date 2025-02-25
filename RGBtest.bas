#DEFINE "LEDpin", "40"
#DEFINE "LEDnum", "40"

Dim LEDarray%(LEDnum)
SetPin LEDpin, DOUT

Sub RGBrainbow
    LEDsteps = Fix(LEDnum/3)
    For i = 0 To LEDsteps
        LEDarray%(i) = (i * &H100) + ((LEDsteps - i) * &H1)
        LEDarray%(i + LEDsteps) = (i * &H10000) + ((LEDsteps - i) * &H100)
        LEDarray%(i + (LEDsteps * 2)) = (i * &H1) + ((LEDsteps - i) * &H10000)
    Next
End Sub

Sub RGBtrans
    For i = 0 To 7
'        LEDarray%(i) = dimmer(RGB(91, 206, 250), 1.5)
'        LEDarray%(i + 8) = dimmer(RGB(245, 169, 184), 1.5)
'        LEDarray%(i + 16) = dimmer(RGB(255, 255, 255), 1.5)
'        LEDarray%(i + 24) = dimmer(RGB(245, 169, 184), 1.5)
'        LEDarray%(i + 32) = dimmer(RGB(91, 206, 250), 1.5)
        LEDarray%(i) = dimmer(RGB(Cyan), 1.5)
        LEDarray%(i + 8) = dimmer(RGB(Magenta), 1.5)
        LEDarray%(i + 16) = dimmer(RGB(White), 1.5)
        LEDarray%(i + 24) = dimmer(RGB(Magenta), 1.5)
        LEDarray%(i + 32) = dimmer(RGB(Cyan), 1.5)
    Next
End Sub

Sub RGBblank
    For i = 0 To LEDnum - 1
        LEDarray%(i) = 0
    Next
    BitBang WS2812 O, LEDpin, LEDarray%()
End Sub    

Sub shiftLeds
    For i = 0 To LEDnum - 1
        carry% = LEDarray%((i + 1) Mod LEDnum)
        LEDarray%((i + 1) Mod LEDnum) = LEDarray%(i)
        LEDarray%(i) = carry%
    Next
End Sub

Function dimmer(inVal, percent)
    R = Fix(((inVal And &HFF0000) >> 16) * (percent / 100))
    G = Fix(((inVal And &H00FF00) >> 8) * (percent / 100))
    B = Fix((inVal And &H0000FF) * (percent / 100))
    dimmer = (R << 16) + (G << 8) + B
End Function
    

RGBtrans
Do
    BitBang WS2812 O, LEDpin, LEDarray%()
    shiftLeds
    Pause 20
Loop

