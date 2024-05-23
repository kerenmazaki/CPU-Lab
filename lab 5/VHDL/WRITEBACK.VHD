LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
use work.aux_package.all;

ENTITY writeback IS
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
END writeback;

ARCHITECTURE behavior OF writeback IS
signal read_data_WB		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
signal ALU_Result_WB	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
signal MemtoReg			: STD_LOGIC;
begin
		-- Mux
	result_WB <= ALU_result_WB
			WHEN ( MemtoReg = '0' )
			ELSE read_data_WB;
			
	MemtoReg_WB <= MemtoReg;
	
	PROCESS
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
			IF reset = '1' THEN
				read_data_WB <= (others => '0');
				ALU_Result_WB <= (others => '0');
				write_register_address_WB <= (others => '0');
				MemtoReg <= '0';
				RegWrite_WB <= '0';
				Instruction_WB <= (others => '0');
			ELSE 
				read_data_WB <= read_data_MEM;
				ALU_Result_WB <= ALU_Result_MEM;
				write_register_address_WB <= write_register_address_MEM;
				Instruction_WB <= Instruction_MEM;
				
				MemtoReg <= MemtoReg_MEM;
				RegWrite_WB <= RegWrite_MEM;
			END IF;
	END PROCESS;	
	
end behavior;