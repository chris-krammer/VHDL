onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group 1k_Prescaler /tb_ioCtrl/i_pre1k/CLK_i
add wave -noupdate -group 1k_Prescaler /tb_ioCtrl/i_pre1k/RST_i
add wave -noupdate -group 1k_Prescaler -radix unsigned /tb_ioCtrl/i_pre1k/SOURCEHZ_i
add wave -noupdate -group 1k_Prescaler -radix unsigned /tb_ioCtrl/i_pre1k/TARGETHZ_i
add wave -noupdate -group 1k_Prescaler /tb_ioCtrl/i_pre1k/OUT_o
add wave -noupdate -group 1k_Prescaler /tb_ioCtrl/i_pre1k/s_out
add wave -noupdate -group 4k_Prescaler /tb_ioCtrl/i_pre4k/CLK_i
add wave -noupdate -group 4k_Prescaler /tb_ioCtrl/i_pre4k/RST_i
add wave -noupdate -group 4k_Prescaler -radix unsigned /tb_ioCtrl/i_pre4k/SOURCEHZ_i
add wave -noupdate -group 4k_Prescaler -radix unsigned /tb_ioCtrl/i_pre4k/TARGETHZ_i
add wave -noupdate -group 4k_Prescaler /tb_ioCtrl/i_pre4k/OUT_o
add wave -noupdate -group 4k_Prescaler /tb_ioCtrl/i_pre4k/s_out
add wave -noupdate -expand -group ioCtrl /tb_ioCtrl/i_io/CLK_i
add wave -noupdate -expand -group ioCtrl /tb_ioCtrl/i_io/FCLK_i
add wave -noupdate -expand -group ioCtrl /tb_ioCtrl/i_io/RST_i
add wave -noupdate -expand -group ioCtrl -expand -group CNTR_Input /tb_ioCtrl/i_io/CNTR0_i
add wave -noupdate -expand -group ioCtrl -expand -group CNTR_Input /tb_ioCtrl/i_io/CNTR1_i
add wave -noupdate -expand -group ioCtrl -expand -group CNTR_Input /tb_ioCtrl/i_io/CNTR2_i
add wave -noupdate -expand -group ioCtrl -expand -group CNTR_Input /tb_ioCtrl/i_io/CNTR3_i
add wave -noupdate -expand -group ioCtrl -expand -group SWs /tb_ioCtrl/i_io/SW_i
add wave -noupdate -expand -group ioCtrl -expand -group SWs /tb_ioCtrl/i_io/s_swFF1
add wave -noupdate -expand -group ioCtrl -expand -group SWs /tb_ioCtrl/i_io/s_swFF2
add wave -noupdate -expand -group ioCtrl -expand -group SWs /tb_ioCtrl/i_io/s_swFF3
add wave -noupdate -expand -group ioCtrl -expand -group SWs /tb_ioCtrl/i_io/swsync
add wave -noupdate -expand -group ioCtrl -expand -group SWs /tb_ioCtrl/i_io/SWSYNC_o
add wave -noupdate -expand -group ioCtrl -expand -group PBs /tb_ioCtrl/i_io/PB_i
add wave -noupdate -expand -group ioCtrl -expand -group PBs /tb_ioCtrl/i_io/s_pbFF1
add wave -noupdate -expand -group ioCtrl -expand -group PBs /tb_ioCtrl/i_io/s_pbFF2
add wave -noupdate -expand -group ioCtrl -expand -group PBs /tb_ioCtrl/i_io/s_pbFF3
add wave -noupdate -expand -group ioCtrl -expand -group PBs /tb_ioCtrl/i_io/pbsync
add wave -noupdate -expand -group ioCtrl -expand -group PBs /tb_ioCtrl/i_io/PBSYNC_o
add wave -noupdate -expand -group ioCtrl -expand -group 7Seg /tb_ioCtrl/i_io/s_sel
add wave -noupdate -expand -group ioCtrl -expand -group 7Seg /tb_ioCtrl/i_io/s_ss_sel
add wave -noupdate -expand -group ioCtrl -expand -group 7Seg /tb_ioCtrl/i_io/s_ss
add wave -noupdate -expand -group ioCtrl -expand -group 7Seg -group MUX_Value /tb_ioCtrl/i_io/U1/IN0_i
add wave -noupdate -expand -group ioCtrl -expand -group 7Seg -group MUX_Value /tb_ioCtrl/i_io/U1/IN1_i
add wave -noupdate -expand -group ioCtrl -expand -group 7Seg -group MUX_Value /tb_ioCtrl/i_io/U1/IN2_i
add wave -noupdate -expand -group ioCtrl -expand -group 7Seg -group MUX_Value /tb_ioCtrl/i_io/U1/IN3_i
add wave -noupdate -expand -group ioCtrl -expand -group 7Seg -group MUX_Value /tb_ioCtrl/i_io/U1/SEL_i
add wave -noupdate -expand -group ioCtrl -expand -group 7Seg -group MUX_Value /tb_ioCtrl/i_io/U1/OUT_o
add wave -noupdate -expand -group ioCtrl -expand -group 7Seg -group Mux_Digit /tb_ioCtrl/i_io/U2/IN0_i
add wave -noupdate -expand -group ioCtrl -expand -group 7Seg -group Mux_Digit /tb_ioCtrl/i_io/U2/IN1_i
add wave -noupdate -expand -group ioCtrl -expand -group 7Seg -group Mux_Digit /tb_ioCtrl/i_io/U2/IN2_i
add wave -noupdate -expand -group ioCtrl -expand -group 7Seg -group Mux_Digit /tb_ioCtrl/i_io/U2/IN3_i
add wave -noupdate -expand -group ioCtrl -expand -group 7Seg -group Mux_Digit /tb_ioCtrl/i_io/U2/SEL_i
add wave -noupdate -expand -group ioCtrl -expand -group 7Seg -group Mux_Digit /tb_ioCtrl/i_io/U2/OUT_o
add wave -noupdate -expand -group ioCtrl -expand -group 7Seg /tb_ioCtrl/i_io/SS_SEL_o
add wave -noupdate -expand -group ioCtrl -expand -group 7Seg /tb_ioCtrl/i_io/SS_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11592287 ns} 0} {{Cursor 2} {0 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 144
configure wave -valuecolwidth 219
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
