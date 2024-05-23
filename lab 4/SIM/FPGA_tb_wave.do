onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fpga_tb/L0/input
add wave -noupdate /fpga_tb/L0/clk
add wave -noupdate /fpga_tb/L0/ena_y
add wave -noupdate /fpga_tb/L0/ena_x
add wave -noupdate /fpga_tb/L0/ena_alu
add wave -noupdate /fpga_tb/L0/ALUFN_out
add wave -noupdate /fpga_tb/L0/y_lsb
add wave -noupdate /fpga_tb/L0/y_msb
add wave -noupdate /fpga_tb/L0/x_lsb
add wave -noupdate /fpga_tb/L0/x_msb
add wave -noupdate /fpga_tb/L0/ALUout_lsb
add wave -noupdate /fpga_tb/L0/ALUout_msb
add wave -noupdate /fpga_tb/L0/Nflag
add wave -noupdate /fpga_tb/L0/Cflag
add wave -noupdate /fpga_tb/L0/Zflag
add wave -noupdate /fpga_tb/L0/x
add wave -noupdate /fpga_tb/L0/y
add wave -noupdate /fpga_tb/L0/ALUout
add wave -noupdate /fpga_tb/L0/alufn
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {235654 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 184
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {106326 ps}
