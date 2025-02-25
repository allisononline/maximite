BYTES = 16

FUNCTION PAD$(STR$,SPC)
    FOR l = 0 TO SPC
        POKE VAR PAD$,l,48
    NEXT
    FOR l = 0 TO SPC
        POKE VAR PAD$,l+(SPC-LEN(STR$)+1),PEEK(VAR STR$,l)
    NEXT
END FUNCTION
    

Open MM.CmdLine$ For Input As #5
FOR j = 1 to (LOF(#5)/Bytes)+((LOF(#5) Mod Bytes) > 0)
    InStr$ = Input$(Bytes,#5)
    Print Bin$(j*Bytes,16)+"  ";
    For i = 1 To Bytes
        If i =< Len(InStr$) Then
            Print Hex$(Peek(VAR InStr$,i),2)+" ";
            If i Mod 4 = 0 Then
                Print " ";
            EndIf
            IF PEEK(VAR InStr$,i) < 32 OR PEEK(VAR InStr$,i) > 126 THEN
                POKE VAR InStr$,i,46
            ENDIF
        Else
            Print "00 ";
            If i Mod 4 = 0 Then
                Print " ";
            EndIf
        EndIf
    NEXT
    Print InStr$
    IF j MOD(35) = 34 THEN
        DO
        LOOP UNTIL InKey$ <> ""
    ENDIF
NEXT
CLOSE #5
