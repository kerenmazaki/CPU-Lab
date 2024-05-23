LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------
ENTITY shifter IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)     
  PORT (dir: IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- ALUFN[2;0]
        x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
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
res_mat(0) <= y(n-2 downto 0) & '0' when (x(0) = '1' and dir = "000") else -- SHL by 1 bit
              "0" & y(n-1 downto 1) when (x(0) = '1' and dir = "001") else -- SHR by 1 bit
              y; -- don't shift
c_vec(0) <= y(n-1) when (x(0) = '1' and dir = "000") else -- take leftmost bit of y
            y(0) when (x(0) = '1' and dir = "001") else -- take rightmost bit of y
            '0'; -- no carry
            
-----middle levels, generic form-------
middle: for i in 1 to k-2 generate
      res_mat(i) <= res_mat(i-1)(n-1-2**i downto 0) & (2**i-1 downto 0 => '0') when (x(i) = '1' and dir = "000") else -- SHL by wanted amount of bits
                    (2**i-1 downto 0 => '0') & res_mat(i-1)(n-1 downto 2**i) when (x(i) = '1' and dir = "001") else -- SHR by wanted amount of bits
                    res_mat(i-1); -- don't shift
     c_vec(i) <= res_mat(i-1)(n-2**i) when (x(i) = '1' and dir = "000") else -- take the last bit to be "pushed" out of y
                  res_mat(i-1)(2**i-1) when (x(i) = '1' and dir = "001") else -- take the last bit to be "pushed" out of y
                  c_vec(i-1); -- take carry from previous level
        end generate;

---------last level-----------------
res <= res_mat(k-2)(n-1-m downto 0) & (m-1 downto 0 => '0') when (x(k-1) = '1' and dir = "000") else -- SHL by wanted amount of bits
              (m-1 downto 0 => '0') & res_mat(k-2)(n-1 downto m) when (x(k-1) = '1' and dir = "001") else -- SHR by wanted amount of bits
              res_mat(k-2) when (dir = "001" or dir = "000") else
              (others => '0');
cout <= res_mat(k-2)(n-m) when (x(k-1) = '1' and dir = "000") else -- take the last bit to be "pushed" out of y
              res_mat(k-2)(m-1) when (x(k-1) = '1' and dir = "001") else -- take the last bit to be "pushed" out of y
              c_vec(k-2); --err: when (dir = "001" or dir = "000"); -- take carry from previous level
              
end df4;





