library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
entity DataPath is	
	port (rst, clk, tb_active, tbmem_wr, IRin, imm1_in, imm2_in, RFout, RFin, Ain, Cin, Cout, mem_in, mem_out, mem_wr, PCin, tb_PMen: in std_logic;
		tbbus, tbDin, tb_PMdatain: in std_logic_vector(15 downto 0);
		tbPMwriteAddr, tbMemAddr_reg: in std_logic_vector(5 downto 0);
		opc: in std_logic_vector(3 downto 0);
		RFaddr, PCsel: in std_logic_vector(1 downto 0);
		add, sub, nop, shl, jmp, jc, jnc, mov, ld, st, done_opc, Nflag, Zflag, Cflag: out std_logic;
		tb_DMdataout: out std_logic_vector(15 downto 0)
		);
	
end DataPath;

-------------------------------------
architecture st of DataPath is
		signal IOpin, DinRF, DoutRF, IR, PMdataout, DMdataout, DMdatain, PC_reg_in, A, C, C_addersub, C_shl, Creg, Dout_imm1, Dout_imm2: std_logic_vector(15 downto 0);
		signal PC_reg_out: std_logic_vector(15 downto 0);
		signal ReadAddr, WriteAddr: std_logic_vector(3 downto 0);
		signal PMreadAddr, DMwriteAddr, DMreadAddr, MemAddr_reg: std_logic_vector(5 downto 0);
		signal DMen, add_sub, Cflag_shifter, Cflag_addersub: std_logic;
		signal zero: std_logic_vector(15 downto 0) := (others => '0');
begin
---------IR--------------------------
	process(PMdataout, IRin)
		begin
			if (IRin = '1') then
				IR <= PMdataout;
			end if;
	end process;
-----------opc decoder---------------
	process(IR)
	begin
		case IR(15 downto 12) is
		
			when "0000" =>
				add <= '1';
				sub <= '0';
				nop <= '0';
				shl <= '0';
				jmp <= '0';
				jc <= '0';
				jnc <= '0';
				mov <= '0';
				ld <= '0';
				st <= '0';
				done_opc <= '0';
			
			when "0001" =>
				add <= '0';
				sub <= '1';
				nop <= '0';
				shl <= '0';
				jmp <= '0';
				jc <= '0';
				jnc <= '0';
				mov <= '0';
				ld <= '0';
				st <= '0';
				done_opc <= '0';
			
			when "0010" =>
				add <= '0';
				sub <= '0';
				nop <= '1';
				shl <= '0';
				jmp <= '0';
				jc <= '0';
				jnc <= '0';
				mov <= '0';
				ld <= '0';
				st <= '0';
				done_opc <= '0';
			
			when "0011" =>
				add <= '0';
				sub <= '0';
				nop <= '0';
				shl <= '1';
				jmp <= '0';
				jc <= '0';
				jnc <= '0';
				mov <= '0';
				ld <= '0';
				st <= '0';
				done_opc <= '0';
				
			when "0100" =>
				add <= '0';
				sub <= '0';
				nop <= '0';
				shl <= '0';
				jmp <= '1';
				jc <= '0';
				jnc <= '0';
				mov <= '0';
				ld <= '0';
				st <= '0';
				done_opc <= '0';
			
			when "0101" =>
				add <= '0';
				sub <= '0';
				nop <= '0';
				shl <= '0';
				jmp <= '0';
				jc <= '1';
				jnc <= '0';
				mov <= '0';
				ld <= '0';
				st <= '0';
				done_opc <= '0';
				
			when "0110" =>
				add <= '0';
				sub <= '0';
				nop <= '0';
				shl <= '0';
				jmp <= '0';
				jc <= '0';
				jnc <= '1';
				mov <= '0';
				ld <= '0';
				st <= '0';
				done_opc <= '0';
			
			when "1000" =>
				add <= '0';
				sub <= '0';
				nop <= '0';
				shl <= '0';
				jmp <= '0';
				jc <= '0';
				jnc <= '0';
				mov <= '1';
				ld <= '0';
				st <= '0';
				done_opc <= '0';
				
			when "1001" =>
				add <= '0';
				sub <= '0';
				nop <= '0';
				shl <= '0';
				jmp <= '0';
				jc <= '0';
				jnc <= '0';
				mov <= '0';
				ld <= '1';
				st <= '0';
				done_opc <= '0';
			
			when "1010" =>
				add <= '0';
				sub <= '0';
				nop <= '0';
				shl <= '0';
				jmp <= '0';
				jc <= '0';
				jnc <= '0';
				mov <= '0';
				ld <= '0';
				st <= '1';
				done_opc <= '0';
			
			when "1011" =>
				add <= '0';
				sub <= '0';
				nop <= '0';
				shl <= '0';
				jmp <= '0';
				jc <= '0';
				jnc <= '0';
				mov <= '0';
				ld <= '0';
				st <= '0';
				done_opc <= '1';
				
			when others => null;
		end case;
	end process;
	
---------RF handler--------------------
RegisterFile :RF generic map (Dwidth => 16 , Awidth=> 4) 
				port map(clk => clk,
						rst => rst,
						WregEn => RFin,
						WregData => DinRF,
						WregAddr => WriteAddr,
						RregAddr => ReadAddr,
						RregData => DoutRF); 

	process(clk, IR, RFaddr, RFout, RFin)
	begin
		case RFaddr is 
			when "00" =>
				ReadAddr <= IR(3 downto 0);
				WriteAddr <= IR(3 downto 0);
			when "01" =>
				ReadAddr <= IR(7 downto 4);
				WriteAddr <= IR(7 downto 4);
			when "10" =>
				ReadAddr <= IR(11 downto 8);
				WriteAddr <= IR(11 downto 8);
			when others => null;
		end case;
	end process;
	
	bidirRF: BidirPin port map (DoutRF, RFout, DinRF, IOpin);
	
