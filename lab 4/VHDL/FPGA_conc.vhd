library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
--------------------------------------------
entity fpga_conc is
	generic (n : integer := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
	port (input: in std_logic_vector (n-1 downto 0); 
		  clk, ena_y ,ena_x ,ena_alu : in std_logic;
		  ALUFN_out: out std_logic_vector (4 downto 0);
		  y_lsb, y_msb, x_lsb, x_msb, ALUout_lsb, ALUout_msb: out std_logic_vector (0 to 6);
		  Nflag, Cflag, Zflag: out std_logic); -- Zflag,Cflag,Nflag
end fpga_conc;
------------- complete the top Architecture code --------------
architecture struct of fpga_conc is 
	signal x, y, ALUout: std_logic_vector(n-1 downto 0); ---from input_register to alu
	signal alufn: std_logic_vector(4 downto 0); ---from input_register to alu
begin

L0: alu generic map (n,k,m) port map (y, x, alufn, ALUout, Nflag, Cflag, Zflag);

-------input register-------
	
	process (ena_x)         
	begin
		if ena_x = '0' then
			x <= input;
		end if;
	end process;
	
	process (ena_y)         
	begin
		if ena_y = '0' then
			y <= input;
		end if;
	end process;
	
	process (ena_alu)         
	begin
		if ena_alu = '0' then
			alufn <= input(4 downto 0);
		end if;
	end process;

	ALUFN_out <= alufn;
	
------------hexa 7-segement -display-------------
process(x)
begin
    case x(3 downto 0) is
		when "0000" => x_lsb <= "0000001"; -- "0"     
		when "0001" => x_lsb <= "1001111"; -- "1" 
		when "0010" => x_lsb <= "0010010"; -- "2" 
		when "0011" => x_lsb <= "0000110"; -- "3" 
		when "0100" => x_lsb <= "1001100"; -- "4" 
		when "0101" => x_lsb <= "0100100"; -- "5" 
		when "0110" => x_lsb <= "0100000"; -- "6" 
		when "0111" => x_lsb <= "0001111"; -- "7" 
		when "1000" => x_lsb <= "0000000"; -- "8"     
		when "1001" => x_lsb <= "0000100"; -- "9" 
		when "1010" => x_lsb <= "0001000"; -- A
		when "1011" => x_lsb <= "1100000"; -- b
		when "1100" => x_lsb <= "0110001"; -- C
		when "1101" => x_lsb <= "1000010"; -- d
		when "1110" => x_lsb <= "0110000"; -- E
		when "1111" => x_lsb <= "0111000"; -- F
		when others => x_lsb <= "1111111"; -- else
    end case;
end process;

process(x)
begin
    case x(7 downto 4) is
		when "0000" => x_msb <= "0000001"; -- "0"     
		when "0001" => x_msb <= "1001111"; -- "1" 
		when "0010" => x_msb <= "0010010"; -- "2" 
		when "0011" => x_msb <= "0000110"; -- "3" 
		when "0100" => x_msb <= "1001100"; -- "4" 
		when "0101" => x_msb <= "0100100"; -- "5" 
		when "0110" => x_msb <= "0100000"; -- "6" 
		when "0111" => x_msb <= "0001111"; -- "7" 
		when "1000" => x_msb <= "0000000"; -- "8"     
		when "1001" => x_msb <= "0000100"; -- "9" 
		when "1010" => x_msb <= "0001000"; -- A
		when "1011" => x_msb <= "1100000"; -- b
		when "1100" => x_msb <= "0110001"; -- C
		when "1101" => x_msb <= "1000010"; -- d
		when "1110" => x_msb <= "0110000"; -- E
		when "1111" => x_msb <= "0111000"; -- F
		when others => x_msb <= "1111111"; -- else
    end case;
end process;

process(y)
begin
    case y(3 downto 0) is
		when "0000" => y_lsb <= "0000001"; -- "0"     
		when "0001" => y_lsb <= "1001111"; -- "1" 
		when "0010" => y_lsb <= "0010010"; -- "2" 
		when "0011" => y_lsb <= "0000110"; -- "3" 
		when "0100" => y_lsb <= "1001100"; -- "4" 
		when "0101" => y_lsb <= "0100100"; -- "5" 
		when "0110" => y_lsb <= "0100000"; -- "6" 
		when "0111" => y_lsb <= "0001111"; -- "7" 
		when "1000" => y_lsb <= "0000000"; -- "8"     
		when "1001" => y_lsb <= "0000100"; -- "9" 
		when "1010" => y_lsb <= "0001000"; -- A
		when "1011" => y_lsb <= "1100000"; -- b
		when "1100" => y_lsb <= "0110001"; -- C
		when "1101" => y_lsb <= "1000010"; -- d
		when "1110" => y_lsb <= "0110000"; -- E
		when "1111" => y_lsb <= "0111000"; -- F
		when others => y_lsb <= "1111111"; -- else
    end case;
end process;

process(y)
begin
    case y(7 downto 4) is
		when "0000" => y_msb <= "0000001"; -- "0"     
		when "0001" => y_msb <= "1001111"; -- "1" 
		when "0010" => y_msb <= "0010010"; -- "2" 
		when "0011" => y_msb <= "0000110"; -- "3" 
		when "0100" => y_msb <= "1001100"; -- "4" 
		when "0101" => y_msb <= "0100100"; -- "5" 
		when "0110" => y_msb <= "0100000"; -- "6" 
		when "0111" => y_msb <= "0001111"; -- "7" 
		when "1000" => y_msb <= "0000000"; -- "8"     
		when "1001" => y_msb <= "0000100"; -- "9" 
		when "1010" => y_msb <= "0001000"; -- A
		when "1011" => y_msb <= "1100000"; -- b
		when "1100" => y_msb <= "0110001"; -- C
		when "1101" => y_msb <= "1000010"; -- d
		when "1110" => y_msb <= "0110000"; -- E
		when "1111" => y_msb <= "0111000"; -- F
		when others => y_msb <= "1111111"; -- else
    end case;
end process;

process(ALUout)
begin
    case ALUout(3 downto 0) is
		when "0000" => ALUout_lsb <= "0000001"; -- "0"     
		when "0001" => ALUout_lsb <= "1001111"; -- "1" 
		when "0010" => ALUout_lsb <= "0010010"; -- "2" 
		when "0011" => ALUout_lsb <= "0000110"; -- "3" 
		when "0100" => ALUout_lsb <= "1001100"; -- "4" 
		when "0101" => ALUout_lsb <= "0100100"; -- "5" 
		when "0110" => ALUout_lsb <= "0100000"; -- "6" 
		when "0111" => ALUout_lsb <= "0001111"; -- "7" 
		when "1000" => ALUout_lsb <= "0000000"; -- "8"     
		when "1001" => ALUout_lsb <= "0000100"; -- "9" 
		when "1010" => ALUout_lsb <= "0001000"; -- A
		when "1011" => ALUout_lsb <= "1100000"; -- b
		when "1100" => ALUout_lsb <= "0110001"; -- C
		when "1101" => ALUout_lsb <= "1000010"; -- d
		when "1110" => ALUout_lsb <= "0110000"; -- E
		when "1111" => ALUout_lsb <= "0111000"; -- F
		when others => ALUout_lsb <= "1111111"; -- else
    end case;
end process;

process(ALUout)
begin
    case ALUout(7 downto 4) is
		when "0000" => ALUout_msb <= "0000001"; -- "0"     
		when "0001" => ALUout_msb <= "1001111"; -- "1" 
		when "0010" => ALUout_msb <= "0010010"; -- "2" 
		when "0011" => ALUout_msb <= "0000110"; -- "3" 
		when "0100" => ALUout_msb <= "1001100"; -- "4" 
		when "0101" => ALUout_msb <= "0100100"; -- "5" 
		when "0110" => ALUout_msb <= "0100000"; -- "6" 
		when "0111" => ALUout_msb <= "0001111"; -- "7" 
		when "1000" => ALUout_msb <= "0000000"; -- "8"     
		when "1001" => ALUout_msb <= "0000100"; -- "9" 
		when "1010" => ALUout_msb <= "0001000"; -- A
		when "1011" => ALUout_msb <= "1100000"; -- b
		when "1100" => ALUout_msb <= "0110001"; -- C
		when "1101" => ALUout_msb <= "1000010"; -- d
		when "1110" => ALUout_msb <= "0110000"; -- E
		when "1111" => ALUout_msb <= "0111000"; -- F
		when others => ALUout_msb <= "1111111"; -- else
    end case;
end process;
end struct; 
	