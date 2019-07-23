-------------------------------------------------------------------------------
--                                                                      
--                        clkPrescale 
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         tb_clkPrescale
--
-- FILENAME:       tb_clkPrescale_sim_cfg.vhd
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
-- DESCRIPTION:    This is the configuration for the clkPrescale testbench
--                 of the clkPrescale VHDL class example.
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

configuration tb_clkPrescale_sim_cfg of tb_clkPrescale is
  for sim
    for i_mux : mux4to1
      use configuration work.mux4to1_rtl_cfg;
    end for;
	for i_pre : clkPrescale
      use configuration work.clkPrescale_rtl_cfg;
    end for;
  end for;
end tb_clkPrescale_sim_cfg;
