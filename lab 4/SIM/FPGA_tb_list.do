onerror {resume}
add list -width 19 /fpga_tb/L0/input
add list /fpga_tb/L0/clk
add list /fpga_tb/L0/ena_y
add list /fpga_tb/L0/ena_x
add list /fpga_tb/L0/ena_alu
add list /fpga_tb/L0/ALUFN_out
add list /fpga_tb/L0/y_lsb
add list /fpga_tb/L0/y_msb
add list /fpga_tb/L0/x_lsb
add list /fpga_tb/L0/x_msb
add list /fpga_tb/L0/ALUout_lsb
add list /fpga_tb/L0/ALUout_msb
add list /fpga_tb/L0/Nflag
add list /fpga_tb/L0/Cflag
add list /fpga_tb/L0/Zflag
add list /fpga_tb/L0/x
add list /fpga_tb/L0/y
add list /fpga_tb/L0/ALUout
add list /fpga_tb/L0/alufn
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
