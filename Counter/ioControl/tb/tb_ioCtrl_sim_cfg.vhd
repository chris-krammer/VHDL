-------------------------------------------------------------------------------
--
--                        ioCtrl
--
-------------------------------------------------------------------------------
--
-- ENTITY:         tb_ioCtrl
--
-- FILENAME:       tb_ioCtrl_sim_cfg.vhd
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
-- DESCRIPTION:    This is the configuration for the ioCtrl testbench
--                 of the ioCtrl VHDL class example.
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

configuration tb_ioCtrl_sim_cfg of tb_ioCtrl is
  for sim
  --  for i_pre1k : clkPrescale
  --    use configuration work.clkPrescale_rtl_cfg;
  --  end for;
  --for i_pre4k : clkPrescale
  --    use configuration work.clkPrescale_rtl_cfg;
  --  end for;
    for i_io : ioCtrl
      use configuration work.ioCtrl_rtl_cfg;
    end for;
  end for;
end tb_ioCtrl_sim_cfg;
