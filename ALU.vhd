LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; 

ENTITY ALU1 IS
generic (n:integer:=16);
PORT( A,B: IN std_logic_vector(n-1 DOWNTO 0);
IEM2: IN std_logic_vector(3 DOWNTO 0);
flagi: IN std_logic_vector(3 DOWNTO 0);
sel: IN std_logic_vector (4 DOWNTO 0);
flago: OUT std_logic_vector(3 DOWNTO 0);
aluo1: OUT std_logic_vector(n-1 DOWNTO 0);
aluo2: OUT std_logic_vector(n-1 DOWNTO 0));
END ALU1;

ARCHITECTURE struct1 OF ALU1 IS
BEGIN

process(sel,A,B,IEM2,flagi)
variable temparith : std_logic_vector(n DOWNTO 0);
variable tempmul : std_logic_vector((2*n)-1 DOWNTO 0);
variable tempflag : std_logic_vector(3 DOWNTO 0);
variable iem : integer := 0;
begin
	tempflag := flagi;

	IF (tempflag(3) = 'U' or tempflag(3) = 'X' or tempflag(3) = 'Z' or tempflag(3) = 'L' or tempflag(3) = '-') THEN tempflag(1) := '0';
	ELSE tempflag(3) := tempflag(3);
	END IF;

	IF (tempflag(2) = 'U' or tempflag(2) = 'X' or tempflag(2) = 'Z' or tempflag(2) = 'L' or tempflag(2) = '-') THEN tempflag(1) := '0';
	ELSE tempflag(2) := tempflag(2);
	END IF;

	IF (tempflag(1) = 'U' or tempflag(1) = 'X' or tempflag(1) = 'Z' or tempflag(1) = 'L' or tempflag(1) = '-') THEN tempflag(1) := '0';
	ELSE tempflag(1) := tempflag(1);
	END IF;

	IF (tempflag(0) = 'U' or tempflag(0) = 'X' or tempflag(0) = 'Z' or tempflag(0) = 'L' or tempflag(0) = '-') THEN tempflag(0) := '0';
	ELSE tempflag(0) := tempflag(0);
	END IF;
	-----------------------------------------------------------------------------------------------------------
	IF (sel = "00000") THEN -- nop
	temparith := ('0' & B) + 1;
	aluo1 <= temparith((n-1) DOWNTO 0); --////not sure
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "00001") THEN -- setc
	tempflag(2) := '1';
	aluo1 <= (others=>'0');
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	
	ELSIF (sel = "00010") THEN -- clrc
	tempflag(2) := '0';
	aluo1 <= (others=>'0');
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "00011") THEN -- ret
	temparith := ('0' & A) + 1;
	aluo1 <= temparith(n-1 DOWNTO 0);
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "00100") THEN -- rti
	temparith := ('0' & A) + 1;
	aluo1 <= temparith(n-1 DOWNTO 0);
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	-----------------------------------------------------------------------------------------------------------
	ELSIF (sel = "00101") THEN -- call dst
	temparith := ('0' & A) - 1;
	aluo1 <= temparith((n-1) DOWNTO 0);
	aluo2 <= (others=>'0');
	tempflag := tempflag; --not sure/////////////////////////////////
	
	ELSIF (sel = "00110") THEN -- jmp dst
	aluo1 <= B;                    ----------->>>not sure/////////////////////////////////
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "00111") THEN -- jz dst
	IF (tempflag(0) = '1') THEN temparith((n-1) DOWNTO 0) := B;
	ELSE temparith((n-1) DOWNTO 0) := (others=>'0');
	END IF;
	aluo1 <= temparith((n-1) DOWNTO 0);
	aluo2 <= (others=>'0');
	tempflag(0) := '0';
	tempflag := tempflag;
	
	ELSIF (sel = "01000") THEN -- jn dst
	IF (tempflag(1) = '1') THEN temparith((n-1) DOWNTO 0) := B;
	ELSE temparith((n-1) DOWNTO 0) := (others=>'0');
	END IF;
	aluo1 <= temparith((n-1) DOWNTO 0);
	aluo2 <= (others=>'0');
	tempflag(1) := '0';
	tempflag := tempflag;
	
	ELSIF (sel = "01001") THEN -- jc dst
	IF (tempflag(2) = '1') THEN temparith((n-1) DOWNTO 0) := B;
	ELSE temparith((n-1) DOWNTO 0) := (others=>'0');
	END IF;
	aluo1 <= temparith((n-1) DOWNTO 0);
	aluo2 <= (others=>'0');
	tempflag(2) := '0';
	tempflag := tempflag;
	
	ELSIF (sel = "01010") THEN -- push dst
	temparith := ('0' & A) - 1;
	aluo1 <= temparith((n-1) DOWNTO 0);
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "01011") THEN -- pop dst
	temparith := ('0' & A) + 1;
	aluo1 <= temparith(n-1 DOWNTO 0);
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "01100") THEN -- inc dst
	temparith := ('0' & A) + 1;
	aluo1 <= temparith(n-1 DOWNTO 0);
	aluo2 <= (others=>'0');
	IF (temparith((n-1) DOWNTO 0) = (temparith((n-1) DOWNTO 0)'range => '0')) THEN tempflag(0) := '1';
	ELSE tempflag(0) := '0';
	END IF;
	tempflag(1) := temparith(n-1);
	tempflag(2) := temparith(n);
	IF (A(n-1) = '0' and temparith(n-1) = '1') THEN tempflag(3) := '1';
	ELSE tempflag(3) := '0';
	END IF;
	
	ELSIF (sel = "01101") THEN -- dec dst
	temparith := ('0' & A) - 1;
	aluo1 <= temparith((n-1) DOWNTO 0);
	aluo2 <= (others=>'0');
	IF (temparith((n-1) DOWNTO 0) = (temparith((n-1) DOWNTO 0)'range => '0')) THEN tempflag(0) := '1';
	ELSE tempflag(0) := '0';
	END IF;
	tempflag(1) := temparith(n-1);
	tempflag(2) := temparith(n);   ----------->>>not sure/////////////////////////////////
	IF (A(n-1) = '1' and temparith(n-1) = '0') THEN tempflag(3) := '1';
	ELSE tempflag(3) := '0';
	END IF;
	
	ELSIF (sel = "01110") THEN -- rlc dst
	tempflag(2) := A(15);
	temparith(n) := '0';
	temparith(n-1 DOWNTO 0) := A(n-2 downto 0) & tempflag(2);
	aluo1 <= temparith(n-1 DOWNTO 0);
	aluo2 <= (others=>'0');
	IF (temparith((n-1) DOWNTO 0) = (temparith((n-1) DOWNTO 0)'range => '0')) THEN tempflag(0) := '1';
	ELSE tempflag(0) := '0';
	END IF;
	tempflag(1) := temparith(n-1);
	IF (A(n-1) != A(n-2)) THEN tempflag(3) := '1';
	ELSE tempflag(3) := '0';
	END IF;
	
	ELSIF (sel = "01111") THEN -- rrc dst
	tempflag(2) := A(0);
	temparith(n) := '0';
	temparith(n-1 DOWNTO 0) := tempflag(2) & A(n-1 downto 1);
	aluo1 <= temparith(n-1 DOWNTO 0);
	aluo2 <= (others=>'0');
	IF (temparith((n-1) DOWNTO 0) = (temparith((n-1) DOWNTO 0)'range => '0')) THEN tempflag(0) := '1';
	ELSE tempflag(0) := '0';
	END IF;
	tempflag(1) := temparith(n-1);
	IF (A(n-1) != A(0)) THEN tempflag(3) := '1';
	ELSE tempflag(3) := '0';
	END IF;
	
	ELSIF (sel = "10000") THEN -- not dst
	temparith(n) := '0';
	temparith((n-1) DOWNTO 0) := (not A);
	aluo1 <= temparith(n-1 DOWNTO 0);
	aluo2 <= (others=>'0');
	IF (temparith((n-1) DOWNTO 0) = (temparith((n-1) DOWNTO 0)'range => '0')) THEN tempflag(0) := '1';
	ELSE tempflag(0) := '0';
	END IF;
	tempflag(1) := temparith(n-1);
	tempflag := tempflag; --not mentioned in the document
	
	ELSIF (sel = "10001") THEN -- out dst
	aluo1 <= A;
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "10010") THEN -- in dst
	aluo1 <= A;
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	-----------------------------------------------------------------------------------------------------------
	ELSIF (sel = "10011") THEN -- mov src, dst
	aluo1 <= A;
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "10100") THEN -- add src, dst
	temparith := ('0' & A) + B;
	aluo1 <= temparith(n-1 DOWNTO 0);
	aluo2 <= (others=>'0');
	IF (temparith((n-1) DOWNTO 0) = (temparith((n-1) DOWNTO 0)'range => '0')) THEN tempflag(0) := '1';
	ELSE tempflag(0) := '0';
	END IF;
	tempflag(1) := temparith(n-1);
	tempflag(2) := temparith(n);
	IF (A(n-1) = B(n-1) and temparith(n-1) != A(n-1)) THEN tempflag(3) := '1';
	ELSE tempflag(3) := '0';
	END IF;
	
	ELSIF (sel = "10101") THEN -- sub src, dst
	temparith := ('0' & A) - B;
	aluo1 <= temparith((n-1) DOWNTO 0);
	aluo2 <= (others=>'0');
	IF (temparith((n-1) DOWNTO 0) = (temparith((n-1) DOWNTO 0)'range => '0')) THEN tempflag(0) := '1';
	ELSE tempflag(0) := '0';
	END IF;
	tempflag(1) := temparith(n-1);
	tempflag(2) := temparith(n);   ----------->>>not sure/////////////////////////////////
	IF (A(n-1) != B(n-1) and temparith(n-1) != A(n-1)) THEN tempflag(3) := '1';
	ELSE tempflag(3) := '0';
	END IF;
	
	ELSIF (sel = "10110") THEN -- mul src, dst 
	tempmul := A * B; 
	aluo1 <= temparith((2*n)-1 downto n);
	aluo2 <= temparith(n-1 downto 0);
	IF (tempmul((2*n)-1 downto n) = (tempmul((2*n)-1 downto n)'range => '0')) THEN tempflag(3 DOWNTO 2) := "00"; --not sure/////////////////////////////////
	ELSE tempflag(3 DOWNTO 2) := "11";
	END IF;
	tempflag := tempflag;
	
	ELSIF (sel = "10111") THEN -- and src, dst
	temparith(n) := '0';
	temparith((n-1) DOWNTO 0) := (A and B);
	aluo1 <= temparith(n-1 DOWNTO 0);
	aluo2 <= (others=>'0');
	IF (temparith((n-1) DOWNTO 0) = (temparith((n-1) DOWNTO 0)'range => '0')) THEN tempflag(0) := '1';
	ELSE tempflag(0) := '0';
	END IF;
	tempflag(1) := temparith(n-1);
	tempflag := tempflag; --not mentioned in the document
	
	ELSIF (sel = "11000") THEN -- or src, dst
	temparith(n) := '0';
	temparith((n-1) DOWNTO 0) := (A or B); 
	aluo1 <= temparith(n-1 DOWNTO 0);
	aluo2 <= (others=>'0');
	IF (temparith((n-1) DOWNTO 0) = (temparith((n-1) DOWNTO 0)'range => '0')) THEN tempflag(0) := '1';
	ELSE tempflag(0) := '0';
	END IF;
	tempflag(1) := temparith(n-1);
	tempflag := tempflag; --not mentioned in the document
	
	ELSIF (sel = "11001") THEN -- ldm dst, imm
	aluo1 <= A;
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "11010") THEN -- ldd dst, ea
	aluo1 <= A;
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "11011") THEN -- std src, ea
	aluo1 <= A;
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "11100") THEN -- shl src, imm, dst
	temparith := (others=>'0');
	iem := to_integer(unsigned(IEM2));
	temparith(n-1 DOWNTO iem-1) := A(((n-1) - iem) DOWNTO 0);
	aluo1 <=  temparith(n-1 DOWNTO 0);
	aluo2 <= (others=>'0');
	IF(temparith = (temparith'range => '0')) THEN tempflag(0) := '1';
	ELSE tempflag(0) := '0';
	END IF;
	tempflag(1) := temparith(n-1);
	tempflag(2) := A(n-iem);
	IF(A(n-iem) != A((n-1) - iem))) THEN tempflag(3) := '1';
	ELSE tempflag(3) := '0';
	END IF;
	
	ELSIF (sel = "11101") THEN -- shr src, imm, dst
	temparith := (others=>'0');
	iem := to_integer(unsigned(IEM2));
	temparith((n-iem-1) DOWNTO 0) := A(n-1 DOWNTO iem);
	aluo1 <=  temparith(n-1 DOWNTO 0);
	aluo2 <= (others=>'0');
	IF(temparith = (temparith'range => '0')) THEN tempflag(0) := '1';
	ELSE tempflag(0) := '0';
	END IF;
	tempflag(1) := temparith(n-1);
	tempflag(2) := A(iem-1);
	IF(temparith(n-1) != temparith(n-2)) THEN tempflag(3) := '1';
	ELSE tempflag(3) := '0';
	END IF;
	
	END IF;
	----------------------------------EEEEENNNNNDDDDD-------------------------------------------------------------
	flago <= tempflag;
	
end process;

END struct1;