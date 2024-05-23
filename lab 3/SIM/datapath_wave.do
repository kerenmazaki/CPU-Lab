onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_datapath/gen_PM
add wave -noupdate /tb_datapath/gen_DM
add wave -noupdate /tb_datapath/gen_out
add wave -noupdate /tb_datapath/PM_done
add wave -noupdate /tb_datapath/DM_done
add wave -noupdate /tb_datapath/DM_out_done
add wave -noupdate /tb_datapath/tb_active
add wave -noupdate /tb_datapath/clk
add wave -noupdate /tb_datapath/rst
add wave -noupdate /tb_datapath/ena
add wave -noupdate /tb_datapath/tbmem_wr
add wave -noupdate /tb_datapath/IRin
add wave -noupdate /tb_datapath/imm1_in
add wave -noupdate /tb_datapath/imm2_in
add wave -noupdate /tb_datapath/PCin
add wave -noupdate /tb_datapath/RFout
add wave -noupdate /tb_datapath/RFin
add wave -noupdate /tb_datapath/Ain
add wave -noupdate /tb_datapath/Cin
add wave -noupdate /tb_datapath/Cout
add wave -noupdate /tb_datapath/mem_in
add wave -noupdate /tb_datapath/mem_out
add wave -noupdate /tb_datapath/mem_wr
add wave -noupdate /tb_datapath/tb_PMen
add wave -noupdate /tb_datapath/add
add wave -noupdate /tb_datapath/sub
add wave -noupdate /tb_datapath/nop
add wave -noupdate /tb_datapath/jmp
add wave -noupdate /tb_datapath/jc
add wave -noupdate /tb_datapath/jnc
add wave -noupdate /tb_datapath/mov
add wave -noupdate /tb_datapath/ld
add wave -noupdate /tb_datapath/st
add wave -noupdate /tb_datapath/done_opc
add wave -noupdate /tb_datapath/Nflag
add wave -noupdate /tb_datapath/Zflag
add wave -noupdate /tb_datapath/Cflag
add wave -noupdate /tb_datapath/done_control
add wave -noupdate /tb_datapath/tbbus
add wave -noupdate /tb_datapath/tbDin
add wave -noupdate /tb_datapath/tb_PMdatain
add wave -noupdate /tb_datapath/tb_DMdataout
add wave -noupdate /tb_datapath/tbPMwriteAddr
add wave -noupdate /tb_datapath/tbMemAddr_reg
add wave -noupdate /tb_datapath/opc
add wave -noupdate /tb_datapath/RFaddr
add wave -noupdate /tb_datapath/PCsel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9598247 ps} 0}
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
WaveRestoreZoom {0 ps} {3053568 ps}
