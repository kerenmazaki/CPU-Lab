LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------
ENTITY shifter IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)     
  PORT (dir: IN STD_LOGIC;
        x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
        res: OUT STD_LOGIC_VECTOR (n-1 downto 0));
END shifter;
--------------------------------------------------------------
ARCHITECTURE df4 OF shifter IS
  type MATRIX is array (0 to k-2) of STD_LOGIC_VECTOR (n-1 downto 0);
  signal res_mat: Matrix; --stores the shift for each level
  
begin

---------first level-----------------
res_mat(0) <= y(n-2 downto 0) & '0' when (x(0) = '1' and dir = '0') else -- SHL by 1 bit
              "0" & y(n-1 downto 1) when (x(0) = '1' and dir = '1') else -- SHR by 1 bit
              y; -- don't shift
            
-----middle levels, generic form-------
middle: for i in 1 to k-2 generate
      res_mat(i) <= res_mat(i-1)(n-1-2**i downto 0) & (2**i-1 downto 0 => '0') when (x(i) = '1' and dir = '0') else -- SHL by wanted amount of bits
                    (2**i-1 downto 0 => '0') & res_mat(i-1)(n-1 downto 2**i) when (x(i) = '1' and dir = '1') else -- SHR by wanted amount of bits
                    res_mat(i-1); -- don't shift
        end generate;

---------last level-----------------
res <= res_mat(k-2)(n-1-m downto 0) & (m-1 downto 0 => '0') when (x(k-1) = '1' and dir = '0') else -- SHL by wanted amount of bits
              (m-1 downto 0 => '0') & res_mat(k-2)(n-1 downto m) when (x(k-1) = '1' and dir = '1') else -- SHR by wanted amount of bits
              res_mat(k-2) when (dir = '1' or dir = '0') else
              (others => '0');
end df4;





