library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
--------------------------------------------
entity FPGA_tb is

	constant n : integer := 8;
	constant k : integer := 3;    -- k=log2(n)
	constant m : integer := 4;   -- m=2^(k-1)
	constant IcacheSize : integer := 20-1;
end FPGA_tb;
------------------------------------------------------------------------------
architecture rtb of FPGA_tb is
	type mem is array (0 to IcacheSize) of std_logic_vector(4 downto 0);
	SIGNAL input, y, x: std_logic_vector (n-1 downto 0); 
	SIGNAL clk, ena_y ,ena_x ,ena_alu : std_logic;
	SIGNAL ALUFN_out: std_logic_vector (4 downto 0);
	SIGNAL y_lsb, y_msb, x_lsb, x_msb, ALUout_lsb, ALUout_msb: std_logic_vector (0 to 6);
	SIGNAL Nflag, Cflag, Zflag: std_logic;
	SIGNAL Icache : mem := (
							"01000","01000","01001","01001","01010","10000","10000","10001","10001","10010",
							"10010","11000","11001","11010","11011","11100","11101","11111","00000","00100");
begin
	L0 : FPGA_conc generic map (n,k,m) port map(input, clk, ena_y ,ena_x ,ena_alu, ALUFN_out,
												y_lsb, y_msb, x_lsb, x_msb, ALUout_lsb,
												ALUout_msb, Nflag, Cflag, Zflag);
	--------- start of stimulus section ---------------------------------------		
	clk <= '0';
	
	tb_input: process
    begin
		input <= (others => '0');
		x <= (others => '0');
		y <= (others => '1');
		ena_alu <= '1';
		ena_x <= '1';
		ena_y <= '1';
		for i in 0 to IcacheSize loop
			wait for 10 ns;
			input(4 downto 0) <= Icache(i);
			ena_alu <= '0';
			wait for 10 ns;
			ena_alu <= '1';
			input <= x+2;
			ena_x <= '0';
			wait for 10 ns;
			ena_x <= '1';
			input <= y-1;
			ena_y <= '0';
			wait for 80 ns;
		end loop;
		wait;
    end process;

  
end architecture rtb;