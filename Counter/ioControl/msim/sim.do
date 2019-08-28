vsim -t ns -lib work work.tb_ioCtrl
view *
do ioCtrl_wave.do
run 100 ms
