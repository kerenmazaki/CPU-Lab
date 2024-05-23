				-- Top Level Structural Model for MIPS Processor Core
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
use work.aux_package.all;

ENTITY MIPS IS

	PORT( 
		reset, clock										: IN STD_LOGIC; 
		BPADD_input											: IN STD_LOGIC_VECTOR( 7 DOWNTO 0 );	
	
		-- Output important signals to pins for easy display in Simulator
		PC_out												: OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		read_data_1_ID_out									: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		read_data_2_ID_out									: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		write_data_ID_out									: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );	
     	Branch_ID_out										: OUT STD_LOGIC;
		Instruction_ID_out									: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		RegWrite_ID_out										: OUT STD_LOGIC;
		Instruction_EX_out									: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		ALU_result_EX_out									: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		ALU_Ainput_EX_out									: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		ALU_Binput_EX_out									: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Zero_EX												: OUT STD_LOGIC;
		Instruction_MEM_out									: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		MemWrite_MEM_out									: OUT STD_LOGIC;
		write_data_MEM_out									: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		read_data_MEM_out									: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		address_MEM_out										: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );	
		instruction_WB_out									: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		MemtoReg_WB_out										: OUT STD_LOGIC;
		CLKCNT_out											: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 );
		STCNT_out											: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		FHCNT_out											: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		STtrigger											: OUT STD_LOGIC
		);
END MIPS;

ARCHITECTURE structure OF MIPS IS

					-- declare signals used to connect VHDL components
	SIGNAL PC_plus_4_IF								: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL PC_plus_4_ID								: STD_LOGIC_VECTOR( 9 DOWNTO 0 );	
	SIGNAL read_data_1_ID 							: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2_ID							: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_Extend_ID							: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Add_result_ID							: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ALU_result_EX 							: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALU_result_MEM 							: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_MEM	 						: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALUSrc_ID								: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL Branch_ID 								: STD_LOGIC;
	SIGNAL BranchNE_ID				 				: STD_LOGIC;
	SIGNAL jump_ID 									: STD_LOGIC;
	SIGNAL Jr_ID									: STD_LOGIC;
	SIGNAL RegDst_ID								: STD_LOGIC;
	SIGNAL RegWrite_ID								: STD_LOGIC;
	SIGNAL RegWrite_EX								: STD_LOGIC;
	SIGNAL RegWrite_MEM								: STD_LOGIC;
	SIGNAL RegWrite_WB								: STD_LOGIC;
	SIGNAL MemWrite_ID 								: STD_LOGIC;
	SIGNAL MemWrite_EX 								: STD_LOGIC;
	SIGNAL MemWrite_MEM								: STD_LOGIC;
	SIGNAL MemtoReg_ID	 							: STD_LOGIC;
	SIGNAL MemtoReg_EX				 				: STD_LOGIC;
	SIGNAL MemtoReg_MEM	 							: STD_LOGIC;
	SIGNAL MemRead_ID			 					: STD_LOGIC;
	SIGNAL MemRead_EX								: STD_LOGIC;
	SIGNAL MemRead_MEM 								: STD_LOGIC;
	SIGNAL jumpAL_ID								: STD_LOGIC;
	SIGNAL ALUop_ID									: STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL Instruction_IF							: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Instruction_ID							: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Instruction_EX							: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Instruction_MEM							: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Instruction_WB							: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL inst_j_ID								: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL result_WB								: STD_LOGIC_VECTOR (31 downto 0);
	SIGNAL PCSrc_ID									: STD_LOGIC;
	SIGNAL write_register_address_WB				: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL sft16_ID									: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL write_register_address_1_ID				: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_0_ID				: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_data_EX							: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL write_register_address_EX				: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_MEM				: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL stall									: STD_LOGIC;
	SIGNAL write_register_address_0_EX_hazard		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_register_1_address_ID 				: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL forward_A								: STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL forward_B								: STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL read_register_1_address_EX				: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_data_ID							: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Ainput_EX								: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Binput_EX								: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL write_data_MEM							: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL MemtoReg_WB								: STD_LOGIC;
	SIGNAL CLKCNT									: STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	SIGNAL STCNT									: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL FHCNT									: STD_LOGIC_VECTOR( 7 DOWNTO 0 );	
	SIGNAL BPADD									: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL flush									: STD_LOGIC;
	SIGNAL PC										: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		
	
	
	
