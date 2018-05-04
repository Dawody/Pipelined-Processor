LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; 

ENTITY EXEC IS
generic (n:integer:=16);
PORT( A,B: IN std_logic_vector(n-1 DOWNTO 0);
IEM2: IN std_logic_vector(3 DOWNTO 0);
flagi: IN std_logic_vector(3 DOWNTO 0);
sel: IN std_logic_vector (4 DOWNTO 0);
flago: OUT std_logic_vector(3 DOWNTO 0);
aluo1: OUT std_logic_vector(n-1 DOWNTO 0);
aluo2: OUT std_logic_vector(n-1 DOWNTO 0));
END EXEC;

ARCHITECTURE arch1 OF EXEC IS

COMPONENT ALU1 IS
generic (n:integer:=16);
PORT( A,B: IN std_logic_vector(n-1 DOWNTO 0);
IEM2: IN std_logic_vector(3 DOWNTO 0);
flagi: IN std_logic_vector(3 DOWNTO 0);
sel: IN std_logic_vector (4 DOWNTO 0);
flago: OUT std_logic_vector(3 DOWNTO 0);
aluo1: OUT std_logic_vector(n-1 DOWNTO 0);
aluo2: OUT std_logic_vector(n-1 DOWNTO 0));
END ALU1;

COMPONENT FORWARD IS
PORT( OPALU, OPMEM, OPWB: IN std_logic_vector(5 DOWNTO 0);
RSALU, RDALU, RSMEM, RDMEM, RSWB, RDWB: IN std_logic_vector(2 DOWNTO 0);
flags: OUT std_logic_vector(4 DOWNTO 0));
END FORWARD;

COMPONENT JUMP IS
PORT( tFLAGS: IN std_logic_vector(3 DOWNTO 0);
OPALU: IN std_logic_vector(4 DOWNTO 0);
flu: OUT std_logic);
END JUMP;

BEGIN



END arch1;