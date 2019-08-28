--------------------------------------------------------------------------------------------------
--                                                                                              --
--                                                                                              --
--                  F A C H H O C H S C H U L E   -   T E C H N I K U M W I E N                 --
--                                                                                              --
--                                                                                              --
--------------------------------------------------------------------------------------------------
--                                                                                              --
-- Web: http://www.technikum-wien.at/                                                           --
--                                                                                              --
-- Contact: christopher.krammer@technikum-wien.at                                               --
--------------------------------------------------------------------------------------------------
--
--
-- Author: Christopher Krammer
--
-- Filename: tb_clkPrescale_sim_cfg.vhd
--
-- Date of Creation: Mon Dec 17 12:30:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Fri Dec 14 12:30:00 2018
--
-- Design Unit: clkPrescale (Testbench Configuration)
--
-- Description: Prescales the clock as enable signal for internal modules
--
--------------------------------------------------------------------------------------------------
--
-- CVS Change Log:
--
--
--------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

configuration tb_clkPrescale_sim_cfg of tb_clkPrescale is
  for sim
    for i_pre1k : clkPrescale
      use configuration work.clkPrescale_rtl_cfg;
    end for;
    for i_pre2k : clkPrescale
      use configuration work.clkPrescale_rtl_cfg;
    end for;
    for i_pre3k : clkPrescale
      use configuration work.clkPrescale_rtl_cfg;
    end for;
    for i_pre101M : clkPrescale
      use configuration work.clkPrescale_rtl_cfg;
    end for;
  end for;
end tb_clkPrescale_sim_cfg;
