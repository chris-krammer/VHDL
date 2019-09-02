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
-- Filename: tb_vgaCtrl_sim.vhd
--
-- Date of Creation: 12:00 19/02/2019
--
-- Version: 1.0
--
-- Date of Latest Version: 12:00 19/02/2019
--
-- Design Unit: tb_vgaCtrl (Tesbench Architecture)
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

architecture sim of tb_vgaCtrl is

  -- Constants used for the Board Clock
  constant ClockFrequencyHz : integer := 100e6; -- 100 MHz
  constant ClockPeriod      : time    := 1000 ms / ClockFrequencyHz;
  constant c_RSTACTIVE      : std_logic := '1';

  -- Constants used for the TestBench
  constant c_displayWidth : integer := 640;
  constant c_displayHeight: integer := 480;
  constant c_hPOL : std_logic := '1';
  constant c_vPOL : std_logic := '1';
  constant c_bPOL : std_logic := '1';

  constant c_TilesPerRow  : integer := 10;
  constant c_TilesPerCol  : integer := 10;
  constant c_hOffset : integer := (c_displayWidth / c_TilesPerRow);   -- 640 / 10 =   64px
  constant c_vOffset : integer := (c_displayHeight / c_TilesPerRow);  -- 480 / 10 =  480px

  -- Component declarations
  component vgaCtrl
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
        g_vFP     : integer := 2;  -- Vertical front porch width
        g_vPULSE  : integer := 10;   -- Vertical sync pulse width
        g_vBP     : integer := 33;  -- Vertical back porch width
        g_vPOL    : std_logic := '1'; -- Vertical sync pulse polarity  (1 = logic HIGH)
        -- Blanking generics
        g_bPOL    : std_logic := '1'; -- Blanking signal polarity (1 = logic HIGH = Display NOT available)
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
        -- Following signals are managed by ioCtrl Module
        --DATA_i  : in std_logic_vector(g_ColorDepth-1 downto 0); -- Color Values Input
        --R_o     : out unsigned((g_ColorDepth/3)-1 downto 0); -- Red Output
        --G_o     : out unsigned((g_ColorDepth/3)-1 downto 0); -- Green Output
        --B_o     : out unsigned((g_ColorDepth/3)-1 downto 0) -- Blue Output
      );
  end component;

  component clkPrescale
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
  end component;

  -- General Signals
  signal s_CLK  : std_logic := '0'; -- BoardClock
  signal s_RST  : std_logic := c_RSTACTIVE; -- Reset Signal
  -- ClkDiv Signals
  signal s_SClk1  : std_logic := '0'; -- SlowClock
  -- vgaCtrl Signals
  signal s_hsync  : std_logic;
  signal s_vsync  : std_logic;
  signal s_data   : std_logic_vector(11 downto 0) := (others => '0');
  signal s_row    : integer;
  signal s_col    : integer;
  signal s_blank  : std_logic;


begin


-- The Device Under Test (DUT)
  -- Generate VGA interface
    i_vgaCtrl : vgaCtrl
    -- Link the generics
    generic map (
      g_RSTACTIVE => c_RSTACTIVE,
      -- Resolution
      g_hPixels => 640, -- Horizontal display width
      g_vPixels => 480, -- Vertical   display width
      -- Horizontal Timings (Values in PIXELS)
      g_hFP     => 16,  -- Horizontal front porch width
      g_hPULSE  => 96,  -- Horizontal sync pulse width
      g_hBP     => 48,  -- Horizontal back porch width
      g_hPOL    => '1', -- Horizontal sync pulse polarity (1 = logic HIGH)
      -- Vertical Timings (Integer Values in PIXELS)
      g_vFP     => 10,  -- Vertical front porch width
      g_vPULSE  => 2,   -- Vertical sync pulse width
      g_vBP     => 33,  -- Vertical back porch width
      g_vPOL    => '1', -- Vertical sync pulse polarity  (1 = logic HIGH)
      -- Blanking generics
      g_bPOL    => c_bPOL,
      -- ColorDepth
      g_ColorDepth  => 12   -- Depth of the Color Values
    )
    -- Link the ports
      port map(
      -- Inputs
    CLK_i => s_CLK,
    RST_i => s_RST,
    ENA_i => s_SClk1,
    -- Outputs
    HSYNC_o => s_hsync,
    VSYNC_o => s_vsync,
    ROW_o   => s_row,
    COL_o   => s_col,
    BLANK_o => s_blank
    );


-- The Device Under Test (DUT)
  -- Generate 25MHz Clock Signal
    i_25Mclk  : clkPrescale
    -- Link the generics
    generic map(  g_SOURCEHZ    =>  ClockFrequencyHz, -- 100MHz
                  g_TARGETHZ    =>  25e6,             --  25MHz
                  g_OUTACTIVE   =>  '1',
                  g_RSTACTIVE   =>  c_RSTACTIVE
                )
    -- Link the ports
    port map(
    -- Inputs
    CLK_i  => s_Clk,
    RST_i  => s_RST,
    -- Outputs
    OUT_o  => s_SClk1
    );

-- Process for generating the MasterClock
p_CLK : s_Clk <= not s_Clk  after ClockPeriod / 2;

-- Take DUT out of reset
p_RST : process is
  begin
      -- In1 is selected by default
    wait until rising_edge(s_CLK);
    wait until rising_edge(s_CLK);
    s_RST <= not c_RSTACTIVE;

    wait for 55 ms;
    s_RST <= c_RSTACTIVE;
    wait for 159 us;
    s_RST <= not c_RSTACTIVE;

    wait;

  end process p_RST;
end architecture;
