onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_vgactrl/s_CLK
add wave -noupdate /tb_vgactrl/s_RST
add wave -noupdate -expand -group 25MHz_Clock /tb_vgactrl/i_25Mclk/CLK_i
add wave -noupdate -expand -group 25MHz_Clock /tb_vgactrl/i_25Mclk/RST_i
add wave -noupdate -expand -group 25MHz_Clock /tb_vgactrl/i_25Mclk/s_out
add wave -noupdate -expand -group 25MHz_Clock -radix unsigned /tb_vgactrl/i_25Mclk/s_prescaler
add wave -noupdate -expand -group 25MHz_Clock -radix unsigned /tb_vgactrl/i_25Mclk/s_counter
add wave -noupdate -expand -group 25MHz_Clock /tb_vgactrl/i_25Mclk/OUT_o
add wave -noupdate -expand -group vgaController /tb_vgactrl/i_vgaCtrl/CLK_i
add wave -noupdate -expand -group vgaController /tb_vgactrl/i_vgaCtrl/RST_i
add wave -noupdate -expand -group vgaController /tb_vgactrl/i_vgaCtrl/ENA_i
add wave -noupdate -expand -group vgaController /tb_vgactrl/i_vgaCtrl/s_hCount
add wave -noupdate -expand -group vgaController /tb_vgactrl/i_vgaCtrl/s_vCount
add wave -noupdate -expand -group vgaController /tb_vgactrl/i_vgaCtrl/s_col
add wave -noupdate -expand -group vgaController /tb_vgactrl/i_vgaCtrl/s_row
add wave -noupdate -expand -group vgaController /tb_vgactrl/i_vgaCtrl/s_hSync
add wave -noupdate -expand -group vgaController /tb_vgactrl/i_vgaCtrl/s_vSync
add wave -noupdate -expand -group vgaController /tb_vgactrl/i_vgaCtrl/s_blank
add wave -noupdate -expand -group vgaController /tb_vgactrl/i_vgaCtrl/ROW_o
add wave -noupdate -expand -group vgaController /tb_vgactrl/i_vgaCtrl/COL_o
add wave -noupdate -expand -group vgaController /tb_vgactrl/i_vgaCtrl/HSYNC_o
add wave -noupdate -expand -group vgaController /tb_vgactrl/i_vgaCtrl/VSYNC_o
add wave -noupdate -expand -group vgaController /tb_vgactrl/i_vgaCtrl/BLANK_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {73500 us}
