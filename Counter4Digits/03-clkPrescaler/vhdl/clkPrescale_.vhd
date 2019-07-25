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
-- Filename: clkPrescale_rtl.vhd
--
-- Version: 1.0
--
-- Design Unit: clkPrescale (Entitiy)
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

entity clkPrescale is
  -- Use generics with "generic map (target => value)" when instantiating
  -- Define Source- and Targetfrequencies
  generic(g_SOURCEHZ : integer := 100e6;
          g_TARGETHZ : integer :=   1e3);
  port(
    -- Inputs
    CLK_i : in std_logic;
    RST_i : in std_logic; -- HIGH Active Reset
    
    -- Outputs
    ERR_o : out std_logic;
    OUT_o: out std_logic
  );
end entity;