LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.PKG.ALL;




ENTITY REGISTER_FILE IS
	PORT (
		R_SRC_ADRS	:IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
		R_DST_ADRS	:IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);

		R_SRC_ADRS_WB	:IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
		R_DST_ADRS_WB	:IN STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
		R_SRC_DATA_WB	:IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		R_DST_DATA_WB	:IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		FLAGS_DATA_WB	:IN STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);
		FE_WB		:IN STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0);

		R_SRC_DATA	:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		R_DST_DATA	:OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
		FLAGS_DATA	:OUT STD_LOGIC_VECTOR(FLAG_SIZE-1 DOWNTO 0)


		
	);
END ENTITY REGISTER_FILE;
		
ARCHITECTURE REGISTER_FILE_ARCH OF REGISTER_FILE IS

	TYPE RAM_TYPE IS ARRAY(0 TO 9) OF std_logic_vector(DATA_SIZE-1 DOWNTO 0);
	SIGNAL REG_MEMORY : RAM_TYPE ;
	
	BEGIN
		R_SRC_DATA <= REG_MEMORY(to_integer(unsigned(R_SRC_ADRS)));
		R_DST_DATA <= REG_MEMORY(to_integer(unsigned(R_DST_ADRS)));
		FLAGS_DATA <= REG_MEMORY(8)(FLAG_SIZE-1 DOWNTO 0);
		


--		REG_MEMORY(TO_INTEGER(UNSIGNED(R_SRC_ADRS_WB))) <= R_SRC_DATA_WB ;--when R_SRC_DATA_WB/="ZZZZZZZZZZZZZZZZ";
--		REG_MEMORY(TO_INTEGER(UNSIGNED(R_DST_ADRS_WB))) <= R_DST_DATA_WB ;--when R_DST_DATA_WB/="ZZZZZZZZZZZZZZZZ";
--		REG_MEMORY(8)(0)	<= FLAGS_DATA_WB(0) when FE_WB(0)='1'; --(Z FLAG)
--		REG_MEMORY(8)(1)	<= FLAGS_DATA_WB(1) when FE_WB(1)='1'; --(N FLAG)
--		REG_MEMORY(8)(2)	<= FLAGS_DATA_WB(2) when FE_WB(2)='1'; --(C FLAG)
--		REG_MEMORY(8)(3)	<= FLAGS_DATA_WB(3) when FE_WB(3)='1'; --(V FLAG)


	PROCESS(R_DST_DATA_WB , FLAGS_DATA_WB , R_SRC_DATA_WB , R_SRC_ADRS_WB , R_DST_ADRS_WB , FE_WB) IS
			BEGIN
				IF(R_SRC_DATA_WB/="ZZZZZZZZZZZZZZZZ")THEN
					REG_MEMORY(TO_INTEGER(UNSIGNED(R_SRC_ADRS_WB))) <= R_SRC_DATA_WB;
				END IF;
				IF(R_DST_DATA_WB/="ZZZZZZZZZZZZZZZZ")THEN
					REG_MEMORY(TO_INTEGER(UNSIGNED(R_DST_ADRS_WB))) <= R_DST_DATA_WB;
				END IF;
				IF(FE_WB(0)='1')THEN
					REG_MEMORY(8)(0)	<= FLAGS_DATA_WB(0); --(Z FLAG)
				END IF;
				IF(FE_WB(1)='1')THEN
					REG_MEMORY(8)(1)	<= FLAGS_DATA_WB(1); --(N FLAG)
				END IF;
				IF(FE_WB(2)='1')THEN
					REG_MEMORY(8)(2)	<= FLAGS_DATA_WB(2); --(C FLAG)
				END IF;
				IF(FE_WB(3)='1')THEN
					REG_MEMORY(8)(3)	<= FLAGS_DATA_WB(3); --(V FLAG)
				END IF;

		END PROCESS;




END REGISTER_FILE_ARCH;