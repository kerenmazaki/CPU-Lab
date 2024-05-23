LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
LIBRARY work;
USE work.aux_package.all;
------------------------------------------------------------------
entity top is
	generic ( n : positive := 8 );
	port( rst,clk : in std_logic;
		  upperBound : in std_logic_vector(n-1 downto 0);
		  countOut : out std_logic_vector(n-1 downto 0));
end top;
------------------------------------------------------------------
architecture arc_sys of top is
	signal cnt_slow, cnt_fast, en : std_logic_vector(n-1 downto 0); -- slow counter, fast counter and 'en' that is the comparison between them.
	signal en_check : std_logic_vector(n-1 downto 0) := (others => '1'); -- permanent '1' vector for comparing with 'en' signal.
	
begin
	----------------------- fast counter process ------------------
	proc1 : process(clk,rst)
	begin
		-- resets to 0 if rst input is 1.
		if (rst = '1') then
			cnt_fast <= (others => '0');
		elsif (clk'event and clk = '1') then
			-- checks if fast counter reached current bound, if not continue counting if reaches start from zero.
			if (cnt_fast >= cnt_slow) then
				cnt_fast <= (others => '0');
			else
				cnt_fast <= cnt_fast + 1;
			end if;
		end if;
	end process;
	---------------------- slow counter process ------------------
	proc2 : process(clk,rst)
	begin
		-- resets to 0 if rst input is 1.
		if (rst = '1') then
			cnt_slow <= (others => '0');
		elsif (clk'event and clk = '1') then
			-- if fast count reached current slow count, slow count will increase.
			-- in addition - if slow count exceeded the upper bound it will reset to zero.
			if (en = en_check) then
				cnt_slow <= cnt_slow + 1;
			end if;
			if ((cnt_slow >= upperBound) and (en = en_check)) then
				cnt_slow <= (others => '0');
			end if;
		end if;
	end process;
	--------------------------------------------------------------
	-- xnor function will return '1' vector only when cnt_fast = cnt_slow.
	en <= cnt_fast xnor cnt_slow;
	countOut <= cnt_fast;
	
end arc_sys;








