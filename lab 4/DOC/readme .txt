----------DUT vhdl files------------
------------------------------------
-- AdderSub.vhd
-- Logic.vhd
-- Shifter.vhd
-- top.vhd
-- FA.vhd
-- aux_package.vhd
------------------------------------

------Functional Descriptions-------
------------------------------------

----------sub-sub-models------------
-FA.vhd:
-- purpose - A simple FullAdder function
-- input - x,y,c
-- function - adds the two outputs.
------------------------------------

----------sub-models----------------
-AdderSub.vhd:
-- purpose - can add two numbers, subtract them or return the negative of x.
-- input - x,y and and command code (alufn[2-0] aka sub_cont).
-- output - res, the result of the function, and cout, carry.
-- function - if the command is to add, the function sends the x,y inputs straight to the full-adder,
--            if the command is to subtract (y-x) it makes x negitve (using xor) and the input of c is '1',
--            if the command is to return the negative of x, it makes x negitve (using xor) and y = 0,
--            this way when we add them we will get -x.

-Logic.vhd:
-- purpose - preforms some basic logical bit-bit calculations.
-- input - x,y and command code (alufn[2-0])
-- output - zout, the result of the function.
-- function - according to the command code (alufn[2-0]) it simply callculates the wanted function.

-Shifter.vhd:
-- purpose - shifts right/left.
-- input - x,y and command code (alufn[2-0] aka dir)
-- function - shifts y right/left according to command code (alufn[2-0]), and the number of times to shift
--            according to the value of x.
-- output - res, the result of the function, and cout, carry.
-- Note: in the sub-models above, if the command code (alufn[2-0]) is not valid - output is 0.
--------------------------------------

----------top-models------------------
-aux_package.vhd:
-- purpose - includs all sub functions, for esier coding.

-top.vhd:
-- purpose - outputs a wanted callculation that varies from adding/subtracting through shifting to some basic logical bit-bit calculations
-- input - x, y, and command code ALUFN.
-- output- ALUout, the result of the output, and three flags (z- zero, c- carry, and n- negative).
-- function - branches inputs into sub models, and in the aftermath decides according to ALUFN whitch output to take, and callculates Zero_flag,
--            Negative flag and Carry_flag acording to the output or to the output flag coming out from the sub-model.
-- Note: if the command code ALUFN[4-3] is not valid - output is unchanged.
---------------------------------------