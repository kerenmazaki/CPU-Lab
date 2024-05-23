LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
use work.aux_package.all;
-------------------------------------
ENTITY INT_CTL IS
  PORT (
		clock, reset						: IN STD_LOGIC;
		address 							: IN STD_LOGIC_VECTOR(11 downto 0);
		GIE									: IN STD_LOGIC;
		MemRead, MemWrite					: IN STD_LOGIC;
		
		data								: INOUT STD_LOGIC_VECTOR(31 downto 0);

		clr_irq								: IN STD_LOGIC;
		BT_int								: IN STD_LOGIC; --BT intterupt request "set_BTIFG"
		KEY1_int, KEY2_int, KEY3_int		: IN STD_LOGIC;
		INTR_out							: OUT STD_LOGIC;
		KEY1_fb, KEY2_fb, KEY3_fb, BT_fb	: OUT STD_LOGIC := '0';
		TYPE_reg							: OUT STD_LOGIC_VECTOR (7 DOWNTO 0):= (others => '0')
		);
		
END INT_CTL;
--------------------------------------------------------------
ARCHITECTURE df OF INT_CTL IS

	SIGNAL IE_reg						: STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
	SIGNAL IFG_reg						: STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
	SIGNAL irq							: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	SIGNAL INTR							: STD_LOGIC;
	SIGNAL top_priority					: integer;

	--signal KEY1_int, KEY2_int, KEY3_int	: STD_LOGIC := '0';
begin

-------------------interrupt handler------------------
PROCESS(clock, BT_int, KEY1_int, KEY2_int, KEY3_int, top_priority, clr_irq)
	BEGIN
	IF (clock'event and clock = '1') THEN
		IF BT_int = '1' THEN
			IF (clr_irq = '1' and top_priority = 2) THEN
				irq(2) <= '0';
				BT_fb <= '1';
			ELSE
				irq(2) <= '1';
			END IF;
		ELSE
			BT_fb <= '0';
		END IF;
		
		IF KEY1_int = '1' THEN
			IF (clr_irq = '1' and top_priority = 3) THEN
					irq(3) <= '0';
					KEY1_fb <= '1';
			ELSE
					irq(3) <= '1';
			END IF;
		ELSE
			KEY1_fb <= '0';
		END IF;
		
		IF KEY2_int = '1' THEN
			IF (clr_irq = '1' and top_priority = 4) THEN
					irq(4) <= '0'; 
					KEY2_fb <= '1';
			ELSE
					irq(4) <= '1';
			END IF;
		ELSE
			KEY2_fb <= '0';
		END IF;
		
		IF KEY3_int = '1' THEN
			IF (clr_irq = '1' and top_priority = 5) THEN
					irq(5) <= '0'; 
					KEY3_fb <= '1';
			ELSE
					irq(5) <= '1';
			END IF;
		ELSE
			KEY3_fb <= '0';
		END IF;
	END IF;
		
	-- update irq -> irq <= ((irq(3 downto 0) & '0') and irq)
		
END PROCESS;
	
	INTR <= ((IFG_reg(0) or IFG_reg(1) or IFG_reg(2) or IFG_reg(3)
			or IFG_reg(4) or IFG_reg(5) or IFG_reg(6) or IFG_reg(7))
			and GIE) or reset;
			
	INTR_out <= INTR;
---------------interrupt registers--------------------

process(clock, reset, data, address, MemWrite)
	begin
	if rising_edge(clock) then
		if reset = '1' then
			IE_reg <= (others => '0');
		elsif (address = x"82C" and MemWrite = '1') then
			IE_reg <= data(7 downto 0);
		end if;
	end if;
end process;
			
process(clock, reset, data, address, MemWrite, irq, IE_reg)
	begin
	if rising_edge(clock) then
		if reset = '1' then
			IFG_reg <= (others => '0');
		elsif (address = x"82D" and MemWrite = '1') then
			IFG_reg <= data(7 downto 0);
		else
			IFG_reg <= irq and IE_reg;
		end if;
	end if;
end process;
	
process(clock, reset, data, address, MemWrite, IFG_reg)
	begin
	if rising_edge(clock) then
		if reset = '1' then
			TYPE_reg <= (others => '0');
		elsif (address = x"82E" and MemWrite = '1') then
			TYPE_reg <= data(7 downto 0);
		else
			if IFG_reg(2) = '1' then
				TYPE_reg <= X"10";
				top_priority <= 2;
				
			elsif IFG_reg(3) = '1' then
				TYPE_reg <= X"14";
				top_priority <= 3;
				
			elsif IFG_reg(4) = '1' then
				TYPE_reg <= X"18";
				top_priority <= 4;
				
			elsif IFG_reg(5) = '1' then
				TYPE_reg <= X"1C";
				top_priority <= 5;
			end if;
		end if;
	end if;
end process;

data <= x"000000" & IE_reg when (address = x"82C" and MemRead = '1') else (others => 'Z');
data <= x"000000" & IFG_reg when (address = x"82D" and MemRead = '1') else (others => 'Z');

end df;