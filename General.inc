Function FindWord$(Inline3$,Wordnum)
    If Wordnum < 1 Then
        Wordnum = 1
    Endif
    FindWord$ = ""
    Local Start = 1
    Local K = 0
    For I = 1 To Wordnum
        Start = Start + K
        K = 0
        Do While Mid$(Inline3$,Start+K,1) = " "
            K = K + 1
        Loop
        Start = Start + K
        K = 0
        Do While Mid$(Inline3$,Start+K,1) <> " " And  Start+K =< Len(Inline3$)
            K = K + 1
        Loop
    Next
    If K > 0 Then
        FindWord$ = Mid$(Inline3$,Start,K)
    Endif
End Function

CSub RMLED
        00000000
        0890E92D AF00B083 4B1E6078 BC00E9D3 F06F481C F04F6100 EA0B0200 EA0C0301 
        E9C00402 687B3400 3400E9D3 D10D4323 E9D34B15 4814BC00 5100F04F 0200F04F 
        0301EA4B 0402EA4C 3400E9C0 E9D3687B 2C003400 2B01BF08 4B0BD10D BC00E9D3 
        F44F4809 F04F5100 EA4B0200 EA4C0301 E9C00402 BF003400 46BD370C 0890E8BD 
        BF004770 58020800 58020818 
End CSub

CSub RMBeep
        00000000
        0890E92D AF00B083 4B1E6078 BC00E9D3 F46F481C F04F0100 EA0B0200 EA0C0301 
        E9C00402 687B3400 3400E9D3 D10D4323 E9D34B15 4814BC00 6100F04F 0200F04F 
        0301EA4B 0402EA4C 3400E9C0 E9D3687B 2C003400 2B01BF08 4B0BD10D BC00E9D3 
        F44F4809 F04F6100 EA4B0200 EA4C0301 E9C00402 BF003400 46BD370C 0890E8BD 
        BF004770 58020C00 58020C18 
End CSub
