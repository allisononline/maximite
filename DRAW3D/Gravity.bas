#Include "A:/General.inc"
#Include "A:/DRAW3D/New3D.inc"
ParticleAmt = 64
ParticleMass = 1
ParticleArea = 0.1
TimeIncre = 1/60
Gravity = 9.8          'Earth mode 
AirDensity = 1.225
'Gravity = 1.62         'Moon mode
'AirDensity = 0.01      
DragCoeff = 0.47
Bounds = 200
Centre.X = Mm.Hres/2
Centre.Y = Mm.Vres/2


Sub InitialiseParticles
    Dim Particle(ParticleAmt,4)
    Generate
End Sub

Sub Generate
    For i = 0 To ParticleAmt-1
        For k = 0 To 2
            Particle(i,k) = (Rnd()*Bounds*2) - Bounds
        Next
        Particle(i,3) = 0
    Next
End Sub

Sub LoadSprites
    Sprite Load "Snow.spr",1
    Sprite Copy #1,#2,63
    For j = 0 To 63
        Sprite.X = Centre.X+Fov(Particle(j,0),Particle(j,2))
        Sprite.Y = Centre.Y-Fov(Particle(j,1),Particle(j,2))
        Sprite Show #(j+1),Sprite.X,Sprite.Y,0
    Next
End Sub

Sub Accelerate(Num)
    AirResistance = (1/2)*AirDensity*(Particle(Num,3)^2)*DragCoeff*ParticleArea
    If Particle(Num,1) > -Bounds Then
        Particle(Num,3) = Particle(Num,3)+(ParticleMass*(Gravity-AirResistance))
    Else
        Particle(Num,3) = Particle(Num,3)*-0.5
    EndIf
End Sub

Sub Move(Num)
    Particle(Num,1) = Particle(Num,1)-((Particle(Num,3))*TimeIncre)
    If Particle(Num,1) < -Bounds Then
        Particle(Num,1) = -Bounds
    EndIf
End Sub

Sub Draw(Num,Colour)
    Dot.X = Centre.X+Fov(Particle(Num,0),Particle(Num,2))
    Dot.Y = Centre.Y-Fov(Particle(Num,1),Particle(Num,2))
    Pixel Dot.X,Dot.Y,Colour
End Sub

Sub MoveParticles
    For i = 0 To ParticleAmt-1
        Accelerate(Particle(),i)
        If Particle(i,3) > 0 Then
            Draw(Particle(),i,RGB(0,0,0))
            Move(Particle(),i)
            Draw(Particle(),i,RGB(255,255,255))
        EndIf
    Next
End Sub

Sub MoveSprites
    For i = 0 To 63
        Accelerate(i)
        Move(i)
        Sprite.X = Centre.X+Fov(Particle(i,0),Particle(i,2))
        Sprite.Y = Centre.Y-Fov(Particle(i,1),Particle(i,2))
        Sprite Next #(i+1),Sprite.X,Sprite.Y
    Next
    Sprite Move
End Sub

Function AllFallen()
    For i = 0 To ParticleAmt
        If Abs(Particle(i,3)) > 0.04 Then
            AllFallen = 0
            Exit Function
        EndIf
    Next
    AllFallen = 1
End Function
        
InitialiseParticles
LoadSprites
Pause 2000
Cls
Do
    MoveSprites
    Pause TimeIncre
Loop Until AllFallen()
