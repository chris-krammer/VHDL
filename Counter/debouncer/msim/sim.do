vsim -t ns -lib work work.tb_debouncer
view *
do debouncer_wave.do
run 100 ms
