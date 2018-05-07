LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.PKG.ALL;


ENTITY PROCESSOR IS

	PORT(
		INT		: IN STD_LOGIC;			--INTERRUPT THE PROCESSOR
		RESET		: IN STD_LOGIC;			-- RESET THE PROCESSOR NOT THE CLK
		CLK		: IN STD_LOGIC;			--GENERAL CLK FOR THE PROCESSOR
		INN		: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		OUTT		:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0)
	);
END ENTITY PROCESSOR;


ARCHITECTURE PROCESSOR_ARCH OF PROCESSOR IS


--------------------------------------------------------FETCH_STAGE--------------------------------------------------------
COMPONENT FETCH IS
	PORT(
		ALUO	: IN STD_LOGIC_VECTOR (DATA_SIZE-1 DOWNTO 0);	-- TO BACKWARD THE PC VALUE FROM THE EXECUTION STAGE
		MEMO	: IN STD_LOGIC_VECTOR (DATA_SIZE-1 DOWNTO 0);	-- TO BACKWARD THE PC VALUE FROM THE MEMORY STAGE
		M_1	: IN STD_LOGIC_VECTOR (DATA_SIZE-1 DOWNTO 0);	-- MEM[1] VALUE COMMING FROM THE MEMORY AND NEEDED FOR INTERRUPT CASE (NOTE THAT YOU CAN DO THE SAME IN RESET CASE TO AVOID FLUSHING TWO INSTRUCCTIONS AND WASTING TWO CLK CUCLES!**)		
		STALL	: IN STD_LOGIC;					-- ENABLE SIGNAL FOR THE PC REGISTER
		INT	: IN STD_LOGIC;					-- INTERRUPT SIGNAL NEEDS PC+1
		RESET	: IN STD_LOGIC;					-- RESET THE PROCESSOR!
		FLU1	: IN STD_LOGIC;					-- FLUSH REQUEST COMMING FROM THE JUMP UNIT
		FLU2	: IN STD_LOGIC;					-- FLUSH REQUEST COMMING FROM THE STACK UNIT
		CLK	: IN STD_LOGIC;					-- CLK NEEDED FOR PC REGISTER
		SKIP_IR	: IN STD_LOGIC;					--THIS SIGNAL TO FETCH NEXT IR AS IMMEDIATE OR EFFECTIVE ADDRESS AND SKIP THE CORRESPONDING PC AND FETCH THE CORRECT IR BY INCREMENTING THE PC BY 2
	
		IR	: OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);	-- THE INSTRUCTION FORM THE MEMORY
		IR_NEXT	: OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);	--THE NEXT INSTRUCTION THAT MAY BE EFFECTIVE ADDRESS OR IMMEDIATE VALUE NEEDED FOR (LDM,LDD,STD) OPERATIONS	
		PC	: OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0)	-- THE CURRECT PC

	);
END COMPONENT;
--------------------------------------------------------DECODE_BUFFER--------------------------------------------------------
COMPONENT DECODE_BUFFER IS
	PORT (
		D_IR		: IN STD_LOGIC_VECTOR (DATA_SIZE-1 DOWNTO 0):=X"0000";
		D_IR_NEXT	: IN STD_LOGIC_VECTOR (DATA_SIZE-1 DOWNTO 0):=X"0000";
		D_PC		: IN STD_LOGIC_VECTOR (DATA_SIZE-1 DOWNTO 0):=X"0000";

		CLK,RST,ENB	: IN STD_LOGIC;

		Q_IR		: OUT STD_LOGIC_VECTOR (DATA_SIZE-1 DOWNTO 0):=X"0000";
		Q_IR_NEXT	: OUT STD_LOGIC_VECTOR (DATA_SIZE-1 DOWNTO 0):=X"0000";
		Q_PC		: OUT STD_LOGIC_VECTOR (DATA_SIZE-1 DOWNTO 0):=X"0000"

	);