BEGIN
					-- copy important signals to output pins for easy 
					-- display in Simulator
		PC_out 				<= PC;
		read_data_1_ID_out	<= read_data_1_ID;									
		read_data_2_ID_out	<= Read_data_2_ID;									
		write_data_ID_out	<= write_data_ID;						
     	Branch_ID_out		<= Branch_ID or BranchNE_ID;		--?? PCSrc					
		Instruction_ID_out	<= Instruction_ID;		
		RegWrite_ID_out		<= RegWrite_ID;							
		Instruction_EX_out	<= Instruction_EX;
		ALU_result_EX_out	<= ALU_result_EX;								
		ALU_Ainput_EX_out	<= Ainput_EX;
		ALU_Binput_EX_out	<= Binput_EX;
		Instruction_MEM_out <= Instruction_MEM;
		MemWrite_MEM_out	<= MemWrite_MEM;
		write_data_MEM_out	<= write_data_MEM;
		read_data_MEM_out	<= read_data_MEM;
		address_MEM_out		<= ALU_result_MEM;
		instruction_WB_out	<= Instruction_WB;
		MemtoReg_WB_out		<= MemtoReg_WB;
		CLKCNT_out			<= CLKCNT;
		STCNT_out			<= STCNT;
		FHCNT_out			<= FHCNT;
	 
					-- connect the 5 MIPS components 
					
   CTL:   control
	PORT MAP ( 	Opcode 			=> Instruction_ID( 31 DOWNTO 26 ),
				RegDst 			=> RegDst_ID,
				ALUSrc 			=> ALUSrc_ID,
				MemtoReg 		=> MemtoReg_ID,
				RegWrite 		=> RegWrite_ID,
				MemRead 		=> MemRead_ID,
				MemWrite 		=> MemWrite_ID,
				Branch 			=> Branch_ID,
				BranchNE		=> BranchNE_ID,
				jump			=> jump_ID,
				JumpAL			=> jumpAL_ID,
				ALUop 			=> ALUop_ID,
                clock 			=> clock,
				reset 			=> reset);



 IFE : Ifetch
	PORT MAP (	Instruction_IF 	=> Instruction_IF,
				PC_plus_4_IF	=> PC_plus_4_IF,
				Add_result_ID	=> Add_result_ID,
				PC_out 			=> PC,        		
				clock 			=> clock,  
				reset 			=> reset,
				inst_j_ID		=> inst_j_ID,
				Jump_ID			=> Jump_ID,
				Jr_ID			=> Jr_ID,
				PCSrc_ID		=> PCSrc_ID,
				result_WB		=> result_WB,
				stall			=> stall,
				read_data_1_ID	=> read_data_1_ID);

   ID : Idecode
   	PORT MAP (	Instruction_IF			 	=> Instruction_IF,
				Instruction_ID				=> Instruction_ID,
				result_WB					=> result_WB,
				jump_ID						=> jump_ID,
        		JumpAL_ID					=> JumpAL_ID,
				pc_plus_4_IF				=> pc_plus_4_IF,
				pc_plus_4_ID				=> pc_plus_4_ID,
				write_register_address_WB	=> write_register_address_WB,
				RegWrite_WB 				=> RegWrite_WB,
				clock			 			=> clock,  
				reset 						=> reset,
				sft16_ID					=> sft16_ID,
				inst_j_ID					=> inst_j_ID,
				write_register_address_1_ID	=> write_register_address_1_ID,
				write_register_address_0_ID	=> write_register_address_0_ID,
				read_register_1_address_ID	=> read_register_1_address_ID,
				Sign_extend_ID				=> Sign_extend_ID,
				read_data_1_ID				=> read_data_1_ID,
				read_data_2_ID				=> read_data_2_ID,
				stall						=> stall,
				Branch_ID 					=> Branch_ID,
				BranchNE_ID					=> BranchNE_ID,
				PCSrc_ID					=> PCSrc_ID,
				Add_Result_ID				=> Add_Result_ID,
				ALUop_ID		 			=> ALUop_ID,
				Jr_ID						=> Jr_ID,
				write_data_ID				=> write_data_ID,
				flush_ID					=> flush);


 

   EXE:  Execute
   	PORT MAP (	Read_data_1_ID			 	=> read_data_1_ID,
             	Read_data_2_ID 				=> read_data_2_ID,
				write_register_address_1_ID => write_register_address_1_ID,
				write_register_address_0_ID => write_register_address_0_ID,
				Sign_extend_ID 				=> Sign_extend_ID,
				sft16_ID					=> sft16_ID,
				ALU_Result_EX				=> ALU_Result_EX,
				write_data_EX				=> write_data_EX,
				pc_plus_4_ID				=> PC_plus_4_ID,
                Clock						=> clock,
				Reset						=> reset,
				RegDst_ID 					=> RegDst_ID,
				ALUSrc_ID					=> ALUSrc_ID,
				MemtoReg_ID					=> MemtoReg_ID,
				RegWrite_ID					=> RegWrite_ID,
				MemRead_ID					=> MemRead_ID,
				MemWrite_ID					=> MemWrite_ID,
				ALUop_ID					=> ALUop_ID,
				MemtoReg_EX					=> MemtoReg_EX,
				RegWrite_EX					=> RegWrite_EX,
				MemRead_EX					=> MemRead_EX,
				MemWrite_EX					=> MemWrite_EX,
				Zero_EX						=> Zero_EX,
				write_register_address_EX	=> write_register_address_EX,
				write_register_address_0_EX_hazard => write_register_address_0_EX_hazard,
				stall						=> stall,
				read_register_1_address_ID	=> read_register_1_address_ID,
				forward_A					=> forward_A,
				forward_B					=> forward_B,
				result_WB					=> result_WB,
				ALU_Result_MEM				=> ALU_Result_MEM,
				read_register_1_address_EX  => read_register_1_address_EX,
				Instruction_ID 				=> Instruction_ID,
				Instruction_EX				=> Instruction_EX,
				Ainput_EX					=> Ainput_EX,
				Binput_EX					=> Binput_EX);

   MEM:  dmemory
	PORT MAP (	clock 						=> clock,
				reset						=> reset,
				ALU_Result_EX			 	=> ALU_Result_EX,
				write_data_EX 				=> write_data_EX,
				write_register_address_EX 	=> write_register_address_EX,
				read_data_MEM  				=> read_data_MEM,
				ALU_Result_MEM 				=> ALU_Result_MEM,
				write_register_address_MEM 	=> write_register_address_MEM,
				MemtoReg_EX 				=> MemtoReg_EX,
				RegWrite_EX 				=> RegWrite_EX,
				MemRead_EX  				=> MemRead_EX,
				MemWrite_EX 				=> MemWrite_EX,
				MemWrite_MEM				=> MemWrite_MEM,
				MemtoReg_MEM 				=> MemtoReg_MEM,
				RegWrite_MEM 				=> RegWrite_MEM,
				MemRead_MEM					=> MemRead_MEM,
				Instruction_MEM 			=> Instruction_MEM,
				Instruction_EX				=> Instruction_EX,
				write_data_MEM				=> write_data_MEM);

   WB:  writeback
	PORT MAP (	read_data_MEM  					=> read_data_MEM,
				ALU_Result_MEM 					=> ALU_Result_MEM,
				write_register_address_MEM 		=> write_register_address_MEM,
				MemtoReg_MEM 					=> MemtoReg_MEM,
				clock 							=> clock,
				reset							=> reset,
				result_WB 						=> result_WB,
				write_register_address_WB		=> write_register_address_WB,
				RegWrite_MEM 					=> RegWrite_MEM,
				RegWrite_WB	 					=> RegWrite_WB,
				Instruction_MEM 				=> Instruction_MEM,
				Instruction_WB					=> Instruction_WB,
				MemtoReg_WB						=> MemtoReg_WB);
				
		
	PROCESS
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
			IF reset = '1' THEN
				   CLKCNT <= (others => '0'); 
			ELSE 
				   CLKCNT <= CLKCNT + 1;
			END IF;
	END PROCESS;
	
	PROCESS
	BEGIN
		WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
		IF reset = '1' THEN
			   STCNT <= (others => '0'); 
		ELSIF stall = '1' THEN
			   STCNT <= STCNT + 1;
		END IF;
	END PROCESS;
	
	PROCESS
	BEGIN
		WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
		IF reset = '1' THEN
			   FHCNT <= (others => '0'); 
		ELSIF flush = '1' THEN
			   FHCNT <= FHCNT + 1;
		END IF;
	END PROCESS;
	
	PROCESS
	BEGIN
		WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
		IF reset = '1' THEN
			   BPADD <= (others => '0'); 
		ELSE 
			   BPADD <= BPADD_input & "00";
		END IF;
	END PROCESS;
	
	STtrigger <= '1' when PC = BPADD else '0';
	
	stall <= '1' when (write_register_address_0_ID = write_register_address_0_EX_hazard OR
			read_register_1_address_ID = write_register_address_0_EX_hazard) AND (MemtoReg_EX = '1')
			else '0';
			
	forward_A <= "10" when (read_register_1_address_EX /= "00000") and (read_register_1_address_EX = write_register_address_MEM) and
			(RegWrite_MEM = '1')
			else "01" when (read_register_1_address_EX /= "00000") and (read_register_1_address_EX = write_register_address_WB) and
			(RegWrite_WB = '1')
			else "00";
			
	forward_B <= "10" when (write_register_address_0_EX_hazard /= "00000") and (write_register_address_0_EX_hazard = write_register_address_MEM) and
			(RegWrite_MEM = '1')
			else "01" when (write_register_address_0_EX_hazard /= "00000") and (write_register_address_0_EX_hazard = write_register_address_WB) and
			(RegWrite_WB = '1')
			else "00";
			
END structure;

