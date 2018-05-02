LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.PKG.ALL;

ENTITY DECODE_BUFFER IS
	PORT (
		D_IR		: IN STD_LOGIC_VECTOR (DATA_SIZE-1 DOWNTO 0):=X"0000";
		D_IR_NEXT	: IN STD_LOGIC_VECTOR (DATA_SIZE-1 DOWNTO 0):=X"0000";
		D_PC		: IN STD_LOGIC_VECTOR (DATA_SIZE-1 DOWNTO 0):=X"0000";

		CLK,RST,ENB	: IN STD_LOGIC;

		Q_IR		: OUT STD_LOGIC_VECTOR (DATA_SIZE-1 DOWNTO 0):=X"0000";
		Q_IR_NEXT	: OUT STD_LOGIC_VECTOR (DATA_SIZE-1 DOWNTO 0):=X"0000";
		Q_PC		: OUT STD_LOGIC_VECTOR (DATA_SIZE-1 DOWNTO 0):=X"0000"

	);

END ENTITY DECODE_BUFFER;



ARCHITECTURE DECODE_BUFFER_ARCH OF DECODE_BUFFER IS

BEGIN
	PROCESS(CLK,RST,ENB)
		BEGIN
			--IT WILL RESET WHEN I RISE THE RST SIGNAL , IT WILL NOT WAIT TILL THE RISING EDGE.
			--IT WILL RESET ALTHOUGH ENABLE SIGNAL WAS OFF (RST IS POWERFUL THAN EBL)
			IF (RST='1') THEN
				Q_IR 		<= (OTHERS=>'0');
				Q_IR_NEXT	<= (OTHERS=>'0');
				Q_PC 		<= (OTHERS=>'0');

			ELSIF ((RISING_EDGE(CLK) AND ENB='1')OR(RISING_EDGE(ENB))) THEN
				Q_IR<=D_IR;
				Q_IR_NEXT<=D_IR_NEXT;
				Q_PC<=D_PC;
			END IF;



	END PROCESS;



END DECODE_BUFFER_ARCH;