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
-- Filename: tb_debouncer_sim.vhd
--
-- Date of Creation: Mon Dec 17 12:30:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Fri Dec 14 12:30:00 2018
--
-- Design Unit: debouncer (Testbench Configuration)
--
-- Description: Syncs and debounces the inputs from mechanical inputs
--------------------------------------------------------------------------------------------------
--
-- CVS Change Log:
--
--
--------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

configuration tb_debouncer_sim_cfg of tb_debouncer is
  for sim
    for PB_DEBx : debouncer
      use configuration work.debouncer_rtl_cfg;
    end for;
    for SW_DEBx : debouncer
      use configuration work.debouncer_rtl_cfg;
    end for;
  end for;
end tb_debouncer_sim_cfg;
