4     ;the program starts at address 4
100   ;ISR address

LDM R1,7  ;R1=7
LDM R2,6  ;R2=6
LDM R0,5  ;R0=5
LDM R4,10 ;R4=10
Add R2,R1 ;R1=13 N=0  C=0  Z=0
OR  R0,R2 ;R2=7  N=0  C=0  Z=0
Sub R0,R4 ;R4=-5 N=1  
Mov R1,R3 ;R3=13 
AND R2,R1 ;R1=5
SHL R1,2,R0 ;R0=52
MUL R2,R1 ;R1=35    [semester only]

;set value 5d at In Port
IN R0      ;R0=5
SETC       ;C=1
;set value 4d at In Port
IN R1      ;R1=4
;set value 7d at In Port
IN R3      ;R3=7
RLC R0     ;R0=11   C=0
NOT R1     ;R1=-5=1111111111111011b   N=1 Z=0
RRC R3     ;R3=3    C=1
CLRC
INC R0     ;R0=12
DEC R1     ;R1=-6 N=1 Z=0
;NEG R3     ;R3=-3   N=1 Z=0   [credit only]

.100
SETC
LDM R1,5
LDM R3,5
NOP
NOP
Sub R3,R1  ;R1=0 Z=1
RTI

