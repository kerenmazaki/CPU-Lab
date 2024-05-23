onerror {resume}
add list -width 11 /top_tb/Y
add list /top_tb/X
add list /top_tb/ALUFN
add list /top_tb/ALUout
add list /top_tb/Nflag
add list /top_tb/Cflag
add list /top_tb/Zflag
add list /top_tb/Icache
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
