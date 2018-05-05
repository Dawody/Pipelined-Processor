Library IEEE;
use ieee.std_logic_1164.all;

Entity tri_state is
port (inp :in std_logic_vector(15 downto 0);
      en :in std_logic;
      oup: out std_logic_vector(15 downto 0));
end tri_state;

architecture Arch_tri of tri_state is
begin
oup<= inp when en='1'
else (others=>'Z');
end Arch_tri;
