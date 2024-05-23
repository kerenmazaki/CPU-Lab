onerror {resume}
add list -width 19 /addersub_tb/cout
add list /addersub_tb/x
add list /addersub_tb/y
add list /addersub_tb/res
add list /addersub_tb/sub_cont
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
