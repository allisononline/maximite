Centre.X = MM.Hres/2
Centre.Y = MM.Vres/2

Function FOV(COORD1,COORD2)
    DISTANCE = 512
    ANGLE = Atn(COORD1 / (DISTANCE + COORD2))
    FOV = (Tan(ANGLE) * DISTANCE)
End Function

Sub Ripple
    For i = -256 To 255 Step 4
        For j = -256 To 255 Step 4
            r = Sqr(((i/16)^2)+((j/16)^2))
            If r <> 0 Then
                y = sin(r)/r
            Else
                y = 1
            EndIf
            invsqr = 255*(1/(1+((i+256)/512))^2)
            PixelColour = RGB(invsqr,invsqr,invsqr)
            Pixel Centre.X+FOV(j,i),Centre.Y-FOV(-100+(y*100),i),PixelColour
        Next
    Next
End Sub

Sub Gravity
    ObjectGravity = 200
    ObjectX = 128
    ObjectZ = 0
    For i = -256 To 255 Step 4
        For j = -256 To 255 Step 4
            dist = Sqr(((ObjectX-j)^2)+((ObjectZ-i)^2))/16
            If dist <> 0 Then
                y = ObjectGravity*(1/(dist^2))
            Else
                y = ObjectGravity
            EndIf
            Pixel Centre.X+FOV(j,i),Centre.Y-FOV(-100+(y),i),RGB(255,255,255)
        Next
    Next
End Sub

Gravity
