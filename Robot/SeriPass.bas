10 Open "COM2:19200, 256" As #5
11 For j = 1 to 6
12 SETPIN j, 8
13 next
17 Pin(1) = 1
18 Pin(2) = 1
20 Do
30 dat$ = Input$(1, #5)
42 contr$ = Bin$(Asc(dat$))
43 If contr$ = "100000" Then
44 For i = 3 to 6
45 Pin(i) = 0
46 next
43 EndIf
43 print contr$
44 If Mid$(contr$,6,1) = "1" THEN
45 Pin(3) = 1
48 Endif
50 Loop
                                               