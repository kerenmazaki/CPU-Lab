LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
LIBRARY work;
use work.aux_package.all;
-------------------------------------
ENTITY top IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  PORT 
  (  
	Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o,Cflag_o,Zflag_o: OUT STD_LOGIC 
  ); -- Zflag,Cflag,Nflag
END top;
------------- complete the top Architecture code --------------
ARCHITECTURE struct OF top IS 
	SIGNAL addersub_out, shifter_out, logic_out: STD_LOGIC_VECTOR(n-1 downto 0); -- output of each submodel
	SIGNAL y_in_logic, y_in_shifter, y_in_addersub: STD_LOGIC_VECTOR(n-1 downto 0); -- y input into each submodel
	SIGNAL x_in_logic, x_in_shifter, x_in_addersub: STD_LOGIC_VECTOR(n-1 downto 0); -- x input into each submodel
	SIGNAL c_out_addersub, c_out_shifter: STD_LOGIC; -- carry flag of addersub and shifter submodels
	SIGNAL z : STD_LOGIC_VECTOR(n-1 downto 0) := (others => '0'); -- zero vector for calculating Z flag
	
BEGIN
  -- initating inputs to subs according to ALUFN
	y_in_logic <= Y_i when ALUFN_i(4 downto 3)= "11" else y_in_logic; 
	y_in_addersub <= Y_i when ALUFN_i(4 downto 3)= "01" else y_in_addersub;
	y_in_shifter <= Y_i when ALUFN_i(4 downto 3)= "10" else y_in_shifter;
	x_in_logic <= X_i when ALUFN_i(4 downto 3)= "11" else x_in_logic; 
	x_in_addersub <= X_i when ALUFN_i(4 downto 3)= "01" else x_in_addersub;
	x_in_shifter <= X_i when ALUFN_i(4 downto 3)= "10" else x_in_shifter;
	
	-- calculating in each submodel
	logic_label: LOGIC generic map (n) port map(
				x => x_in_logic,
				y => y_in_logic,
				alufn => ALUFN_i(2 downto 0),
				zout => logic_out
				);
	addersub_label: AdderSub generic map (n) port map (
				x => x_in_addersub,
				y => y_in_addersub,
				sub_cont => ALUFN_i(2 downto 0),
				cout => c_out_addersub,
				res => addersub_out
				);
	shifter_label: shifter generic map(n, k, m) port map (
				dir => ALUFN_i(2 downto 0),
			  x => x_in_shifter,
	    		y => y_in_shifter,
	    		cout => c_out_shifter,
	    		res => shifter_out
				);		
	
	-- deciding wich submodel output to channel to system output
	with ALUFN_i(4 downto 3) select
		ALUout_o <= addersub_out when "01",
			shifter_out when "10",
			logic_out when "11",
			unaffected when others;
  
  -- calculating C flag (carry)
	with ALUFN_i(4 downto 3) select
		Cflag_o <= c_out_addersub when "01",
			c_out_shifter when "10",
			'0' when "11",
			unaffected when others;	
   
  -- calculating Z flag (zero) by comparing to zero vector
  Zflag_o <= '1' when (ALUFN_i (4 downto 3) = "01" and addersub_out = z) else
            '1' when (ALUFN_i (4 downto 3) = "10" and shifter_out = z) else
            '1' when (ALUFN_i (4 downto 3) = "11" and logic_out = z) else
            '0' when (ALUFN_i (4 downto 3) = "01" and addersub_out /= z) else
            '0' when (ALUFN_i (4 downto 3) = "10" and shifter_out /= z) else
            '0' when (ALUFN_i (4 downto 3) = "11" and logic_out /= z) else
            unaffected;
                
  -- calculating N flag (Negative)
	with ALUFN_i(4 downto 3) select
		Nflag_o <= addersub_out(n-1) when "01",
			shifter_out(n-1) when "10",
			logic_out(n-1) when "11",
			unaffected when others;
			
END struct;

