Library IEEE;
use ieee.std_logic_1164.all;

Entity MY_SP_UNIT is
port (OP_MEM: IN std_logic_vector(4 downto 0);
      FLUSH2:out std_logic);
end  MY_SP_UNIT;

architecture Arch_SP_UNIT of MY_SP_UNIT is
begin
FLUSH2 <= '1' when OP_MEM="00101" 
else '1' when OP_MEM="00011"
else '1' when OP_MEM="11110" 
else '1' when OP_MEM="11111"
else '1' when OP_MEM="00100"
else '0' ;
end Arch_SP_UNIT;

