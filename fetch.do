vsim work.fetch
# vsim work.fetch 
# Start time: 13:11:19 on May 01,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading ieee.numeric_std(body)
# Loading work.pkg
# Loading work.fetch(fetch_arch)
# Loading work.ir_ram(ir_ram_arch)
# Loading work.pc_register(pc_register_arch)
add wave sim:/fetch/*
mem load -i /home/dawod/ARCH/Pipelined-Processor/IR_RAM.mem /fetch/RAM/MEMORY
force -freeze sim:/fetch/FLU1 0 0
force -freeze sim:/fetch/FLU2 0 0
force -freeze sim:/fetch/CLK 0 0, 1 {50 ps} -r 100
force -freeze sim:/fetch/SKIP_IR 0 0
force -freeze sim:/fetch/RESET 0 0  
# THIS VALUE IS NOT RESET THE REGISTER . IT IS RESET SIGNAL FOR ALL THE PROCESSOR
force -freeze sim:/fetch/INT 0 0
force -freeze sim:/fetch/STALL 0 0
force -freeze sim:/fetch/M_1 16#0065 0
force -freeze sim:/fetch/MEMO 16#0067 0
force -freeze sim:/fetch/ALUO 16#006a 0
# ORDINARY CASE
run
run
run
# ALUO CASE
force -freeze sim:/fetch/FLU1 1 0
run
force -freeze sim:/fetch/FLU1 0 0
run
force -freeze sim:/fetch/FLU2 1 0
run
force -freeze sim:/fetch/FLU2 0 0
run

