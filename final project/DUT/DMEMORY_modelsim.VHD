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

	GENERIC(ModelSim : boolean := True;
			prog_width : integer := 8);
			
	PORT(	
			ALU_result 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	read_data_2			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	   		MemRead, Memwrite 	: IN 	STD_LOGIC;
            clock,reset			: IN 	STD_LOGIC;
			INTR1				: IN 	STD_LOGIC;
			TYPE_reg			: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
			
			data				: INOUT STD_LOGIC_VECTOR( 31 DOWNTO 0);
			
			read_data_out		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			address_out			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 )	
        );
END dmemory;

ARCHITECTURE behavior OF dmemory IS
SIGNAL write_clock					: STD_LOGIC;
SIGNAL bus_write_en, bus_read_en	: STD_LOGIC;
SIGNAL read_data					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL memwrite_dm					: STD_LOGIC;
SIGNAL Mem_Addr 					: STD_LOGIC_VECTOR( prog_width-1 DOWNTO 0 );
SIGNAL address						: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL write_data					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );

BEGIN

-------MUX for memory----------
	bus_write_en <= '1' when (address(11) = '1' and MemWrite = '1') else '0';
	data <= write_data when bus_write_en = '1' else (others => 'Z');

	bus_read_en <= '1' when (address(11) = '1' and MemRead = '1') else '0';
	read_data_out <= data when bus_read_en = '1' else read_data;

	MemWrite_dm <= '1' when (MemWrite = '1' and address(11) = '0') else '0';

	data_memory : altsyncram
	GENERIC MAP  (
		operation_mode => "SINGLE_PORT",
		width_a => 32,
		widthad_a => prog_width,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "C:\Users\keren\Documents\school\third year\semester b\CPU lab\final project\ours\assembly\test6_data.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		wren_a => MemWrite_dm,
		clock0 => write_clock,
		address_a => Mem_Addr,
		data_a => write_data,
		q_a => read_data);
		
-- Load memory address register with write clock
		write_clock <= NOT clock;
		
	G1:	if (ModelSim = True) generate		
			Mem_Addr <= address(9 downto 2);
		end generate;
	
	G2: if (ModelSim = False) generate		
			Mem_Addr <= address(9 downto 2) & "00";
		end generate;
		
	address <= x"000000" & TYPE_reg when INTR1 = '1' ELSE ALU_result;
	
	address_out <= address;
	
	write_data <= read_data_2;
	
END behavior;

