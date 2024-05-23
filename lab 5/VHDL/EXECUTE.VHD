--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
use work.aux_package.all;

ENTITY  Execute IS
	PORT(	
		Read_data_1_ID 							: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Read_data_2_ID 							: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		write_register_address_1_ID				: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		write_register_address_0_ID				: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		Sign_extend_ID							: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		PC_plus_4_ID							: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		sft16_ID								: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		clock, reset							: IN 	STD_LOGIC;
		RegDst_ID 								: IN 	STD_LOGIC;
		ALUSrc_ID 								: IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		MemtoReg_ID			 					: IN 	STD_LOGIC;
		RegWrite_ID							 	: IN 	STD_LOGIC;
		MemRead_ID							 	: IN 	STD_LOGIC;
		MemWrite_ID 							: IN 	STD_LOGIC;
		ALUop_ID 								: IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
		stall									: IN	STD_LOGIC;
		read_register_1_address_ID				: IN	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		forward_A								: IN	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
		forward_B								: IN	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
		result_WB								: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		ALU_Result_MEM							: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Instruction_ID							: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );

		
		ALU_Result_EX 							: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		write_data_EX							: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		write_register_address_EX				: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		write_register_address_0_EX_hazard		: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		MemtoReg_EX 							: OUT 	STD_LOGIC;
		RegWrite_EX 							: OUT 	STD_LOGIC;
		MemRead_EX 								: OUT 	STD_LOGIC;
		MemWrite_EX			 					: OUT 	STD_LOGIC;
		Branch_EX 								: OUT 	STD_LOGIC;
		BranchNE_EX 							: OUT 	STD_LOGIC;
		Zero_EX									: OUT 	STD_LOGIC;
		read_register_1_address_EX				: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		Instruction_EX							: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Ainput_EX								: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Binput_EX								: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 )
		);
END Execute;

