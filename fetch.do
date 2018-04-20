vsim work.fetch
# End time: 19:20:48 on Apr 20,2018, Elapsed time: 0:10:18
# Errors: 0, Warnings: 1
# vsim work.fetch 
# Start time: 19:20:48 on Apr 20,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading ieee.numeric_std(body)
# Loading work.pkg
# Loading work.fetch(fetch_arch)
# Loading work.ir_ram(ir_ram_arch)
# Loading work.general_register(general_register_arch)
add wave sim:/fetch/*
force -freeze sim:/fetch/STALL 0 0
force -freeze sim:/fetch/INT 0 0
force -freeze sim:/fetch/FLU1 0 0
force -freeze sim:/fetch/FLU2 0 0
force -freeze sim:/fetch/RST 0 0
force -freeze sim:/fetch/ENB 1 0
force -freeze sim:/fetch/CLK 0 0, 1 {50 ps} -r 100
noforce sim:/fetch/IR
noforce sim:/fetch/PC
force -freeze sim:/fetch/ALUO 16#7 0
force -freeze sim:/fetch/MEMO 16#9 0
force -freeze sim:/fetch/M_1 16#11 0
mem load -i /home/dawod/ARCH/Pipelined-Processor/RAM.mem /fetch/RAM/MEMORY
