onerror {resume}
add list -width 21 /tb_datapath/gen_PM
add list /tb_datapath/gen_DM
add list /tb_datapath/gen_out
add list /tb_datapath/PM_done
add list /tb_datapath/DM_done
add list /tb_datapath/DM_out_done
add list /tb_datapath/tb_active
add list /tb_datapath/clk
add list /tb_datapath/rst
add list /tb_datapath/ena
add list /tb_datapath/tbmem_wr
add list /tb_datapath/IRin
add list /tb_datapath/imm1_in
add list /tb_datapath/imm2_in
add list /tb_datapath/PCin
add list /tb_datapath/RFout
add list /tb_datapath/RFin
add list /tb_datapath/Ain
add list /tb_datapath/Cin
add list /tb_datapath/Cout
add list /tb_datapath/mem_in
add list /tb_datapath/mem_out
add list /tb_datapath/mem_wr
add list /tb_datapath/tb_PMen
add list /tb_datapath/add
add list /tb_datapath/sub
add list /tb_datapath/nop
add list /tb_datapath/jmp
add list /tb_datapath/jc
add list /tb_datapath/jnc
add list /tb_datapath/mov
add list /tb_datapath/ld
add list /tb_datapath/st
add list /tb_datapath/done_opc
add list /tb_datapath/Nflag
add list /tb_datapath/Zflag
add list /tb_datapath/Cflag
add list /tb_datapath/done_control
add list /tb_datapath/tbbus
add list /tb_datapath/tbDin
add list /tb_datapath/tb_PMdatain
add list /tb_datapath/tb_DMdataout
add list /tb_datapath/tbPMwriteAddr
add list /tb_datapath/tbMemAddr_reg
add list /tb_datapath/opc
add list /tb_datapath/RFaddr
add list /tb_datapath/PCsel
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
