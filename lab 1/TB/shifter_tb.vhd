library IEEE;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

entity shifter_tb is
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
end shifter_tb;

architecture rtb of shifter_tb is
	SIGNAL cout : STD_LOGIC;
	SIGNAL x,y,res : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	SIGNAL dir : STD_LOGIC_VECTOR (2 DOWNTO 0); -- ALUFN[2;0]
begin
	L0 : shifter generic map (n,k,m) port map(
	    dir => dir,
	    x => x,
	    y => y,
	    cout => cout,
	    res => res);
    
	--------- start of stimulus section ------------------	
  shifter_tb : process
  begin
    for j in 0 to 5 loop
      
		  x <= (others => '0');
		  y <= "11010111";
		  for i in 0 to 7 loop
			wait for 50 ns;
			x <= x+1;
		  end loop;
		  
		  y <= "00101010";
		  x <= (others => '0');
		  for i in 0 to 7 loop
			wait for 50 ns;
			x <= x+1;
		  end loop;
		 end loop;
		 wait;
        end process;
		  
	dir_tb : process
      begin
        dir <= "000";
        for i in 0 to 2 loop
		      wait for 800 ns;
		      dir <= dir + 1;
		     end loop;
		     wait;
          end process dir_tb; 
  
end architecture rtb;
