LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY WB_stage IS
	PORT(
		ALUO1 	: in std_logic_vector(15 downto 0);
		B	: in std_logic_vector(15 downto 0);
		MEMO	: in std_logic_vector(15 downto 0);
		ALUO2	: in std_logic_vector(15 downto 0);
	
		OP_WB	: in std_logic_vector(4 downto 0);
		DATA1	:out std_logic_vector(15 downto 0);
		DATA2 	:out std_logic_vector(15 downto 0));
END ENTITY WB_stage;


ARCHITECTURE Arch_WB_stage OF WB_stage IS

------------------------------TRI STATE------------------------------
component tri_state is
port (inp :in std_logic_vector(15 downto 0);
      en :in std_logic;
      oup: out std_logic_vector(15 downto 0));
end component;

-------------------------------MUX3---------------------------------
component mux3_WB is
port(ALUO1,B,MEMO:in std_logic_vector(15 downto 0);
OP:in std_logic_vector(4 downto 0);
DATA1:out std_logic_vector(15 downto 0));
end component;

--------------------------------MUX2--------------------------------
component mux2_WB is
port(ALUO2,MEMO:in std_logic_vector(15 downto 0);
OP:in std_logic_vector(4 downto 0);
DATA2:out std_logic_vector(15 downto 0));
end component;

----------------------------SIGNALS AREA-----------------------
signal tr0_en,tr1_en,tr2_en,tr3_en,tr4_en:std_logic;
signal tr0_out,tr1_out,tr2_out,tr3_out,tr4_out:std_logic_vector(15 downto 0);

-----------------------------------------------------------------------
begin

tr1_en <='1' when  OP_WB(4 DOWNTO 0)="11010"
else '0';

tr2_en <='1' when OP_WB(4 downto 0)="10110"
else '0';

tr3_en <='1' when OP_WB(4 downto 0)="01011"
else '0';

tr0_en <='0' when OP_WB(4 downto 0)="11110"  OR OP_WB(4 downto 0)="11011" OR  OP_WB(4 downto 0)="00110"  OR OP_WB(4 downto 0)="00111" OR OP_WB(4 downto 0)="01000" OR OP_WB(4 downto 0)="01001" OR OP_WB(4 downto 0)="00000" 
else '1';



ts0:tri_state  port map(ALUO1 ,tr0_en,tr0_out);
ts1:tri_state  port map(B,'0',tr1_out);
ts2:tri_state  port map(MEMO,tr1_en,tr2_out);
ts3:tri_state  port map(ALUO2,tr2_en,tr3_out);
ts4:tri_state  port map(MEMO ,tr3_en,tr4_out);

mux3_WB_comp:mux3_WB port map (tr0_out,tr1_out,tr2_out,OP_WB,DATA1);
mux2_WB_comp:mux2_WB port map (tr3_out,tr4_out,OP_WB,DATA2);

END  Arch_WB_stage;