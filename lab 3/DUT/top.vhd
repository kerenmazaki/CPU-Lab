LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
-------------------------------------
entity top is

	port(
		rst, ena, clk: in std_logic;
		tb_active, tb_PMen, tbmem_wr: in std_logic;
		tbbus, tbDin, tb_PMdatain: in std_logic_vector(15 downto 0);
		tbPMwriteAddr, tbMemAddr_reg: in std_logic_vector(5 downto 0);
		done_control: out std_logic;
		tb_DMdataout: out std_logic_vector(15 downto 0)
	);
end top;
-------------------------------------
architecture st of top is 
	signal add, sub, nop, shl, jmp, jc, jnc, mov, ld, st, done_opc, Cin, Ain,
			Nflag, Zflag, Cflag, mem_in, mem_out, mem_wr, Cout, RFin,
			RFout, IRin, PCin, imm1_in, imm2_in: std_logic;
	signal PCsel, RFaddr: std_logic_vector(1 downto 0);
	signal opc: std_logic_vector(3 downto 0);
	
begin
	L0 : DataPath port map(
						rst, clk, tb_active, tbmem_wr, IRin, imm1_in, imm2_in, RFout, RFin,
						Ain, Cin, Cout, mem_in, mem_out, mem_wr, PCin, tb_PMen,
						tbbus, tbDin, tb_PMdatain, tbPMwriteAddr, tbMemAddr_reg, opc,
						RFaddr, PCsel, add, sub, nop, shl, jmp, jc, jnc, mov, ld, st, done_opc,
						Nflag, Zflag, Cflag, tb_DMdataout
						);
						
	cont : control port map(
						rst, ena, clk, add, sub, nop, shl, jmp, jc, jnc, mov, ld, st, done_opc,
						Nflag, Zflag, Cflag, mem_in, mem_out, mem_wr, Cout, Cin,  Ain, RFin, 
						RFout, IRin, PCin, imm1_in, imm2_in, done_control, PCsel, RFaddr, opc
	);	
	
end st;
