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
-- Filename: tb_mux4to1_sim_cfg.vhd
--
-- Date of Creation: Sun Dec 16 21:33:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Sun Dec 16 21:33:00 2018
--
-- Design Unit: mux4to1 (Testbench Configuration)
--
-- Description: Selects one of the four inputs and copies it to the output
--------------------------------------------------------------------------------------------------
--
-- CVS Change Log:
--
--
--------------------------------------------------------------------------------------------------
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
