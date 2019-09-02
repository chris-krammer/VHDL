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
-- Filename: vgaCtrl_rtl.vhd
--
-- Date of Creation: 12:00 19/02/2019
--
-- Version: 1.0
--
-- Date of Latest Version: 12:00 19/02/2019
--
-- Design Unit: vgaCtrl (Architecture)
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

-- Just as a Reminder
  -- Generics
  -- -- Resolution
  -- g_hPixels  : integer := 640; -- Horizontal display width
  -- g_vPixels  : integer := 480; -- Vertical   display width
  -- -- Horizontal Timings (Values in PIXELS)
  -- g_hFP    : integer := 16;  -- Horizontal front porch width
  -- g_hPULSE : integer := 96;  -- Horizontal sync pulse width
  -- g_hBP    : integer := 48;  -- Horizontal back porch width
  -- g_hPOL   : std_logic := '1'; -- Horizontal sync pulse polarity (1 = logic HIGH)
  -- -- Vertical Timings (Integer Values in PIXELS)
  -- g_vFP    : integer := 10;  -- Vertical front porch width
  -- g_vPULSE : integer := 2;   -- Vertical sync pulse width
  -- g_vBP    : integer := 33;  -- Vertical back porch width
  -- g_vPOL   : std_logic := '1'; -- Vertical sync pulse polarity  (1 = logic HIGH)
  -- --Blanking generics
  -- g_bPOL   : std_logic := '1'; -- Polarity of Display Available (1 = logic HIGH)
  -- -- ColorDepth
  -- g_ColorDepth: integer := 12 -- ColorDepth 6bit, 12bit or 24bit

  -- Ports
  -- -- Inputs
  -- CLK_i : in std_logic; -- Board Clock
  -- RST_i : in std_logic; -- High Active Asynchronous Reset
  -- EN_i  : in std_logic; -- Enable Input coming from clkDiv
  -- DATA_i  : in std_logic_vector(g_ColorDepth-1 downto 0); -- Color Values Input R[11:8], G[7:4], B[3:0]
  -- -- Outputs
  -- HSYNC_o : out std_logic; -- Horizontal Sync Output
  -- VSYNC_o : out std_logic; -- Vertical   Sync Output
  -- R_o     : out std_logic_vector((g_ColorDepth/3)-1 downto 0); -- Red Output
  -- G_o     : out std_logic_vector((g_ColorDepth/3)-1 downto 0); -- Green Output
  -- B_o     : out std_logic_vector((g_ColorDepth/3)-1 downto 0); -- Blue Output
  -- ROW_o   : out std_logic_vector(11 downto 0); -- ROW Index Output
  -- COL_o   : out std_logic_vector(11 downto 0)  -- Column Index Output
  -- BLANK_o : out std_logic -- Blanking time indication


architecture rtl of vgaCtrl is

  -- Define Values for the HSYNC and VSYNC Counters
  constant c_hMax : integer := g_hFP + g_hPULSE + g_hBP + g_hPixels; -- for 640x480: c_hMax = 800
  constant c_vMax : integer := g_vFP + g_vPULSE + g_vBP + g_vPixels; -- for 640x480: c_vMax = 525

  signal s_hCount : integer range 0 to c_hMax := 0;
  signal s_vCount : integer range 0 to c_vMax := 0;

  signal s_col : integer range 0 to (g_hPixels - 1) := 0;
  signal s_row : integer range 0 to (g_vPixels - 1) := 0;

  signal s_hSync : std_logic := not g_hPOL;
  signal s_vSync : std_logic := not g_vPOL;
  signal s_blank : std_logic := not g_bPOL;

begin

p_seq : process(CLK_i, RST_i) is -- Sequential because it is clocked

  begin

  if(RST_i = g_RSTACTIVE) then    -- Reset Detected
    s_hCount <= 0;                -- Reset horizontal counter
    s_vCount <= 0;                -- Reset vertical counter
    s_row    <= 0;                -- Reset Row Index
    s_col    <= 0;                -- Reset Column Index
    s_hSync  <= not g_hPOL;       -- Disable horizontal Sync
    s_vSync  <= not g_VPOL;       -- Disable vertical Sync
    s_blank  <= not g_bPOL;       -- Enable Display

  elsif(rising_edge(CLK_i)) then  -- Rising Edge at Master Clock detected
    if (ENA_i = '1') then         -- Pixel Clock is HIGH

      ---- Manage horizontal and vertical counters
      if (s_hCount = c_hMax - 1) then       -- Horizontal count reached
        s_hCount <= 0;                      -- Reset Horizontal count

        if (s_vCount = c_vMax - 1) then     -- Vertical count reached
          s_vCount <= 0;                    -- Reset Vertical count

        else                                -- Vertical count NOT reached
          s_vCount <= s_vCount + 1;         -- Increment Vertical count
        end if;

      else                                  -- Horizontal count NOT reached
        s_hCount <= s_hCount + 1;           -- Increment Horizontal count
      end if;

      -- Manage horizontal sync pulse
      if (s_hCount < (g_hPixels + g_hFP) or s_hCount >= (g_hPixels + g_hFP + g_hPULSE)) then
        s_hSync <= not g_hPOL;              -- Deassert horizontal sync pulse
      else
        s_hSync <= g_hPOL;                  -- Assert horizontal sync pulse
      end if;

      -- Manage vertical sync pulse
      if (s_vCount < (g_vPixels + g_vFP) or s_vCount >= (g_vPixels + g_vFP + g_vPULSE)) then
        s_vSync <= not g_vPOL;              -- Deassert vertical sync pulse
      else
        s_vSync <= g_vPOL;                  -- Assert vertical sync pulse
      end if;

      -- Manage blanking time (no colors should be output)
      if (s_hCount < g_hPixels and s_vCount < g_vPixels) then      -- Beam is in visible area
        s_blank <= g_bPOL;                  -- Inidicate display availability
      else                                  -- Beam is not in visible area
        s_blank <= not g_bPOL;              -- Indicate no display availability
      end if;

      -- Manage pixel coordinates
      if (s_hCount < g_hPixels) then         -- Beam is in visible area
        s_col <= s_hCount;                   -- Output the column number
      end if;

      if (s_vCount < g_vPixels) then         -- Beam is in visible area
        s_row <= s_vCount;                   -- Output the row number
      end if;

    end if; -- Enable
  end if;   -- Master Clock Rising Edge
end process p_seq;

  -- Assign signals to Outputs
  HSYNC_o <= s_hSync;
  VSYNC_o <= s_vSync;
  BLANK_o <= s_blank;
  COL_o <= s_col;
  ROW_o <= s_row;

end architecture;

