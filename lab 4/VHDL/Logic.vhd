LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY LOGIC IS
	GENERIC (n : INTEGER := 8);
	PORT (x, y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		alufn: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		 zout: OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0));
END LOGIC;
--------------------------------------------------------
ARCHITECTURE df1 OF LOGIC IS
BEGIN
	-- Assigning values to output according to ALUFN
	with alufn select
		zout <= not y when "000",
			y or x when "001",
			y and x when "010",
			y xor x when "011",
			y nor x when "100",
			y nand x when "101",
			y xnor x when "111",
			(others => '0') when others;
END df1;
