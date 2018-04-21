library ieee;
use ieee.std_logic_1164.all;

entity mux2_WB is
port(ALUO2,MEMO:in std_logic_vector(15 downto 0);
OP:in std_logic_vector(4 downto 0);
DATA2:out std_logic_vector(15 downto 0));
end mux2_WB;

architecture Arch_mux2_WB of mux2_WB is
begin
DATA2<= MEMO when OP="01011"
else  ALUO2 when OP="10110"
else (others=>'Z');
end Arch_mux2_WB;


