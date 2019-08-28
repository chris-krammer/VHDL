vsim -t ns -lib work work.tb_counter_fsm
view *
do counter_fsm_wave.do
run 100 ms