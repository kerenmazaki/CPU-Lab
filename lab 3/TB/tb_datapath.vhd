library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use work.aux_package.all;
---------------------------------------------------------
entity tb_datapath is
end tb_datapath;
------------------------------------------------------------------------------
architecture rtb of tb_datapath is
	signal gen_PM, gen_DM, gen_out: boolean:= true; 	
	signal PM_done, DM_done, DM_out_done: boolean:= false;
	signal tb_active, clk, rst, ena, tbmem_wr, IRin, imm1_in, imm2_in, PCin, RFout, RFin, Ain, Cin,
	Cout, mem_in, mem_out, mem_wr, tb_PMen, add, sub, nop, jmp, jc, jnc,
	mov, ld, st, done_opc, Nflag, Zflag, Cflag, done_control: std_logic;
	signal tbbus, tbDin, tb_PMdatain, tb_DMdataout: std_logic_vector(15 downto 0);
	signal tbPMwriteAddr, tbMemAddr_reg: std_logic_vector(5 downto 0);
	signal opc: std_logic_vector(3 downto 0);
	signal RFaddr, PCsel: std_logic_vector(1 downto 0);
	constant ITCMinit_txt_location: string(1 to 113):=
	"C:\Users\keren\Documents\school\third year\semester b\CPU lab\lab 3\308374529_318501335\Memory files\ITCMinit.txt";
	constant DTCMinit_txt_location: string(1 to 113):=
	"C:\Users\keren\Documents\school\third year\semester b\CPU lab\lab 3\308374529_318501335\Memory files\DTCMinit.txt";
	constant DTCMcontent_txt_location: string(1 to 116):=
	"C:\Users\keren\Documents\school\third year\semester b\CPU lab\lab 3\308374529_318501335\Memory files\DTCMcontent.txt";
	
begin
	L0 : DataPath port map(
						rst, clk, tb_active, tbmem_wr, IRin, imm1_in, imm2_in,
						RFout, RFin, Ain, Cin, Cout, mem_in, mem_out, mem_wr,
						PCin, tb_PMen, tbbus, tbDin, tb_PMdatain, tbPMwriteAddr,
						tbMemAddr_reg, opc, RFaddr, PCsel, add, sub, nop, jmp, jc, jnc,
						mov, ld, st, done_opc, Nflag, Zflag, Cflag, tb_DMdataout
						);

----------init Program Memory----------------------------------- 
	gen_PM <= not gen_PM after 50 ns;	
	process
		file infile: text open read_mode is ITCMinit_txt_location;
		variable L: line;
		variable line_entry: bit_vector (15 downto 0);
		variable good: boolean;
		variable counter: integer := -1;
	begin
		while not endfile (infile) loop
			counter := counter + 1;
			readline(infile, L);
			hread(L, line_entry, good);
			next when not good;
			tb_PMdatain <= to_stdlogicvector(line_entry);
			tbPMwriteAddr <= conv_std_logic_vector(counter,6);
			wait until gen_PM;
		end loop;
		PM_done <= true;
		file_close(infile);
		report "end of Program Memory File" severity note;
		wait;
	end process;
	
--------------init Data Memory--------------------
	gen_DM <= not gen_DM after 50 ns; 	
	process
		file infile: text open read_mode is DTCMinit_txt_location;
		variable L: line;
		variable line_entry: bit_vector (15 downto 0);
		variable good: boolean;
		variable counter: integer := -1;
	begin
		while not endfile (infile) loop
			counter := counter + 1;
			readline(infile, L);
			hread(L, line_entry, good);
			next when not good;
			tbbus <= to_stdlogicvector(line_entry);
			tbMemAddr_reg <= conv_std_logic_vector(counter,6);
			wait until gen_DM;
		end loop;
		DM_done <= true;
		file_close(infile);
		report "end of Program Memory File" severity note;
		wait;
	end process;

