5
125

LDM R1,7  ;R1=7
LDM R2,6  ;R2=6
Add R2,R1 ;R1=13
LDM R0,9  ;R0=9
OR  R0,R2 ;R2=15         
OUT R2    ;OUT PORT =15

SETC    ;C=1
;set value 4d at In Port
IN R1   ;R1=4
RLC R0  ;R0=19   C=0
NOT R1  ;R1=-5   N=1 Z=0


.125
RTI