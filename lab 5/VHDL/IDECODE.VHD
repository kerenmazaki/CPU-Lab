						--  Idecode module (implements the register file for
LIBRARY IEEE; 			-- the MIPS computer)
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.aux_package.all;

ENTITY Idecode IS
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
END Idecode;


ARCHITECTURE behavior OF Idecode IS
TYPE register_file IS ARRAY ( 0 TO 31 ) OF STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL register_array				: register_file;
	SIGNAL write_data					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_register_1_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_register_2_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL Branch_Add 					: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL Instruction_immediate_value	: STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	SIGNAL Instruction					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL pc_plus_4					: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL equal						: STD_LOGIC;
	SIGNAL Sign_extend 	 				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL PCSrc						: STD_LOGIC;
	SIGNAL read_data_1					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL write_register_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL jr							: STD_LOGIC;
	SIGNAL flush						: STD_LOGIC;

BEGIN
	Instruction_ID <= Instruction;

	read_register_1_address 	<= Instruction( 25 DOWNTO 21 );
   	read_register_2_address 	<= Instruction( 20 DOWNTO 16 );
   	write_register_address_1_ID	<= Instruction( 15 DOWNTO 11 );
   	write_register_address_0_ID <= Instruction( 20 DOWNTO 16 );
   	Instruction_immediate_value <= Instruction( 15 DOWNTO 0 );
	
	PCSrc <= (Branch_ID AND equal) OR (BranchNE_ID AND NOT(equal));
	
	PCSrc_ID <= PCSrc;
	
	read_data_1_ID <= read_data_1;
	read_data_2_ID <= read_data_2;
	
	equal <= '1' WHEN read_data_1 = read_data_2 ELSE '0';
	
	read_register_1_address_ID <= read_register_1_address;
	
					-- Read Register 1 Operation
	read_data_1 <= register_array( 
			      CONV_INTEGER( read_register_1_address ) );
				  
					-- Read Register 2 Operation		 
	read_data_2 <= register_array( 
			      CONV_INTEGER( read_register_2_address ) );
		
				-- jal mux - write to register
	pc_plus_4_ID <= pc_plus_4;			

	write_data <= (31 downto 8 => '0') & pc_plus_4(9 downto 2) WHEN JumpAL_ID = '1' ELSE
					result_WB;
				
	write_data_ID <= write_data;
	
					-- Sign Extend 16-bits to 32-bits
    Sign_extend <= X"0000" & Instruction_immediate_value
					WHEN Instruction_immediate_value(15) = '0'
					ELSE	X"FFFF" & Instruction_immediate_value;

					
	Sign_extend_ID <= Sign_extend;	

		-- jr 
	jr <= '1' WHEN (ALUOp_ID = "010" AND Sign_extend(5 downto 0) = "0001000") ELSE '0';
	
	Jr_ID <= jr;

	inst_j_ID <= Sign_extend(7 downto 0);	
					
							-- Adder to compute Branch Address
	Branch_Add	<= pc_plus_4( 9 DOWNTO 2 ) +  Sign_extend( 7 DOWNTO 0 ) ;
	Add_result_ID <= Branch_Add( 7 DOWNTO 0 );

					-- lui shifter
	sft16_ID <= Instruction(15 downto 0) & X"0000";
	
	write_register_address <= "11111" when JumpAL_ID = '1'
							else write_register_address_WB; 
		
	flush <= PCSrc OR jump_ID OR jr;
	flush_ID <= flush;
	
	PROCESS
		BEGIN
			WAIT UNTIL clock'EVENT AND clock = '0';
			IF reset = '1' THEN
						-- Initial register values on reset are register = reg#
						-- use loop to automatically generate reset logic 
						-- for all registers
				FOR i IN 0 TO 31 LOOP
					register_array(i) <= CONV_STD_LOGIC_VECTOR( i, 32 );
				END LOOP;
						-- Write back to register - don't write to register 0
			ELSIF RegWrite_WB = '1' AND write_register_address /= 0 THEN
				  register_array( CONV_INTEGER( write_register_address)) <= write_data;
			END IF;
	END PROCESS;

		
	PROCESS
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
			IF (reset = '1' OR flush = '1') THEN
				instruction <= (others => '0');
				pc_plus_4 <= (others => '0');	
			ELSIF stall = '0' THEN
				instruction <= instruction_IF;
				pc_plus_4 <= PC_plus_4_IF;

			END IF;
	END PROCESS;
	
END behavior;

