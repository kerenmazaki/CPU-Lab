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
	GENERIC(ModelSim : boolean := False;
			prog_width : integer := 10);
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
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS
	SIGNAL PC, PC_plus_4		: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL next_PC				: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Mem_Addr			 	: STD_LOGIC_VECTOR(prog_width-1 DOWNTO 0);
	SIGNAL next_PC_2, next_PC_1 : STD_LOGIC_VECTOR(7 DOWNTO 0 );
BEGIN
						--ROM for Instruction Memory
inst_memory: altsyncram
	
	GENERIC MAP (
		operation_mode => "ROM",
		width_a => 32,
		widthad_a => prog_width,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "C:\Users\keren\Documents\school\third year\semester b\CPU lab\lab 5\ours\MIPS single cycle Architecture\ModelSim\L1_Caches\asm_ver2\program.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		clock0     => clock,
		address_a 	=> Mem_Addr, 
		q_a 			=> instruction_IF );
		
					-- Instructions always start on word address - not byte
	PC(1 DOWNTO 0) <= "00";
		
		
					-- copy output signals - allows read inside module
	PC_out <= PC;
		
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
		
		PC_plus_4_IF <= PC_plus_4;
								
						-- Mux to select Branch Address or PC + 4        
		next_PC_2  <= X"00" WHEN Reset = '1' ELSE
			Add_result_ID  WHEN  PCSrc_ID = '1' ELSE
			PC_plus_4(9 DOWNTO 2);
		
						-- j mux
		next_PC_1 <= inst_j_ID when jump_ID = '1' else
				next_PC_2;
					
						-- jr Mux
		next_PC <= next_PC WHEN stall = '1' ELSE
					read_data_1_ID(7 downto 0) WHEN jr_ID = '1' ELSE next_PC_1;	
		
	PROCESS
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
			IF reset = '1' THEN
				   PC( 9 DOWNTO 2) <= "00000000" ; 
			ELSIF stall = '0' THEN
				   PC( 9 DOWNTO 2 ) <= next_PC;
			END IF;
	END PROCESS;

	
END behavior;


