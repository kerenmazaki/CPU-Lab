--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
use work.aux_package.all;

ENTITY  Execute IS

	PORT(
			Read_data_1 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Read_data_2 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Sign_extend 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALUOp 			: IN 	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
			ALUSrc 			: IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
			Zero 			: OUT	STD_LOGIC;
			ALU_Result 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Add_Result 		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			jr				: OUT	STD_LOGIC;
			PC_plus_4 		: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			sft16			: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			clock, reset	: IN 	STD_LOGIC
		);
			
END Execute;

ARCHITECTURE behavior OF Execute IS
SIGNAL Ainput, Binput 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL ALU_output_mux		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL Branch_Add 			: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
SIGNAL ALU_ctl				: STD_LOGIC_VECTOR( 3 DOWNTO 0 );
SIGNAL shift_res			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL shamt				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL Function_opcode 		: STD_LOGIC_VECTOR( 5 DOWNTO 0 );

	BEGIN

	shift: Shifter generic map (32, 5, 16) port map (dir => ALU_ctl(2), x => shamt, y => Binput, res => shift_res);  

						-- ALU input muxes
						
	shamt <= X"000000" & B"000" & Sign_extend(10 downto 6);
	
	Ainput <= Read_data_1;
									
	Binput <= Read_data_2 WHEN ( ALUSrc = "00" ) ELSE
			sft16 WHEN ( ALUSrc = "10" ) ELSE
			sign_extend;
						
						-- Generate ALU control bits
						
	ALU_ctl(0) <= '1' WHEN ((ALUop = "010" AND (Function_opcode = "100101" OR Function_opcode = "101010")) OR
							ALUop = "011" OR ALUop = "101" OR ALUop = "111") ELSE '0';
	ALU_ctl(1) <= '0' WHEN ((ALUop = "010" AND (Function_opcode = "100100" OR Function_opcode = "100101" OR
							Function_opcode = "000010")) OR ALUop = "001" OR ALUop = "011" OR ALUop = "111") ELSE '1';
	ALU_ctl(2) <= '1' WHEN ((ALUop = "010" AND (Function_opcode = "100010" OR Function_opcode = "100110" OR Function_opcode = "000010" OR
							Function_opcode = "101010")) OR ALUop = "110" OR ALUop = "100" OR ALUop = "101") ELSE '0'; 
	ALU_ctl(3) <= '1' WHEN ((ALUop = "010" AND (Function_opcode = "100110" OR Function_opcode = "000000")) OR
							ALUop = "100" OR ALUop = "111") ELSE '0'; 
	
	-- jr 
	jr <= '1' WHEN (ALUop = "010" AND Function_opcode = "0001000") ELSE '0';
	
	-- Generate Zero Flag
	Zero <= '1' WHEN ( ALU_output_mux(31 DOWNTO 0) = X"00000000" )
		ELSE '0';    
						-- Select ALU output        
	ALU_result <= ALU_output_mux( 31 DOWNTO 0 );
		
						-- Adder to compute Branch Address
	Branch_Add	<= PC_plus_4( 9 DOWNTO 2 ) +  Sign_extend( 7 DOWNTO 0 ) ;
	Add_result 	<= Branch_Add( 7 DOWNTO 0 );
	
	
	Function_opcode <= Sign_extend(5 DOWNTO 0);	


PROCESS ( ALU_ctl, Ainput, Binput, shift_res )
	variable mult_result: STD_LOGIC_VECTOR (63 downto 0);
	variable slt_result: STD_LOGIC_VECTOR (31 downto 0);
	

	
	BEGIN
					-- Select ALU operation
 	CASE ALU_ctl IS
						-- ALU performs AND
		WHEN "0000" 	=>	ALU_output_mux 	<= Ainput AND Binput; 
						-- ALU performs OR
     	WHEN "0001" 	=>	ALU_output_mux 	<= Ainput OR Binput;
						-- ALU performs Add
	 	WHEN "0010" 	=>	ALU_output_mux 	<= Ainput + Binput;
						-- ALU performs SRL
 	 	WHEN "0100" 	=>	ALU_output_mux 	<= shift_res;
						-- ALU performs ALUresult = SUB
 	 	WHEN "0110" 	=>	ALU_output_mux 	<= Ainput - Binput;
						-- ALU performs SLT
  	 	WHEN "0111" 	=>	slt_result 	:= Ainput - Binput;
							ALU_output_mux <= (31 downto 1 => '0') & slt_result(31);
						-- ALU performs MUL
		WHEN "1001"		=> mult_result := Ainput * Binput;
							ALU_output_mux <= mult_result(31 downto 0);
						-- ALU performs XOR
		WHEN "1110"		=> ALU_output_mux 	<= Ainput XOR Binput;
						-- ALU performs sll
		WHEN "1010"		=> ALU_output_mux 	<= shift_res;
		
		WHEN OTHERS	=>	ALU_output_mux 	<= X"00000000" ;
  	END CASE;
  END PROCESS;
END behavior;

