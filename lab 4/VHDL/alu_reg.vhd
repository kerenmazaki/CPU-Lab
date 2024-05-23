library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
--------------------------------------------
entity alu_reg is

	generic (n : integer := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
	port (
		x, y: in std_logic_vector(n-1 downto 0);
		ALUFN: in std_logic_vector (4 downto 0);
		clk, ena: in std_logic;
		Zflag, Cflag, Nflag: out std_logic;
		ALUout: out std_logic_vector (n-1 downto 0)
		);
end alu_reg;
--------------------------------------------
architecture st of alu_reg is
	signal  x_in, y_in: std_logic_vector(n-1 downto 0);
	signal	ALUFN_in: std_logic_vector (4 downto 0);
	signal	Zflag_out, Cflag_out, Nflag_out: std_logic;
	signal	ALUout_out: std_logic_vector (n-1 downto 0);
	
	begin
	
	L0: alu generic map (n,k,m)
			port map (x_in, y_in, ALUFN_in, ALUout_out, Nflag_out, Cflag_out, Zflag_out);
			
		process(clk,ena,x,y,ALUFN)
		begin
			if (clk'event and clk = '1') then
				if (ena = '1') then
					x_in <= x;
					y_in <= y;
					ALUFN_in <= ALUFN;
				end if;
			end if;
		end process;
		
		process (clk,ena,ALUout_out,Zflag_out,Cflag_out,Nflag_out)
		begin
			if (clk'event and clk = '1') then
				if (ena = '1') then
					ALUout <= ALUout_out;
					Zflag <= Zflag_out;
					Cflag <= Cflag_out;
					Nflag <= Nflag_out;
				end if;
			end if;
		end process;
	
	end st;