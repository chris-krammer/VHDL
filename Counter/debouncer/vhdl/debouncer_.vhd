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
-- Filename: ioCtrl_rtl.vhd
--
-- Date of Creation: Sun Dec 16 21:33:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Sun Dec 16 21:33:00 2018
--
-- Design Unit: debouncer (Entity)
--
-- Description: Syncs and debounces the inputs from mechanical inputs
--------------------------------------------------------------------------------------------------
--
-- CVS Change Log:
--
--
--------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncer is
  generic(  g_SOURCEHZ      : integer range 1 to 100e6 := 100e6;  -- Board Clock Frequency in Hz
            g_DEBTIME       : integer range 1 to 100 := 10;       -- Debounce Time in ms
            g_RSTACTIVE     : std_logic := '1'                    -- Reset ACTIVE state
          );
  port(
        --  Inputs
        CLK_i : in std_logic;  -- Board Clock
        RST_i : in std_logic;  -- Reset
        IN_i  : in std_logic;  -- Input to be debounced

        -- Outputs
        OUT_o : out std_logic

      );
end entity ; -- debouncer_
