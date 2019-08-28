onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_counter_fsm/s_Clk
add wave -noupdate /tb_counter_fsm/s_RST
add wave -noupdate /tb_counter_fsm/s_UP
add wave -noupdate /tb_counter_fsm/s_DOWN
add wave -noupdate /tb_counter_fsm/s_HLD
add wave -noupdate /tb_counter_fsm/s_CNT_RST
add wave -noupdate -expand -group clkPrescaler /tb_counter_fsm/i_clk/CLK_i
add wave -noupdate -expand -group clkPrescaler /tb_counter_fsm/i_clk/RST_i
add wave -noupdate -expand -group clkPrescaler -radix unsigned /tb_counter_fsm/i_clk/SOURCEHZ_i
add wave -noupdate -expand -group clkPrescaler -radix unsigned /tb_counter_fsm/i_clk/TARGETHZ_i
add wave -noupdate -expand -group clkPrescaler /tb_counter_fsm/i_clk/OUT_o
add wave -noupdate -expand -group DEC /tb_counter_fsm/i_counter_DEC/CLK_i
add wave -noupdate -expand -group DEC -radix unsigned /tb_counter_fsm/i_counter_DEC/CNTR0_o
add wave -noupdate -expand -group DEC -radix unsigned /tb_counter_fsm/i_counter_DEC/CNTR1_o
add wave -noupdate -expand -group DEC -radix unsigned /tb_counter_fsm/i_counter_DEC/CNTR2_o
add wave -noupdate -expand -group DEC -radix unsigned /tb_counter_fsm/i_counter_DEC/CNTR3_o
add wave -noupdate -expand -group DEC /tb_counter_fsm/i_counter_DEC/s_state
add wave -noupdate -group HEX /tb_counter_fsm/i_counter_HEX/CLK_i
add wave -noupdate -group HEX -radix hexadecimal /tb_counter_fsm/i_counter_HEX/CNTR0_o
add wave -noupdate -group HEX -radix hexadecimal /tb_counter_fsm/i_counter_HEX/CNTR1_o
add wave -noupdate -group HEX -radix hexadecimal /tb_counter_fsm/i_counter_HEX/CNTR2_o
add wave -noupdate -group HEX -radix hexadecimal /tb_counter_fsm/i_counter_HEX/CNTR3_o
add wave -noupdate -group HEX /tb_counter_fsm/i_counter_HEX/s_state
add wave -noupdate -group OCT /tb_counter_fsm/i_counter_OCT/CLK_i
add wave -noupdate -group OCT -radix octal /tb_counter_fsm/i_counter_OCT/CNTR0_o
add wave -noupdate -group OCT -radix octal /tb_counter_fsm/i_counter_OCT/CNTR1_o
add wave -noupdate -group OCT -radix octal /tb_counter_fsm/i_counter_OCT/CNTR2_o
add wave -noupdate -group OCT -radix octal /tb_counter_fsm/i_counter_OCT/CNTR3_o
add wave -noupdate -group OCT /tb_counter_fsm/i_counter_OCT/s_state
add wave -noupdate -group BIN /tb_counter_fsm/i_counter_BIN/CLK_i
add wave -noupdate -group BIN -radix unsigned /tb_counter_fsm/i_counter_BIN/CNTR0_o
add wave -noupdate -group BIN -radix unsigned /tb_counter_fsm/i_counter_BIN/CNTR1_o
add wave -noupdate -group BIN -radix unsigned /tb_counter_fsm/i_counter_BIN/CNTR2_o
add wave -noupdate -group BIN -radix unsigned /tb_counter_fsm/i_counter_BIN/CNTR3_o
add wave -noupdate -group BIN /tb_counter_fsm/i_counter_BIN/s_MAX
add wave -noupdate -group BIN /tb_counter_fsm/i_counter_BIN/s_state
add wave -noupdate -radix binary /tb_counter_fsm/i_counter_DEC_fsm/p_CNT/v_EN
add wave -noupdate -radix binary /tb_counter_fsm/i_counter_DEC_fsm/p_CNT/v_ENTENS
add wave -noupdate -radix binary /tb_counter_fsm/i_counter_DEC_fsm/p_CNT/v_ENHUNS
add wave -noupdate -radix binary /tb_counter_fsm/i_counter_DEC_fsm/p_CNT/v_ENTHOU
add wave -noupdate -radix decimal /tb_counter_fsm/i_counter_DEC_fsm/p_CNT/v_Ones
add wave -noupdate -radix decimal /tb_counter_fsm/i_counter_DEC_fsm/p_CNT/v_Tens
add wave -noupdate -radix decimal /tb_counter_fsm/i_counter_DEC_fsm/p_CNT/v_Huns
add wave -noupdate -radix decimal /tb_counter_fsm/i_counter_DEC_fsm/p_CNT/v_Thou
add wave -noupdate -radix decimal /tb_counter_fsm/i_counter_DEC_fsm/p_CNT/v_Count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 135
configure wave -valuecolwidth 74
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
WaveRestoreZoom {0 ns} {105 ms}
