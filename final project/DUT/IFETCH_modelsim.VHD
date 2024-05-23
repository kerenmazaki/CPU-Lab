-- Ifetch module (provides the PC and instruction 
--memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
use work.aux_package.all;

ENTITY Ifetch IS

	GENERIC(ModelSim : boolean := True;
			prog_width : integer := 8);
			
	PORT(	Add_result 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        	Branch 			: IN 	STD_LOGIC;
			BranchNE 		: IN 	STD_LOGIC;
			jump	 		: IN 	STD_LOGIC;
			jr		 		: IN 	STD_LOGIC;
        	Zero 			: IN 	STD_LOGIC;
        	clock, reset 	: IN 	STD_LOGIC;
			read_data_1		: IN	STD_LOGIC_VECTOR (31 downto 0);
			inst_j			: IN	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			pc_inter		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			INTR2			: IN	STD_LOGIC;
			
      		PC_out 			: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			Instruction 	: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	ret_add_int 	: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			PC_plus_4_out	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 )
			);
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS
	SIGNAL PC, PC_plus_4 					: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL next_PC							: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL Mem_Addr 						: STD_LOGIC_VECTOR(prog_width-1 DOWNTO 0 );
	SIGNAL next_PC_3, next_PC_2, next_PC_1 	: STD_LOGIC_VECTOR(7 DOWNTO 0 );
	SIGNAL PCSrc: STD_LOGIC;
BEGIN
						--ROM for Instruction Memory
inst_memory: altsyncram
	
	GENERIC MAP (
		operation_mode => "ROM",
		width_a => 32,
		widthad_a => prog_width,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "C:\Users\keren\Documents\school\third year\semester b\CPU lab\final project\ours\assembly\test6_program.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		clock0   	=> clock,
		address_a 	=> Mem_Addr, 
		q_a 		=> Instruction );
		
					-- Instructions always start on word address - not byte
		PC(1 DOWNTO 0) <= "00";
		
					-- copy output signals - allows read inside module
		PC_out 			<= PC;
		PC_plus_4_out	<= PC_plus_4;
		
						-- send address to inst. memory address register
	G1:	if (ModelSim = True) generate		
			Mem_Addr <= Next_PC;
		end generate;
	
	G2: if (ModelSim = False) generate		
			Mem_Addr <= Next_PC & "00";
		end generate;
		
		
						-- Adder to increment PC by 4        
      	PC_plus_4( 9 DOWNTO 2 )  <= PC( 9 DOWNTO 2 ) + 1;
       	PC_plus_4( 1 DOWNTO 0 )  <= "00";

		
		PCSrc <= (Branch AND Zero) OR (BranchNE AND (NOT(Zero)));
		
								
		-- Mux to select Branch Address or PC + 4   
		
		next_PC_3  <= X"00" WHEN Reset = '1' ELSE
			Add_result  WHEN  PCSrc = '1' ELSE
			PC_plus_4(9 DOWNTO 2);
		
						-- j mux
		next_PC_2 <= inst_j when jump = '1' else
				next_PC_3;
			
			
						-- jr Mux
		next_PC_1 <= read_data_1(7 downto 0) WHEN jr = '1' ELSE next_PC_2;
		
		ret_add_int <= next_PC_1;
		
		next_PC <= pc_inter(9 downto 2) when INTR2 = '1' ELSE next_PC_1;
		
		
	PROCESS
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
			IF reset = '1' THEN
				   PC( 9 DOWNTO 2) <= "00000000" ; 
			ELSE 
				   PC( 9 DOWNTO 2 ) <= next_PC;
			END IF;
	END PROCESS;
END behavior;


