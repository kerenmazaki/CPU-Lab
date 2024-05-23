LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------
ENTITY shifter IS
  GENERIC (n : INTEGER := 16;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)     
  PORT (x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
        cout: OUT STD_LOGIC;
        res: OUT STD_LOGIC_VECTOR (n-1 downto 0));
END shifter;
--------------------------------------------------------------
ARCHITECTURE df4 OF shifter IS
  type MATRIX is array (0 to k-2) of STD_LOGIC_VECTOR (n-1 downto 0);
  signal res_mat: Matrix; --stores the shift for each level
  signal c_vec: STD_LOGIC_VECTOR (0 to k-2); --stores the carry for each level
  
begin

---------first level-----------------
res_mat(0) <= y(n-2 downto 0) & '0' when (x(0) = '1') else
              y; -- don't shift
c_vec(0) <= y(n-1) when (x(0) = '1') else -- take leftmost bit of y
				'0'; -- no carry
            
-----middle levels, generic form-------
middle: for i in 1 to k-2 generate
      res_mat(i) <= res_mat(i-1)(n-1-2**i downto 0) & (2**i-1 downto 0 => '0') when (x(i) = '1') else -- SHL by wanted amount of bits
                    res_mat(i-1); -- don't shift
     c_vec(i) <= res_mat(i-1)(n-2**i) when (x(i) = '1') else -- take the last bit to be "pushed" out of y
                  c_vec(i-1); -- take carry from previous level
        end generate;

---------last level-----------------
res <= res_mat(k-2)(n-1-m downto 0) & (m-1 downto 0 => '0') when (x(k-1) = '1' ) else -- SHL by wanted amount of bits
              res_mat(k-2);
cout <= res_mat(k-2)(n-m) when (x(k-1) = '1') else -- take the last bit to be "pushed" out of y
              c_vec(k-2); -- take carry from previous level
              
end df4;





