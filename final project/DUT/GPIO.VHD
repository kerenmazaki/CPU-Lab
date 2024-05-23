LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.aux_package.all;
-------------------------------------
ENTITY GPIO IS
     
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
END GPIO;
--------------------------------------------------------------
ARCHITECTURE df OF GPIO IS
signal SW_en: std_logic;
begin

--------------------------LEDR---------------------------------
LED_R: GPO_interface generic map(x"800", 8) port map (reset, data(7 downto 0), MemRead, MemWrite, address(11 downto 0), LEDR);

--------------------------HEX---------------------------------
HEX_0: GPO_interface generic map(x"804", 4) port map (reset, data(3 downto 0), MemRead, MemWrite, address(11 downto 0), HEX0);
HEX_1: GPO_interface generic map(x"805", 4) port map (reset, data(3 downto 0), MemRead, MemWrite, address(11 downto 0), HEX1);
HEX_2: GPO_interface generic map(x"808", 4) port map (reset, data(3 downto 0), MemRead, MemWrite, address(11 downto 0), HEX2);
HEX_3: GPO_interface generic map(x"809", 4) port map (reset, data(3 downto 0), MemRead, MemWrite, address(11 downto 0), HEX3);
HEX_4: GPO_interface generic map(x"80C", 4) port map (reset, data(3 downto 0), MemRead, MemWrite, address(11 downto 0), HEX4);
HEX_5: GPO_interface generic map(x"80D", 4) port map (reset, data(3 downto 0), MemRead, MemWrite, address(11 downto 0), HEX5);


-----------------------SW GPI----------------------------------
SW_en <= '1' when (address(11 downto 0) = x"810" and MemRead = '1') else '0';

data(7 downto 0) <= SW when SW_en = '1' else (others => 'Z');
data(31 downto 8) <= (others => '0') when SW_en = '1' else (others => 'Z');

-----------------------KEYs GPI----------------------------------
process(KEY1_fb,KEY1)
	begin
	if KEY1_fb = '1' then
		KEY1_int <= '0';
	elsif (KEY1'event and KEY1 = '1' and KEY1_fb = '0') then
		KEY1_int <= '1';
	end if;
end process;

process(KEY2_fb,KEY2)
	begin
	if KEY2_fb = '1' then
		KEY2_int <= '0';
	elsif (KEY2'event and KEY2 = '1' and KEY2_fb = '0') then
		KEY2_int <= '1';
	end if;
end process;

process(KEY3_fb,KEY3)
	begin
	if KEY3_fb = '1' then
		KEY3_int <= '0';
	elsif (KEY3'event and KEY3 = '1' and KEY3_fb = '0') then
		KEY3_int <= '1';
	end if;
end process;

end df;