END COMPONENT;
--------------------------------------------------------DECODE_STAGE--------------------------------------------------------
COMPONENT DECODE IS
	PORT(
		--DATA FROM FETCH STAGE
		IR	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);	-- THE INSTRUCTION FORM THE MEMORY
		IR_NEXT	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);	--THE NEXT INSTRUCTION THAT MAY BE EFFECTIVE ADDRESS OR IMMEDIATE VALUE NEEDED FOR (LDM,LDD,STD) OPERATIONS
		PC	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);	--THE VALUE OF (PC+1) FROM THE FETCH STAGE OR JUST (PC) IN INTERRUPT CASE ONLY

		
		--DATA FROM WRITE BACK STAGE
		R_SRC_ADRS_WB	:IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
		R_DST_ADRS_WB	:IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
		R_SRC_DATA_WB	:IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		R_DST_DATA_WB	:IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		FLAGS_DATA_WB	:IN STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);
		FE_WB		:IN STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);
		clk		:in std_logic;

		--DATA EXTRACTED FOR HE IR GOING TO EXECUTION STAGE
		OPERATION	:OUT STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0);
		R_SRC_DATA	:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		R_DST_DATA	:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		FLAGS_DATA	:OUT STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);
		R_SRC_ADRS	:OUT STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
		R_DST_ADRS	:OUT STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
		IMMD		:OUT STD_LOGIC_VECTOR(3 DOWNTO 0);		--IMMEDIATE 4BIT WORKS WITH SHIFT OPERATIONS ONLY
		MEM_R_W		:OUT STD_LOGIC_VECTOR(1 DOWNTO 0);		--MEMORY(READ/WRITE)
		FE		:OUT STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);	--FLAGS ENABLE(V-C-N-Z)
		
		--DATA EXTRACTED FROM THE IR GOING TO FETCH STAGE
		SKIP_IR		:OUT STD_LOGIC	--THIS SIGNAL TO FETCH NEXT IR AS IMMEDIATE OR EFFECTIVE ADDRESS AND SKIP THE CORRESPONDING PC AND FETCH THE CORRECT IR BY INCREMENTING THE PC BY 2

	);
END COMPONENT;
--------------------------------------------------------EXECUTE_BUFFER--------------------------------------------------------
COMPONENT EXECUTE_BUFFER IS
	PORT (

		D_OPERATION	: IN STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0):="00000";
		D_R_SRC_DATA	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";
		D_R_DST_DATA	: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";
		D_FLAGS_DATA	: IN STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0):=X"0";
		D_R_SRC_ADRS	: IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0):="000";
		D_R_DST_ADRS	: IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0):="000";
		D_IMMD		: IN STD_LOGIC_VECTOR(3 DOWNTO 0):=X"0";		--IMMEDIATE 4BIT WORKS WITH SHIFT OPERATIONS ONLY
		D_PC		: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		D_MEM_R_W	: IN STD_LOGIC_VECTOR(1 DOWNTO 0):="00";		--MEMORY(READ/WRITE)
		D_FE		: IN STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0):=X"0";	--FLAGS ENABLE(V-C-N-Z)
				
		CLK,RST,ENB	: IN STD_LOGIC;

		Q_OPERATION	:OUT STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0):="00000";
		Q_R_SRC_DATA	:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";
		Q_R_DST_DATA	:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";
		Q_FLAGS_DATA	:OUT STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0):=X"0";
		Q_R_SRC_ADRS	:OUT STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0):="000";
		Q_R_DST_ADRS	:OUT STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0):="000";
		Q_IMMD		:OUT STD_LOGIC_VECTOR(3 DOWNTO 0):=X"0";		--IMMEDIATE 4BIT WORKS WITH SHIFT OPERATIONS ONLY
		Q_PC		:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		Q_MEM_R_W	:OUT STD_LOGIC_VECTOR(1 DOWNTO 0):="00";		--MEMORY(READ/WRITE)
		Q_FE		:OUT STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0):=X"0"	--FLAGS ENABLE(V-C-N-Z)

	);
