LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; 
USE WORK.PKG.ALL;

ENTITY EXEC IS
generic (n:integer:=16);
	PORT( 

		OPERATION_ALU	: IN STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0);
		OPERATION_MWM	: IN STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0);
		OPERATION_WB	: IN STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0);

		R_SRC_ADRS_ALU	: IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
		R_SRC_ADRS_MEM	: IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
		R_SRC_ADRS_WB	: IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);

		R_DST_ADRS_ALU	: IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
		R_DST_ADRS_MEM	: IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
		R_DST_ADRS_WB	: IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);

		FLAGS_ALU	: IN STD_LOGIC_VECTOR(FLAG-1 DOWNTO 0);
		FLAGS_MEM	: IN STD_LOGIC_VECTOR(FLAG-1 DOWNTO 0);
		FLAGS_WB	: IN STD_LOGIC_VECTOR(FLAG-1 DOWNTO 0);

----------------------

		R_SRC_DATA 	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		R_DST_DATA 	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);

		ALUO1_MEM 	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		ALUO2_MEM 	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);

		ALUO1_WB 	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		ALUO2_WB 	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);

		ALUO1_MEM 	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		MEMO_WB 	: IN std_logic_vector(DATA_SIZE-1 DOWNTO 0);


--------------------


		IMMD		: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		PC		: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);

		FLAG_OUT	:OUT STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);
		ALU_OUT_1	:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		ALU_OUT_2	:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		FLUSH		:OUT STD_LOGIC;
		STALL 		:OUT STD_LOGIC
	);
END EXEC;



ARCHITECTURE arch1 OF EXEC IS

---------------------------ALU UNIT----------------------------------------
COMPONENT ALU1 IS
generic (n:integer:=16);
	PORT( 
		A,B	: IN std_logic_vector(n-1 DOWNTO 0);
		IEM2	: IN std_logic_vector(3 DOWNTO 0);
		flagi	: IN std_logic_vector(3 DOWNTO 0);
		sel	: IN std_logic_vector (4 DOWNTO 0);
		flago	:OUT std_logic_vector(3 DOWNTO 0);
		aluo1	:OUT std_logic_vector(n-1 DOWNTO 0);
		aluo2	:OUT std_logic_vector(n-1 DOWNTO 0));
END ALU1;

----------------------FORWARDING UNIT---------------------------------------
COMPONENT forwarding_unit IS
	PORT( 
		op_alu 		: IN std_logic_vector(4 DOWNTO 0);
		op_mem 		: IN std_logic_vector(4 DOWNTO 0);
		op_wb 		: IN std_logic_vector(4 DOWNTO 0);

		rsrc_alu	: IN std_logic_vector(2 DOWNTO 0);
		rsrc_mem	: IN std_logic_vector(2 DOWNTO 0);
		rsrc_wb 	: IN std_logic_vector(2 DOWNTO 0);

		rdst_alu	: IN std_logic_vector(2 DOWNTO 0);
		rdst_mem	: IN std_logic_vector(2 DOWNTO 0);
		rdst_wb 	: IN std_logic_vector(2 DOWNTO 0);

		tflags_alu 	: IN std_logic_vector(3 DOWNTO 0);
		tflags_mem 	: IN std_logic_vector(3 DOWNTO 0);
		tflags_wb 	: IN std_logic_vector(3 DOWNTO 0);

		rsrc 		: IN std_logic_vector(15 DOWNTO 0);
		rdst 		: IN std_logic_vector(15 DOWNTO 0);

		aluo1_mem 	: IN std_logic_vector(15 DOWNTO 0);
		aluo2_mem 	: IN std_logic_vector(15 DOWNTO 0);

		aluo1_wb 	: IN std_logic_vector(15 DOWNTO 0);
		aluo2_wb 	: IN std_logic_vector(15 DOWNTO 0);

		memo_wb 	: IN std_logic_vector(15 DOWNTO 0);

		A 		: OUT std_logic_vector(15 DOWNTO 0);
		B 		: OUT std_logic_vector(15 DOWNTO 0);
		tflags 		: OUT std_logic_vector(3 DOWNTO 0);
		stall 		: OUT std_logic);


END forwarding_unit;

--------------------------JUMP UNIT-------------------------------------
COMPONENT JUMP IS
	PORT( 
		tFLAGS	: IN std_logic_vector(3 DOWNTO 0);
		OPALU	: IN std_logic_vector(4 DOWNTO 0);
		flu	:OUT std_logic);
END JUMP;

--------------------------SIGNALS AREA-----------------------------------

BEGIN

	JMP_UNIT: JUMP PORT MAP (tFLAGS=> FLAG_OUT , OPALU =>  , flu => );



END arch1;