library ieee;
use ieee.std_logic_1164.all;

package aux_package is
-----------------------------------------------------------------
	component RF is
		generic( Dwidth: integer:=16;
				 Awidth: integer:=4);
		port(	clk,rst,WregEn: in std_logic;	
				WregData:	in std_logic_vector(Dwidth-1 downto 0);
				WregAddr,RregAddr:	
							in std_logic_vector(Awidth-1 downto 0);
				RregData: 	out std_logic_vector(Dwidth-1 downto 0)
		);
	end component;
-----------------------------------------------------------------
	component ProgMem is
		generic( Dwidth: integer:=16;
				 Awidth: integer:=6;
				 dept:   integer:=64);
		port(	clk,memEn: in std_logic;	
				WmemData:	in std_logic_vector(Dwidth-1 downto 0);
				WmemAddr,RmemAddr:	
							in std_logic_vector(Awidth-1 downto 0);
				RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
		);
	end component;
-----------------------------------------------------------------
	component dataMem is
		generic( Dwidth: integer:=16;
				 Awidth: integer:=6;
				 dept:   integer:=64);
		port(	clk,memEn: in std_logic;	
				WmemData:	in std_logic_vector(Dwidth-1 downto 0);
				WmemAddr,RmemAddr:	
							in std_logic_vector(Awidth-1 downto 0);
				RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
		);
	end component;
-----------------------------------------------------------------
	component control is
	
		port(
			rst, ena, clk: in std_logic;
			add, sub, nop, shl, jmp, jc, jnc, mov, ld, st, done_opc, Nflag, Zflag, Cflag: in std_logic; 
			mem_in, mem_out, mem_wr, Cout, Cin,  Ain, RFin, RFout, IRin, PCin, imm1_in, imm2_in, done_control: out std_logic;
			PCsel, RFaddr: out std_logic_vector(1 downto 0);
			opc: out std_logic_vector(3 downto 0)
			);
	end component;
-----------------------------------------------------------------
	component DataPath is	
	
		port (rst, clk, tb_active, tbmem_wr, IRin, imm1_in, imm2_in, RFout, RFin, Ain, Cin, Cout, mem_in, mem_out, mem_wr, PCin, tb_PMen: in std_logic;
			tbbus, tbDin, tb_PMdatain: in std_logic_vector(15 downto 0);
			tbPMwriteAddr, tbMemAddr_reg: in std_logic_vector(5 downto 0);
			opc: in std_logic_vector(3 downto 0);
			RFaddr, PCsel: in std_logic_vector(1 downto 0);
			add, sub, nop, shl, jmp, jc, jnc, mov, ld, st, done_opc, Nflag, Zflag, Cflag: out std_logic;
			tb_DMdataout: out std_logic_vector(15 downto 0)
			);
	end component;

-----------------------------------------------------------------
component top is

	port(
		rst, ena, clk: in std_logic;
		tb_active, tb_PMen, tbmem_wr: in std_logic;
		tbbus, tbDin, tb_PMdatain: in std_logic_vector(15 downto 0);
		tbPMwriteAddr, tbMemAddr_reg: in std_logic_vector(5 downto 0);
		done_control: out std_logic;
		tb_DMdataout: out std_logic_vector(15 downto 0)
	);
end component;

----------------------------------------------------------------

component BidirPin is
	generic( width: integer:=16 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
end component;

----------------------------------------------------------------

component AdderSub is
  GENERIC (n : INTEGER := 16);
  PORT (x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	    sub_cont: IN STD_LOGIC;
        cout: OUT STD_LOGIC;
        res: OUT STD_LOGIC_VECTOR(n-1 downto 0));
END component;

----------------------------------------------------------------
component FA IS
	PORT (xi, yi, cin: IN std_logic;
			  s, cout: OUT std_logic);
END component;

----------------------------------------------------------------
component shifter IS
  GENERIC (n : INTEGER := 16;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)     
  PORT (x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
        cout: OUT STD_LOGIC;
        res: OUT STD_LOGIC_VECTOR (n-1 downto 0));
END component;


end aux_package;