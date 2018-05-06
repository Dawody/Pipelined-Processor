



vsim work.processor
# vsim work.processor 
# Start time: 17:24:21 on May 06,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading ieee.numeric_std(body)
# Loading work.pkg
# Loading work.processor(processor_arch)
# Loading work.fetch(fetch_arch)
# Loading work.ir_ram(ir_ram_arch)
# Loading work.pc_register(pc_register_arch)
# Loading work.decode_buffer(decode_buffer_arch)
# Loading work.decode(decode_arch)
# Loading work.register_file(register_file_arch)
# Loading work.execute_buffer(execute_buffer_arch)
# Loading work.exec(exec_arch)
# ** Warning: (vsim-3473) Component instance "JMP_UNIT : JUMP" is not bound.
#    Time: 0 ps  Iteration: 0  Instance: /processor/E File: /home/dawod/ARCH/Pipelined-Processor/Execution.vhd
# Loading work.forwarding_unit(forwarding_unit_arch)
# Loading work.alu1(struct1)
# Loading work.memory_buffer(memory_buffer_arch)
# Loading work.memory_stage(memory_stage_arch)
# Loading work.tri_state(arch_tri)
# Loading work.memory(arch_memory)
# Loading work.my_sp_unit(sp_unit_arch)
# Loading work.wb_buffer(wb_buffer_arch)
# Loading work.wb_stage(arch_wb_stage)
# Loading work.mux3_wb(arch_mux3_wb)
# Loading work.mux2_wb(arch_mux2_wb)
# ** Warning: (vsim-8684) No drivers exist on out port /processor/E/FLUSH, and its initial value is not used.
# Therefore, simulation behavior may occur that is not in compliance with
# the VHDL standard as the initial values come from the base signal /processor/FLU1_E_X.
add wave sim:/processor/*
force -freeze sim:/processor/INT 0 0
force -freeze sim:/processor/RESET 0 0
force -freeze sim:/processor/CLK 1 0, 0 {50 ps} -r 100
mem load -i /home/dawod/ARCH/Pipelined-Processor/IR_RAM.mem /processor/F/RAM/MEMORY
mem load -i /home/dawod/ARCH/Pipelined-Processor/REG.mem /processor/D/REG_FILE/REG_MEMORY
