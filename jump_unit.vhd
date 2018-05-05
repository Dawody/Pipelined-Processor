LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY JUMP_UNIT IS
	PORT(
		op_alu : IN std_logic_vector(4 DOWNTO 0);
		tflags : IN std_logic_vector(3 DOWNTO 0);
		FLU1 : OUT std_logic);
END ENTITY JUMP_UNIT;


ARCHITECTURE JUMP_UNIT_ARCH OF JUMP_UNIT IS
	BEGIN
	Process (ALL)
	BEGIN
	
	-- FLU1 <= '0';
		if op_alu = "00111" and tflags(0) = '1' then
			FLU1 <= '1';
		elsif op_alu = "01000" and tflags(1) = '1' then
			FLU1 <= '1';
		elsif op_alu = "01001" and tflags(2) = '1' then
			FLU1 <= '1';
		elsif op_alu = "00101" then
			FLU1 <= '1';
		else
			FLU1 <= '0';
		end if;
	end process;
END JUMP_UNIT_ARCH;