-------Program Memory handler--------------------
ProgramMemory :progMem generic map (Dwidth => 16 , Awidth=> 6, dept => 64) 
						port map(clk => clk,
								memEn => tb_PMen,
								WmemData => tb_PMdatain,
								WmemAddr => tbPMwriteAddr,
								RmemAddr => PMreadAddr,
								RmemData => PMdataout);
								   
	process(PC_reg_out)
	begin
		PMreadAddr <= PC_reg_out(5 downto 0);
	end process;
	

-------Data Memory handler--------------------
DataMemory :dataMem generic map (Dwidth => 16 , Awidth=> 6, dept => 64) 
					port map(clk => clk,
							memEn => DMen,
							WmemData => DMdatain,
							WmemAddr => DMwriteAddr,
							RmemAddr => DMreadAddr,
							RmemData=> DMdataout);
	
	process(mem_wr, tbmem_wr,tb_active)
	begin
		if (tb_active = '0') then 
			DMen <= mem_wr;
		elsif (tb_active = '1') then
			DMen <= tbmem_wr;
		end if;
	end process;
	
	process(IOpin, tbbus,tb_active)
	begin
		if (tb_active = '0') then 
			DMdatain <= IOpin;
		elsif (tb_active = '1') then
			DMdatain <= tbbus;
		end if;
	end process;
	
	process(IOpin, tbDin, tb_active)
	begin
		if (tb_active = '0') then 
			DMreadAddr <= IOpin(5 downto 0);
		elsif (tb_active = '1') then
			DMreadAddr <= tbDin(5 downto 0);
		end if;
	end process;
	
-----------Data Memory Address Register-------
	process(clk, IOpin, mem_in)
	begin
		if (clk'event and clk = '0') then
			if(mem_in = '1') then
				MemAddr_reg <= IOpin(5 downto 0);
			end if;
		end if;
	end process;
----------------------------------------------	

	process(MemAddr_reg, tbMemAddr_reg,tb_active)
	begin
		if (tb_active = '0') then 
			DMwriteaddr <= MemAddr_reg;
		elsif (tb_active = '1') then
			DMwriteaddr <= tbMemAddr_reg;
		end if;
	end process;	
	
	tb_DMdataout <= DMdataout;
		
	bidirDM: BidirPin port map (DMdataout, mem_out, open, IOpin);
					
-------------------PC----------------------------
	process(clk, PCin, PC_reg_in)
	begin
		if (rst='1') then
			PC_reg_out <= (others=>'0');
		end if;
		if (clk'event and clk='1') then
			if (PCin='1') then
				PC_reg_out <= PC_reg_in;
			end if;
		end if;
	end process;
	

	process(PCsel, PC_reg_out, IR)
		variable offset_addr: std_logic_vector(15 downto 0);
	begin
	
		offset_addr(4 downto 0) := IR(4 downto 0);
		if (IR(4) = '1') then
			offset_addr(15 downto 5) := (others => '1');
		else
			offset_addr(15 downto 5) := (others => '0');
		end if;
		
		case PCsel is
			when "00" =>
				PC_reg_in <= (others => '0');
			when "01" =>
				PC_reg_in <= PC_reg_out + 1 + offset_addr; 
			when "10" =>
				PC_reg_in <= PC_reg_out + 1;
			when others => null;	
		end case;
	end process;

------------ALU top----------------------------------
---------------A reg-----------------
	process (IOpin, clk, Ain)
	begin
		if (clk'event and clk='0') then
			if (Ain='1') then
				A <= IOpin;
			end if;
		end if;
	end process;


-------------opc handler---------------		
	C <= C_shl when (opc = "0011") else C_addersub;

--------------Adder/sub---------------

	process(opc)
	begin
		case opc is
			when "0000" =>
				add_sub <= '0';
			when "0001" =>
				add_sub <= '1';
			when others => null;
		end case;
	end process;
	
ALU: AdderSub generic map (n => 16) 
	port map (A, IOpin, add_sub, Cflag_addersub, C_addersub);
	

-------------shl----------------------
shftr: shifter generic map (n => 16, k => 3, m => 4)
	port map (IOpin, A, Cflag_shifter, C_shl);

-----------flags----------------------

	with opc select
			Cflag <= unaffected when "1111", Cflag_shifter when "0011", Cflag_addersub when others;

	with C(15) select
			Nflag <= '1' when '1', '0' when '0', unaffected when others;
	
	Zflag <= '1' when (C = zero) else '0';
		
-----------C reg----------------------	
	process (C, clk, Cin)
	begin	
		if (clk'event and clk='0') then
			if (Cin='1') then
				Creg <= C;
			end if;
		end if;
	end process;
	
	bidirALU: BidirPin port map (Creg, Cout, open, IOpin);

-------------sign extention----------------
	process(imm1_in,IR)
	begin
		Dout_imm1(3 downto 0) <= IR(3 downto 0);
		if (IR(3) = '1') then 
			Dout_imm1(15 downto 4) <= (others => '1');
		else
			Dout_imm1(15 downto 4) <= (others => '0');
		end if;
	end process;
	
	process(imm2_in,IR)
	begin
		Dout_imm2(7 downto 0) <= IR(7 downto 0);
		if (IR(3) = '1') then
			Dout_imm2(15 downto 8) <= (others => '1');
		else
			Dout_imm2(15 downto 8) <= (others => '0');
		end if;
	end process;
	
	imm1Bidir: BidirPin port map (Dout_imm1, imm1_in, open, IOpin);
	imm2Bidir: BidirPin port map (Dout_imm2, imm2_in, open, IOpin);

end st;