						--  Dmemory module (implements the data
						--  memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
use work.aux_package.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY dmemory IS
	GENERIC(ModelSim : boolean := False;
			prog_width : integer := 10);
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
END dmemory;

ARCHITECTURE behavior OF dmemory IS

SIGNAL write_clock		: STD_LOGIC;
SIGNAL MemWrite			: STD_LOGIC;
SIGNAL address			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL write_data		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL Mem_Addr			: STD_LOGIC_VECTOR(prog_width-1 DOWNTO 0 );
			
BEGIN
	data_memory : altsyncram
	GENERIC MAP  (
		operation_mode => "SINGLE_PORT",
		width_a => 32,
		widthad_a => prog_width,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "C:\Users\keren\Documents\school\third year\semester b\CPU lab\lab 5\ours\MIPS single cycle Architecture\ModelSim\L1_Caches\asm_ver2\dmemory.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		wren_a => MemWrite,
		clock0 => write_clock,
		address_a => Mem_Addr,
		data_a => write_data,
		q_a => read_data_MEM);
-- Load memory address  register with write clock
		write_clock <= NOT clock;
		
	write_data_MEM <= write_data;
	
							-- send address to inst. memory address register
	G1:	if (ModelSim = True) generate		
			Mem_Addr <= address(9 downto 2);
		end generate;
	
	G2: if (ModelSim = False) generate		
			Mem_Addr <= address(9 downto 2) & "00";
		end generate;
	
	ALU_Result_MEM <= address;
	
	MemWrite_MEM <= MemWrite;
		
	 PROCESS
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
			IF reset = '1' THEN
				write_register_address_MEM <= (others => '0');
				address <= (others => '0');
				write_data <= (others => '0');
				Instruction_MEM <= (others => '0');
				MemtoReg_MEM <= '0';
				RegWrite_MEM <= '0';
				MemRead_MEM <= '0';
				MemWrite <= '0';
			ELSE 
				write_register_address_MEM <= write_register_address_EX;
				address <= ALU_Result_EX;
				write_data <= write_data_EX;
				Instruction_MEM <= Instruction_EX;
				
				MemtoReg_MEM <= MemtoReg_EX;
				RegWrite_MEM <= RegWrite_EX;
				MemRead_MEM <= MemRead_EX; 
				MemWrite <= MemWrite_EX;
			END IF;
	END PROCESS;	
	

END behavior;

