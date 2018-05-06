Library IEEE;
use ieee.std_logic_1164.all;

Entity MY_SP_UNIT is
port (
	OP_MEM	: IN std_logic_vector(4 downto 0);
      	FLUSH2	:out std_logic);
end  MY_SP_UNIT;

architecture SP_UNIT_ARCH of MY_SP_UNIT is
begin
--FLUSH2 <= '1' when OP_MEM="00101"	--CALL --delete here after discussion
FLUSH2 <= '1' when OP_MEM="00011"	--RET
else '1' when OP_MEM="11110" 	--RESET	--maybe deleted or not
else '1' when OP_MEM="11111"	--INT	--maybe deleted or not
else '1' when OP_MEM="00100"	--RTI
else '0' ;
end SP_UNIT_ARCH;

