LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.aux_package.all;
-------------------------------------
ENTITY TOP IS
     
  PORT (
		reset, clock										: in std_logic; 
		SW													: in std_logic_vector (7 downto 0);
		KEY1, KEY2, KEY3									: in std_logic;
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5					: out std_logic_vector(3 downto 0);
		LEDR												: out std_logic_vector(7 downto 0);
		out_signal											: out std_logic		
		);
END TOP;
--------------------------------------------------------------
ARCHITECTURE df OF TOP IS

		SIGNAL MemWrite_out											:  STD_LOGIC;
		SIGNAL MemRead_out											:  STD_LOGIC;
		SIGNAL TYPE_reg												:  STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		SIGNAL data													:  STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		SIGNAL address												:  STD_LOGIC_VECTOR( 31 DOWNTO 0 );	
		SIGNAL INTR													:  STD_LOGIC;
		SIGNAL INTA													:  STD_LOGIC;
		SIGNAL GIE													:  STD_LOGIC;
		SIGNAL KEY1_int, KEY2_int, KEY3_int, BT_int					:  STD_LOGIC;
		SIGNAL KEY1_fb, KEY2_fb, KEY3_fb, BT_fb						:  STD_LOGIC;

begin

MIPS_entity: MIPS port map (reset, clock, INTR, TYPE_reg, data, address, INTA, GIE, MemRead_out, MemWrite_out);
							
GPIO_entity: GPIO port map (reset,SW, KEY1, KEY2, KEY3, address(11 downto 0), KEY1_fb, KEY2_fb, KEY3_fb, data, MemRead_out,
							MemWrite_out, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, KEY1_int, KEY2_int, KEY3_int);

timer_entity: timer port map (clock, reset, BT_fb, data, address(11 downto 0), MemWrite_out, BT_int, out_signal);

INT_CTL_entity: INT_CTL port map (clock, reset, address(11 downto 0), GIE, MemRead_out, MemWrite_out, data, INTA, BT_int,
								KEY1_int, KEY2_int, KEY3_int, INTR, KEY1_fb, KEY2_fb, KEY3_fb, BT_fb, TYPE_reg);


end df;