END COMPONENT;
---------------------------------------------------------EXECUTE_STAGE--------------------------------------------------------
COMPONENT EXEC IS
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
		A		:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		B		:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		NEW_PC		:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		FLUSH		:OUT STD_LOGIC;
		STALL 		:OUT STD_LOGIC
	);
END COMPONENT;

---------------------------------------------------------MEMORY_BUFFER--------------------------------------------------------
COMPONENT MEMORY_BUFFER IS
	PORT (
		D_ALUO1		: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";
		D_ALUO2		: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";
		D_MEM		: IN STD_LOGIC_VECTOR(1 DOWNTO 0):="00";		--MEMORY(READ/WRITE)
		D_R_SRC_ADRS	: IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0):="000";
		D_R_DST_ADRS	: IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0):="000";
		D_OPERATION	: IN STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0):="00000";
		D_FLAGS		: IN STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0):=X"0";
		D_FE		: IN STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0):=X"0";	--FLAGS ENABLE(V-C-N-Z)
		D_A		: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";
		D_B		: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";
		
		CLK,RST,ENB	: IN STD_LOGIC;

		Q_ALUO1		:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";
		Q_ALUO2		:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";
		Q_MEM		:OUT STD_LOGIC_VECTOR(1 DOWNTO 0):="00";		--MEMORY(READ/WRITE)
		Q_R_SRC_ADRS	:OUT STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0):="000";
		Q_R_DST_ADRS	:OUT STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0):="000";
		Q_OPERATION	:OUT STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0):="00000";		
		Q_FLAGS		:OUT STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0):=X"0";
		Q_FE		:OUT STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0):=X"0";	--FLAGS ENABLE(V-C-N-Z)
		Q_A		:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";
		Q_B		:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000"
	);
END COMPONENT;



---------------------------------------------------------MEMORY_STAGE--------------------------------------------------------

COMPONENT Memory_stage IS
	PORT(
--ADD IT TO PORT MAP		clk 	: IN std_logic;
	        Flags   	: in std_logic_vector(3 downto 0);
		A 		: in std_logic_vector(DATA_SIZE-1 DOWNTO 0);
		B		: in std_logic_vector(DATA_SIZE-1 DOWNTO 0);
		MEM		: in std_logic_vector(1 downto 0);
		OP_MEM		: in std_logic_vector(OPCODE_SIZE-1 DOWNTO 0);
		MEMO		:out std_logic_vector(DATA_SIZE-1 DOWNTO 0);
		M_1	:OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		Flags_out:out std_logic_vector(3 downto 0);
		FLUSH2		:out std_logic
	);
END COMPONENT;


--------------------------------------------------------WRITE_BACK_BUFFER--------------------------------------------------------
COMPONENT WB_BUFFER IS
	PORT (
		D_ALUO1		: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";
		D_ALUO2		: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";
		D_MEMO		: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";		--MEMORY(READ/WRITE)
		D_R_SRC_ADRS	: IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0):="000";
		D_R_DST_ADRS	: IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0):="000";
		D_OPERATION	: IN STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0):="00000";
		D_FLAGS		: IN STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0):=X"0";
		D_FE		: IN STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0):=X"0";	--FLAGS ENABLE(V-C-N-Z)
		D_A		: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";
		D_B		: IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";
		
		CLK,RST,ENB	: IN STD_LOGIC;

		Q_ALUO1		:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";
		Q_ALUO2		:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";
		Q_MEMO		:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";		--MEMORY(READ/WRITE)
		Q_R_SRC_ADRS	:OUT STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0):="000";
		Q_R_DST_ADRS	:OUT STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0):="000";
		Q_OPERATION	:OUT STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0):="00000";		
		Q_FLAGS		:OUT STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0):=X"0";
		Q_FE		:OUT STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0):=X"0";	--FLAGS ENABLE(V-C-N-Z)
		Q_A		:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000";
		Q_B		:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0):=X"0000"
	);
