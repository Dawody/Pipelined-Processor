LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;


PACKAGE PKG IS


------------------------------CONSTANTS-----------------------
CONSTANT HALF_CYCLE	: TIME := 50 PS;
CONSTANT IR_SIZE	: INTEGER :=16;
CONSTANT ADDRESS_SIZE	: INTEGER :=10;	--1KB MEMORY 
CONSTANT CELL_SIZE 	: INTEGER :=16;	--WORD ADDRESSABLE MEMORY






------------------------OPCODES-------------------------------------------
CONSTANT OPCODE_SIZE	:INTEGER :=5;
CONSTANT NOP	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="00000";
CONSTANT SETC	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="00001";
CONSTANT CLRC	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="00010";
CONSTANT RET	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="00011";
CONSTANT RTI	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="00100";

CONSTANT CALL	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="00101";
CONSTANT JMP	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="00110";
CONSTANT JZ	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="00111";
CONSTANT JN	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="01000";
CONSTANT JC	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="01001";
CONSTANT PUSH	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="01010";
CONSTANT POP	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="01011";
CONSTANT INC	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="01100";
CONSTANT DEC	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="01101";
CONSTANT RLC	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="01110";
CONSTANT RRC	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="01111";
CONSTANT NOTT	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="10000";
CONSTANT OUTT	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="10001";
CONSTANT INN	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="10010";

CONSTANT MOV	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="10011";
CONSTANT ADD	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="10100";
CONSTANT SUB	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="10101";
CONSTANT MUL	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="10110";
CONSTANT ANDD	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="10111";
CONSTANT ORR	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="11000";
CONSTANT LDM	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="11001";
CONSTANT LDD	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="11010";
CONSTANT STDD	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="11011";
CONSTANT SHL	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="11100";
CONSTANT SHR	:STD_LOGIC_VECTOR (OPCODE_SIZE-1 DOWNTO 0) :="11101";





END PKG;



