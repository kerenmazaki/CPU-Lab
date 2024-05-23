LIBRARY ieee;
USE ieee.std_logic_1164.all;
LIBRARY work;
use work.aux_package.all;
-------------------------------------
ENTITY AdderSub IS
  GENERIC (n : INTEGER := 8);
  PORT (x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	    sub_cont: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        cout: OUT STD_LOGIC;
        res: OUT STD_LOGIC_VECTOR(n-1 downto 0));
END AdderSub;
--------------------------------------------------------------
ARCHITECTURE df3 OF AdderSub IS
	SIGNAL reg, x_in, y_in: std_logic_vector(n-1 DOWNTO 0);
	SIGNAL c_in: std_logic;
	SIGNAL temp_xor: std_logic_vector(n-1 DOWNTO 0) :=  (others => '1'); -- '1' vector for preforming xor with x input when wanted (subtractor or negative).

BEGIN
  -- x,y,c input according to alufn function, full explanation for method at readme.txt
	with sub_cont select
		y_in <= y when "000",
		y when "001",
		(others => '0') when others; -- y=0 when wanting to calculate neg(x), or not valid input that will resault with output 0.
	with sub_cont select
		x_in <= x when "000",
		x XOR temp_xor when "001",
		x XOR temp_xor when "010", -- For subtracting or calculating neg(x) using xor on each bit.
		(others => '0') when others; -- x=0 when the input is not valid, and will result with output 0.
	with sub_cont select
		c_in <= '1' when "001",
		'1' when "010", -- c=1 when we want to subtract or get neg(x)
		'0' when others;
	
	-- calculating using FA
	first : FA port map(
			xi => x_in(0),
			yi => y_in(0),
			cin => c_in,
			s => res(0),
			cout => reg(0)
		);
	
	rest : for i in 1 to n-1 generate
		chain : FA port map(
			xi => x_in(i) ,
			yi => y_in(i),
			cin => reg(i-1),
			s => res(i),
			cout => reg(i)
		);
	end generate;
		
	cout <= reg(n-1);
END df3;
