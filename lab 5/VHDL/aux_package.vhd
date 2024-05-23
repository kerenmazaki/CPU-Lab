library IEEE;
use ieee.std_logic_1164.all;

package aux_package is

--------------------------------------------------------
	component control IS
	PORT( 	
		Opcode 		: IN 	STD_LOGIC_VECTOR(5 DOWNTO 0);
		clock, reset: IN 	STD_LOGIC;
		
		RegDst 		: OUT 	STD_LOGIC;
		ALUSrc 		: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		MemtoReg 	: OUT 	STD_LOGIC;
		RegWrite 	: OUT 	STD_LOGIC;
		MemRead 	: OUT 	STD_LOGIC;
		MemWrite 	: OUT 	STD_LOGIC;
		Branch 		: OUT 	STD_LOGIC;
		BranchNE 	: OUT 	STD_LOGIC;
		jump		: OUT 	STD_LOGIC;
		jumpAL		: OUT 	STD_LOGIC;
		ALUop 		: OUT 	STD_LOGIC_VECTOR(2 DOWNTO 0)
		);

	END component;
	--------------------------------------------------------
	component  Execute IS
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
	END component;
	--------------------------------------------------------
	component dmemory IS
	PORT(	
            clock,reset					: IN 	STD_LOGIC;
			ALU_Result_EX 				: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			write_data_EX				: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			write_register_address_EX	: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			MemtoReg_EX 				: IN 	STD_LOGIC;
			RegWrite_EX 				: IN 	STD_LOGIC;
			MemRead_EX 					: IN 	STD_LOGIC;
			MemWrite_EX 				: IN 	STD_LOGIC;
			Instruction_EX				: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			
			MemWrite_MEM 				: OUT 	STD_LOGIC;
			read_data_MEM 				: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALU_Result_MEM				: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			write_register_address_MEM	: OUT 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			Add_result_MEM				: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			MemtoReg_MEM 				: OUT 	STD_LOGIC;
			RegWrite_MEM 				: OUT 	STD_LOGIC;
			MemRead_MEM					: OUT 	STD_LOGIC;
			Instruction_MEM				: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			write_data_MEM				: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 )
        	);

	END component;
	--------------------------------------------------------
	component Idecode IS
	  PORT(
			Instruction_IF				: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			pc_plus_4_IF				: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			result_WB					: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			clock,reset					: IN 	STD_LOGIC;
			write_register_address_WB	: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			jump_ID						: IN 	STD_LOGIC;				
			JumpAL_ID					: IN 	STD_LOGIC;
			RegWrite_WB    				: IN 	STD_LOGIC;
			stall						: IN	STD_LOGIC;
			Branch_ID 					: IN 	STD_LOGIC;
			BranchNE_ID 				: IN 	STD_LOGIC;
			ALUOp_ID					: IN	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
		
			read_data_1_ID				: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data_2_ID				: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Instruction_ID				: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			sft16_ID					: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			PCSrc_ID					: OUT	STD_LOGIC;
			pc_plus_4_ID				: OUT 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			write_register_address_1_ID	: OUT 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			write_register_address_0_ID	: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			read_register_1_address_ID	: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			Add_Result_ID				: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			Sign_extend_ID 	 			: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			inst_j_ID					: OUT	STD_LOGIC_VECTOR(7 downto 0);
			Jr_ID		 				: OUT 	STD_LOGIC;
			write_data_ID				: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			flush_ID					: OUT	STD_LOGIC
			);
	END component;
	--------------------------------------------------------
	component Ifetch IS
	PORT(
			Add_result_ID	: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			inst_j_ID		: IN	STD_LOGIC_VECTOR(7 downto 0);
        	clock, reset 	: IN 	STD_LOGIC;
			Jump_ID			: IN 	STD_LOGIC;
			Jr_ID		 	: IN 	STD_LOGIC;
			PCSrc_ID		: IN 	STD_LOGIC;
			result_WB		: IN	STD_LOGIC_VECTOR (31 downto 0);
			stall			: IN	STD_LOGIC;
			read_data_1_ID	: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			
      		PC_out 			: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			instruction_IF 	: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	PC_plus_4_IF 	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 )
			);

	END component;
	--------------------------------------------------------
	component writeback IS
	PORT(	
			read_data_MEM 				: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALU_Result_MEM				: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			write_register_address_MEM	: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			clock,reset					: IN 	STD_LOGIC;
			MemtoReg_MEM 				: IN 	STD_LOGIC;
			RegWrite_MEM 				: IN 	STD_LOGIC;
			Instruction_MEM				: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );

			
			result_WB					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			write_register_address_WB	: OUT 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );			
			RegWrite_WB					: OUT	STD_LOGIC;
			Instruction_WB				: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			MemtoReg_WB					: OUT	STD_LOGIC
        	);
	END component;
	--------------------------------------------------------

	component shifter IS
	  GENERIC (n : INTEGER := 8;
			   k : integer := 3;   -- k=log2(n)
			   m : integer := 4	); -- m=2^(k-1)     
	  PORT (dir: IN STD_LOGIC;
			x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			res: OUT STD_LOGIC_VECTOR (n-1 downto 0));
	END component;
	
end aux_package;