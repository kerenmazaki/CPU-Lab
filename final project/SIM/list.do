onerror {resume}
add list -width 24 /fpga_tb/U_0/U_0/reset
add list /fpga_tb/U_0/U_0/clock
add list /fpga_tb/U_0/U_0/SW
add list /fpga_tb/U_0/U_0/KEY1
add list /fpga_tb/U_0/U_0/KEY2
add list /fpga_tb/U_0/U_0/KEY3
add list /fpga_tb/U_0/U_0/HEX0
add list /fpga_tb/U_0/U_0/HEX1
add list /fpga_tb/U_0/U_0/HEX2
add list /fpga_tb/U_0/U_0/HEX3
add list /fpga_tb/U_0/U_0/HEX4
add list /fpga_tb/U_0/U_0/HEX5
add list /fpga_tb/U_0/U_0/LEDR
add list /fpga_tb/U_0/U_0/out_signal
add list /fpga_tb/U_0/U_0/MemWrite_out
add list /fpga_tb/U_0/U_0/MemRead_out
add list /fpga_tb/U_0/U_0/TYPE_reg
add list /fpga_tb/U_0/U_0/data
add list /fpga_tb/U_0/U_0/address
add list /fpga_tb/U_0/U_0/INTR
add list /fpga_tb/U_0/U_0/INTA
add list /fpga_tb/U_0/U_0/GIE
add list /fpga_tb/U_0/U_0/KEY1_int
add list /fpga_tb/U_0/U_0/KEY2_int
add list /fpga_tb/U_0/U_0/KEY3_int
add list /fpga_tb/U_0/U_0/BT_int
add list /fpga_tb/U_0/U_0/KEY1_fb
add list /fpga_tb/U_0/U_0/KEY2_fb
add list /fpga_tb/U_0/U_0/KEY3_fb
add list /fpga_tb/U_0/U_0/BT_fb
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
