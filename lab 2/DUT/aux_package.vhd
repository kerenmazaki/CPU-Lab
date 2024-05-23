LIBRARY ieee;
USE ieee.std_logic_1164.all;


package aux_package is

	component top is
		generic ( n : positive := 8 ); 
		port( rst,clk : in std_logic;
		  upperBound : in std_logic_vector(n-1 downto 0);
		  countOut : out std_logic_vector(n-1 downto 0));
	end component;
	
end aux_package;

