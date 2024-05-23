onerror {resume}
add list -width 16 /tb_top/gen_PM
add list /tb_top/gen_DM
add list /tb_top/gen_out
add list /tb_top/PM_done
add list /tb_top/DM_done
add list /tb_top/DM_out_done
add list /tb_top/tb_active
add list /tb_top/rst
add list /tb_top/ena
add list /tb_top/tb_PMen
add list /tb_top/tbmem_wr
add list /tb_top/clk
add list /tb_top/done_control
add list /tb_top/tbbus
add list /tb_top/tbDin
add list /tb_top/tb_PMdatain
add list /tb_top/tb_DMdataout
add list /tb_top/tbPMwriteAddr
add list /tb_top/tbMemAddr_reg
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
