library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
-------------------------------------------------------------
entity control is
	port(
		rst, ena, clk: in std_logic;
		add, sub, nop, shl, jmp, jc, jnc, mov, ld, st, done_opc, Nflag, Zflag, Cflag: in std_logic; 
		mem_in, mem_out, mem_wr, Cout, Cin,  Ain, RFin, RFout, IRin, PCin, imm1_in, imm2_in, done_control: out std_logic;
		PCsel, RFaddr: out std_logic_vector(1 downto 0);
		opc: out std_logic_vector(3 downto 0)
		);
end control;
-------------------------------------------------------------
architecture control_FSM of control is
	type state is (
					ADD1, ADD2, ADD3, SUB1, SUB2, SUB3, NOP1, NOP2, NOP3, SHL1, SHL2, SHL3,
					JUMP, JC_C1, JC_C0, JNC_C1, JNC_C0, MOVE, LD1, LD2, LD3,
					LD4, ST1, ST2, ST3, ST4, DONE, RESET, FETCH, DECODE
					);
	signal pr_state, nxt_state: state;
	
begin

	process(rst, clk)
	begin
		if (rst = '1') then
			pr_state <= RESET;
		elsif (clk'event and clk = '1') then 
			if (ena = '1') then
				pr_state <= nxt_state;
			end if;
		end if;
	end process;
	

	process(add, sub, nop, jmp, jc, jnc, mov, ld, st, done_opc, Nflag, Zflag, Cflag, clk, pr_state)
	begin
	
		case pr_state is
		
			when DECODE =>
				if (add = '1') then
					nxt_state <= ADD1;
				elsif (sub = '1') then
					nxt_state <= SUB1;
				elsif (nop = '1') then
					nxt_state <= NOP1;
				elsif (shl = '1') then
					nxt_state <= SHL1;
				elsif (jmp = '1') then
					nxt_state <= JUMP;
				elsif (jc = '1' and Cflag = '1') then
					nxt_state <= JC_C1;
				elsif (jc = '1' and Cflag = '0') then
					nxt_state <= JC_C0;
				elsif (jnc = '1' and Cflag = '1') then
					nxt_state <= JNC_C1;
				elsif (jnc = '1' and Cflag = '0') then
					nxt_state <= JNC_C0;
				elsif (mov = '1') then
					nxt_state <= MOVE;
				elsif (ld = '1') then
					nxt_state <= LD1;
				elsif (st = '1') then
					nxt_state <= ST1;
				elsif (done_opc = '1') then
					nxt_state <= DONE;
				end if;
		
			when RESET =>
				opc <= "1111";
				PCin <= '0';
				PCsel <= "00";
				IRin <= '0';
				RFaddr <= "00";
				RFin <= '0';
				RFout <= '0';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '0';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= FETCH;	
				
			when FETCH =>
				opc <= "1111";
				PCin <= '0';
				PCsel <= "00";
				IRin <= '1';
				RFaddr <= "00";
				RFin <= '0';
				RFout <= '0';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '0';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= DECODE;
			
			when ADD1 =>
				opc <= "0000";
				PCin <= '1';
				PCsel <= "10";
				IRin <= '0';
				RFaddr <= "01";
				RFin <= '0';
				RFout <= '1';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '1';
				Cin <= '0';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= ADD2;
				
			when ADD2 =>
				opc <= "1111";
				PCin <= '0';
				PCsel <= "00";
				IRin <= '0';
				RFaddr <= "00";
				RFin <= '0';
				RFout <= '1';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '1';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= ADD3;
				
			when ADD3 =>
				opc <= "1111";
				PCin <= '0';
				PCsel <= "00";
				IRin <= '0';
				RFaddr <= "10";
				RFin <= '1';
				RFout <= '0';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '0';
				Cout <= '1';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= FETCH;
				
			when SUB1 =>
				opc <= "0001";
				PCin <= '1';
				PCsel <= "10";
				IRin <= '0';
				RFaddr <= "01";
				RFin <= '0';
				RFout <= '1';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '1';
				Cin <= '0';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= SUB2;
				
			when SUB2 =>
				opc <= "1111";
				PCin <= '0';
				PCsel <= "00";
				IRin <= '0';
				RFaddr <= "00";
				RFin <= '0';
				RFout <= '1';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '1';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= SUB3;
				
			when SUB3 =>
				opc <= "1111";
				PCin <= '0';
				PCsel <= "00";
				IRin <= '0';
				RFaddr <= "10";
				RFin <= '1';
				RFout <= '0';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '0';
				Cout <= '1';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= FETCH;

			when NOP1 =>
				opc <= "0010";
				PCin <= '1';
				PCsel <= "10";
				IRin <= '0';
				RFaddr <= "00";
				RFin <= '0';
				RFout <= '1';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '1';
				Cin <= '0';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= NOP2;
				
			when NOP2 =>
				opc <= "1111";
				PCin <= '0';
				PCsel <= "00";
				IRin <= '0';
				RFaddr <= "00";
				RFin <= '0';
				RFout <= '1';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '1';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= NOP3;
				
			when NOP3 =>
				opc <= "1111";
				PCin <= '0';
				PCsel <= "00";
				IRin <= '0';
				RFaddr <= "00";
				RFin <= '1';
				RFout <= '0';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '0';
				Cout <= '1';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= FETCH;
				
			when SHL1 =>
				opc <= "0011";
				PCin <= '1';
				PCsel <= "10";
				IRin <= '0';
				RFaddr <= "01";
				RFin <= '0';
				RFout <= '1';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '1';
				Cin <= '0';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= SHL2;
				
			when SHL2 =>
				opc <= "1111";
				PCin <= '0';
				PCsel <= "00";
				IRin <= '0';
				RFaddr <= "00";
				RFin <= '0';
				RFout <= '1';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '1';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= SHL3;
				
			when SHL3 =>
				opc <= "1111";
				PCin <= '0';
				PCsel <= "00";
				IRin <= '0';
				RFaddr <= "10";
				RFin <= '1';
				RFout <= '0';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '0';
				Cout <= '1';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= FETCH;
				
			when JUMP =>
				opc <= "1111";
				PCin <= '1';
				PCsel <= "01";
				IRin <= '0';
				RFaddr <= "00";
				RFin <= '0';
				RFout <= '0';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '0';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= FETCH;	
				
			when JC_C0 =>
				opc <= "1111";
				PCin <= '1';
				PCsel <= "10";
				IRin <= '0';
				RFaddr <= "00";
				RFin <= '0';
				RFout <= '0';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '0';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= FETCH;	
				
			when JC_C1 =>
				opc <= "1111";
				PCin <= '1';
				PCsel <= "01";
				IRin <= '0';
				RFaddr <= "00";
				RFin <= '0';
				RFout <= '0';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '0';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= FETCH;	
				
			when JNC_C0 =>
				opc <= "1111";
				PCin <= '1';
				PCsel <= "01";
				IRin <= '0';
				RFaddr <= "00";
				RFin <= '0';
				RFout <= '0';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '0';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= FETCH;	
				
			when JNC_C1 =>
				opc <= "1111";
				PCin <= '1';
				PCsel <= "10";
				IRin <= '0';
				RFaddr <= "00";
				RFin <= '0';
				RFout <= '0';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '0';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= FETCH;	
				
			when MOVE =>
				opc <= "1111";
				PCin <= '1';
				PCsel <= "10";
				IRin <= '0';
				RFaddr <= "10";
				RFin <= '1';
				RFout <= '0';
				imm1_in <= '1';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '0';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= FETCH;
				
			when LD1 =>
				opc <= "1111";
				PCin <= '1';
				PCsel <= "10";
				IRin <= '0';
				RFaddr <= "00";
				RFin <= '0';
				RFout <= '0';
				imm1_in <= '0';
				imm2_in <= '1';
				Ain <= '1';
				Cin <= '0';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= LD2;
				
			when LD2 =>
				opc <= "1111";
				PCin <= '0';
				PCsel <= "00";
				IRin <= '0';
				RFaddr <= "01";
				RFin <= '0';
				RFout <= '1';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '1';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= LD3;
				
			when LD3 =>
				opc <= "1111";
				PCin <= '0';
				PCsel <= "00";
				IRin <= '0';
				RFaddr <= "00";
				RFin <= '0';
				RFout <= '0';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '0';
				Cout <= '1';
				mem_in <= '1';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= LD4;
				
			when LD4 =>
				opc <= "1111";
				PCin <= '0';
				PCsel <= "00";
				IRin <= '0';
				RFaddr <= "10";
				RFin <= '1';
				RFout <= '0';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '0';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '1';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= FETCH;
				
			when ST1 =>
				opc <= "1111";
				PCin <= '1';
				PCsel <= "10";
				IRin <= '0';
				RFaddr <= "00";
				RFin <= '0';
				RFout <= '0';
				imm1_in <= '0';
				imm2_in <= '1';
				Ain <= '1';
				Cin <= '0';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= ST2;
				
			when ST2 =>
				opc <= "1111";
				PCin <= '0';
				PCsel <= "00";
				IRin <= '0';
				RFaddr <= "01";
				RFin <= '0';
				RFout <= '1';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '1';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= ST3;
				
			when ST3 =>
				opc <= "1111";
				PCin <= '0';
				PCsel <= "00";
				IRin <= '0';
				RFaddr <= "00";
				RFin <= '0';
				RFout <= '0';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '0';
				Cout <= '1';
				mem_in <= '1';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '0';
				nxt_state <= ST4;
				
			when ST4 =>
				opc <= "1111";
				PCin <= '0';
				PCsel <= "00";
				IRin <= '0';
				RFaddr <= "10";
				RFin <= '0';
				RFout <= '1';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Cin <= '0';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '1';
				done_control <= '0';
				nxt_state <= FETCH;
				
			when DONE =>
				opc <= "1111";
				PCin <= '1';
				PCsel <= "10";
				IRin <= '0';
				RFaddr <= "00";
				RFin <= '0';
				RFout <= '0';
				imm1_in <= '0';
				imm2_in <= '0';
				Ain <= '0';
				Ain <= '0';
				Cin <= '0';
				Cout <= '0';
				mem_in <= '0';
				mem_out <= '0';
				mem_wr <= '0';
				done_control <= '1';
				nxt_state <= FETCH;	
		end case;
	end process;
end control_FSM;