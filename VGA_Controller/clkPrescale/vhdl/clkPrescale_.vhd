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
-- Filename: clkPrescale_rtl.vhd
--
-- Date of Creation: Sun Dec 16 21:33:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Sun Dec 16 21:33:00 2018
--
-- Design Unit: clkPrescale (Entity)
--
-- Description: Prescales MasterClock
--        Generic g_SOURCEHZ defines MasterClock Frequency in HZ (integer)
--        Generic g_TARGETHZ defines TargetClock Frequency in HZ (integer)
--
-- !! KEEP IN MIND: THE OUTPUT SHOULD ONLY BE USED AS ENABLE SIGNAL, _NOT_ AS CLOCK SIGNAL
--                  SIGNAL IS _NOT_ ROUTED VIA CLOCK-TREE
--------------------------------------------------------------------------------------------------
--
-- CVS Change Log:
--
--
--------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clkPrescale is
generic(g_SOURCEHZ  : integer   := 100e6;  -- Frequency of the Master Clock HZ
        g_TARGETHZ  : integer   :=   1e3;  -- Desired Frequency in HZ
        g_OUTACTIVE : std_logic :=   '1';  -- Defines ACTIVE state of output
        g_RSTACTIVE : std_logic :=   '0'   -- Defines ACTIVE state for RST_i
        );

port(
  -- Inputs
  CLK_i : in std_logic;
  RST_i : in std_logic;

  -- Outputs
  OUT_o: out std_logic
  );
end entity;
