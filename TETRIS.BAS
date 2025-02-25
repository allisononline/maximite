10  Dim TETRO(4,4)
12  Dim HOPPER(4,4)
14  Dim FIELD(12,22)
16  Dim POSITION(2)
20  TETRO(2,1) = 2
30  TETRO(1,2) = 2
40  TETRO(2,2) = 2
50  TETRO(3,2) = 2

52  Sub INIT
80      For j = 0 To 21
82          FIELD(0,j) = 1
84          FIELD(11,j) = 1
86      NEXT
88      FOR i = 0 to 11
90          FIELD(i,0) = 1
92          FIELD(i,21) = 1
94      NEXT
96      FOR j = 1 TO 20
82          For i = 1 To 10
108             FIELD(i,j) = 0
110         Next
120     Next
122     POSITION(0) = 3
124     POSITION(1) = 2
130 End Sub

132 Sub HOPPER (arg1$)
134     i = 0 : j = 0
134     For j = 0 To 3
136         For i = 0 To 3
132             If arg1$ = "CUT" Then
134                 If FIELD(POSITION(0)+i,POSITION(1)+j) = 2 Then
138                     HOPPER(i,j)=FIELD(POSITION(0)+i,POSITION(1)+j)
140                     FIELD(POSITION(0)+i,POSITION(1)+j)=0
140                 EndIf
140             ElseIf arg1$ = "PASTE" Then
138 FIELD(POSITION(0)+i,POSITION(1)+j)=FIELD(POSITION(0)+i,POSITION(1)+j)+HOPPER(i,j)
140             ElseIf arg1$ = "CLEAR" Then
141                 HOPPER(i,j) = 0
142             ELSEIF arg1$ = "PRINT" Then
144                 Print HOPPER(i,j);
142             EndIf
140         Next
142         If arg1$ = "PRINT" Then
144             Print ""
146         EndIf
142     Next
144 End Sub

132 Sub DRAW
134     Cls
134     For l = 0 To 21
136         For k = 0 To 11
138             If FIELD(k,l) > 0 Then
140                 Print FIELD(k,l);
142             Else
144                 Print "  ";
146             EndIf
148         Next
150         Print ""
152     Next
154 End Sub

154 Sub ENTER
156     POSITION(0) = 3
158     POSITION(1) = 2
156     For j = 0 To 3
158         For i = 0 To 3
162             HOPPER(i,j) = TETRO(i,j)
162         Next
164     Next
164     HOPPER "PASTE"
166 End Sub

168 FUNCTION BLOCK()
170     FOR j = 0 to 3
172         FOR i = 0 to 3
174             IF FIELD(POSITION(0)+i,POSITION(1)+j) > 2 THEN
176                 BLOCK = 1
178             ENDIF
180         NEXT
182     NEXT
184 END FUNCTION

168 FUNCTION BUMP(DIR$)
172         for j = 0 to 3
174             for i = 0 to 3
176                 IF HOPPER(i,j) = 2 THEN
170                 IF DIR$ = "DOWN" THEN
176                     if FIELD(POSITION(0)+i,POSITION(1)+j+1) = 1 THEN
178                         BUMP = 1
180                      ENDIF
170                 ELSEIF DIR$ = "LEFT" THEN
176                     if FIELD(POSITION(0)+i-1,POSITION(1)+j) = 1 THEN
178                         BUMP = 1
180                      ENDIF
170                 ELSEIF DIR$ = "RIGHT" THEN
176                     if FIELD(POSITION(0)+i+1,POSITION(1)+j) = 1 THEN
178                         BUMP = 1
180                      ENDIF
170                 ELSEIF DIR$ = "RLEFT" THEN
176                     if FIELD(POSITION(0)+3-j,POSITION(1)+i) = 1 THEN
178                         BUMP = 1
180                      ENDIF
170                 ELSEIF DIR$ = "RRIGHT" THEN
176                     if FIELD(POSITION(0)+j,POSITION(1)+3-i) = 1 THEN
178                         BUMP = 1
180                      ENDIF
186                 ENDIF
188                 ENDIF
182             NEXT
184         NEXT
188 END FUNCTION

132 Sub ROTATE(DIR$) 
133     Local ROTATE(4,4)
134     HOPPER "CUT"
136     For k = 0 To 1
136         For j = 0 To 3
138             For i = 0 To 3
140                 If k = 0 Then
142                     IF DIR$ = "RLEFT" THEN
138                         ROTATE(3-j,i) = HOPPER(i,j)
140                     ELSEIF DIR$ = "RRIGHT"
138                         ROTATE(j,3-i) = HOPPER(i,j
140                     ENDIF
140                 Else
142                     HOPPER(i,j) = ROTATE(i,j)
144                 EndIf
140             Next
142         Next
144     Next
144     HOPPER "PASTE"
152 End Sub

168 Sub DROP
170     HOPPER "CUT"
172     IF BUMP("DOWN") = 0 THEN
188         POSITION(1) = POSITION(1) + 1
186     HOPPER "PASTE"
190     ELSEIF BUMP("DOWN") = 1 THEN
192         PETRIFY
194     ENDIF
196 END SUB     

194 SUB PETRIFY
192     FOR j = 0 TO 3 
194         FOR i = 0 TO 3
196             IF HOPPER(i,j) = 2 THEN
198                 HOPPER(i,j) = 1
200             ENDIF
202         NEXT
204     NEXT
206     HOPPER "PASTE"
208     ENTER
206 End Sub

168 Sub MOVE(DIR$)
170     HOPPER "CUT"
172         IF DIR$ = "LEFT" THEN
172              IF BUMP("LEFT") = 0 THEN
188                 POSITION(0) = POSITION(0) - 1
190              ENDIF
190         ELSEIF DIR$ = "RIGHT" THEN
192              IF BUMP("RIGHT") = 0 THEN
194                 POSITION(0) = POSITION(0) + 1
196              ENDIF
190         ENDIF
186         HOPPER "PASTE"
188 End Sub

190 Sub KEYPRESS
192     LOCAL KEY$ = InKey$
192     IF Key$ = "s" THEN
194         DROP
196     ELSEIF Key$ = "a" THEN
198         MOVE "LEFT"
200     ELSEIF Key$ = "d" THEN
202         MOVE "RIGHT"
204     ENDIF
206 END SUB

208 SUB GAME
210     INIT
212     DO
'232         KEYPRESS
'234         DROP
230         DRAW
232         PAUSE 100
240     LOOP UNTIL BLOCK() = 1
242     PRINT "TILT"
242 END SUB

244 GAME                                                     