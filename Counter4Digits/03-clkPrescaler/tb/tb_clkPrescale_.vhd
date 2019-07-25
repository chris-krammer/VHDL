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
-- Filename: tb_clkPrescale_.vhd
--
-- Version: 1.0
--
-- Design Unit: tb_clkPrescale (Testbench Entity)
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

entity tb_clkPrescale is
end tb_clkPrescale;

