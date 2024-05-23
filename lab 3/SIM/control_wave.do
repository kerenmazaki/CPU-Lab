onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_control/rst
add wave -noupdate /tb_control/ena
add wave -noupdate /tb_control/clk
add wave -noupdate /tb_control/add
add wave -noupdate /tb_control/sub
add wave -noupdate /tb_control/nop
add wave -noupdate /tb_control/jmp
add wave -noupdate /tb_control/jc
add wave -noupdate /tb_control/jnc
add wave -noupdate /tb_control/mov
add wave -noupdate /tb_control/ld
add wave -noupdate /tb_control/st
add wave -noupdate /tb_control/done_opc
add wave -noupdate /tb_control/mem_in
add wave -noupdate /tb_control/mem_out
add wave -noupdate /tb_control/mem_wr
add wave -noupdate /tb_control/Cout
add wave -noupdate /tb_control/Cin
add wave -noupdate /tb_control/Ain
add wave -noupdate /tb_control/RFin
add wave -noupdate /tb_control/RFout
add wave -noupdate /tb_control/IRin
add wave -noupdate /tb_control/PCin
add wave -noupdate /tb_control/imm1_in
add wave -noupdate /tb_control/imm2_in
add wave -noupdate /tb_control/done_control
add wave -noupdate /tb_control/Nflag
add wave -noupdate /tb_control/Zflag
add wave -noupdate /tb_control/Cflag
add wave -noupdate /tb_control/PCsel
add wave -noupdate /tb_control/RFaddr
add wave -noupdate /tb_control/opc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9597916 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {2895872 ps}
