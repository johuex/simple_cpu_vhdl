onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /simple_vhdl_cpu/clk
add wave -noupdate /simple_vhdl_cpu/reset
add wave -noupdate /simple_vhdl_cpu/RAM/mem_arr
add wave -noupdate /simple_vhdl_cpu/REGS/regs
add wave -noupdate /simple_vhdl_cpu/in_command_1
add wave -noupdate /simple_vhdl_cpu/in_command_2
add wave -noupdate /simple_vhdl_cpu/in_command_3
add wave -noupdate /simple_vhdl_cpu/in_command_4
add wave -noupdate /simple_vhdl_cpu/in_command_5
add wave -noupdate /simple_vhdl_cpu/in_command_6
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 374
configure wave -valuecolwidth 311
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {20 ns}
