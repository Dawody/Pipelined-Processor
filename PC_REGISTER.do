vsim work.pc_register
# End time: 11:17:52 on May 01,2018, Elapsed time: 2:50:38
# Errors: 0, Warnings: 1
# vsim work.pc_register 
# Start time: 11:17:52 on May 01,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading ieee.numeric_std(body)
# Loading work.pkg
# Loading work.pc_register(pc_register_arch)
add wave sim:/pc_register/*
force -freeze sim:/pc_register/CLK 0 0, 1 {50 ps} -r 100
force -freeze sim:/pc_register/RST 1 0
force -freeze sim:/pc_register/ENB 1 0
force -freeze sim:/pc_register/D 1111000011110000 0
run
# ** Warning: (vsim-3116) Problem reading symbols from linux-gate.so.1 : can not open ELF file.
run
force -freeze sim:/pc_register/RST 0 0
run
run
force -freeze sim:/pc_register/ENB 0 0
force -freeze sim:/pc_register/D 1111000011111111 0
run
force -freeze sim:/pc_register/ENB 1 0
run
force -freeze sim:/pc_register/D 1111111111111111 0
run


