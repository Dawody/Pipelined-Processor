5             ;	the program starts at address 5
100           ;ISR address

;data segment
10
20
30
40
50
60
70

MUL R4,R3
LDD R1,1022  ;R1=20
LDD R2,4 ;R2=30
ADD R2,R1 ;R1=50
STD R1,1022  ;M[4]=50
Push R2   ;M[1023]=30 Sp=1022 assume von Neumann arch
Push R1   ;M[1022]=50 Sp=1021
LDD R1,0  ;R1=5
LDD R2,1  ;R2=100
ADD R2,R1 ;R1=105
Pop R1    ;R1=50
pop R2    ;R2=30

.100
SETC
LDM R1,5
LDM R2,5
sub R1,R2
RTI


