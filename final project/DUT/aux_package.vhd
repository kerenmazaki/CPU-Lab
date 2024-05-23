library IEEE;
use ieee.std_logic_1164.all;

package aux_package is

--------------------------------------------------------
	component control IS

   PORT( 	
		Opcode 			: IN 	STD_LOGIC_VECTOR(5 DOWNTO 0);
		clock, reset	: IN 	STD_LOGIC;
		INTR			: IN	STD_LOGIC;
		
		RegDst 			: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		ALUSrc 			: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		MemtoReg 		: OUT 	STD_LOGIC;
		RegWrite 		: OUT 	STD_LOGIC;
		MemRead 		: OUT 	STD_LOGIC;
		MemWrite	 	: OUT 	STD_LOGIC;
		Branch 			: OUT 	STD_LOGIC;
		BranchNE 		: OUT 	STD_LOGIC;
		jump			: OUT 	STD_LOGIC;
		jumpAL			: OUT 	STD_LOGIC;
		ALUop 			: OUT 	STD_LOGIC_VECTOR(2 DOWNTO 0);
		INTA_out		: OUT	STD_LOGIC;
		INTR1_out		: OUT	STD_LOGIC;
		INTR2			: OUT	STD_LOGIC
	);

	END component;
	--------------------------------------------------------
	component  Execute IS

	PORT(
			Read_data_1 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Read_data_2 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Sign_extend 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALUOp 			: IN 	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
			ALUSrc 			: IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
			Zero 			: OUT	STD_LOGIC;
			ALU_Result 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Add_Result 		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			jr				: OUT	STD_LOGIC;
			PC_plus_4 		: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			sft16			: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			clock, reset	: IN 	STD_LOGIC
		);
	END component;
	--------------------------------------------------------
	component dmemory IS

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

	END component;
	--------------------------------------------------------
	component Idecode IS
	
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
	END component;
	--------------------------------------------------------
	component Ifetch IS
	
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
	
	--------------------------------------------------------
	component MIPS IS

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
		
	END component;
	--------------------------------------------------------
	component GPO_interface IS  
	
		generic (per_address: std_logic_vector(11 downto 0); out_len: integer);

 PORT (
		reset: in std_logic;
		data: inout std_logic_vector (out_len-1 downto 0);
		MemRead: in std_logic;
		MemWrite: in std_logic;
		address: in std_logic_vector(11 downto 0);
		GPO_out: out std_logic_vector (out_len-1 downto 0)
		);
	END component;
	--------------------------------------------------------
	component GPIO IS
     
	PORT (
		reset										: in std_logic;
		SW											: in std_logic_vector(7 downto 0);
		KEY1, KEY2, KEY3							: in std_logic;
		Address										: in std_logic_vector (11 downto 0);
		KEY1_fb, KEY2_fb, KEY3_fb					: in std_logic;
		data										: inout std_logic_vector (31 downto 0);
		MemRead, MemWrite							: in std_logic;
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5			: out std_logic_vector(3 downto 0);
		LEDR										: out std_logic_vector(7 downto 0);
		KEY1_int, KEY2_int, KEY3_int				: out std_logic := '0'

		);
	END component;
	
	--------------------------------------------------------
	component timer IS
     
	PORT  (
		MCLK, reset: in std_logic;
		BT_fb: in std_logic;
		data: in std_logic_vector (31 downto 0);
		address: in std_logic_vector (11 downto 0);
		MemWrite: in std_logic;
		BT_int: out std_logic;
		out_signal: out std_logic
		);
	END component;
	
	--------------------------------------------------------
	component INT_CTL IS
	 PORT (
		clock, reset						: IN STD_LOGIC;
		address 							: IN STD_LOGIC_VECTOR(11 downto 0);
		GIE									: IN STD_LOGIC;
		MemRead, MemWrite					: IN std_logic;
		
		data								: INOUT STD_LOGIC_VECTOR(31 downto 0);

		clr_irq								: IN STD_LOGIC;
		BT_int								: IN STD_LOGIC; --BT intterupt request "set_BTIFG"
		KEY1_int, KEY2_int, KEY3_int		: IN STD_LOGIC;
		INTR_out							: OUT STD_LOGIC;
		KEY1_fb, KEY2_fb, KEY3_fb, BT_fb	: OUT STD_LOGIC;
		TYPE_reg							: OUT STD_LOGIC_VECTOR (7 DOWNTO 0):= (others => '0')
		);
	END component;
	
	--------------------------------------------------------
	component TOP IS
	
 PORT (
		reset, clock										: in std_logic; 
		SW													: in std_logic_vector (7 downto 0);
		KEY1, KEY2, KEY3									: in std_logic;
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5					: out std_logic_vector(3 downto 0);
		LEDR												: out std_logic_vector(7 downto 0);
		out_signal											: out std_logic		
		);
	END component;
	
	--------------------------------------------------------
	component fpga_conc is
	port (
		reset, clock														: in std_logic; 
		KEY1, KEY2, KEY3													: in std_logic;
		SW																	: in std_logic_vector(7 downto 0);
		HEX0_out, HEX1_out, HEX2_out, HEX3_out, HEX4_out, HEX5_out			: out std_logic_vector(6 downto 0);
		LEDR																: out std_logic_vector(7 downto 0);
		out_signal															: out std_logic
		);
	end component;
	

end aux_package;