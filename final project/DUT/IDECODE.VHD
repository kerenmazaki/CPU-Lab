						--  Idecode module (implements the register file for
LIBRARY IEEE; 			-- the MIPS computer)
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.aux_package.all;

ENTITY Idecode IS

	  PORT(
			Instruction : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALU_result	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			RegWrite 	: IN 	STD_LOGIC;
			MemtoReg 	: IN 	STD_LOGIC;
			RegDst 		: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			JumpAL		: IN 	STD_LOGIC;
			pc_plus_4	: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			ret_add_int	: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			clock,reset	: IN 	STD_LOGIC;
			INTR		: IN	STD_LOGIC;	
			jr			: IN	STD_LOGIC;
			INTR1		: IN	STD_LOGIC;
			
			read_data_1	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data_2	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Sign_extend : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			sft16		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			inst_j		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			GIE			: OUT	STD_LOGIC;
			pc_inter	: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 )
			);
END Idecode;


ARCHITECTURE behavior OF Idecode IS
TYPE register_file IS ARRAY ( 0 TO 31 ) OF STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL register_array				: register_file;
	SIGNAL write_register_address 		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL result						: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL write_data					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_register_1_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_register_2_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_1		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_0		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL Instruction_immediate_value	: STD_LOGIC_VECTOR( 15 DOWNTO 0 );

BEGIN
	read_register_1_address 	<= Instruction( 25 DOWNTO 21 );
   	read_register_2_address 	<= Instruction( 20 DOWNTO 16 );
   	write_register_address_1	<= Instruction( 15 DOWNTO 11 );
   	write_register_address_0 	<= Instruction( 20 DOWNTO 16 );
   	Instruction_immediate_value <= Instruction( 15 DOWNTO 0 );
	
					-- Read Register 1 Operation
	read_data_1 <= register_array( 
			      CONV_INTEGER( read_register_1_address ) );
				  
					-- Read Register 2 Operation		 
	read_data_2 <= register_array( 
			      CONV_INTEGER( read_register_2_address ) );
				  
					-- Mux for Register Write Address
   write_register_address <= write_register_address_1 WHEN RegDst = "01" ELSE
			write_register_address_0 WHEN RegDst = "00" ELSE   
			"11111";
			
					-- Mux to bypass data memory for Rformat instructions
	result <= ALU_result WHEN ( MemtoReg = '0') ELSE read_data;
	
	process
	begin
		wait until (clock'event and clock = '1');
			if (INTR1 = '1') then 
				pc_inter <= read_data;
			end if;
	end process;
	
				-- jal mux - write to register
	write_data <= (31 downto 8 => '0') & pc_plus_4(9 downto 2) WHEN JumpAL = '1' ELSE
					result;
					
					-- Sign Extend 16-bits to 32-bits
    	Sign_extend <= X"0000" & Instruction_immediate_value
		WHEN Instruction_immediate_value(15) = '0'
		ELSE	X"FFFF" & Instruction_immediate_value;

					-- lui shifter
		sft16 <= Instruction(15 downto 0) & X"0000";
		
					-- j shifter
		inst_j  <= Instruction(7 downto 0);
		
PROCESS
	BEGIN
	
		WAIT UNTIL clock'EVENT AND clock = '1';
		IF reset = '1' THEN
					-- Initial register values on reset are register = reg#
					-- use loop to automatically generate reset logic 
					-- for all registers
			FOR i IN 0 TO 31 LOOP
				register_array(i) <= CONV_STD_LOGIC_VECTOR( i, 32 );
 			END LOOP;
			
		ELSIF INTR = '1' THEN 
			register_array(27) <= x"000000" & ret_add_int; -- write return address from ISR to $k1
			register_array(26)(0) <= '0'; --$k0(0)(GIE) = '0'
		
		ELSIF (jr = '1' and read_register_1_address = "11011") THEN  
			register_array(26)(0) <= '1'; --$k0(0)(GIE) = '1'
			
				-- Write back to register - don't write to register 0
  		ELSIF RegWrite = '1' AND write_register_address /= 0 THEN
		      register_array( CONV_INTEGER( write_register_address)) <= write_data;
		END IF;
	END PROCESS;
	
	GIE <= register_array(26)(0);
	
	
END behavior;


