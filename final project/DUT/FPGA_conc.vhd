library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
--------------------------------------------
entity fpga_conc is
	port (
		reset, clock														: in std_logic; 
		KEY1, KEY2, KEY3													: in std_logic;
		SW																	: in std_logic_vector(7 downto 0);
		HEX0_out, HEX1_out, HEX2_out, HEX3_out, HEX4_out, HEX5_out			: out std_logic_vector(0 to 6);
		LEDR																: out std_logic_vector(7 downto 0);
		out_signal															: out std_logic
		);
end fpga_conc;
------------- complete the top Architecture code --------------
architecture struct of fpga_conc is 

signal HEX0, HEX1, HEX2, HEX3, HEX4, HEX5			: std_logic_vector(3 downto 0);
signal KEY1_revr, KEY2_revr, KEY3_revr, reset_revr	: std_logic;

begin

KEY1_revr <= not(KEY1);
KEY2_revr <= not(KEY2);
KEY3_revr <= not(KEY3);
reset_revr <= not(reset);

U_0 : TOP PORT MAP (reset_revr, clock, SW, KEY1_revr, KEY2_revr, KEY3_revr, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, out_signal);

	
------------hexa 7-segement -display-------------
process(HEX0)
begin
    case HEX0 is
		when "0000" => HEX0_out <= "0000001"; -- "0"     
		when "0001" => HEX0_out <= "1001111"; -- "1" 
		when "0010" => HEX0_out <= "0010010"; -- "2" 
		when "0011" => HEX0_out <= "0000110"; -- "3" 
		when "0100" => HEX0_out <= "1001100"; -- "4" 
		when "0101" => HEX0_out <= "0100100"; -- "5" 
		when "0110" => HEX0_out <= "0100000"; -- "6" 
		when "0111" => HEX0_out <= "0001111"; -- "7" 
		when "1000" => HEX0_out <= "0000000"; -- "8"     
		when "1001" => HEX0_out <= "0000100"; -- "9" 
		when "1010" => HEX0_out <= "0001000"; -- A
		when "1011" => HEX0_out <= "1100000"; -- b
		when "1100" => HEX0_out <= "0110001"; -- C
		when "1101" => HEX0_out <= "1000010"; -- d
		when "1110" => HEX0_out <= "0110000"; -- E
		when "1111" => HEX0_out <= "0111000"; -- F
		when others => HEX0_out <= "1111111"; -- else
    end case;
end process;

process(HEX1)
begin
    case HEX1 is
		when "0000" => HEX1_out <= "0000001"; -- "0"     
		when "0001" => HEX1_out <= "1001111"; -- "1" 
		when "0010" => HEX1_out <= "0010010"; -- "2" 
		when "0011" => HEX1_out <= "0000110"; -- "3" 
		when "0100" => HEX1_out <= "1001100"; -- "4" 
		when "0101" => HEX1_out <= "0100100"; -- "5" 
		when "0110" => HEX1_out <= "0100000"; -- "6" 
		when "0111" => HEX1_out <= "0001111"; -- "7" 
		when "1000" => HEX1_out <= "0000000"; -- "8"     
		when "1001" => HEX1_out <= "0000100"; -- "9" 
		when "1010" => HEX1_out <= "0001000"; -- A
		when "1011" => HEX1_out <= "1100000"; -- b
		when "1100" => HEX1_out <= "0110001"; -- C
		when "1101" => HEX1_out <= "1000010"; -- d
		when "1110" => HEX1_out <= "0110000"; -- E
		when "1111" => HEX1_out <= "0111000"; -- F
		when others => HEX1_out <= "1111111"; -- else
    end case;
end process;

process(HEX2)
begin
    case HEX2 is
		when "0000" => HEX2_out <= "0000001"; -- "0"     
		when "0001" => HEX2_out <= "1001111"; -- "1" 
		when "0010" => HEX2_out <= "0010010"; -- "2" 
		when "0011" => HEX2_out <= "0000110"; -- "3" 
		when "0100" => HEX2_out <= "1001100"; -- "4" 
		when "0101" => HEX2_out <= "0100100"; -- "5" 
		when "0110" => HEX2_out <= "0100000"; -- "6" 
		when "0111" => HEX2_out <= "0001111"; -- "7" 
		when "1000" => HEX2_out <= "0000000"; -- "8"     
		when "1001" => HEX2_out <= "0000100"; -- "9" 
		when "1010" => HEX2_out <= "0001000"; -- A
		when "1011" => HEX2_out <= "1100000"; -- b
		when "1100" => HEX2_out <= "0110001"; -- C
		when "1101" => HEX2_out <= "1000010"; -- d
		when "1110" => HEX2_out <= "0110000"; -- E
		when "1111" => HEX2_out <= "0111000"; -- F
		when others => HEX2_out <= "1111111"; -- else
    end case;
