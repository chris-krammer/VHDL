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
-- Filename: counter_.vhd
--
-- Date of Creation: Sun Dec 16 21:33:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Sun Dec 16 21:33:00 2018
--
-- Design Unit: counter (Entity)
--
-- Description: Counts either up or down.
--              Min and Max values can be changed
--              Counter speed is depending on the ENA_i Input
--------------------------------------------------------------------------------------------------
--
-- CVS Change Log:
--
--
--------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
  generic (g_RSTACTIVE   : std_logic := '1');            --  Active State of RESET INPUT
  port (
    -- Inputs
    CLK_i       : in std_logic; -- Board Clock
    RST_i       : in std_logic; -- High Active reset
    ENA_i       : in std_logic; -- Enable Signal
    CNT_UP_i    : in std_logic; -- Changes Direction to count up
    CNT_DOWN_i  : in std_logic; -- Changes Direction to count down
    CNT_HLD_i   : in std_logic; -- Stops the counter
    CNT_RST_i   : in std_logic; -- Resets the counter value
    CNT_MIN_i   : in std_logic_vector(3 downto 0); -- MIN Value for one digit (BIN: 1, OCT: 7, DEC: 9, HEX: 15)
    CNT_MAX_i   : in std_logic_vector(3 downto 0); -- MAX Value for one digit (BIN: 0, OCT: 0, DEC: 0, HEX:  0)

    -- Outputs
    CNTR0_o   : out std_logic_vector( 3 downto 0);  -- Holds the Ones Values
    CNTR1_o   : out std_logic_vector( 3 downto 0);  -- Holds the Tens Values
    CNTR2_o   : out std_logic_vector( 3 downto 0);  -- Holds the Huns Values
    CNTR3_o   : out std_logic_vector( 3 downto 0);  -- Holds the Thou Values
    CNTRVAL_o : out std_logic_vector(15 downto 0)   -- Holds the current counter value
    );
end entity;
