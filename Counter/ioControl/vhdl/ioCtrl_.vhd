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
-- Filename: ioCtrl_.vhd
--
-- Date of Creation: Sun Dec 16 21:33:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Sun Dec 16 21:33:00 2018
--
-- Design Unit: mux4to1 (Entity)
--
-- Description: Syncs and debounces the inputs and acts as last instance before outputs interact
--              with the "real" world
--------------------------------------------------------------------------------------------------
--
-- CVS Change Log:
--
--
--------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity ioCtrl is
  generic(  g_SOURCEHZ    : integer range 1 to 100e6 := 100e6;  -- Board Clock Frequency in Hz
            g_PBINPUTS    : integer   :=  5;            --  Number of PushButtons (excl. CPU_RESET)
            g_SWINPUTS    : integer   := 16;            --  Number of Switches
            g_DEBTIME     : integer   := 10;            --  Debounce Time in MasterClock Ticks
            g_RSTACTIVE   : std_logic := '1'            --  Active State of RESET INPUT
          );

  port( CLK_i     : in  std_logic;                      --  Clock Input 1kHz
        RST_i     : in  std_logic;                      --  Reset Input
        -- Inputs from real world
        SW_i      : in  std_logic_vector(g_SWINPUTS-1 downto 0); --  Switch Inputs
        PB_i      : in  std_logic_vector(g_PBINPUTS-1 downto 0); --  Push-Button Inputs
        -- Inputs from internal counter
        CNTR0_i   : in  std_logic_vector( 3 downto 0); --  Counter Input Digit 1
        CNTR1_i   : in  std_logic_vector( 3 downto 0); --  Counter Input Digit 2
        CNTR2_i   : in  std_logic_vector( 3 downto 0); --  Counter Input Digit 3
        CNTR3_i   : in  std_logic_vector( 3 downto 0); --  Counter Input Digit 4
        -- Outputs to the 7 Segment
        SS_o      : out std_logic_vector( 7 downto 0); --  Seven-Segment Output
        SS_SEL_o  : out std_logic_vector( 3 downto 0); --  Seven-Segment Selector Output
        -- Debounced Outputs for internal use
        SWSYNC_o  : out std_logic_vector(g_SWINPUTS-1 downto 0); --  Syncronized Switches Output
        PBSYNC_o  : out std_logic_vector(g_PBINPUTS-1 downto 0)  --  Syncronized Push-Buttons Output
      );

end ioCtrl;


