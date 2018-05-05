LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Memory_stage IS
	PORT(
--ADD IT TO PORT MAP		clk 	: IN std_logic;
		A 	: in std_logic_vector(15 downto 0);
		B	: in std_logic_vector(15 downto 0);
		MEM	: in std_logic_vector(1 downto 0);
		OP_MEM	: in std_logic_vector(4 downto 0);
		MEMO	:out std_logic_vector(15 downto 0);
		FLUSH2	:out std_logic);
END ENTITY Memory_stage;

ARCHITECTURE Memory_stage_ARCH OF Memory_stage IS

-----------------------------MEMORY--------------------------------
component Memory IS
	PORT(
--ADD IT TO PORT MAP		clk : IN std_logic;
		MEM  : IN std_logic_vector(1 DOWNTO 0);
		A : IN  std_logic_vector(15 DOWNTO 0);
		B  : IN  std_logic_vector(15 DOWNTO 0);
		MEMO : OUT std_logic_vector(15 DOWNTO 0));
END component;

------------------------------TRI SATTE-----------------------------------
component tri_state is
port (inp :in std_logic_vector(15 downto 0);
      en :in std_logic;
      oup: out std_logic_vector(15 downto 0));
end component;

------------------------------------SP UNIT----------------------------------
component MY_SP_UNIT is
port (OP_MEM: IN std_logic_vector(4 downto 0);
      FLUSH2:out std_logic);
end component;

-----------------------------------SIGNALS AAREA------------------------
signal tr0_en,tr1_en:std_logic;
signal tr0_out,tr1_out,memout:std_logic_vector(15 downto 0);

--------------------------------------------------------------------
begin

tr0_en <='1' when MEM(1 DOWNTO 0)="01" OR MEM(1 DOWNTO 0)="10"
else '0';

tr1_en <='1' when MEM(1 DOWNTO 0)="01"
else '0';

ts0:tri_state  port map(A ,tr0_en,tr0_out);
ts1:tri_state  port map(B,tr1_en,tr1_out);

my_memory:Memory port map(MEM,tr0_out,tr1_out,MEMO);

my_sp_unit_comp:MY_SP_UNIT port map(OP_MEM(4 DOWNTO 0),FLUSH2);

END Memory_stage_ARCH;