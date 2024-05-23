library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------------------------------------
component FPGA_conc is
	generic (n : integer := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
	port (input: in std_logic_vector (n-1 downto 0); 
		  clk, ena_y ,ena_x ,ena_alu : in std_logic;
		  ALUFN_out: out std_logic_vector (4 downto 0);
		  y_lsb, y_msb, x_lsb, x_msb, ALUout_lsb, ALUout_msb: out std_logic_vector (0 to 6);
		  Nflag, Cflag, Zflag: out std_logic); -- Zflag,Cflag,Nflag
	end component;
--------------------------------------------------------
	component alu_reg is

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
	end component;
--------------------------------------------------------
	component alu is
	GENERIC (n : INTEGER := 8;
		 k : integer := 3;   -- k=log2(n)
		 m : integer := 4 );   -- m=2^(k-1)
	PORT 
	(  
		Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		Nflag_o,Cflag_o,Zflag_o: OUT STD_LOGIC 
	); -- Zflag,Cflag,Nflag
	end component;
---------------------------------------------------------
	COMPONENT AdderSub IS
  		GENERIC (n : INTEGER := 8);
  		PORT (x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
        		sub_cont: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			    cout: OUT STD_LOGIC;
        		res: OUT STD_LOGIC_VECTOR(n-1 downto 0));
	END COMPONENT;
---------------------------------------------------------
	COMPONENT FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	END COMPONENT;	
----------------------------------------------------------
	COMPONENT LOGIC IS
		GENERIC (n : INTEGER := 8);
		PORT (x, y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			alufn: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			zout: OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0));
	END COMPONENT;
-----------------------------------------------------------
	COMPONENT shifter IS
  		GENERIC (n : INTEGER := 8;
		  	 k : integer := 3;   -- k=log2(n)
		  	 m : integer := 4	); -- m=2^(k-1)     
  		PORT (dir: IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- ALUFN[2;0]
  		      x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
  		      cout: OUT STD_LOGIC;
  		      res: OUT STD_LOGIC_VECTOR (n-1 downto 0));
	END COMPONENT;
	
end aux_package;

