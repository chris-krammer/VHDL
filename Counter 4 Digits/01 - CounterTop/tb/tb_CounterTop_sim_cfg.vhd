-------------------------------------------------------------------------------
--                                                                      
--                        CounterTop 
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         tb_CounterTop
--
-- FILENAME:       tb_CounterTop_sim_cfg.vhd
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
-- DESCRIPTION:    This is the configuration for the CounterTop testbench
--                 of the CounterTop VHDL class example.
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

configuration tb_CounterTop_sim_cfg of tb_CounterTop is
  for sim
    for i_CounterTop : CounterTop
      use configuration work.CounterTop_struc_cfg;
    end for;
  end for;
end tb_CounterTop_sim_cfg;