END COMPONENT;

---------------------------------------------------------WRITE_BACK_STAGE--------------------------------------------------------

COMPONENT WB_stage IS
	PORT(
		ALUO1 	: in std_logic_vector(15 downto 0);
		B	: in std_logic_vector(15 downto 0);
		MEMO	: in std_logic_vector(15 downto 0);
		ALUO2	: in std_logic_vector(15 downto 0);
	
		OP_WB	: in std_logic_vector(4 downto 0);
		OUT_op  :out std_logic_vector(15 downto 0);
		DATA1	:out std_logic_vector(15 downto 0);
		DATA2 	:out std_logic_vector(15 downto 0));
END COMPONENT;

------------------------------------------------------------------------------------------------------------------------------
---------------------------------------############****(((DESIGNER_MANUAL))))***############-----------------------
--SIGNAL IR_F_B  := SIGNAL IR THAT COME FROM FETCH STAGE AND GO TO BUFFER
--SIGNAL IR_B_D  := SIGNAL IR THAT COME FROM BUFFER AND GO TO DECODE STAGE
--F  := FETCH STAGE
--D  := DECODE STAGE
--E  := EXCUTE STAGE
--M  := MEMORY STAGE
--W  := WRITE BACK STAGE
--B  := BUFFERS THAT BETWEEN STAGES
--X  := THIS MEANS THAT THIS SIGNAL IS GOING TO MANY STAGES NOT SPECIFIC STAGE LIKE FLUSH AND STALL
--**JUST LOOK TO THE LAST TWO CHARACTERS ONLY!
-------------------------------

---------------------------------------------------------SIGNALS_AREA--------------------------------------------------------

SIGNAL ALUO_E_X		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL MEMO_M_X		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL M_1_M_F		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL FLU1_E_X		:STD_LOGIC;
SIGNAL FLU2_M_X		:STD_LOGIC;
SIGNAL STALL_E_X	:STD_LOGIC;
SIGNAL STALL_NOT_E_X	:STD_LOGIC;
SIGNAL SKIP_IR_D_F	:STD_LOGIC;
SIGNAL IR_F_B		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL IR_NEXT_F_B	:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL PC_F_B		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL FLUSH		:STD_LOGIC;
SIGNAL IR_B_D		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL IR_NEXT_B_D	:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL PC_B_D		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);

SIGNAL R_SRC_ADRS_WB_W_D:STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
SIGNAL R_DST_ADRS_WB_W_D:STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
SIGNAL R_SRC_DATA_WB_W_D:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL R_DST_DATA_WB_W_D:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL FLAGS_DATA_WB_W_D:STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);
SIGNAL FE_WB_W_D	:STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);

SIGNAL OPERATION_D_B	:STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0);
SIGNAL R_SRC_DATA_D_B	:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL R_DST_DATA_D_B	:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL FLAGS_DATA_D_B	:STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);
SIGNAL R_SRC_ADRS_D_B	:STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
SIGNAL R_DST_ADRS_D_B	:STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
SIGNAL IR_NEXT_D_B	:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL IMMD_D_B		:STD_LOGIC_VECTOR(3 DOWNTO 0);			--IMMEDIATE 4BIT WORKS WITH SHIFT OPERATIONS ONLY
SIGNAL MEM_R_W_D_B	:STD_LOGIC_VECTOR(1 DOWNTO 0);			--MEMORY(READ/WRITE)
SIGNAL FE_D_B		:STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);	--FLAGS ENABLE(V-C-N-Z)


