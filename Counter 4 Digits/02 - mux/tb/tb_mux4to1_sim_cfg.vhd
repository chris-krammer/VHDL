-------------------------------------------------------------------------------
--                                                                      
--                        mux4to1 
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         tb_mux4to1
--
-- FILENAME:       tb_mux4to1_sim_cfg.vhd
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
-- DESCRIPTION:    This is the configuration for the mux4to1 testbench
--                 of the mux4to1 VHDL class example.
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

configuration tb_mux4to1_sim_cfg of tb_mux4to1 is
  for sim
    for i_mux4to1_D0 : mux4to1
      use configuration work.mux4to1_rtl_cfg;
    end for;
	for i_mux4to1_D1 : mux4to1
      use configuration work.mux4to1_rtl_cfg;
    end for;
	for i_mux4to1_D2 : mux4to1
      use configuration work.mux4to1_rtl_cfg;
    end for;
  end for;
end tb_mux4to1_sim_cfg;