end process;

process(HEX3)
begin
    case HEX3 is
		when "0000" => HEX3_out <= "0000001"; -- "0"     
		when "0001" => HEX3_out <= "1001111"; -- "1" 
		when "0010" => HEX3_out <= "0010010"; -- "2" 
		when "0011" => HEX3_out <= "0000110"; -- "3" 
		when "0100" => HEX3_out <= "1001100"; -- "4" 
		when "0101" => HEX3_out <= "0100100"; -- "5" 
		when "0110" => HEX3_out <= "0100000"; -- "6" 
		when "0111" => HEX3_out <= "0001111"; -- "7" 
		when "1000" => HEX3_out <= "0000000"; -- "8"     
		when "1001" => HEX3_out <= "0000100"; -- "9" 
		when "1010" => HEX3_out <= "0001000"; -- A
		when "1011" => HEX3_out <= "1100000"; -- b
		when "1100" => HEX3_out <= "0110001"; -- C
		when "1101" => HEX3_out <= "1000010"; -- d
		when "1110" => HEX3_out <= "0110000"; -- E
		when "1111" => HEX3_out <= "0111000"; -- F
		when others => HEX3_out <= "1111111"; -- else
    end case;
end process;

process(HEX4)
begin
    case HEX4 is
		when "0000" => HEX4_out <= "0000001"; -- "0"     
		when "0001" => HEX4_out <= "1001111"; -- "1" 
		when "0010" => HEX4_out <= "0010010"; -- "2" 
		when "0011" => HEX4_out <= "0000110"; -- "3" 
		when "0100" => HEX4_out <= "1001100"; -- "4" 
		when "0101" => HEX4_out <= "0100100"; -- "5" 
		when "0110" => HEX4_out <= "0100000"; -- "6" 
		when "0111" => HEX4_out <= "0001111"; -- "7" 
		when "1000" => HEX4_out <= "0000000"; -- "8"     
		when "1001" => HEX4_out <= "0000100"; -- "9" 
		when "1010" => HEX4_out <= "0001000"; -- A
		when "1011" => HEX4_out <= "1100000"; -- b
		when "1100" => HEX4_out <= "0110001"; -- C
		when "1101" => HEX4_out <= "1000010"; -- d
		when "1110" => HEX4_out <= "0110000"; -- E
		when "1111" => HEX4_out <= "0111000"; -- F
		when others => HEX4_out <= "1111111"; -- else
    end case;
end process;

process(HEX5)
begin
    case HEX5 is
		when "0000" => HEX5_out <= "0000001"; -- "0"     
		when "0001" => HEX5_out <= "1001111"; -- "1" 
		when "0010" => HEX5_out <= "0010010"; -- "2" 
		when "0011" => HEX5_out <= "0000110"; -- "3" 
		when "0100" => HEX5_out <= "1001100"; -- "4" 
		when "0101" => HEX5_out <= "0100100"; -- "5" 
		when "0110" => HEX5_out <= "0100000"; -- "6" 
		when "0111" => HEX5_out <= "0001111"; -- "7" 
		when "1000" => HEX5_out <= "0000000"; -- "8"     
		when "1001" => HEX5_out <= "0000100"; -- "9" 
		when "1010" => HEX5_out <= "0001000"; -- A
		when "1011" => HEX5_out <= "1100000"; -- b
		when "1100" => HEX5_out <= "0110001"; -- C
		when "1101" => HEX5_out <= "1000010"; -- d
		when "1110" => HEX5_out <= "0110000"; -- E
		when "1111" => HEX5_out <= "0111000"; -- F
		when others => HEX5_out <= "1111111"; -- else
    end case;
end process;


end struct; 
	