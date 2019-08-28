onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_mux4to1/s_Clk
add wave -noupdate /tb_mux4to1/s_SClk
add wave -noupdate /tb_mux4to1/s_Rst
add wave -noupdate -radix unsigned /tb_mux4to1/s_SEL
add wave -noupdate -expand -group mux_D0 -radix unsigned /tb_mux4to1/i_mux4to1_D0/IN0_i
add wave -noupdate -expand -group mux_D0 -radix unsigned /tb_mux4to1/i_mux4to1_D0/IN1_i
add wave -noupdate -expand -group mux_D0 -radix unsigned /tb_mux4to1/i_mux4to1_D0/IN2_i
add wave -noupdate -expand -group mux_D0 -radix unsigned /tb_mux4to1/i_mux4to1_D0/IN3_i
add wave -noupdate -expand -group mux_D0 -radix unsigned /tb_mux4to1/i_mux4to1_D0/SEL_i
add wave -noupdate -expand -group mux_D0 -radix unsigned /tb_mux4to1/i_mux4to1_D0/OUT_o
add wave -noupdate -expand -group mux_D1 -radix unsigned /tb_mux4to1/i_mux4to1_D1/IN0_i
add wave -noupdate -expand -group mux_D1 -radix unsigned /tb_mux4to1/i_mux4to1_D1/IN1_i
add wave -noupdate -expand -group mux_D1 -radix unsigned /tb_mux4to1/i_mux4to1_D1/IN2_i
add wave -noupdate -expand -group mux_D1 -radix unsigned /tb_mux4to1/i_mux4to1_D1/IN3_i
add wave -noupdate -expand -group mux_D1 -radix unsigned /tb_mux4to1/i_mux4to1_D1/SEL_i
add wave -noupdate -expand -group mux_D1 -radix unsigned /tb_mux4to1/i_mux4to1_D1/OUT_o
add wave -noupdate -expand -group mux_D2 -radix unsigned /tb_mux4to1/i_mux4to1_D2/IN0_i
add wave -noupdate -expand -group mux_D2 -radix unsigned /tb_mux4to1/i_mux4to1_D2/IN1_i
add wave -noupdate -expand -group mux_D2 -radix unsigned /tb_mux4to1/i_mux4to1_D2/IN2_i
add wave -noupdate -expand -group mux_D2 -radix unsigned /tb_mux4to1/i_mux4to1_D2/IN3_i
add wave -noupdate -expand -group mux_D2 -radix unsigned /tb_mux4to1/i_mux4to1_D2/SEL_i
add wave -noupdate -expand -group mux_D2 -radix unsigned /tb_mux4to1/i_mux4to1_D2/OUT_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 117
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
WaveRestoreZoom {0 ns} {36750 us}
