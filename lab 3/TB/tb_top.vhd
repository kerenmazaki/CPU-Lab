library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use work.aux_package.all;
---------------------------------------------------------
entity tb_top is
end tb_top;
------------------------------------------------------------------------------
architecture rtb of tb_top is
	signal gen_PM, gen_DM, gen_out: boolean:= true; 	
	signal PM_done, DM_done, DM_out_done: boolean:= false;
	signal tb_active: std_logic; 
	signal rst, ena, tb_PMen, tbmem_wr, clk, done_control: std_logic;
	signal tbbus, tbDin, tb_PMdatain, tb_DMdataout: std_logic_vector(15 downto 0);
	signal tbPMwriteAddr, tbMemAddr_reg: std_logic_vector(5 downto 0);
	constant ITCMinit_txt_location: string(1 to 113):=
	"C:\Users\keren\Documents\school\third year\semester b\CPU lab\lab 3\308374529_318501335\Memory files\ITCMinit.txt";
	constant DTCMinit_txt_location: string(1 to 113):=
	"C:\Users\keren\Documents\school\third year\semester b\CPU lab\lab 3\308374529_318501335\Memory files\DTCMinit.txt";
	constant DTCMcontent_txt_location: string(1 to 116):=
	"C:\Users\keren\Documents\school\third year\semester b\CPU lab\lab 3\308374529_318501335\Memory files\DTCMcontent.txt";
	
begin
	L0: top port map (
				rst, ena, clk, tb_active, tb_PMen, tbmem_wr,
				tbbus, tbDin, tb_PMdatain, tbPMwriteAddr, tbMemAddr_reg,
				done_control, tb_DMdataout
				);
				
----------------------------------------------------------------
	
	
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
		for i in 1 to 64 loop
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
		wait until done_control = '1';
		tb_active <= '1';
		wait;
    end process; 

---------------------clk init--------------------	
	process
    begin
		clk <= '1';
		wait for 50 ns;
		clk <= not clk;
		wait for 50 ns;
    end process;

end architecture rtb;

	