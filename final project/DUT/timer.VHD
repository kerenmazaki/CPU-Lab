LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
use work.aux_package.all;
-------------------------------------
ENTITY timer IS
     
  PORT (
		MCLK, reset			: in std_logic;
		BT_fb				: in std_logic;
		data				: in std_logic_vector (31 downto 0);
		address				: in std_logic_vector (11 downto 0);
		MemWrite			: in std_logic;
		BT_int				: out std_logic := '0';
		out_signal			: out std_logic
		);
END timer;
--------------------------------------------------------------
ARCHITECTURE df OF timer IS

signal BTCTL: std_logic_vector (7 downto 0):= (5 => '1', others => '0');
signal BTCNT, out_conter, BTCCR0, BTCCR1, BTCL0, BTCL1: std_logic_vector (31 downto 0) := (others => '0');
signal CLK, MCLK2, MCLK4, MCLK8: std_logic := '0';
signal BTOUTEN, BTHOLD: std_logic;
signal BTSSEL: std_logic_vector (1 downto 0);
signal BTIPx: std_logic_vector (2 downto 0);
signal set_BTIFG: std_logic;

begin

-----------registers------------
process
	begin
		wait until (MCLK'event) and (MCLK = '1');
			if reset = '1' then
				BTCTL <= (5 => '1', others => '0');
			elsif (address = x"81C" and MemWrite = '1') then
				BTCTL <= data(7 downto 0);
			end if;
	end process;
	
process
	begin
		wait until (CLK'event) and (CLK = '1');
			if BTHOLD = '0' then
				if reset = '1' then
					BTCNT <= (others => '0');
				elsif (address = x"820" and MemWrite = '1') then
					BTCNT <= data;
				else
					BTCNT <= BTCNT + 1;
				end if;
			end if;
	end process;

process
	begin
		wait until (MCLK'event) and (MCLK = '1');
			if reset = '1' then
				BTCCR0 <= (others => '0');
			elsif (address = x"824" and MemWrite = '1') then
				BTCCR0 <= data;
			end if;
	end process;
	
process
	begin
		wait until (MCLK'event) and (MCLK = '1');
			if reset = '1' then
				BTCCR1 <= (others => '0');
			elsif (address = x"828" and MemWrite = '1') then
				BTCCR1 <= data;
			end if;
	end process;
	
--------- devide BTCTL ------------
BTOUTEN <= BTCTL(6);
BTHOLD <= BTCTL(5);
BTSSEL <= BTCTL(4 downto 3);
BTIPx <= BTCTL(2 downto 0);

-------- CLK divider---------------
process
	begin
		wait until (MCLK'event) and (MCLK = '1');
			if reset = '1' then
				MCLK2 <= '0';
			else
				MCLK2 <= not(MCLK2);
			end if;
	end process;

process
	begin
		wait until (MCLK2'event) and (MCLK2 = '1');
			if reset = '1' then
				MCLK4 <= '0';
			else
				MCLK4 <= not(MCLK4);
			end if;
	end process;
	
process
	begin
		wait until (MCLK4'event) and (MCLK4 = '1');
			if reset = '1' then
				MCLK8 <= '0';
			else
				MCLK8 <= not(MCLK8);
			end if;
	end process;

CLK <= MCLK when BTSSEL = "00" else MCLK2 when BTSSEL = "01" else MCLK4 when BTSSEL = "10" else MCLK8;

-----------set_BTIFG MUX-----------
with BTIPx select set_BTIFG <=
	BTCNT(0) when "000",
	BTCNT(3) when "001",
	BTCNT(7) when "010",
	BTCNT(11) when "011",
	BTCNT(15) when "100",
	BTCNT(19) when "101",
	BTCNT(23) when "110",
	BTCNT(25) when others;

process(BT_fb,set_BTIFG)
	begin
	if BT_fb = '1' then
		BT_int <= '0';
	elsif (set_BTIFG'event and set_BTIFG = '1' and BT_fb = '0') then
		BT_int <= '1';
	end if;
end process;

-----------compare latches---------
BTCL0 <= BTCCR0;
BTCL1 <= BTCCR1;

---------create out_signal---------
process(BTCNT, BTCL0)
	begin
		if out_conter = BTCL0 or reset = '1' then
			out_conter <= (others => '0');
		else
			out_conter <= out_conter + 1;
		end if;
	end process;

out_signal <= '1' when ((BTOUTEN = '1') and (BTCL0 = out_conter)) else
			'0' when (((BTOUTEN = '1') and (BTCL1 = out_conter)) or (reset = '1'));
end df;





