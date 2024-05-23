LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.aux_package.all;

-------------------------------------
ENTITY GPO_interface IS  

		generic (per_address: std_logic_vector(11 downto 0); out_len: integer);

  PORT (
		reset: in std_logic;
		data: inout std_logic_vector (out_len-1 downto 0);
		MemRead: in std_logic;
		MemWrite: in std_logic;
		address: in std_logic_vector(11 downto 0);
		GPO_out: out std_logic_vector (out_len-1 downto 0)
		);
END GPO_interface;
--------------------------------------------------------------
ARCHITECTURE df OF GPO_interface IS

signal write_en, read_en: std_logic;
signal Q: std_logic_vector (out_len-1 downto 0):= (others => '0');
begin

	write_en <= '1' when (address = per_address and MemWrite = '1') else '0';
	Q <= (others => '0') when reset = '1' else data when write_en = '1' else Q;
	
	read_en <= '1' when (address = per_address and MemRead = '1') else '0';
	data <= Q when read_en = '1' else (others => 'Z');
	
	GPO_out <= Q;

end df;





