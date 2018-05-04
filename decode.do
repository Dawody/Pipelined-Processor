vsim work.decode
# End time: 18:11:56 on May 01,2018, Elapsed time: 0:06:58
# Errors: 0, Warnings: 9
# vsim work.decode 
# Start time: 18:11:56 on May 01,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading ieee.numeric_std(body)
# Loading work.pkg
# Loading work.decode(decode_arch)
# Loading work.register_file(register_file_arch)
add wave sim:/decode/*
force -freeze sim:/decode/IR 1001100000100000 0
force -freeze sim:/decode/IR_NEXT 16#4444 0
force -freeze sim:/decode/PC 16#1 0
force -freeze sim:/decode/R_SRC_ADRS_WB 010 0
force -freeze sim:/decode/R_DST_ADRS_WB 011 0
force -freeze sim:/decode/R_SRC_DATA_WB 16#fff1 0
force -freeze sim:/decode/R_DST_DATA_WB 16#fff2 0
force -freeze sim:/decode/FLAGS_DATA_WB 1100 0
force -freeze sim:/decode/FE_WB 1010 0
mem load -i /home/dawod/ARCH/Pipelined-Processor/REG.mem /decode/REG_FILE/REG_MEMORY
run
