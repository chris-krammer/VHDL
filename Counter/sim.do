vsim -t ns -lib work work.tb_CounterTop
view *
do CounterTop_wave.do
run 400 ms
