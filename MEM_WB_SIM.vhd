LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY MEM_WB_stage IS
	PORT(clk : IN std_logic;
	    A :in std_logic_vector(15 downto 0);
	    B:in std_logic_vector(15 downto 0);
		MEM:in std_logic_vector(1 downto 0);
	     ALUO1 :in std_logic_vector(15 downto 0); 
		ALUO2:in std_logic_vector(15 downto 0);
		OP_MEM_WB:in std_logic_vector(4 downto 0);
		SP_UNIT_OUT:OUT std_logic;
		DATA1:out std_logic_vector(15 downto 0);
		DATA2 :out std_logic_vector(15 downto 0));
END ENTITY MEM_WB_stage;

ARCHITECTURE Arch_MEM_WB_stage OF MEM_WB_stage IS

component WB_stage IS
	PORT(ALUO1 :in std_logic_vector(15 downto 0);
		B:in std_logic_vector(15 downto 0);
		MEMO:in std_logic_vector(15 downto 0);
		ALUO2:in std_logic_vector(15 downto 0);
		OP_WB:in std_logic_vector(4 downto 0);
		DATA1:out std_logic_vector(15 downto 0);
		DATA2 :out std_logic_vector(15 downto 0));
END component;


component Memory_stage IS
	PORT(
		clk : IN std_logic;
		A :in std_logic_vector(15 downto 0);
		B:in std_logic_vector(15 downto 0);
		MEM:in std_logic_vector(1 downto 0);
		OP_MEM:in std_logic_vector(4 downto 0);
		MEMO:out std_logic_vector(15 downto 0);
		FLUSH2:out std_logic);
END component;

component tri_state is
port (inp :in std_logic_vector(15 downto 0);
      en :in std_logic;
      oup: out std_logic_vector(15 downto 0));
end component;

signal tr0_en:std_logic;
signal tr0_out,MEM_OUT,tr2_out,tr3_out:std_logic_vector(15 downto 0);


begin

tr0_en <='1' when  MEM(1 DOWNTO 0)="10"
else '0';

ts0:tri_state  port map(MEM_OUT ,tr0_en,tr0_out);

MY_MEM:Memory_stage PORT map(clk,A,B,MEM,OP_MEM_WB,MEM_OUT,SP_UNIT_OUT);
MY_WB:WB_stage port map(ALUO1,B,tr0_out,ALUO2,OP_MEM_WB,DATA1,DATA2);

END  Arch_MEM_WB_stage;