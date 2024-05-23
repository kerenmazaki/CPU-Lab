library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
LIBRARY work;
use work.aux_package.all;


entity addersub_tb is
	constant m : integer := 8;
end addersub_tb;

architecture rtb of addersub_tb is
	SIGNAL cout : STD_LOGIC;
	SIGNAL x,y,res : STD_LOGIC_VECTOR (m-1 DOWNTO 0);
	SIGNAL sub_cont: STD_LOGIC_VECTOR (2 DOWNTO 0);
begin
	L0 : AdderSub generic map (m) port map(x,y,sub_cont,cout,res);
    
	--------- start of stimulus section ------------------	
    tb : process
    begin
		  x <= (others => '1');
		  y <= (others => '0');
		  for i in 0 to 18 loop
			wait for 50 ns;
 		   x <= x-1;
 		   y <= y+2;	
		  end loop;
		  wait;
        end process tb;
		  
	tb_sub_cont : process
  	begin
    		sub_cont <="000";
    		for i in 0 to 5 loop
     			wait for 200 ns;
      			sub_cont <= sub_cont+1;
    			end loop;
    		wait;
  	end process tb_sub_cont;
  
end architecture rtb;
