10 LCD INIT 1, 2, 3, 4, 5, 6
20 GPSDAT$ = "": G2$ = "":T3$ = "":V4$ = "":L5$ = "":N6$ = "":L7$ = ""
30 E8$ = "":S9$ = "":C0$ = "":D1$ = "":V2$ = "":A3$ = "":C4$ = ""
32 LAT$ = ""
34 LON$ = ""
36 VARIAT$ = "   "
38 LCD 2, 3, "Searching..."
40 Open "COM2:9600, 1024" As #5
60 Input #5, G2$, T3$, V4$, L5$, N6$, L7$, E8$, S9$, C0$, D1$, V2$, A3$, C4$
70 If G2$ = "$GPRMC" Then
80 If V4$ = "A" Then
81 If Mid$(L5$,5,1) = "." Then
82 LCD 1,2,Mid$(L5$,1,2)+Chr$(223)+Mid$(L5$,3,2)+"'"+Mid$(L5$,6,2)
83 Else
84 LCD 1,1,Mid$(L5$,1,3)+Chr$(223)+Mid$(L5$,3,2)+"'"+Mid$(L5$,7,2)
85 EndIf
86 LCD 1,10,"."+Right$(L5$,3)+Chr$(34)+" "+N6$
87 Print L5$
91 If Mid$(L7$,5,1) = "." Then
92 LCD 2,2,Mid$(L7$,1,2)+Chr$(223)+Mid$(L7$,3,2)+"'"+Mid$(L7$,6,2)
93 Else
94 LCD 2,1,Mid$(L7$,1,3)+Chr$(223)+Mid$(L7$,3,2)+"'"+Mid$(L7$,7,2)
95 EndIf
96 LCD 2,10,"."+Right$(L7$,3)+Chr$(34)+" "+E8$
97 Print L7$
100 EndIf
110 EndIf
120 EndIf
130 GoTo 60


                                                                      