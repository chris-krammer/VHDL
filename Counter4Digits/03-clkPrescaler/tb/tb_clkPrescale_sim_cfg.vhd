--------------------------------------------------------------------------------
--                                                                            --
--        F A C H H O C H S C H U L E   -   T E C H N I K U M W I E N         --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
-- Web: http://www.technikum-wien.at/                                         --
--                                                                            --
-- Contact: christopher.krammer@technikum-wien.at                             --
--                                                                            --
--------------------------------------------------------------------------------
--
-- Author: Christopher Krammer
--
-- Filename: tb_clkPrescale_sim_cfg.vhd
--
-- Version: 1.0
--
-- Design Unit: tb_clkPrescale (Testbench Configuration)
--
-- Description: Prescales MasterClock
--        Generic g_SOURCEHZ defines MasterClock Frequency in HZ (integer)
--        Generic g_TARGETHZ defines TargetClock Frequency in HZ (integer)
--
-- !! KEEP IN MIND: NO MECHANISMS IMPLEMENTED FOR TARGET > SOURCE
-- !! KEEP IN MIND: NOT SUITABLE AS CLOCK SIGNAL (ROUTED AS SIGNAL)
-- !! KEEP IN MIND: FOR SERIOUS CLOCK GENERATION USE MANUFACTURER SUPPLIED CORES
--
--------------------------------------------------------------------------------
-- CVS Change Log:
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

configuration tb_clkPrescale_sim_cfg of tb_clkPrescale is
  for sim
    for i_clk1 : clkPrescale
      use configuration work.clkPrescale_rtl_cfg;
    end for;
    for i_clk2 : clkPrescale
      use configuration work.clkPrescale_rtl_cfg;
    end for;
    for i_clk3 : clkPrescale
      use configuration work.clkPrescale_rtl_cfg;
    end for;
    for i_clk4 : clkPrescale
      use configuration work.clkPrescale_rtl_cfg;
    end for;
  end for;
end tb_clkPrescale_sim_cfg;
