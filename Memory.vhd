LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Memory IS
	PORT(
--		clk 	: IN std_logic;
		MEM  	: IN std_logic_vector(1 DOWNTO 0);
		A 	: IN std_logic_vector(15 DOWNTO 0);
		B  	: IN std_logic_vector(15 DOWNTO 0);
		MEMO 	:OUT std_logic_vector(15 DOWNTO 0);
		M_1	:OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY Memory;

ARCHITECTURE Arch_Memory OF Memory IS

	TYPE Memory_type IS ARRAY(0 TO 1023) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL Memory : Memory_type ;
--:= (
--   0     => X"0064",
--   1     => X"0065",
--   2     => X"0066",
--   3     => X"0067",
--   4     => X"0068",
--  OTHERS => X"00FF"
--	
--	);



	BEGIN
		PROCESS(ALL) IS
			BEGIN
				IF MEM = "01" THEN
					Memory(to_integer(unsigned(A(9 DOWNTO 0)))) <= B;
				END IF;
		END PROCESS;

		MEMO <= Memory(to_integer(unsigned(A(9 DOWNTO 0))));
		M_1  <= Memory(1);
END Arch_Memory;
