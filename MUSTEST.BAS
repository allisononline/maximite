Input "PLEASE ENTER A FILE NAME: ", File$

Open File$ For Input As #2

Do While Eof(2) = 0
    Input #2, X$,Y
    B = Peek(Var X$,1)
    If B = 48 Then
        C = 0
    Elseif B < 48 Or B > 56 Then
        Print "SCALE OUT OF RANGE"
        Exit
    Endif
    C = Peek(Var X$,2)
    If C <41 Or C > 71 Then
        Print "NOT A NOTE"
        Exit
    Elseif C = 65 Then
        C = 0
    Elseif C = 66 Then
        C = 2
    Elseif C = 67 Then
        C = 3
    Elseif C = 68 Then
        C = 5
    Elseif C = 69 Then
        C = 7
    Elseif C = 70 Then
        C = 8
    Elseif C = 71 Then
        C = 10
    Endif
    If Peek(Var X$,3) = 35 Then
        '
    Endif
    If C <> 0 Then
        Note = (110*2)^(C/12)
'        Play Tone Note,Note
        Pause 250 * Y
        Play Tone 0,0
        Print Note ;
    EndIf
Loop
