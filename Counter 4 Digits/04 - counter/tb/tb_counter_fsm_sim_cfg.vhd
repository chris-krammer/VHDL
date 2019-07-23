-------------------------------------------------------------------------------
--                                                                      
--                        counter 
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         tb_counter_fsm
--
-- FILENAME:       tb_counter_fsm_sim_cfg.vhd
-- 
-- ARCHITECTURE:   sim
-- 
-- ENGINEER:       Christopher Krammer
--
-- DATE:           30. June 2000
--
-- VERSION:        1.0
--
-------------------------------------------------------------------------------
--                                                                      
-- DESCRIPTION:    This is the configuration for the counter testbench
--                 of the counter VHDL class example.
--
--
-------------------------------------------------------------------------------
--
-- REFERENCES:     (none)
--
-------------------------------------------------------------------------------
--                                                                      
-- PACKAGES:       std_logic_1164 (IEEE library)
--
-------------------------------------------------------------------------------
--                                                                      
-- CHANGES:        Version 2.0 - RH - 30 June 2000
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

configuration tb_counter_fsm_sim_cfg of tb_counter_fsm is
  for sim
    for i_counter_DEC_fsm : counter_fsm
      use configuration work.counter_fsm_rtl_cfg;
    end for;
    for i_counter_DEC : counter
      use configuration work.counter_rtl_cfg;
    end for;
	for i_counter_OCT : counter_fsm
      use configuration work.counter_fsm_rtl_cfg;
    end for;
	for i_counter_BIN : counter_fsm
      use configuration work.counter_fsm_rtl_cfg;
    end for;
	for i_clk : clkPrescale
      use configuration work.clkPrescale_rtl_cfg;
    end for;
  end for;
end tb_counter_fsm_sim_cfg;
