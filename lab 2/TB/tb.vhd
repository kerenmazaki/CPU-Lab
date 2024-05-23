library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library work;
USE work.aux_package.all;
---------------------------------------------------------
entity tb is
	constant n : integer := 8;
end tb;
---------------------------------------------------------
architecture rtb of tb is
	signal rst,clk : std_logic;
	signal upperBound : std_logic_vector(n-1 downto 0);
	signal countOut : std_logic_vector(n-1 downto 0);
begin
	L0 : top generic map (n) port map(rst,clk,upperBound,countOut);
    
	--------- start of stimulus section ------------------	
        gen_clk : process
        begin
		  clk <= '0';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
				
		gen_upperBound : process
        begin
		  upperBound <= (1=>'1',0=>'0',others => '0');
		  for i in 0 to 3 loop
			wait for 900 ns;
				upperBound <= upperBound+1;
		  end loop;

		for i in 0 to 1 loop
			wait for 900 ns;
				upperBound <= upperBound-2;
		  end loop;
        end process;
		  
		gen_rst : process
        begin
		rst <='1';
		wait for 100 ns;
		rst <= '0';
		wait for 2000 ns;
		rst <='1';
		wait for 100 ns;
		rst <= '0';	
		wait;
        end process; 
		
end architecture rtb;
