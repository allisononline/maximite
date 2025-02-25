Sub SHA2Initialise
    Dim H%(8)
    Dim K%(64)
    Dim W%(64)
    MaxVal% = &HFFFFFFFF
    H%(0)=&H6a09e667:H%(1)=&Hbb67ae85:H%(2)=&H3c6ef372:H%(3)=&Ha54ff53a
    H%(4)=&H510e527f:H%(5)=&H9b05688c:H%(6)=&H1f83d9ab:H%(7)=&H5be0cd19
    K%(0)=&H428a2f98:K%(1)=&H71374491:K%(2)=&Hb5c0fbcf:K%(3)=&He9b5dba5
    K%(4)=&H3956c25b:K%(5)=&H59f111f1:K%(6)=&H923f82a4:K%(7)=&Hab1c5ed5
    K%(8)=&Hd807aa98:K%(9)=&H12835b01:K%(10)=&H243185be:K%(11)=&H550c7dc3
    K%(12)=&H72be5d74:K%(13)=&H80deb1fe:K%(14)=&H9bdc06a7:K%(15)=&Hc19bf174
    K%(16)=&He49b69c1:K%(17)=&Hefbe4786:K%(18)=&H0fc19dc6:K%(19)=&H240ca1cc
    K%(20)=&H2de92c6f:K%(21)=&H4a7484aa:K%(22)=&H5cb0a9dc:K%(23)=&H76f988da
    K%(24)=&H983e5152:K%(25)=&Ha831c66d:K%(26)=&Hb00327c8:K%(27)=&Hbf597fc7
    K%(28)=&Hc6e00bf3:K%(29)=&Hd5a79147:K%(30)=&H06ca6351:K%(31)=&H14292967
    K%(32)=&H27b70a85:K%(33)=&H2e1b2138:K%(34)=&H4d2c6dfc:K%(35)=&H53380d13
    K%(36)=&H650a7354:K%(37)=&H766a0abb:K%(38)=&H81c2c92e:K%(39)=&H92722c85
    K%(40)=&Ha2bfe8a1:K%(41)=&Ha81a664b:K%(42)=&Hc24b8b70:K%(43)=&Hc76c51a3
    K%(44)=&Hd192e819:K%(45)=&Hd6990624:K%(46)=&Hf40e3585:K%(47)=&H106aa070
    K%(48)=&H19a4c116:K%(49)=&H1e376c08:K%(50)=&H2748774c:K%(51)=&H34b0bcb5
    K%(52)=&H391c0cb3:K%(53)=&H4ed8aa4a:K%(54)=&H5b9cca4f:K%(55)=&H682e6ff3
    K%(56)=&H748f82ee:K%(57)=&H78a5636f:K%(58)=&H84c87814:K%(59)=&H8cc70208
    K%(60)=&H90befffa:K%(61)=&Ha4506ceb:K%(62)=&Hbef9a3f7:K%(63)=&Hc67178f2
End Sub

Sub SHA2ResetHash
    H%(0)=&H6a09e667:H%(1)=&Hbb67ae85:H%(2)=&H3c6ef372:H%(3)=&Ha54ff53a
    H%(4)=&H510e527f:H%(5)=&H9b05688c:H%(6)=&H1f83d9ab:H%(7)=&H5be0cd19
End Sub

Function ReverseBytes%(Int32%)
    For j = 0 To 3
        Poke Var ReverseBytes%,j,Peek(Var Int32%,(3-j))
    Next
End Function

Sub SHA2LoadWords(MsgInput$,L%)
    If L% = 0 Then
        L% = Len(MsgInput$)
    EndIf
    MsgInput$ = "   "+MsgInput$
    Local Byte% = 0
    Local Word1% = 0
    MsgAddress = Peek(VarAddr MsgInput$)+4
    For i = 0 To 15
        W%(i) = ReverseBytes%(Peek(Word MsgAddress+(i*4)))
    Next
    If (56-L%) > 0 Then
        W%(L% >> 2) = W%(L% >> 2) OR (&H80 << (8*(3-L% Mod(4))))
        W%(15) = L%*8
    EndIf
End Sub

Sub SHA2ExtendWords
    Local s0% = 0
    Local s1% = 0
    For i = 16 To 63
        s0% = RightRotate%(W%(i-15),7) XOR RightRotate%(W%(i-15),18) XOR (W%(i-15) >> 3)
        S1% = RightRotate%(W%(i-2),17) XOR RightRotate%(W%(i-2),19) XOR (W%(i-2) >> 10)
        W%(i) = NoCarry32%(W%(i-16) + s0% + W%(i-7) + s1%)
    Next
End Sub

Sub SHA2Compress
    Local a%(8)
    For i = 0 To 7
        a%(i) = h%(i)
    Next
    Local S1% = 0
    Local ch% = 0
    Local temp1% = 0
    Local S0% = 0
    Local maj% = 0
    Local temp2% = 0
    For i = 0 To 63
        S1% = RightRotate%(a%(4),6) XOR RightRotate%(a%(4),11) XOR RightRotate%(a%(4),25)
        ch% = (a%(4) AND a%(5)) XOR ((MaxVal%-a%(4)) AND a%(6))
        temp1% = NoCarry32%(a%(7)+S1%+ch%+K%(i)+W%(i))
        S0% = RightRotate%(a%(0),2) XOR RightRotate%(a%(0),13) XOR RightRotate%(a%(0),22)
        maj% = (a%(0) AND a%(1)) XOR (a%(0) AND a%(2)) XOR (a%(1) AND a%(2))
        temp2% = NoCarry32%(S0%+maj%)
        For j = 7 To 1 Step -1
            a%(j) = a%(j-1)
        Next
        a%(4) = NoCarry32%(a%(4)+temp1%)
        a%(0) = NoCarry32%(temp1%+temp2%)
    Next
    For i = 0 To 7
        h%(i) = NoCarry32%(h%(i)+a%(i))
    Next
End Sub

Function SHA2CreateDigest$()
    SHA2CreateDigest$ = ""
    For i = 0 To 7
        SHA2CreateDigest$ = SHA2CreateDigest$ + LCase$(Hex$(H%(i),8))
    Next
End Function

Function RightRotate%(Value%,Bits)
    Local Carry% = Value% AND ((2^Bits)-1)
    RightRotate% = (Value% >> Bits) + (Carry% << (32-Bits))
End Function

Function NoCarry32%(Value%)
    NoCarry32% = Value% AND MaxVal%
End Function

Function SHA2ProcessString$(InStr$)
    SHA2LoadWords(InStr$)
    SHA2ExtendWords
    SHA2Compress
    SHA2ProcessString$ = SHA2CreateDigest$()
End Function

Function SHA2ProcessFile$(Filename$)
    Open Filename$ For Input As #3
    Do 
        FileIn$ = Input$(64,#3)
        SHA2LoadWords(FileIn$,LOF(#3))
        SHA2ExtendWords
        SHA2Compress
    Loop Until EOF(#3)
    Close #3
    SHA2ProcessFile$ = SHA2CreateDigest$()
End Function

Function SHA2DoubleProcess$()
    For i = 7 To 0 Step -1
        W%(i) = H%(i)
    Next
    For i = 8 To 15
        W%(i) = 0
    Next
    W%(8) = &H80000000
    W%(15) = 256
    SHA2ResetHash
    SHA2ExtendWords
    SHA2Compress
    SHA2DoubleProcess$ = SHA2CreateDigest$()
End Function

Sub SHA2Test
    SHA2Initialise
    SHA2LoadWords("hello world")
    SHA2ExtendWords
    SHA2Compress
    Print SHA2CreateDigest$()
End Sub
