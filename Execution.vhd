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
		OPERATION_MEM	: IN STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0);
		OPERATION_WB	: IN STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0);

		R_SRC_ADRS_ALU	: IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
		R_SRC_ADRS_MEM	: IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
		R_SRC_ADRS_WB	: IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);

		R_DST_ADRS_ALU	: IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
		R_DST_ADRS_MEM	: IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
		R_DST_ADRS_WB	: IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);

		FLAGS_ALU	: IN STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);
		FLAGS_MEM	: IN STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);
		FLAGS_WB	: IN STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);



		R_SRC_DATA 	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		R_DST_DATA 	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);

		ALUO1_MEM 	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		ALUO2_MEM 	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);

		ALUO1_WB 	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		ALUO2_WB 	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);

		MEMO_WB 	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);

		IR_DEC 		: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		PC		: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		IMMD_4BIT	: IN STD_LOGIC_VECTOR(3 DOWNTO 0);


		FLAG_OUT	:OUT STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);
		ALU_OUT_1	:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		ALU_OUT_2	:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		NEW_PC		:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		FLUSH		:OUT STD_LOGIC;
		STALL 		:OUT STD_LOGIC
	);
END EXEC;



ARCHITECTURE EXEC_ARCH OF EXEC IS

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
END COMPONENT;

----------------------FORWARDING UNIT---------------------------------------

COMPONENT FORWARDING_UNIT IS
	PORT(
		op_alu 		: IN std_logic_vector(4 DOWNTO 0);
		op_mem 		: IN std_logic_vector(4 DOWNTO 0);
		op_wb 		: IN std_logic_vector(4 DOWNTO 0);

		rsrc_alu 	: IN std_logic_vector(2 DOWNTO 0);
		rsrc_mem 	: IN std_logic_vector(2 DOWNTO 0);
		rsrc_wb 	: IN std_logic_vector(2 DOWNTO 0);

		rdst_alu 	: IN std_logic_vector(2 DOWNTO 0);
		rdst_mem 	: IN std_logic_vector(2 DOWNTO 0);
		rdst_wb 	: IN std_logic_vector(2 DOWNTO 0);

		tflags_alu	: IN std_logic_vector(3 DOWNTO 0);
		tflags_mem 	: IN std_logic_vector(3 DOWNTO 0);
		tflags_wb 	: IN std_logic_vector(3 DOWNTO 0);

		rsrc 		: IN std_logic_vector(15 DOWNTO 0);
		rdst 		: IN std_logic_vector(15 DOWNTO 0);

		aluo1_mem 	: IN std_logic_vector(15 DOWNTO 0);
		aluo2_mem 	: IN std_logic_vector(15 DOWNTO 0);

		aluo1_wb 	: IN std_logic_vector(15 DOWNTO 0);
		aluo2_wb 	: IN std_logic_vector(15 DOWNTO 0);

		memo_wb 	: IN std_logic_vector(15 DOWNTO 0);
		IR_dec 		: IN std_logic_vector(15 DOWNTO 0);

		A 		:OUT std_logic_vector(15 DOWNTO 0);
		B 		:OUT std_logic_vector(15 DOWNTO 0);
		tflags 		:OUT std_logic_vector(3 DOWNTO 0);
		stall 		:OUT std_logic);
END COMPONENT;





--------------------------JUMP UNIT-------------------------------------
COMPONENT JUMP IS
	PORT( 
		tFLAGS	: IN std_logic_vector(3 DOWNTO 0);
		OPALU	: IN std_logic_vector(4 DOWNTO 0);
		flu	:OUT std_logic);
END COMPONENT;

--------------------------SIGNALS AREA-----------------------------------

SIGNAL ALU_A	:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL ALU_B	:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL ALU_FLAG	:STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);
SIGNAL ALU_BBB	:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);	-- THIS SIGNAL TO SOLVE THE PROBLEM OF CALL OPERATION (DESTINITION SHOULD EQUAL PC NOT Rdst)-NOTICE THAT WE NEED TO SOLVE THE PROBLEM OF Rdst ALSO!

BEGIN

	JMP_UNIT : JUMP PORT MAP(
		tFLAGS	=> ALU_FLAG ,
		OPALU	=> OPERATION_ALU ,
		flu	=> FLUSH
	);


	FORWARDING : FORWARDING_UNIT PORT MAP
	(
		op_alu 		=> OPERATION_ALU ,
		op_mem 		=> OPERATION_MEM ,
		op_wb  		=> OPERATION_WB ,

		rsrc_alu 	=> R_SRC_ADRS_ALU , 
		rsrc_mem 	=> R_SRC_ADRS_MEM , 
		rsrc_wb  	=> R_SRC_ADRS_WB ,

		rdst_alu 	=> R_DST_ADRS_ALU , 
		rdst_mem 	=> R_DST_ADRS_MEM , 
		rdst_wb  	=> R_DST_ADRS_WB ,

		tflags_alu 	=> FLAGS_ALU ,
		tflags_mem 	=> FLAGS_MEM ,
		tflags_wb 	=> FLAGS_WB ,

		rsrc 		=> R_SRC_DATA ,
		rdst  		=> R_DST_DATA ,

		aluo1_mem 	=> ALUO1_MEM ,
		aluo2_mem 	=> ALUO2_MEM ,

		aluo1_wb  	=> ALUO1_WB ,
		aluo2_wb  	=> ALUO2_WB ,

		memo_wb  	=> MEMO_WB ,
		IR_dec  	=> IR_DEC ,


		A  		=> ALU_A ,
		B  		=> ALU_B ,
		tflags  	=> ALU_FLAG ,
		stall  		=> STALL 
	);

	ALU_BBB <= PC WHEN OPERATION_ALU = CALL
	ELSE	ALU_B;

	NEW_PC	<= ALU_B;

	ALU : ALU1 PORT MAP 
	( 
		A	=> ALU_A ,
		B	=> ALU_BBB ,
		IEM2	=> IMMD_4BIT ,
		flagi	=> ALU_FLAG ,
		sel	=> OPERATION_ALU ,
		flago	=> FLAG_OUT ,
		aluo1	=> ALU_OUT_1 ,
		aluo2	=> ALU_OUT_2 
	);

	

END EXEC_ARCH;