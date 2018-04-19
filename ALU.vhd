USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

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
	aluo1 <= B + 1; --////not sure
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "00001") THEN -- setc
	tempflag(2) := '1';
	aluo1 <= (others=>'0');
	aluo2 <= (others=>'0');
	
	
	ELSIF (sel = "00010") THEN -- clrc
	tempflag(2) := '0';
	aluo1 <= (others=>'0');
	aluo2 <= (others=>'0');
	
	ELSIF (sel = "00011") THEN -- ret
	aluo1 <= A + 1;
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "00100") THEN -- rti
	aluo1 <= A + 1;
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	-----------------------------------------------------------------------------------------------------------
	ELSIF (sel = "00101") THEN -- call dst
	aluo1 <= A - 1;
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "00110") THEN -- jmp dst
	aluo1 <= B;
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "00111") THEN -- jz dst
	aluo1 <= B;
	aluo2 <= (others=>'0');
	tempflag(0) := '0';
	tempflag := tempflag;
	
	ELSIF (sel = "01000") THEN -- jn dst
	aluo1 <= B;
	aluo2 <= (others=>'0');
	tempflag(1) := '0';
	tempflag := tempflag;
	
	ELSIF (sel = "01001") THEN -- jc dst
	aluo1 <= B;
	aluo2 <= (others=>'0');
	tempflag(2) := '0';
	tempflag := tempflag;
	
	ELSIF (sel = "01010") THEN -- push dst
	aluo1 <= A - 1;
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "01011") THEN -- pop dst
	aluo1 <= A + 1;
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "01100") THEN -- inc dst
	aluo1 <= A + 1;
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "01101") THEN -- dec dst
	aluo1 <= A - 1;
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "01110") THEN -- rlc dst
	tempflag(2) := A(15);
	aluo1 <= A(n-2 downto 0) & tempflag(2);
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "01111") THEN -- rrc dst
	tempflag(2) := A(0);
	aluo1 <= tempflag(2) & A(n-1 downto 1);
	aluo2 <= (others=>'0');
	tempflag := tempflag;
	
	ELSIF (sel = "10000") THEN -- not dst
	temparith := '0' & (not A);
	aluo1 <= temparith(n-1 DOWNTO 0);
	aluo2 <= (others=>'0');
	IF (temparith(n-1 DOWNTO 0) = (temparith(n-1 DOWNTO 0)'range => '0')) THEN tempflag(1 DOWNTO 0) := "01";
	ELSIF (temparith(n-1) = '1') THEN 
	tempflag(1 DOWNTO 0) := "10";
	ELSE tempflag(1 DOWNTO 0) := "00";
	tempflag := tempflag;
	END IF;
	
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
	aluo1 <= temparith(n-1 downto 0); 
	IF (temparith(n-1 DOWNTO 0) = (temparith(n-1 DOWNTO 0)'range => '0')) THEN tempflag(1 DOWNTO 0) := "01";
	ELSIF (temparith(n-1) = '1') THEN 
	tempflag(1 DOWNTO 0) := "10";
	ELSE tempflag(1 DOWNTO 0) := "00";
	END IF;
	
	ELSIF (sel = "10101") THEN -- sub src, dst
	temparith := ('0' & A) - B; 
	aluo1 <= temparith(n-1 downto 0); 
	IF (A = B) THEN tempflag(1 DOWNTO 0) := "01";
	ELSIF (temparith(n-1) = '1') THEN 
	tempflag(1 DOWNTO 0) := "10";
	ELSE tempflag(1 DOWNTO 0) := "00";
	END IF;
	
	ELSIF (sel = "10110") THEN -- mul src, dst 
	tempmul := A * B;
	aluo2 <= temparith(n-1 downto 0); 
	aluo1 <= temparith((2*n)-1 downto n);
	IF (A = (A'range => '0') OR B = (B'range => '0')) THEN tempflag(1 DOWNTO 0) := "01";
	ELSIF (tempmul((2*n)-1) = '1') THEN --//not sure
	tempflag(1 DOWNTO 0) := "10";
	ELSE tempflag(1 DOWNTO 0) := "00";
	END IF;
	
	ELSIF (sel = "10111") THEN -- and src, dst
	temparith := '0' & (A and B); 
	aluo1 <= temparith(n-1 DOWNTO 0);
	IF (A = (A'range => '0') OR B = (B'range => '0')) THEN tempflag(1 DOWNTO 0) := "01";
	ELSIF (temparith(n-1) = '1') THEN 
	tempflag(1 DOWNTO 0) := "10";
	ELSE tempflag(1 DOWNTO 0) := "00";
	END IF;
	
	ELSIF (sel = "11000") THEN -- or src, dst
	temparith := '0' & (A or B); 
	aluo1 <= temparith(n-1 DOWNTO 0);
	IF (A = (A'range => '0') AND B = (B'range => '0')) THEN tempflag(1 DOWNTO 0) := "01";
	ELSIF (temparith(n-1) = '1') THEN 
	tempflag(1 DOWNTO 0) := "10";
	ELSE tempflag(1 DOWNTO 0) := "00";
	END IF;
	
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
	aluo1 <= (A(((n-1) - IEM2) DOWNTO 0) & (others=>'0'));
	IF(A = (A'range => '0')) THEN tempflag(0) := '0';
	ELSE tempflag := tempflag;
	END IF;
	
	ELSIF (sel = "11101") THEN -- shr src, imm, dst
	aluo1 <= ((others=>'0') & A(n-1 DOWNTO IEM2));
	IF(A = (A'range => '0')) THEN tempflag(0) := '0';
	ELSE tempflag := tempflag;
	END IF;
	
	END IF;
	----------------------------------EEEEENNNNNDDDDD-------------------------------------------------------------
	flago <= tempflag;
	
end process;

END struct1;