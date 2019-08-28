vsim -t ns -lib work work.tb_clkPrescale
view *
do clkPrescale_wave.do
run 15 ms
