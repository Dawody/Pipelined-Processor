vsim work.ir_ram
# vsim work.ir_ram 
# Start time: 08:18:29 on May 01,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading ieee.numeric_std(body)
# Loading work.pkg
# Loading work.ir_ram(ir_ram_arch)
add wave sim:/ir_ram/*
mem load -i /home/dawod/ARCH/Pipelined-Processor/IR_RAM.mem /ir_ram/MEMORY
force -freeze sim:/ir_ram/ADDRESS 0000000000 0
run
force -freeze sim:/ir_ram/ADDRESS 0000000001 0
run
force -freeze sim:/ir_ram/ADDRESS 0000000010 0
run
force -freeze sim:/ir_ram/ADDRESS 0000000011 0
run
force -freeze sim:/ir_ram/ADDRESS 0000000100 0
run
