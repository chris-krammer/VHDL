onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_clkprescale/s_Clk
add wave -noupdate /tb_clkprescale/s_RST
add wave -noupdate -expand -group pre1k /tb_clkprescale/i_pre1k/g_SOURCEHZ
add wave -noupdate -expand -group pre1k /tb_clkprescale/i_pre1k/g_TARGETHZ
add wave -noupdate -expand -group pre1k /tb_clkprescale/i_pre1k/g_OUTACTIVE
add wave -noupdate -expand -group pre1k -radix unsigned /tb_clkprescale/i_pre1k/s_prescaler
add wave -noupdate -expand -group pre1k -radix unsigned /tb_clkprescale/i_pre1k/s_counter
add wave -noupdate -expand -group pre1k /tb_clkprescale/i_pre1k/OUT_o
add wave -noupdate -expand -group pre2k /tb_clkprescale/i_pre2k/g_SOURCEHZ
add wave -noupdate -expand -group pre2k /tb_clkprescale/i_pre2k/g_TARGETHZ
add wave -noupdate -expand -group pre2k /tb_clkprescale/i_pre2k/g_OUTACTIVE
add wave -noupdate -expand -group pre2k -radix unsigned /tb_clkprescale/i_pre2k/s_prescaler
add wave -noupdate -expand -group pre2k -radix unsigned /tb_clkprescale/i_pre2k/s_counter
add wave -noupdate -expand -group pre2k /tb_clkprescale/i_pre2k/OUT_o
add wave -noupdate -expand -group pre3k /tb_clkprescale/i_pre3k/g_SOURCEHZ
add wave -noupdate -expand -group pre3k /tb_clkprescale/i_pre3k/g_TARGETHZ
add wave -noupdate -expand -group pre3k /tb_clkprescale/i_pre3k/g_OUTACTIVE
add wave -noupdate -expand -group pre3k -radix unsigned /tb_clkprescale/i_pre3k/s_prescaler
add wave -noupdate -expand -group pre3k -radix unsigned /tb_clkprescale/i_pre3k/s_counter
add wave -noupdate -expand -group pre3k /tb_clkprescale/i_pre3k/OUT_o
add wave -noupdate -expand -group pre101M /tb_clkprescale/i_pre101M/g_SOURCEHZ
add wave -noupdate -expand -group pre101M /tb_clkprescale/i_pre101M/g_TARGETHZ
add wave -noupdate -expand -group pre101M /tb_clkprescale/i_pre101M/g_OUTACTIVE
add wave -noupdate -expand -group pre101M -radix unsigned /tb_clkprescale/i_pre101M/s_prescaler
add wave -noupdate -expand -group pre101M -radix unsigned /tb_clkprescale/i_pre101M/s_counter
add wave -noupdate -expand -group pre101M /tb_clkprescale/i_pre101M/OUT_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1000030 ns} 0} {{Cursor 2} {1687998 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 124
configure wave -valuecolwidth 169
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ns} {15750 us}
