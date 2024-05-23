onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_top/gen_PM
add wave -noupdate -radix hexadecimal /tb_top/gen_DM
add wave -noupdate -radix hexadecimal /tb_top/gen_out
add wave -noupdate -radix hexadecimal /tb_top/PM_done
add wave -noupdate -radix hexadecimal /tb_top/DM_done
add wave -noupdate -radix hexadecimal /tb_top/DM_out_done
add wave -noupdate -radix hexadecimal /tb_top/tb_active
add wave -noupdate -radix hexadecimal /tb_top/rst
add wave -noupdate -radix hexadecimal /tb_top/ena
add wave -noupdate -radix hexadecimal /tb_top/L0/cont/pr_state
add wave -noupdate -radix hexadecimal /tb_top/L0/cont/nxt_state
add wave -noupdate -radix hexadecimal /tb_top/L0/L0/ProgramMemory/sysRAM
add wave -noupdate -radix hexadecimal /tb_top/L0/L0/DataMemory/sysRAM
add wave -noupdate -radix hexadecimal /tb_top/L0/L0/RegisterFile/sysRF
add wave -noupdate -radix hexadecimal /tb_top/L0/add
add wave -noupdate -radix hexadecimal /tb_top/L0/sub
add wave -noupdate -radix hexadecimal /tb_top/L0/nop
add wave -noupdate -radix hexadecimal /tb_top/L0/jmp
add wave -noupdate -radix hexadecimal /tb_top/L0/jc
add wave -noupdate -radix hexadecimal /tb_top/L0/jnc
add wave -noupdate -radix hexadecimal /tb_top/L0/mov
add wave -noupdate -radix hexadecimal /tb_top/L0/ld
add wave -noupdate -radix hexadecimal /tb_top/L0/st
add wave -noupdate -radix hexadecimal /tb_top/L0/done_opc
add wave -noupdate -radix hexadecimal /tb_top/L0/Cin
add wave -noupdate -radix hexadecimal /tb_top/L0/Ain
add wave -noupdate -radix hexadecimal /tb_top/L0/Nflag
add wave -noupdate -radix hexadecimal /tb_top/L0/Zflag
add wave -noupdate -radix hexadecimal /tb_top/L0/Cflag
add wave -noupdate -radix hexadecimal /tb_top/L0/mem_in
add wave -noupdate -radix hexadecimal /tb_top/L0/mem_out
add wave -noupdate -radix hexadecimal /tb_top/L0/mem_wr
add wave -noupdate -radix hexadecimal /tb_top/L0/Cout
add wave -noupdate -radix hexadecimal /tb_top/L0/RFin
add wave -noupdate -radix hexadecimal /tb_top/L0/RFout
add wave -noupdate -radix hexadecimal /tb_top/L0/IRin
add wave -noupdate -radix hexadecimal /tb_top/L0/PCin
add wave -noupdate -radix hexadecimal /tb_top/L0/imm1_in
add wave -noupdate -radix hexadecimal /tb_top/L0/imm2_in
add wave -noupdate -radix hexadecimal /tb_top/L0/PCsel
add wave -noupdate -radix hexadecimal /tb_top/L0/RFaddr
add wave -noupdate -radix hexadecimal /tb_top/L0/opc
add wave -noupdate -radix hexadecimal /tb_top/clk
add wave -noupdate -radix hexadecimal /tb_top/done_control
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9001417 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 201
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
WaveRestoreZoom {0 ps} {1908736 ps}
