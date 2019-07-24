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
-- !! KEEP IN MIND: NEW FREQUENCY IS UPDATED DURING CLOCK LOW.
--          THIS MEANS THE ACTUAL PERIOD WILL BE FINISHED BEFORE
--          THE NEW PERIOD WILL START
--          EXCEPTION: RESET
--
-- !! KEEP IN MIND: OUTPUT IS NOT UPDATED IF WRONG INPUTS APPLIED
--
--------------------------------------------------------------------------------
-- CVS Change Log:
--
--------------------------------------------------------------------------------
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
