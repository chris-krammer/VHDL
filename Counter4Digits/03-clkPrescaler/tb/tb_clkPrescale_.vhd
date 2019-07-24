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

entity tb_clkPrescale is
end tb_clkPrescale;

