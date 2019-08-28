onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_debouncer/s_CLK
add wave -noupdate /tb_debouncer/s_RST
add wave -noupdate /tb_debouncer/s_PBIN
add wave -noupdate -group PB_0 /tb_debouncer/GEN_PB_DEBOUNCER(0)/PB_DEBx/IN_i
add wave -noupdate -group PB_0 /tb_debouncer/GEN_PB_DEBOUNCER(0)/PB_DEBx/s_flipflops
add wave -noupdate -group PB_0 /tb_debouncer/GEN_PB_DEBOUNCER(0)/PB_DEBx/line__50/v_count
add wave -noupdate -group PB_0 /tb_debouncer/GEN_PB_DEBOUNCER(0)/PB_DEBx/s_counter_set
add wave -noupdate -group PB_0 /tb_debouncer/GEN_PB_DEBOUNCER(0)/PB_DEBx/s_OUT
add wave -noupdate -group PB_0 /tb_debouncer/GEN_PB_DEBOUNCER(0)/PB_DEBx/OUT_o
add wave -noupdate -group PB_1 /tb_debouncer/GEN_PB_DEBOUNCER(1)/PB_DEBx/IN_i
add wave -noupdate -group PB_1 /tb_debouncer/GEN_PB_DEBOUNCER(1)/PB_DEBx/s_flipflops
add wave -noupdate -group PB_1 /tb_debouncer/GEN_PB_DEBOUNCER(1)/PB_DEBx/line__50/v_count
add wave -noupdate -group PB_1 /tb_debouncer/GEN_PB_DEBOUNCER(1)/PB_DEBx/s_counter_set
add wave -noupdate -group PB_1 /tb_debouncer/GEN_PB_DEBOUNCER(1)/PB_DEBx/s_OUT
add wave -noupdate -group PB_1 /tb_debouncer/GEN_PB_DEBOUNCER(1)/PB_DEBx/OUT_o
add wave -noupdate -group PB_2 /tb_debouncer/GEN_PB_DEBOUNCER(2)/PB_DEBx/IN_i
add wave -noupdate -group PB_2 /tb_debouncer/GEN_PB_DEBOUNCER(2)/PB_DEBx/s_flipflops
add wave -noupdate -group PB_2 /tb_debouncer/GEN_PB_DEBOUNCER(2)/PB_DEBx/line__50/v_count
add wave -noupdate -group PB_2 /tb_debouncer/GEN_PB_DEBOUNCER(2)/PB_DEBx/s_counter_set
add wave -noupdate -group PB_2 /tb_debouncer/GEN_PB_DEBOUNCER(2)/PB_DEBx/s_OUT
add wave -noupdate -group PB_2 /tb_debouncer/GEN_PB_DEBOUNCER(2)/PB_DEBx/OUT_o
add wave -noupdate -group PB_3 /tb_debouncer/GEN_PB_DEBOUNCER(3)/PB_DEBx/IN_i
add wave -noupdate -group PB_3 /tb_debouncer/GEN_PB_DEBOUNCER(3)/PB_DEBx/s_flipflops
add wave -noupdate -group PB_3 /tb_debouncer/GEN_PB_DEBOUNCER(3)/PB_DEBx/line__50/v_count
add wave -noupdate -group PB_3 /tb_debouncer/GEN_PB_DEBOUNCER(3)/PB_DEBx/s_counter_set
add wave -noupdate -group PB_3 /tb_debouncer/GEN_PB_DEBOUNCER(3)/PB_DEBx/s_OUT
add wave -noupdate -group PB_3 /tb_debouncer/GEN_PB_DEBOUNCER(3)/PB_DEBx/OUT_o
add wave -noupdate /tb_debouncer/s_PBOUT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {53716738 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 157
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
WaveRestoreZoom {0 ns} {105 ms}
