LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY forwarding_unit IS
	PORT(
		op_alu : IN std_logic_vector(4 DOWNTO 0);
		op_mem : IN std_logic_vector(4 DOWNTO 0);
		op_wb : IN std_logic_vector(4 DOWNTO 0);
		rsrc_alu : IN std_logic_vector(2 DOWNTO 0);
		rsrc_mem : IN std_logic_vector(2 DOWNTO 0);
		rsrc_wb : IN std_logic_vector(2 DOWNTO 0);
		rdst_alu : IN std_logic_vector(2 DOWNTO 0);
		rdst_mem : IN std_logic_vector(2 DOWNTO 0);
		rdst_wb : IN std_logic_vector(2 DOWNTO 0);
		tflags_alu : IN std_logic_vector(3 DOWNTO 0);
		tflags_mem : IN std_logic_vector(3 DOWNTO 0);
		tflags_wb : IN std_logic_vector(3 DOWNTO 0);
		rsrc : IN std_logic_vector(15 DOWNTO 0);
		rdst : IN std_logic_vector(15 DOWNTO 0);
		aluo1_mem : IN std_logic_vector(15 DOWNTO 0);
		aluo2_mem : IN std_logic_vector(15 DOWNTO 0);
		aluo1_wb : IN std_logic_vector(15 DOWNTO 0);
		aluo2_wb : IN std_logic_vector(15 DOWNTO 0);
		memo_wb : IN std_logic_vector(15 DOWNTO 0);
		A : OUT std_logic_vector(15 DOWNTO 0);
		B : OUT std_logic_vector(15 DOWNTO 0);
		tflags : OUT std_logic_vector(3 DOWNTO 0);
		stall : OUT std_logic);
END ENTITY forwarding_unit;


ARCHITECTURE arch1 OF forwarding_unit IS
	BEGIN
	Process (ALL)
	BEGIN
	stall <= '0';
	
	
	if (op_alu >= "10011" and op_alu <= "11000") or (op_alu >= "00011" and op_alu <= "00101") or op_alu = "01010" or op_alu = "01011" or op_alu = "11111" then
		if rsrc_alu = rdst_mem and op_mem >= "01100" and op_alu <= "11101" and op_alu /= "10001" and op_alu /= "11011" and op_mem /= "11010" then
			A <= aluo1_mem;
		elsif rsrc_alu = rdst_mem and (op_mem = "01011" or op_mem = "11010") then
			stall <= '1';
		elsif rsrc_alu = rsrc_mem then 
			if op_mem = "00011" or op_mem = "00100" or op_mem = "00101" or op_mem = "01010" or op_mem = "01011" or op_mem = "11111" then
				A <= aluo1_mem;
			elsif op_mem = "10110" then
				A <= aluo2_mem;
			end if;
		elsif rsrc_alu = rdst_wb and op_wb >= "01100" and op_wb <= "11101" and op_wb /= "10001" and op_wb /= "11011" and op_mem /= "11010" and op_mem /= "01011" then
			A <= aluo1_wb;
		elsif rsrc_alu = rdst_mem and (op_wb = "01011" or op_wb = "11010") then
			A <= memo_wb;
		elsif rsrc_alu = rsrc_wb then 
			if op_wb = "00011" or op_wb = "00100" or op_wb = "00101" or op_wb = "01010" or op_wb = "01011" or op_wb = "11111" then
				A <= aluo1_wb;
			elsif op_wb = "10110" then
				A <= aluo2_wb;
			end if;
		else
			A <= rsrc;
		end if;
	end if;
	
	
	if op_alu >= "00101" and op_alu <= "11101" and op_alu /= "11001" and op_alu /= "11010" and op_alu /= "10011" and op_alu /= "10010" and op_alu /= "01011" then
		if rdst_alu = rdst_mem and op_mem >= "01100" and op_mem <= "11101" and op_mem /= "10001" and op_mem /= "11011" and op_mem /= "11010" and op_mem /= "01011" then
			B <= aluo1_mem;
		elsif rdst_alu = rdst_mem and (op_mem = "01011" or op_mem = "11010") then
			stall <= '1';
		elsif rdst_alu = rsrc_mem then 
			if op_mem = "00011" or op_mem = "00100" or op_mem = "00101" or op_mem = "01010" or op_mem = "01011" or op_mem = "11111" then
				B <= aluo1_mem;
			elsif op_mem = "10110" then
				B <= aluo2_mem;
			end if;
		elsif rdst_alu = rdst_wb and op_wb >= "01100" and op_wb <= "11101" and op_wb /= "10001" and op_wb /= "11011" and op_mem /= "11010" and op_mem /= "01011" then
			B <= aluo1_wb;
		elsif rdst_alu = rdst_mem and (op_wb = "01011" or op_wb = "11010") then
			B <= memo_wb;
		elsif rdst_alu = rsrc_wb then 
			if op_wb = "00011" or op_wb = "00100" or op_wb = "00101" or op_wb = "01010" or op_wb = "01011" or op_wb = "11111" then
				B <= aluo1_wb;
			elsif op_wb = "10110" then
				B <= aluo2_wb;
			end if;
		else
			B <= rsrc;
		end if;
	end if;
	
	
	
	if (op_mem >= "00010" and op_mem <= "00011") or (op_mem >= "00111" and op_mem <= "01001") or (op_mem >= "01100" and op_mem <= "10000") or (op_mem >= "10100" and op_mem <= "11000")   or (op_mem >= "11100" and op_mem <= "11101") then
		tflags <= tflags_mem;
	elsif op_alu = "00100" then
		stall <= '1';
	elsif (op_wb >= "00010" and op_wb <= "00011") or (op_wb >= "00111" and op_wb <= "01001") or (op_wb >= "01100" and op_wb <= "10000") or (op_wb >= "10100" and op_wb <= "11000")   or (op_wb >= "11100" and op_wb <= "11101") or op_wb = "00100" then
		tflags <= tflags_wb;
	else
		tflags <= tflags_alu;
	end if;


	

	
	
	
	
	
	
	
	
	
	end process;
			-- if op_mem >= "01100" and op_alu <= "11101" and op_alu /= "10001" and op_alu /= "11011" then
			
	
	
		
		
		
END arch1;

