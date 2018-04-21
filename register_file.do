vsim work.register_file
# End time: 10:01:16 on Apr 21,2018, Elapsed time: 0:09:07
# Errors: 2, Warnings: 0
# vsim work.register_file 
# Start time: 10:01:16 on Apr 21,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading ieee.numeric_std(body)
# Loading work.pkg
# Loading work.register_file(register_file_arch)
add wave sim:/register_file/*
noforce sim:/register_file/R_SRC_DATA
noforce sim:/register_file/R_DST_DATA
noforce sim:/register_file/FLAGS_DATA
#mem load -i /home/dawod/ARCH/Pipelined-Processor/REG.mem /register_file/REG_MEMORY
force -freeze sim:/register_file/R_SRC_ADRS 000 0
force -freeze sim:/register_file/R_DST_ADRS 001 0
force -freeze sim:/register_file/R_SRC_ADRS_WB 001 0
force -freeze sim:/register_file/R_DST_ADRS_WB 010 0
force -freeze sim:/register_file/R_SRC_DATA_WB 0000001111111111 0
force -freeze sim:/register_file/R_DST_DATA_WB 1111110000000000 0
force -freeze sim:/register_file/FLAGS_DATA 1001 0