--------------write resoults to DTCMcontent--------------------
	gen_out <= not gen_out after 50 ns; 	
	process
		file outfile: text open write_mode is DTCMcontent_txt_location;
		variable L: line;
	begin
		wait until done_control = '1';
		for i in 0 to 15 loop
			wait until(gen_out'event and gen_out = true);
			tbDin <= conv_std_logic_vector(i, 16);
			hwrite(L, to_bitvector(tb_DMdataout), left, 4);
			writeline(outfile, L);
		end loop;
		DM_out_done <= true;
		file_close(outfile);
		report "Finished Writing From Data Memory" severity note;
		wait;
	end process;
-----------------initiate------------------------
	process
    begin
		tb_active <= '1'; 
		rst <= '1';
		ena <= '0';
		tb_PMen <= '1';
		tbmem_wr <= '1';
		wait until DM_done and PM_done; 
		tb_active <= '0';
		rst <= '0';
		ena <= '1';
		tb_PMen <= '0';
		tbmem_wr <= '0';
		wait;
    end process; 

--------------clk init---------------	
	
	process
    begin
		clk <= '1';
		wait for 50 ns;
		clk <= not clk;
		wait for 50 ns;
    end process;

------------------run the code-----------------
	process
    begin
		wait until ena = '1';
-----ld r2,2(r0)---------	
----RESET----
		opc <= "0000";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '0';
		RFaddr <= "00";
		RFin <= '0';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '0';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0'; 
		done_control <= '0';
		
		wait for 101 ns;
		
----FETCH----	
		opc <= "0000";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '1';
		RFaddr <= "00";
		RFin <= '0';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '0';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;
		
----DECODE----		
	
		wait for 101 ns;
		
----LD1----
		opc <= "1001";
		PCin <= '1';
		PCsel <= "10";
		IRin <= '0';
		RFaddr <= "00";
		RFin <= '0';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '1';
		Ain <= '1';
		Cin <= '0';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;
		
----LD2----
		opc <= "1001";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '0';
		RFaddr <= "01";
		RFin <= '0';
		RFout <= '1';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '1';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;
				
----LD3----	
		opc <= "1001";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '0';
		RFaddr <= "00";
		RFin <= '0';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '0';
		Cout <= '1';
		mem_in <= '1';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;

----LD4----		
		opc <= "1001";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '0';
		RFaddr <= "10";
		RFin <= '1';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '0';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '1';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;

-----ld r9,9(r0)---------			
----FETCH----	
		opc <= "0000";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '1';
		RFaddr <= "00";
		RFin <= '0';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '0';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;
		
----DECODE----		
	
		wait for 101 ns;
	
----LD1----
		opc <= "1001";
		PCin <= '1';
		PCsel <= "10";
		IRin <= '0';
		RFaddr <= "00";
		RFin <= '0';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '1';
		Ain <= '1';
		Cin <= '0';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;
		
----LD2----
		opc <= "1001";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '0';
		RFaddr <= "01";
		RFin <= '0';
		RFout <= '1';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '1';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;
				
----LD3----	
		opc <= "1001";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '0';
		RFaddr <= "00";
		RFin <= '0';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '0';
		Cout <= '1';
		mem_in <= '1';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;

----LD4----		
		opc <= "1001";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '0';
		RFaddr <= "10";
		RFin <= '1';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '0';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '1';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;		

-----ld r2,2(r0)---------	

		wait for 101 ns;
		
----FETCH----	
		opc <= "0000";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '1';
		RFaddr <= "00";
		RFin <= '0';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '0';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
	
		wait for 101 ns;
		
----DECODE----		
	
		wait for 101 ns;
			
----LD1----
		opc <= "1001";
		PCin <= '1';
		PCsel <= "10";
		IRin <= '0';
		RFaddr <= "00";
		RFin <= '0';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '1';
		Ain <= '1';
		Cin <= '0';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;
		
----LD2----
		opc <= "1001";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '0';
		RFaddr <= "01";
		RFin <= '0';
		RFout <= '1';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '1';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;
				
----LD3----	
		opc <= "1001";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '0';
		RFaddr <= "00";
		RFin <= '0';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '0';
		Cout <= '1';
		mem_in <= '1';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;

----LD4----		
		opc <= "1001";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '0';
		RFaddr <= "10";
		RFin <= '1';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '0';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '1';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;
		
-----ld r13,13(r0)---------	
----FETCH----	
		opc <= "0000";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '1';
		RFaddr <= "00";
		RFin <= '0';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '0';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;

----DECODE----		
	
		wait for 101 ns;
			
----LD1----
		opc <= "1001";
		PCin <= '1';
		PCsel <= "10";
		IRin <= '0';
		RFaddr <= "00";
		RFin <= '0';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '1';
		Ain <= '1';
		Cin <= '0';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;
		
----LD2----
		opc <= "1001";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '0';
		RFaddr <= "01";
		RFin <= '0';
		RFout <= '1';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '1';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;
				
----LD3----	
		opc <= "1001";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '0';
		RFaddr <= "00";
		RFin <= '0';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '0';
		Cout <= '1';
		mem_in <= '1';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;

----LD4----		
		opc <= "1001";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '0';
		RFaddr <= "10";
		RFin <= '1';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '0';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '1';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;
		
-----mov r1,1---------	
----FETCH----	
		opc <= "0000";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '1';
		RFaddr <= "00";
		RFin <= '0';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '0';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;

----DECODE----		
	
		wait for 101 ns;
			
----MOVE----
		opc <= "1000";
		PCin <= '1';
		PCsel <= "01";
		IRin <= '0';
		RFaddr <= "10";
		RFin <= '1';
		RFout <= '0';
		imm1_in <= '1';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '0';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;
		
-----add r3,r2,r13---------	
----FETCH----	
		opc <= "0000";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '1';
		RFaddr <= "00";
		RFin <= '0';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '0';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;

----DECODE----		
	
		wait for 101 ns;
			
----ADD1---
		opc <= "0000";
		PCin <= '1';
		PCsel <= "10";
		IRin <= '0';
		RFaddr <= "01";
		RFin <= '0';
		RFout <= '1';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '1';
		Cin <= '0';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;
		
----ADD2---		
		opc <= "0000";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '0';
		RFaddr <= "00";
		RFin <= '0';
		RFout <= '1';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '1';
		Cout <= '0';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;
		
----ADD3---
		opc <= "0000";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '0';
		RFaddr <= "10";
		RFin <= '1';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '0';
		Cout <= '1';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '0';
		
		wait for 101 ns;
		
----DONE---
		opc <= "0000";
		PCin <= '0';
		PCsel <= "00";
		IRin <= '0';
		RFaddr <= "10";
		RFin <= '1';
		RFout <= '0';
		imm1_in <= '0';
		imm2_in <= '0';
		Ain <= '0';
		Cin <= '0';
		Cout <= '1';
		mem_in <= '0';
		mem_out <= '0';
		mem_wr <= '0';
		done_control <= '1';
		
		wait;
    end process; 
	
end architecture rtb;
