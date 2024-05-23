		-- control module (implements MIPS control unit)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
use work.aux_package.all;

ENTITY control IS

   PORT( 	
		Opcode 			: IN 	STD_LOGIC_VECTOR(5 DOWNTO 0);
		clock, reset	: IN 	STD_LOGIC;
		INTR			: IN	STD_LOGIC;
		
		RegDst 			: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		ALUSrc 			: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		MemtoReg 		: OUT 	STD_LOGIC;
		RegWrite 		: OUT 	STD_LOGIC;
		MemRead 		: OUT 	STD_LOGIC;
		MemWrite	 	: OUT 	STD_LOGIC;
		Branch 			: OUT 	STD_LOGIC;
		BranchNE 		: OUT 	STD_LOGIC;
		jump			: OUT 	STD_LOGIC;
		jumpAL			: OUT 	STD_LOGIC;
		ALUop 			: OUT 	STD_LOGIC_VECTOR(2 DOWNTO 0);
		INTA_out		: OUT	STD_LOGIC;
		INTR1_out		: OUT	STD_LOGIC;
		INTR2			: OUT	STD_LOGIC
	);

END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  R_format, Lw, Sw, mul, beq, bne, addi, andi, ori, xori, slti, lui, j, jal, INTR1: STD_LOGIC;

BEGIN   
	
	PROCESS
	BEGIN
	WAIT UNTIL (clock'EVENT and clock = '1');
		IF INTR = '1' then
			INTR1 <= '1';
		ELSE
			INTR1 <= '0';
		END IF;
	END PROCESS;
	
	PROCESS
	BEGIN
	WAIT UNTIL (clock'EVENT and clock = '1');
		IF INTR1 = '1' then
			INTR2 <= '1';
		ELSE
			INTR2 <= '0';
		END IF;
	END PROCESS;
	
	INTA_out <= INTR1;
	INTR1_out <= INTR1;
	
				-- Code to generate control signals using opcode bits
	R_format 	<=  '1'  WHEN  Opcode = "000000"  ELSE '0';
	Lw          <=  '1'  WHEN  Opcode = "100011"  ELSE '0';
 	Sw          <=  '1'  WHEN  Opcode = "101011"  ELSE '0';
	mul			<=	'1'	 WHEN  Opcode = "011100"  ELSE '0';
   	beq         <=  '1'  WHEN  Opcode = "000100"  ELSE '0';
	bne         <=  '1'  WHEN  Opcode = "000101"  ELSE '0';
   	addi        <=  '1'  WHEN  Opcode = "001000"  ELSE '0';
	andi        <=  '1'  WHEN  Opcode = "001100"  ELSE '0';
	ori         <=  '1'  WHEN  Opcode = "001101"  ELSE '0';
	xori        <=  '1'  WHEN  Opcode = "001110"  ELSE '0';
	lui         <=  '1'  WHEN  Opcode = "001111"  ELSE '0';
	slti        <=  '1'  WHEN  Opcode = "001010"  ELSE '0';
	j           <=  '1'  WHEN  Opcode = "000010"  ELSE '0';
	jal         <=  '1'  WHEN  Opcode = "000011"  ELSE '0';
	
  	RegWrite 	<=  (R_format OR Lw OR mul OR addi OR andi OR ori OR xori OR lui OR slti OR jal);
	RegDst(0)	<=  (R_format OR mul);
	RegDst(1) 	<=	jal;
 	ALUSrc(0)	<=  (Lw OR Sw OR addi OR andi OR ori OR xori OR slti);
	ALUSrc(1)	<=	lui;
	Branch      <=  beq;
	BranchNE	<=  bne;
	MemWrite 	<=  Sw ;
	MemtoReg 	<=  Lw ;
  	MemRead 	<=  Lw OR INTR1;
	ALUOp(0) 	<=  (andi OR ori OR slti OR mul);
	ALUOp(1) 	<=  (R_format OR beq OR bne OR ori OR mul);
	ALUOp(2) 	<=  (beq OR bne OR xori OR slti OR mul);
	jump		<=	(j OR jal);
	jumpAL		<=	jal;

   END behavior;


