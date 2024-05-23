library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb_control is
end tb_control;
--------------------------------------------------
architecture rtb of tb_control is
	
	signal rst,ena,clk, add, sub, nop, jmp, jc, jnc, mov, ld, st, done_opc: std_logic;
	signal mem_in, mem_out, mem_wr, Cout, Cin,  Ain, RFin, RFout, IRin, PCin, imm1_in, imm2_in, done_control, Nflag, Zflag, Cflag: std_logic;
	signal PCsel, RFaddr: std_logic_vector(1 downto 0);
	signal opc: std_logic_vector(3 downto 0);
begin
	
	cont : control port map(
							rst, ena, clk, add, sub, nop, jmp, jc, jnc, mov, ld, st, done_opc, Nflag, Zflag, Cflag,
							mem_in, mem_out, mem_wr, Cout, Cin, Ain, RFin, RFout, IRin, PCin, imm1_in, imm2_in,
							done_control,PCsel, RFaddr, opc
							);
		
------------------------------------------------		
clock : process
        begin
			clk <= '1';
			wait for 50 ns;
			clk <= not clk;
			wait for 50 ns;
        end process;
		
--------------------------------------------------
		
start_sim: process
	begin
		rst <= '1' , '0' after 100 ns;
		ena <= '1';
		add <= '0', '1' after 200 ns,  '0' after 300 ns;
		sub <= '0', '1' after 700 ns,  '0' after 800 ns;
		nop <= '0', '1' after 1200 ns ,'0' after 1300 ns;
		jmp <= '0', '1' after 1700 ns , '0' after 1800 ns;
		jc <= '0', '1' after 2000 ns , '0' after 2100 ns, '1' after 2300 ns, '0' after 2400 ns;
		jnc <= '0', '1' after 2600 ns , '0' after 2700 ns, '1' after 2900 ns, '0' after 3000 ns;
		mov <= '0', '1' after 3200 ns , '0' after 3300 ns;
		ld <= '0', '1' after 3500 ns , '0' after 3600 ns;
		st <= '0', '1' after 4100 ns , '0' after 4200 ns;
		done_opc <= '0', '1' after 4700 ns;
		Cflag <= '0', '1' after 2300 ns , '0' after 2400 ns, '1' after 2900 ns , '0' after 3000 ns;
		Nflag <= '0', '1' after 4700 ns;
		Zflag <= '0', '1' after 4700 ns;
		wait;
		
	end process;


end architecture rtb;
