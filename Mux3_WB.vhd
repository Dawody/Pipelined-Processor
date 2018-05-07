library ieee;
use ieee.std_logic_1164.all;

entity mux3_WB is
port(ALUO1,B,MEMO:in std_logic_vector(15 downto 0);
OP:in std_logic_vector(4 downto 0);
DATA1:out std_logic_vector(15 downto 0));
end mux3_WB;

architecture Arch_mux3_WB of mux3_WB is
begin
DATA1<= MEMO when OP="11010"
-----------------new for out op write back--------------
else (others=>'Z') when OP="10001"
-----------------------------------------------------------
else  ALUO1;
end Arch_mux3_WB;