SIGNAL OPERATION_B_E	:STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0);
SIGNAL R_SRC_DATA_B_E	:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL R_DST_DATA_B_E	:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL FLAGS_DATA_B_E	:STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);
SIGNAL R_SRC_ADRS_B_E	:STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
SIGNAL R_DST_ADRS_B_E	:STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
SIGNAL IMMD_B_E		:STD_LOGIC_VECTOR(3 DOWNTO 0);			--IMMEDIATE 4BIT WORKS WITH SHIFT OPERATIONS ONLY
SIGNAL PC_B_E		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL MEM_R_W_B_E	:STD_LOGIC_VECTOR(1 DOWNTO 0);			--MEMORY(READ/WRITE)
SIGNAL FE_B_E		:STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);	--FLAGS ENABLE(V-C-N-Z)
SIGNAL IR_NEXT_B_E	:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);


----------------------------------------------------------------------------------------------

--SIGNALS FOR EXECUTION STAGE INPUT IN ADDITION OF THE PREVIOUS SIGNALS


-------------------------MEMORY BUFFER--------------------------------------

SIGNAL ALUO1_E_B		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL ALUO2_E_B		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL MEM_R_W_E_B		:STD_LOGIC_VECTOR(1 DOWNTO 0);			--MEMORY(READ/WRITE)
SIGNAL R_SRC_ADRS_E_B		:STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
SIGNAL R_DST_ADRS_E_B		:STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
SIGNAL OPERATION_E_B		:STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0);
SIGNAL FLAGS_E_B		:STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);
SIGNAL FE_E_B			:STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);	--FLAGS ENABLE(V-C-N-Z)
SIGNAL A_E_B			:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL B_E_B			:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL NEW_PC_E_F		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);


SIGNAL ALUO1_B_M		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL ALUO2_B_M		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL MEM_R_W_B_M		:STD_LOGIC_VECTOR(1 DOWNTO 0);			--MEMORY(READ/WRITE)
SIGNAL R_SRC_ADRS_B_M		:STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
SIGNAL R_DST_ADRS_B_M		:STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
SIGNAL OPERATION_B_M		:STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0);
SIGNAL FLAGS_B_M		:STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);
SIGNAL FE_B_M			:STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);	--FLAGS ENABLE(V-C-N-Z)
SIGNAL A_B_M			:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL B_B_M			:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);

-------------------------WRITE BACK BUFFER---------------------------------

SIGNAL ALUO1_M_B		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL ALUO2_M_B		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
--I COMMENTD THE NEXT SIGNAL BECAUSE IT IS ALREADY DECLARED AS MEMO_M_X WITH THE SIGNALS OF FETCH STAGE
--SIGNAL MEMO_M_B			:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);	--MEMORY(READ/WRITE)
SIGNAL R_SRC_ADRS_M_B		:STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
SIGNAL R_DST_ADRS_M_B		:STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
SIGNAL OPERATION_M_B		:STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0);
SIGNAL FLAGS_M_B		:STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);
SIGNAL FE_M_B			:STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);	--FLAGS ENABLE(V-C-N-Z)
SIGNAL A_M_B			:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL B_M_B			:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);



SIGNAL ALUO1_B_W		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL ALUO2_B_W		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL MEMO_B_W			:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);	--MEMORY(READ/WRITE)
SIGNAL R_SRC_ADRS_B_W		:STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
SIGNAL R_DST_ADRS_B_W		:STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
SIGNAL OPERATION_B_W		:STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0);
SIGNAL FLAGS_B_W		:STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);
SIGNAL FE_B_W			:STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);	--FLAGS ENABLE(V-C-N-Z)
SIGNAL A_B_W			:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL B_B_W			:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);


-------------------------------------------

SIGNAL DATA1_W_D		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
SIGNAL DATA2_W_D 		:STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
--YOU MAY ADD THE SAME SIGNALS_B_W TO BE LIKE SIGNALS_W_D OR YOU MAY NOT!


