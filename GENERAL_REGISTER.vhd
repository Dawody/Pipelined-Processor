LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.PKG.ALL;

ENTITY GENERAL_REGISTER IS
	PORT (
		D		: IN STD_LOGIC_VECTOR (DATA_SIZE-1 DOWNTO 0):=X"0000";
		CLK,RST,ENB	: IN STD_LOGIC;
		Q 		: OUT STD_LOGIC_VECTOR (DATA_SIZE-1 DOWNTO 0):=X"0000"
	);

END ENTITY GENERAL_REGISTER;



ARCHITECTURE GENERAL_REGISTER_ARCH OF GENERAL_REGISTER IS

BEGIN
	PROCESS(CLK,RST,ENB)
		BEGIN
			--IT WILL RESET WHEN I RISE THE RST SIGNAL , IT WILL NOT WAIT TILL THE RISING EDGE.
			--IT WILL RESET ALTHOUGH ENABLE SIGNAL WAS OFF (RST IS POWERFUL THAN EBL)
			IF (RST='1') THEN
				Q <= (OTHERS=>'0');
			ELSIF ((RISING_EDGE(CLK) AND ENB='1')OR(RISING_EDGE(ENB))) THEN
				Q<=D;
			END IF;



	END PROCESS;



END GENERAL_REGISTER_ARCH;