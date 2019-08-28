onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_countertop/s_Clk
add wave -noupdate /tb_countertop/s_Rst
add wave -noupdate /tb_countertop/s_pb
add wave -noupdate /tb_countertop/s_sw
add wave -noupdate -group U1 /tb_countertop/i_CounterTop/U1/CLK_i
add wave -noupdate -group U1 /tb_countertop/i_CounterTop/U1/RST_i
add wave -noupdate -group U1 /tb_countertop/i_CounterTop/U1/OUT_o
add wave -noupdate -group U1 /tb_countertop/i_CounterTop/U1/s_out
add wave -noupdate -group U1 /tb_countertop/i_CounterTop/U1/s_prescaler
add wave -noupdate -group U1 /tb_countertop/i_CounterTop/U1/s_counter
add wave -noupdate -group U2 /tb_countertop/i_CounterTop/U2/CLK_i
add wave -noupdate -group U2 /tb_countertop/i_CounterTop/U2/RST_i
add wave -noupdate -group U2 /tb_countertop/i_CounterTop/U2/OUT_o
add wave -noupdate -group U2 /tb_countertop/i_CounterTop/U2/s_out
add wave -noupdate -group U2 /tb_countertop/i_CounterTop/U2/s_prescaler
add wave -noupdate -group U2 /tb_countertop/i_CounterTop/U2/s_counter
add wave -noupdate -group U3 /tb_countertop/i_CounterTop/U3/CLK_i
add wave -noupdate -group U3 /tb_countertop/i_CounterTop/U3/RST_i
add wave -noupdate -group U3 /tb_countertop/i_CounterTop/U3/OUT_o
add wave -noupdate -group U3 /tb_countertop/i_CounterTop/U3/s_out
add wave -noupdate -group U3 /tb_countertop/i_CounterTop/U3/s_prescaler
add wave -noupdate -group U3 /tb_countertop/i_CounterTop/U3/s_counter
add wave -noupdate -group U4 /tb_countertop/i_CounterTop/U4/CLK_i
add wave -noupdate -group U4 /tb_countertop/i_CounterTop/U4/RST_i
add wave -noupdate -group U4 /tb_countertop/i_CounterTop/U4/OUT_o
add wave -noupdate -group U4 /tb_countertop/i_CounterTop/U4/s_out
add wave -noupdate -group U4 /tb_countertop/i_CounterTop/U4/s_prescaler
add wave -noupdate -group U4 /tb_countertop/i_CounterTop/U4/s_counter
add wave -noupdate -group U5 /tb_countertop/i_CounterTop/U5/IN0_i
add wave -noupdate -group U5 /tb_countertop/i_CounterTop/U5/IN1_i
add wave -noupdate -group U5 /tb_countertop/i_CounterTop/U5/IN2_i
add wave -noupdate -group U5 /tb_countertop/i_CounterTop/U5/IN3_i
add wave -noupdate -group U5 /tb_countertop/i_CounterTop/U5/SEL_i
add wave -noupdate -group U5 /tb_countertop/i_CounterTop/U5/OUT_o
add wave -noupdate -group U6 /tb_countertop/i_CounterTop/U6/IN0_i
add wave -noupdate -group U6 /tb_countertop/i_CounterTop/U6/IN1_i
add wave -noupdate -group U6 /tb_countertop/i_CounterTop/U6/IN2_i
add wave -noupdate -group U6 /tb_countertop/i_CounterTop/U6/IN3_i
add wave -noupdate -group U6 /tb_countertop/i_CounterTop/U6/SEL_i
add wave -noupdate -group U6 /tb_countertop/i_CounterTop/U6/OUT_o
add wave -noupdate -group U7 /tb_countertop/i_CounterTop/U7/CLK_i
add wave -noupdate -group U7 /tb_countertop/i_CounterTop/U7/RST_i
add wave -noupdate -group U7 /tb_countertop/i_CounterTop/U7/SW_i
add wave -noupdate -group U7 /tb_countertop/i_CounterTop/U7/PB_i
add wave -noupdate -group U7 /tb_countertop/i_CounterTop/U7/CNTR0_i
add wave -noupdate -group U7 /tb_countertop/i_CounterTop/U7/CNTR1_i
add wave -noupdate -group U7 /tb_countertop/i_CounterTop/U7/CNTR2_i
add wave -noupdate -group U7 /tb_countertop/i_CounterTop/U7/CNTR3_i
add wave -noupdate -group U7 /tb_countertop/i_CounterTop/U7/SS_o
add wave -noupdate -group U7 /tb_countertop/i_CounterTop/U7/SS_SEL_o
add wave -noupdate -group U7 /tb_countertop/i_CounterTop/U7/SWSYNC_o
add wave -noupdate -group U7 /tb_countertop/i_CounterTop/U7/PBSYNC_o
add wave -noupdate -group U7 /tb_countertop/i_CounterTop/U7/s_SS_CLK_EN
add wave -noupdate -group U7 /tb_countertop/i_CounterTop/U7/s_sel
add wave -noupdate -group U7 /tb_countertop/i_CounterTop/U7/s_ss_sel
add wave -noupdate -group U7 /tb_countertop/i_CounterTop/U7/s_ss
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/CLK_i
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/RST_i
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/ENA_i
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/CNT_UP_i
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/CNT_DOWN_i
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/CNT_HLD_i
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/CNT_RST_i
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/CNT_MIN_i
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/CNT_MAX_i
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/CNTR0_o
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/CNTR1_o
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/CNTR2_o
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/CNTR3_o
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/CNTRVAL_o
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/s_state
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/s_prev_state
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/s_Ones
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/s_Tens
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/s_Huns
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/s_Thou
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/s_Count
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/s_MIN
add wave -noupdate -group U8 /tb_countertop/i_CounterTop/U8/s_MAX
add wave -noupdate /tb_countertop/s_ss_sel
add wave -noupdate /tb_countertop/s_ss
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {108046422 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 246
configure wave -valuecolwidth 112
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
WaveRestoreZoom {0 ns} {60150983 ns}
