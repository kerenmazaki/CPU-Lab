LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use work.aux_package.all;

ENTITY fpga_tb IS

END fpga_tb ;


ARCHITECTURE struct OF fpga_tb IS

	signal reset, clock													: std_logic; 
	signal KEY1, KEY2, KEY3												: std_logic;
	signal SW, LEDR														: std_logic_vector(7 downto 0);
	signal HEX0_out, HEX1_out, HEX2_out, HEX3_out, HEX4_out, HEX5_out	: std_logic_vector(6 downto 0);
	signal out_signal													: std_logic;
	signal mw_U_0clk													: std_logic;
	signal mw_U_0disable_clk 											: boolean := FALSE;
	signal mw_U_1pulse 													: std_logic :='0';


BEGIN

U_0 : fpga_conc PORT MAP (reset, clock, KEY1, KEY2, KEY3, SW, HEX0_out, HEX1_out, HEX2_out, HEX3_out, HEX4_out, HEX5_out, LEDR, out_signal);

SW <= x"2A";

   -- ModuleWare code(v1.9) for instance 'U_0' of 'clk'
u_0clk_proc:	PROCESS
					BEGIN
						WHILE NOT mw_U_0disable_clk LOOP
							mw_U_0clk <= '1', '0' AFTER 5 ns;
							WAIT FOR 10 ns;
						END LOOP;
						WAIT;
					END PROCESS u_0clk_proc;
				   
mw_U_0disable_clk <= TRUE AFTER 100000 us;
clock <= mw_U_0clk;

   -- ModuleWare code(v1.9) for instance 'U_1' of 'pulse'
   reset <= mw_U_1pulse;
   
   
u_1pulse_proc:	PROCESS
					BEGIN
						mw_U_1pulse <= '0', '1' AFTER 10 ns;
						WAIT;
					END PROCESS u_1pulse_proc;
	
KEY1 <= '1', '0' AFTER 1 us, '1' AFTER 1.5 ns;
KEY2 <= '1', '0' AFTER 2 ns, '1' AFTER 2.5 ns;
KEY3 <= '1', '0' AFTER 3 ns, '1' AFTER 3.5 ns;
	  

END struct;
