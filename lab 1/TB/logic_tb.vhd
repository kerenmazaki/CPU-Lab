library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
LIBRARY work;
use work.aux_package.all;

entity logic_tb is
  constant m : integer := 8;
end logic_tb;

architecture rtb of logic_tb is
  SIGNAL x,y,zout : STD_LOGIC_VECTOR (m-1 DOWNTO 0);
  SIGNAL alufn : STD_LOGIC_VECTOR (2 DOWNTO 0);

begin
  L0 : LOGIC generic map (m) port map(x,y,alufn,zout);
    
  --------- start of stimulus section ------------------  
  tb_logic : process
  begin
    x <= "11000101";
    y <= "10111001";
    wait for 400 ns;
    x <= "01101001";
    y <= "11110101";
    wait;
    
  end process tb_logic;
          
  tb_alufn : process
  begin
    alufn <="000";
    for i in 0 to 14 loop
      wait for 50 ns;
      alufn <= alufn+1;
    end loop;
    wait;
  end process tb_alufn; 
end architecture rtb;

