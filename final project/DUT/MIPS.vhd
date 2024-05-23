				-- Top Level Structural Model for MIPS Processor Core
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use work.aux_package.all;
ENTITY MIPS IS

	PORT( 
			reset, clock		: IN 	STD_LOGIC;
			INTR				: IN 	STD_LOGIC;
			TYPE_reg			: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
			
			data				: INOUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
			
			address				: OUT  	STD_LOGIC_VECTOR(31 DOWNTO 0);
			INTA				: OUT 	STD_LOGIC;
			GIE					: OUT	STD_LOGIC;
			MemRead_out			: OUT	STD_LOGIC;
			Memwrite_out		: OUT	STD_LOGIC
		);
		
END MIPS;

ARCHITECTURE structure OF MIPS IS

					-- declare signals used to connect VHDL components
	SIGNAL ret_add_int 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL PC_plus_4		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL read_data_1 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_Extend 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Add_result 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ALU_result 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALUSrc 			: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL Branch 			: STD_LOGIC;
	SIGNAL BranchNE 		: STD_LOGIC;
	SIGNAL jump 			: STD_LOGIC;
	SIGNAL RegDst 			: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL Regwrite 		: STD_LOGIC;
	SIGNAL Zero 			: STD_LOGIC;
	SIGNAL MemWrite 		: STD_LOGIC;
	SIGNAL MemtoReg 		: STD_LOGIC;
	SIGNAL MemRead 			: STD_LOGIC;
	SIGNAL JumpAL			: STD_LOGIC;
	SIGNAL sft16			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALUop 			: STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL Instruction		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL inst_j			: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL jr				: STD_LOGIC;
	SIGNAL PC				: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL pc_inter			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL INTR1			: STD_LOGIC;
	SIGNAL INTR2			: STD_LOGIC;
	
BEGIN

	MemRead_out 	<= MemRead;
	Memwrite_out 	<= MemWrite;
   
  IFE : Ifetch
	PORT MAP (	Instruction 	=> Instruction,
				BranchNE		=> BranchNE,
				jump			=> jump,
				jr				=> jr,
    	    	ret_add_int 	=> ret_add_int,
				PC_plus_4_out	=> PC_plus_4,
				Add_result 		=> Add_result,
				Branch 			=> Branch,
				Zero 			=> Zero,
				PC_out 			=> PC,        		
				clock 			=> clock,  
				reset 			=> reset,
				inst_j			=> inst_j,
				read_data_1		=> read_data_1,
				pc_inter		=> pc_inter,
				INTR2			=> INTR2);

   ID : Idecode
   	PORT MAP (	read_data_1 	=> read_data_1,
        		read_data_2 	=> read_data_2,
        		Instruction 	=> Instruction,
        		read_data 		=> read_data,
				ALU_result 		=> ALU_result,
				JumpAL			=> JumpAL,
				ret_add_int		=> ret_add_int,
				PC_plus_4		=> PC_plus_4,
				RegWrite 		=> RegWrite,
				MemtoReg 		=> MemtoReg,
				RegDst 			=> RegDst,
				Sign_extend 	=> Sign_extend,
        		clock 			=> clock,  
				reset 			=> reset,
				inst_j			=> inst_j,
				sft16			=> sft16,
				INTR			=> INTR,
				INTR1			=> INTR1,
				GIE				=> GIE,
				pc_inter		=> pc_inter,
				jr				=> jr);


   CTL:   control
	PORT MAP ( 	Opcode 			=> Instruction( 31 DOWNTO 26 ),
				RegDst 			=> RegDst,
				ALUSrc 			=> ALUSrc,
				MemtoReg 		=> MemtoReg,
				RegWrite 		=> RegWrite,
				MemRead 		=> MemRead,
				MemWrite 		=> MemWrite,
				Branch 			=> Branch,
				BranchNE		=> BranchNE,
				jump			=> jump,
				JumpAL			=> jumpAL,
				ALUop 			=> ALUop,
                clock 			=> clock,
				reset 			=> reset,
				INTR			=> INTR,
				INTA_out		=> INTA,
				INTR1_out		=> INTR1,
				INTR2			=> INTR2);

   EXE:  Execute
   	PORT MAP (	Read_data_1 	=> read_data_1,
             	Read_data_2 	=> read_data_2,
				Sign_extend 	=> Sign_extend,
				ALUOp 			=> ALUop,
				ALUSrc 			=> ALUSrc,
				sft16			=> sft16,
				Zero 			=> Zero,
                ALU_Result		=> ALU_Result,
				Add_Result 		=> Add_Result,
				PC_plus_4		=> PC_plus_4,
                Clock			=> clock,
				Reset			=> reset,
				jr				=> jr
				);

   MEM:  dmemory
	PORT MAP (	read_data_out	=> read_data,
				ALU_Result 		=> ALU_Result,
				read_data_2 	=> read_data_2,
				MemRead 		=> MemRead, 
				Memwrite 		=> MemWrite, 
                clock 			=> clock,  
				reset 			=> reset,
				data			=> data,
				TYPE_reg		=> TYPE_reg,
				INTR1			=> INTR1,
				address_out		=> address);
END structure;

