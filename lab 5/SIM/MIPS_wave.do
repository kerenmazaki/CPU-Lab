onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /mips_tb/clock
add wave -noupdate -radix hexadecimal /mips_tb/reset
add wave -noupdate /mips_tb/U_0/PC_out
add wave -noupdate -radix hexadecimal /mips_tb/Instruction_ID_out
add wave -noupdate -radix hexadecimal /mips_tb/read_data_1_ID_out
add wave -noupdate -radix hexadecimal /mips_tb/read_data_2_ID_out
add wave -noupdate -radix hexadecimal /mips_tb/write_data_ID_out
add wave -noupdate -radix hexadecimal /mips_tb/RegWrite_ID_out
add wave -noupdate -radix hexadecimal /mips_tb/Branch_ID_out
add wave -noupdate -radix hexadecimal /mips_tb/Instruction_EX_out
add wave -noupdate -radix hexadecimal /mips_tb/ALU_result_EX_out
add wave -noupdate -radix hexadecimal /mips_tb/ALU_Ainput_EX_out
add wave -noupdate -radix hexadecimal /mips_tb/ALU_Binput_EX_out
add wave -noupdate -radix hexadecimal /mips_tb/Zero_EX
add wave -noupdate -radix hexadecimal /mips_tb/Instruction_MEM_out
add wave -noupdate /mips_tb/U_0/MemWrite_MEM_out
add wave -noupdate -radix hexadecimal /mips_tb/write_data_MEM_out
add wave -noupdate -radix hexadecimal /mips_tb/read_data_MEM_out
add wave -noupdate -radix hexadecimal /mips_tb/address_MEM_out
add wave -noupdate -radix hexadecimal /mips_tb/instruction_WB_out
add wave -noupdate -radix hexadecimal /mips_tb/MemtoReg_WB_out
add wave -noupdate -radix hexadecimal /mips_tb/CLKCNT_out
add wave -noupdate -radix hexadecimal /mips_tb/STCNT_out
add wave -noupdate -radix hexadecimal /mips_tb/FHCNT_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {83422 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 277
configure wave -valuecolwidth 204
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
WaveRestoreZoom {0 ps} {1200236 ps}
