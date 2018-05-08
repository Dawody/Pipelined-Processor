3
125

LDM R0,3  ; # of occurance of loop
LDM R1,5  ; R1=5
LDM R2,12 ; R2=12
LDM R3,8  ; R3=8
LDM R4,20 ; R4=20
Add R1,R1 ; 
DEC R0
JZ  R2
JMP R3
call R4   
LDM R5,22
Jmp R5
Nop
Nop
Nop
Nop
Nop
DEC R1  
RET


.125
RTI
