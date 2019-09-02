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
-- Filename: vgaCtrl_.vhd
--
-- Date of Creation: 12:00 19/02/2019
--
-- Version: 1.0
--
-- Date of Latest Version: 12:00 19/02/2019
--
-- Design Unit: vgaCtrl (Entity)
--
-- Description: Entity to control a VGA interface with 640x480 visible pixels
--        Main target is to control the HSYNC_o and VSYNC_o Outputs
--        Color Data is just passed by
--
--        This Entity is meant to be more generic than the project specifications (640x480)
--------------------------------------------------------------------------------------------------
--
-- CVS Change Log:
--
--
--------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vgaCtrl is
  generic(
    -- State for ACTIVE Reset
    g_RSTACTIVE : std_logic := '1';
    -- Resolution
    g_hPixels : integer := 640; -- Horizontal display width
    g_vPixels : integer := 480; -- Vertical   display width
    -- Horizontal Timings (Values in PIXELS)
    g_hFP     : integer := 16;  -- Horizontal front porch width
    g_hPULSE  : integer := 96;  -- Horizontal sync pulse width
    g_hBP     : integer := 48;  -- Horizontal back porch width
    g_hPOL    : std_logic := '1'; -- Horizontal sync pulse polarity (1 = logic HIGH)
    -- Vertical Timings (Integer Values in PIXELS)
    g_vFP     : integer := 10;  -- Vertical front porch width
    g_vPULSE  : integer := 2;   -- Vertical sync pulse width
    g_vBP     : integer := 33;  -- Vertical back porch width
    g_vPOL    : std_logic := '1'; -- Vertical sync pulse polarity  (1 = logic HIGH)
    -- Blanking generics
    g_bPOL    : std_logic := '1'; -- Blanking signal polarity (1 = logic HIGH = Display available)
    --ColorDepth
    g_ColorDepth  : integer := 12 -- ColorDepth 6bit, 12bit or 24bit
    );

  port(
    -- Inputs
    CLK_i   : in std_logic; -- Board Clock
    RST_i   : in std_logic; -- Reset
    ENA_i   : in std_logic; -- Enable Input coming from clkPrescaler
    -- Outputs
    HSYNC_o : out std_logic; -- Horizontal Sync Output
    VSYNC_o : out std_logic; -- Vertical   Sync Output
    BLANK_o : out std_logic; -- Blanking time indication
    ROW_o   : out integer;  -- ROW Index Output
    COL_o   : out integer  -- Column Index Output

    );

end entity;