ARCHITECTURE behavior OF Execute IS
SIGNAL Ainput, Binput 				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL ALU_output_mux				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL ALU_ctl						: STD_LOGIC_VECTOR( 3 DOWNTO 0 );
SIGNAL shift_res					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL Sign_extend_EX				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL Read_data_2_EX				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL Read_data_1_EX				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL ALUSrc_EX					: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL sft16_EX						: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL ALUOp_EX						: STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL PC_plus_4_EX					: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
SIGNAL write_register_address_1_EX	: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
SIGNAL write_register_address_0_EX	: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
SIGNAL RegDst_EX					: STD_LOGIC;
SIGNAL Function_opcode				: STD_LOGIC_VECTOR( 5 DOWNTO 0 );
SIGNAL RegDst_MUX					: STD_LOGIC;
SIGNAL ALUSrc_MUX					: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
SIGNAL MemtoReg_MUX					: STD_LOGIC;
SIGNAL RegWrite_MUX					: STD_LOGIC;
SIGNAL MemRead_MUX					: STD_LOGIC;
SIGNAL MemWrite_MUX					: STD_LOGIC;
SIGNAL ALUop_MUX					: STD_LOGIC_VECTOR( 2 DOWNTO 0 );
SIGNAL Binput_mux					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL shamt						: STD_LOGIC_VECTOR( 31 DOWNTO 0 );



	BEGIN

	shift: Shifter generic map (32, 5, 16) port map (dir => ALU_ctl(2), x => shamt, y => Binput, res => shift_res);

	shamt <= X"000000" & B"000" & Sign_extend_EX(10 downto 6);

						-- ALU input muxes	
	
	Ainput <= Read_data_1_EX WHEN forward_A = "00" ELSE result_WB WHEN forward_A = "01" ELSE ALU_Result_MEM;

	Binput_mux <= Read_data_2_EX WHEN forward_B = "00" ELSE result_WB WHEN forward_B = "01" ELSE ALU_Result_MEM;
						
	Binput <= Binput_mux WHEN ( ALUSrc_EX = "00" ) ELSE
			sft16_EX WHEN ( ALUSrc_EX = "10" ) ELSE
			Sign_extend_EX;
			
	Ainput_EX <= Ainput;
	Binput_EX <= Binput;
						
	write_data_EX <= Read_data_2_EX;
	
	Function_opcode <= Sign_extend_EX(5 DOWNTO 0);
						-- Generate ALU control bits
						
	ALU_ctl(0) <= '1' WHEN ((ALUOp_EX = "010" AND (Function_opcode = "100101" OR Function_opcode = "101010")) OR
							ALUOp_EX = "011" OR ALUOp_EX = "101" OR ALUOp_EX = "111") ELSE '0';
	ALU_ctl(1) <= '0' WHEN ((ALUOp_EX = "010" AND (Function_opcode = "100100" OR Function_opcode = "100101" OR
							Function_opcode = "000010")) OR ALUOp_EX = "001" OR ALUOp_EX = "011" OR ALUOp_EX = "111") ELSE '1';
	ALU_ctl(2) <= '1' WHEN ((ALUOp_EX = "010" AND (Function_opcode = "100010" OR Function_opcode = "100110" OR Function_opcode = "000010" OR
							Function_opcode = "101010")) OR ALUOp_EX = "110" OR ALUOp_EX = "100" OR ALUOp_EX = "101") ELSE '0'; 
	ALU_ctl(3) <= '1' WHEN ((ALUOp_EX = "010" AND (Function_opcode = "100110" OR Function_opcode = "000000")) OR
							ALUOp_EX = "100" OR ALUOp_EX = "111") ELSE '0'; 
	

	
	-- Generate Zero Flag
	Zero_EX <= '1' WHEN ( ALU_output_mux(31 DOWNTO 0) = X"00000000" )
		ELSE '0';    
						-- Select ALU output        
	ALU_Result_EX <= ALU_output_mux( 31 DOWNTO 0 );		
	
					-- Mux for Register Write Address
	write_register_address_EX <= write_register_address_1_EX WHEN RegDst_EX = '1' ELSE
			write_register_address_0_EX;
			
	write_register_address_0_EX_hazard <= write_register_address_0_EX;

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
  

	RegDst_MUX <= RegDst_ID when stall = '0' else '0';
	ALUSrc_MUX <= ALUSrc_ID when stall = '0' else (others => '0');
	MemtoReg_MUX <= MemtoReg_ID when stall = '0' else '0';
	RegWrite_MUX <= RegWrite_ID when stall = '0' else '0';
	MemRead_MUX <= MemRead_ID when stall = '0' else '0';
	MemWrite_MUX <= MemWrite_ID when stall = '0' else'0';
	ALUop_MUX <= ALUop_ID when stall = '0' else (others => '0');
	
  
  	PROCESS
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
			IF reset = '1' THEN
				pc_plus_4_EX <= (others => '0');
				write_register_address_0_EX <= (others => '0');
				write_register_address_1_EX <= (others => '0');
				Sign_extend_EX <= (others => '0');
				read_data_1_EX <= (others => '0');	 
				read_data_2_EX <= (others => '0');
				sft16_EX <= (others => '0');
				read_register_1_address_EX <= (others => '0');
				Instruction_EX <= (others => '0');
				
				RegDst_EX <= '0';
				ALUSrc_EX <= (others => '0');
				MemtoReg_EX <= '0';
				RegWrite_EX <= '0';
				MemRead_EX <= '0';
				MemWrite_EX <= '0';
				ALUop_EX <= (others => '0');
				
				
			ELSE 
				pc_plus_4_EX <= PC_plus_4_ID;
				write_register_address_0_EX <= write_register_address_0_ID;
				write_register_address_1_EX <= write_register_address_1_ID;
				Sign_extend_EX <= Sign_extend_ID;
				read_data_1_EX <= read_data_1_ID;	 
				read_data_2_EX <= read_data_2_ID;
				sft16_EX <= sft16_ID;
				read_register_1_address_EX <= read_register_1_address_ID;
				Instruction_EX <= Instruction_ID;
				
				RegDst_EX <= RegDst_MUX;
				ALUSrc_EX <= ALUSrc_MUX;
				MemtoReg_EX <= MemtoReg_MUX;
				RegWrite_EX <= RegWrite_MUX;
				MemRead_EX <= MemRead_MUX;
				MemWrite_EX <= MemWrite_MUX;
				ALUop_EX <= ALUop_MUX;
				
			END IF;
	END PROCESS;	
END behavior;

