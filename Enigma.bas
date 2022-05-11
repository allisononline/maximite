
rotorI(0) = 4: rotorI(1) = 10: rotorI(2) = 12: rotorI(3) = 5
rotorI(4) = 11: rotorI(5) = 6: rotorI(6) = 3: rotorI(7) = 16
rotorI(8) = 21: rotorI(9) = 25: rotorI(10) = 13: rotorI(11) = 19
rotorI(12) = 14: rotorI(13) = 22: rotorI(14) = 24: rotorI(15) = 7
rotorI(16) = 23: rotorI(17) = 20: rotorI(18) = 18: rotorI(19) = 15
rotorI(20) = 0: rotorI(21) = 8: rotorI(22) = 1: rotorI(23) = 17
rotorI(24) = 2: rotorI(25) = 9

rotorII(0) = 0: rotorII(1) = 9: rotorII(2) = 3: rotorII(3) = 10
rotorII(4) = 18: rotorII(5) = 8: rotorII(6) = 17: rotorII(7) = 20
rotorII(8) = 23: rotorII(9) = 1: rotorII(10) = 11: rotorII(11) = 7
rotorII(12) = 22: rotorII(13) = 19: rotorII(14) = 12: rotorII(15) = 2
rotorII(16) = 16: rotorII(17) = 6: rotorII(18) = 25: rotorII(19) = 13
rotorII(20) = 15: rotorII(21) = 24: rotorII(22) = 5: rotorII(23) = 21
rotorII(24) = 14: rotorII(25) = 4

rotorIII(0) = 1: rotorIII(1) = 3: rotorIII(2) = 5: rotorIII(3) = 7
rotorIII(4) = 9: rotorIII(5) = 11: rotorIII(6) = 2: rotorIII(7) = 15
rotorIII(8) = 17: rotorIII(9) = 19: rotorIII(10) = 23: rotorIII(11) = 21
rotorIII(12) = 25: rotorIII(13) = 13: rotorIII(14) = 24: rotorIII(15) = 4
rotorIII(16) = 8: rotorIII(17) = 22: rotorIII(18) = 6: rotorIII(19) = 0
rotorIII(20) = 10: rotorIII(21) = 12: rotorIII(22) = 20: rotorIII(23) = 18
rotorIII(24) = 16: rotorIII(25) = 14
Const rotorI$ = "EKMFLGDQVZNTOWYHXUSPAIBRCJ"
Const rotorII$ = "AJDKSIRUXBLHWTMCQGZNPYFVOE"
Const rotorIII$ = "BDFHJLCPRTXVZNYEIWGAKMUSQO"
rotorIpos = 0
rotorIIpos = 0
rotorIIIpos = 0

Function rotorFwd$(rotorNum$, rotorpos, letter$)
    number = ((Asc(UCase$(letter$)) - &H41 + rotorpos) Mod 26) + 1
    rotorFwd$ = Mid$(rotorNum$, number, 1)
End Function

Sub arrayPrint
    For i = 1 To 26
        Print "rotorI("+Format$(i - 1)+") =";
        Print Asc(Mid$(rotorI$, i, 1)) - &H41;
        If Not (i Mod 4) Then
            Print
        ElseIf Not (i = 26) Then
            Print ": ";
        EndIf
    Next
    Print
    Print
    For i = 1 To 26
        Print "rotorII("+Format$(i - 1)+") =";
        Print Asc(Mid$(rotorII$, i, 1)) - &H41;
        If Not (i Mod 4) Then
            Print
        ElseIf Not (i = 26) Then
            Print ": ";
        EndIf
    Next
    Print
    Print
    For i = 1 To 26
        Print "rotorIII("+Format$(i - 1)+") =";
        Print Asc(Mid$(rotorIII$, i, 1)) - &H41;
        If Not (i Mod 4) Then
            Print
        ElseIf Not (i = 26) Then
            Print ": ";
        EndIf
    Next
    Print
    Print
End Sub

arrayPrint
   = 17: rotorII(7) = 20
rotorII(8) = 23: rot