-----------------------------------------------------------------------------------------------

BEGIN

--------------------------------------------------THIS PART MUST BE DELETED BEFORE SIMULATION--------------------------------


------------------------------------------------------------------------------------------------------------------------------
	
	FLUSH <= FLU1_E_X OR FLU2_M_X;
	STALL_NOT_E_X <= NOT STALL_E_X;


	F : FETCH PORT MAP (
		ALUO 	=> NEW_PC_E_F , 
		MEMO 	=> MEMO_M_X , 
		M_1 	=> M_1_M_F , 
		STALL 	=> STALL_E_X , 
		INT 	=> INT , 
		RESET 	=> RESET , 
		FLU1 	=> FLU1_E_X , 
		FLU2 	=> FLU2_M_X , 
		CLK 	=> CLK , 
		SKIP_IR	=> SKIP_IR_D_F , 
		IR 	=> IR_F_B , 
		IR_NEXT	=> IR_NEXT_F_B , 
		PC 	=> PC_F_B
	);





	D_BUF: DECODE_BUFFER PORT MAP (
		D_IR 		=> IR_F_B , 
		D_IR_NEXT	=> IR_NEXT_F_B , 
		D_PC 		=> PC_F_B , 
		CLK 		=> CLK , 
		RST 		=> FLUSH , 
		ENB 		=> STALL_NOT_E_X , 
		Q_IR 		=> IR_B_D , 
		Q_IR_NEXT 	=> IR_NEXT_B_D , 
		Q_PC 		=> PC_B_D 
	);


	D : DECODE PORT MAP (
		IR 		=> IR_B_D , 
		IR_NEXT 	=> IR_NEXT_B_D , 
		PC 		=> PC_B_D , 
		R_SRC_ADRS_WB 	=> R_SRC_ADRS_WB_W_D , 
		R_DST_ADRS_WB 	=> R_DST_ADRS_WB_W_D , 
		R_SRC_DATA_WB 	=> DATA2_W_D ,--R_SRC_DATA_WB_W_D , 
		R_DST_DATA_WB 	=> DATA1_W_D ,--R_DST_DATA_WB_W_D , 
		FLAGS_DATA_WB	=> FLAGS_DATA_WB_W_D , 
		FE_WB 		=> FE_WB_W_D , 
		clk		=> clk,
		OPERATION 	=> OPERATION_D_B , 
		R_SRC_DATA 	=> R_SRC_DATA_D_B , 
		R_DST_DATA 	=> R_DST_DATA_D_B , 
		FLAGS_DATA 	=> FLAGS_DATA_D_B , 
		R_SRC_ADRS 	=> R_SRC_ADRS_D_B , 
		R_DST_ADRS 	=> R_DST_ADRS_D_B , 
		IMMD 		=> IMMD_D_B , 
		MEM_R_W 	=> MEM_R_W_D_B , 
		FE 		=> FE_D_B , 
		SKIP_IR 	=> SKIP_IR_D_F 
	);

	E_BUF: EXECUTE_BUFFER PORT MAP (
		D_OPERATION 	=> OPERATION_D_B , 
		D_R_SRC_DATA 	=> R_SRC_DATA_D_B , 
		D_R_DST_DATA 	=> R_DST_DATA_D_B , 
		D_FLAGS_DATA 	=> FLAGS_DATA_D_B , 
		D_R_SRC_ADRS 	=> R_SRC_ADRS_D_B , 
		D_R_DST_ADRS	=> R_DST_ADRS_D_B , 
		D_IMMD 		=> IMMD_D_B , 
		D_PC 		=> PC_B_D , 		-- I DIDN'T USE THIS SIGNAL IN DECODE STAGE SO I TAKE IT DIRECTLY FROM THE DECODEBUFFER TO THE EXECUTE BUFFER
		D_MEM_R_W 	=> MEM_R_W_D_B , 
		D_FE 		=> FE_D_B , 
		CLK 		=> CLK , 
		RST 		=> FLU2_M_X , 
		ENB 		=> STALL_NOT_E_X , 
		Q_OPERATION 	=> OPERATION_B_E , 
		Q_R_SRC_DATA	=> R_SRC_DATA_B_E , 
		Q_R_DST_DATA 	=> R_DST_DATA_B_E , 
		Q_FLAGS_DATA 	=> FLAGS_DATA_B_E , 
		Q_R_SRC_ADRS 	=> R_SRC_ADRS_B_E , 
		Q_R_DST_ADRS 	=> R_DST_ADRS_B_E , 
		Q_IMMD 		=> IMMD_B_E , 
		Q_PC 		=> PC_B_E , 
		Q_MEM_R_W 	=> MEM_R_W_B_E , 
		Q_FE 		=> FE_B_E
	);

	E : EXEC PORT MAP
	( 
		OPERATION_ALU	=> OPERATION_B_E ,
		OPERATION_MEM	=> OPERATION_B_M ,
		OPERATION_WB	=> OPERATION_B_W ,

		R_SRC_ADRS_ALU	=> R_SRC_ADRS_B_E ,
		R_SRC_ADRS_MEM	=> R_SRC_ADRS_B_M ,
		R_SRC_ADRS_WB	=> R_SRC_ADRS_B_W ,

		R_DST_ADRS_ALU	=> R_DST_ADRS_B_E ,
		R_DST_ADRS_MEM	=> R_DST_ADRS_B_M ,
		R_DST_ADRS_WB	=> R_DST_ADRS_B_W ,

		FLAGS_ALU	=> FLAGS_DATA_B_E ,
		FLAGS_MEM	=> FLAGS_B_M ,
		FLAGS_WB	=> FLAGS_B_W ,



		R_SRC_DATA	=> R_SRC_DATA_B_E ,
		R_DST_DATA	=> R_DST_DATA_B_E ,

		ALUO1_MEM	=> ALUO1_B_M , 
		ALUO2_MEM	=> ALUO2_B_M ,

		ALUO1_WB	=> ALUO1_B_W ,
		ALUO2_WB	=> ALUO2_B_W ,

		MEMO_WB		=> MEMO_B_W , 

		IR_DEC		=> IR_NEXT_B_E ,
		PC		=> PC_B_E ,
		IMMD_4BIT	=> IMMD_B_E ,


		FLAG_OUT	=> FLAGS_E_B ,
		ALU_OUT_1	=> ALUO1_E_B ,
		ALU_OUT_2	=> ALUO2_E_B ,
		A		=> A_E_B ,
		B		=> B_E_B ,
		NEW_PC		=> NEW_PC_E_F ,
		FLUSH		=> FLU1_E_X ,
		STALL		=> STALL_E_X
	);


	M_BUF: MEMORY_BUFFER PORT MAP(
		D_ALUO1 	=> ALUO1_E_B , 
		D_ALUO2 	=> ALUO2_E_B  , 
		D_MEM 		=> MEM_R_W_E_B  , 
		D_R_SRC_ADRS	=> R_SRC_ADRS_E_B  , 
		D_R_DST_ADRS 	=> R_DST_ADRS_E_B  , 
		D_OPERATION 	=> OPERATION_E_B  , 
		D_FLAGS 	=> FLAGS_E_B  , 
		D_FE 		=> FE_E_B  , 
		D_A 		=> A_E_B  , 
		D_B 		=> B_E_B  , 
		CLK 		=> CLK , 
		RST 		=> '0' , 
		ENB 		=> '1' , 
		Q_ALUO1 	=> ALUO1_B_M , 
		Q_ALUO2 	=> ALUO2_B_M , 
		Q_MEM 		=> MEM_R_W_B_M , 
		Q_R_SRC_ADRS 	=> R_SRC_ADRS_B_M , 
		Q_R_DST_ADRS 	=> R_DST_ADRS_B_M , 
		Q_OPERATION 	=> OPERATION_B_M , 
		Q_FLAGS 	=> FLAGS_B_M , 
		Q_FE		=> FE_B_M , 
		Q_A 		=> A_B_M , 
		Q_B 		=> B_B_M 
	);




	M : Memory_stage PORT MAP(
        	Flags   => FLAGS_B_M,
		A 	=> A_B_M , 
		B 	=> B_B_M , 
		MEM 	=> MEM_R_W_B_M , 
		OP_MEM 	=> OPERATION_B_M , 
		MEMO 	=> MEMO_M_X ,
		M_1 	=> M_1_M_F ,
		Flags_out=>FLAGS_M_B ,
		FLUSH2 	=> FLU2_M_X
	);




	WB_BUF: WB_BUFFER PORT MAP(
		D_ALUO1 	=> ALUO1_M_B , 
		D_ALUO2 	=> ALUO2_M_B , 
		D_MEMO 		=> MEMO_M_X , 
		D_R_SRC_ADRS 	=> R_SRC_ADRS_M_B  , 
		D_R_DST_ADRS 	=> R_DST_ADRS_M_B  , 
		D_OPERATION 	=> OPERATION_M_B  , 
		D_FLAGS 	=> FLAGS_M_B  , 
		D_FE 		=> FE_M_B  , 
		D_A 		=> A_M_B  , 
		D_B 		=> B_M_B  , 
		CLK 		=> CLK , 
		RST 		=> '0' , 
		ENB 		=> '1' , 
		Q_ALUO1 	=> ALUO1_B_W , 
		Q_ALUO2 	=> ALUO2_B_W , 
		Q_MEMO 		=> MEMO_B_W , 
		Q_R_SRC_ADRS 	=> R_SRC_ADRS_B_W , 
		Q_R_DST_ADRS 	=> R_DST_ADRS_B_W , 
		Q_OPERATION 	=> OPERATION_B_W , 
		Q_FLAGS 	=> FLAGS_B_W , 
		Q_FE 		=> FE_B_W , 
		Q_A 		=> A_B_W , 
		Q_B 		=> B_B_W 
	);




	WB: WB_stage PORT MAP(
		ALUO1 	=> ALUO1_B_W ,	
		B 	=> B_B_W ,
		MEMO 	=> MEMO_B_W ,
		ALUO2 	=> ALUO2_B_W ,
		OP_WB	=> OPERATION_B_W ,
		OUT_op	=> OUTT ,
		DATA1	=> DATA1_W_D ,
		DATA2	=> DATA2_W_D
	);


	R_SRC_ADRS_WB_W_D <= R_SRC_ADRS_B_W;
	R_DST_ADRS_WB_W_D <= R_DST_ADRS_B_W;
	FLAGS_DATA_WB_W_D <= FLAGS_B_W;
	FE_WB_W_D 	  <= FE_B_W;
	

	R_SRC_ADRS_E_B	  <= R_SRC_ADRS_B_E;
	R_DST_ADRS_E_B    <= R_DST_ADRS_B_E;
	OPERATION_E_B     <= OPERATION_B_E;
	FE_E_B		  <= FE_B_E;
	MEM_R_W_E_B	  <= MEM_R_W_B_E;
	
	ALUO1_M_B 	  <= ALUO1_B_M ;
	ALUO2_M_B	  <= ALUO2_B_M ;
	R_SRC_ADRS_M_B	  <= R_SRC_ADRS_B_M ;
 	R_DST_ADRS_M_B	  <= R_DST_ADRS_B_M ;
-- 	FLAGS_M_B	  <= FLAGS_B_M ;
	FE_M_B	  	  <= FE_B_M ;
	A_M_B 		  <= A_B_M;
	B_M_B 		  <= B_B_M;
	OPERATION_M_B 	  <= OPERATION_B_M;

--------




END PROCESSOR_ARCH;