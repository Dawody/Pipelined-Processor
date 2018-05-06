LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.PKG.ALL;



ENTITY DECODE IS 
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


END ENTITY DECODE;


ARCHITECTURE DECODE_ARCH OF DECODE IS

------------------------------COMPONENTS----------------------
COMPONENT REGISTER_FILE IS
	PORT (
		R_SRC_ADRS	:IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
		R_DST_ADRS	:IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);

		R_SRC_ADRS_WB	:IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
		R_DST_ADRS_WB	:IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
		R_SRC_DATA_WB	:IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		R_DST_DATA_WB	:IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		FLAGS_DATA_WB	:IN STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);
		FE_WB		:IN STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);
		clk		:in std_logic;

		R_SRC_DATA	:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		R_DST_DATA	:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		FLAGS_DATA	:OUT STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0)

	);
END COMPONENT;
------------------------------SIGNALS------------------------
SIGNAL OPCODE		 :STD_LOGIC_VECTOR(OPCODE_SIZE-1 DOWNTO 0);
SIGNAL R_SRC_DATA_SIGNAL :STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0); 
--------------------------------------------------------------------------------------
BEGIN


--------------------------DECODE STAGE OUTPUT-------------------------

	--IR(15 DOWNTO 11)
	OPCODE	<= IR(DATA_SIZE-1 DOWNTO 11);
	OPERATION <= OPCODE;

	--IR(10 DOWNTO 5)
	REG_FILE: REGISTER_FILE PORT MAP (R_SRC_ADRS => IR(10 DOWNTO 8) , R_DST_ADRS => IR(7 DOWNTO 5) , R_SRC_ADRS_WB => R_SRC_ADRS_WB , R_DST_ADRS_WB => R_DST_ADRS_WB , R_SRC_DATA_WB => R_SRC_DATA_WB , R_DST_DATA_WB => R_DST_DATA_WB , FLAGS_DATA_WB => FLAGS_DATA_WB , FE_WB => FE_WB , clk => clk, R_SRC_DATA => R_SRC_DATA_SIGNAL , R_DST_DATA => R_DST_DATA , FLAGS_DATA => FLAGS_DATA); --LINE FROM THE HELL!

	R_SRC_ADRS <= IR(10 DOWNTO 8);
	R_DST_ADRS <= IR(7 DOWNTO 5);
	R_SRC_DATA <=IR_NEXT WHEN OPCODE = LDM OR OPCODE = LDD OR OPCODE = STDD
	ELSE	     R_SRC_DATA_SIGNAL;

	--IR(4 DOWNTO 1) = IMMEDIATE VALUE
	IMMD	<= IR(4 DOWNTO 1);

	--MEMORY(READ/WRITE)
	MEM_R_W <=	"10"	WHEN OPCODE = RET OR OPCODE = RTI OR OPCODE = POP OR OPCODE = LDD
	ELSE		"01"	WHEN OPCODE = CALL OR OPCODE = PUSH OR OPCODE = STDD OR OPCODE = INTR
	ELSE		"00";

	--FLAGS ENABLE SIGNALS
	FE(0) <= '1'	WHEN	OPCODE = RESET OR OPCODE = RTI OR OPCODE = SHLL OR OPCODE = SHRR OR OPCODE =  ADD OR OPCODE = SUBB OR OPCODE = MUL OR OPCODE = INC OR OPCODE = DEC OR OPCODE = ANDD OR OPCODE = ORR OR OPCODE = NOTT OR OPCODE = JZ;	--ZERO FLAG
	FE(1) <= '1'	WHEN	OPCODE = RESET OR OPCODE = RTI OR OPCODE = SHLL OR OPCODE = SHRR OR OPCODE =  ADD OR OPCODE = SUBB OR OPCODE = MUL OR OPCODE = INC OR OPCODE = DEC OR OPCODE = ANDD OR OPCODE = ORR OR OPCODE = NOTT OR OPCODE = JN;	--NEGATIVE FLAG	
	FE(2) <= '1'	WHEN	OPCODE = RESET OR OPCODE = RTI OR OPCODE = SHLL OR OPCODE = SHRR OR OPCODE =  ADD OR OPCODE = SUBB OR OPCODE = MUL OR OPCODE = INC OR OPCODE = DEC OR OPCODE = JC OR OPCODE = SETC OR OPCODE = CLRC OR OPCODE = RLC OR OPCODE = RRC;	--CARRY FLAG
	FE(3) <= '1'	WHEN	OPCODE = RESET OR OPCODE = RTI OR OPCODE = SHLL OR OPCODE = SHRR OR OPCODE =  ADD OR OPCODE = SUBB OR OPCODE = MUL OR OPCODE = INC OR OPCODE = DEC;	--OVER FLOW FLAG


--------------------------------------------------------

	SKIP_IR	<= '1'	WHEN OPCODE = LDM OR OPCODE = LDD OR OPCODE = STDD
	ELSE	   '0';
	
	

END DECODE_ARCH;