onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/ALUFN
add wave -noupdate /top_tb/Y
add wave -noupdate /top_tb/X
add wave -noupdate /top_tb/ALUout
add wave -noupdate /top_tb/Nflag
add wave -noupdate /top_tb/Cflag
add wave -noupdate /top_tb/Zflag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
WaveRestoreZoom {0 ps} {1024 ns}