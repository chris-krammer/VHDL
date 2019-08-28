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
-- Filename: counterTop_.vhd
--
-- Date of Creation: Sun Dec 16 21:33:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Sun Dec 16 21:33:00 2018
--
-- Design Unit: counterTop (Entity)
--
-- Description: Counts up or down and displays the current value through the four onboard 7-Segments
--        Counter is able to:
--        - hold counter value
--        - reset counter value
--        - reset counter value and continue with the last direction or hold (BTNR)
--        - count up
--        - count down
--        - change counter base (DEC, HEX, OCT, BIN) (requires RESET (BTNC OR BTNR))
--        - change the counting frequency (1kHz, 1Hz, 10Hz, 100Hz)
--
--------------------------------------------------------------------------------------------------
--
-- CVS Change Log:
--
--
--------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity counterTop is
  generic ( g_SOURCEHZ  : integer   := 100e6;  -- Frequency of the Master Clock HZ
            g_RSTACTIVE : std_logic :=   '0';  -- Defines ACTIVE state for RST_i
            g_PBs       : integer := 5;
            g_SWs       : integer := 16
          );

  port (
  -- Inputs from Basys 3 Bord
  CLK_i : in std_logic; -- Master Clock Input
    -- E3
  RST_i : in std_logic; -- Reset (LOW ACTIVE ON NEXYS A7 BOARD!!)
    -- CPU_RESET, C12
  PB_i  : in std_logic_vector(g_PBs - 1 downto 0);
    -- PB_i(0) -> Count Value RESET,  BTNR, M17
    -- PB_i(1) -> Count Value HOLD,   BTNL, P17
    -- PB_i(2) -> Count UPWARDS,      BTNU, M18
    -- PB_i(3) -> Count DOWNWARDS,    BTND, P18
  SW_i  : in std_logic_vector(g_SWs - 1 downto 0);
    -- SW_i( 1: 0) -> Set BASE    SW1 , L16 : SW0 , J15
    -- SW_i(13: 2) -> NOT USED
    -- SW_i(15:14) -> Set SPEED   SW15, V10  : SW14, 11

  -- Outputs for Basys 3 Board (Low Active)
  SS_Sel_o  : out std_logic_vector(3 downto 0);
    -- SS_Sel_o(0) -> En/Disabled Digit 0,  AN0, J17
    -- SS_Sel_o(1) -> En/Disabled Digit 1,  AN1, J18
    -- SS_Sel_o(2) -> En/Disabled Digit 2,  AN2, T9
    -- SS_Sel_o(3) -> En/Disabled Digit 3,  AN3, J14
  SS_o    : out std_logic_vector(7 downto 0)
    -- SS_o(0) -> En/Disabled Segment DP, H15
    -- SS_o(1) -> En/Disabled Segment CG, L18
    -- SS_o(2) -> En/Disabled Segment CF, T11
    -- SS_o(3) -> En/Disabled Segment CE, P15
    -- SS_o(4) -> En/Disabled Segment CD, K13
    -- SS_o(5) -> En/Disabled Segment CC, K16
    -- SS_o(6) -> En/Disabled Segment CB, R10
    -- SS_o(7) -> En/Disabled Segment CA, T10
  );

end counterTop;
