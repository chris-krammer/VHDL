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
-- Filename: counterTop_struc.vhd
--
-- Date of Creation: Sun Dec 16 21:33:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Sun Dec 16 21:33:00 2018
--
-- Design Unit: counterTop (Architecture)
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
use IEEE.numeric_std.all;

architecture struc of counterTop is

  -----------------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------------
  constant c_CntFreq1Hz     : integer range 0 to g_SOURCEHZ := 1;     -- Counter Speed 1Hz
  constant c_CntFreq10Hz    : integer range 0 to g_SOURCEHZ := 10;    -- Counter Speed 10Hz
  constant c_CntFreq100Hz   : integer range 0 to g_SOURCEHZ := 100;   -- Counter Speed 100Hz
  constant c_CntFreq1000Hz  : integer range 0 to g_SOURCEHZ := 1000;  -- Counter Speed 1000Hz
  constant c_CntFreq4000Hz  : integer range 0 to g_SOURCEHZ := 4000;  -- 7-Seg Refresh Speed (Digits * c_CntFreq1000Hz)
  constant c_CntBaseDEC     : std_logic_vector( 3 downto 0) := x"9";  -- Counter Max for Decimal counter
  constant c_CntBaseHEX     : std_logic_vector( 3 downto 0) := x"F";  -- Counter Max for Hexadecimal counter
  constant c_CntBaseOCT     : std_logic_vector( 3 downto 0) := x"7";  -- Counter Max for Octal counter
  constant c_CntBaseBIN     : std_logic_vector( 3 downto 0) := x"1";  -- Counter Max for Binary counter

  constant c_DEBTIME  : integer := 1;  -- Debounce Time in ms
  -----------------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------------
  -- General Signals
  signal s_SPEED_out  : std_logic;
  signal s_BASE_out   : std_logic_vector( 3 downto 0);
  signal s_1khz_out   : std_logic;
  signal s_1hz_out    : std_logic;
  signal s_10hz_out   : std_logic;
  signal s_100hz_out  : std_logic;
  signal s_sw   : std_logic_vector(g_SWs - 1 downto 0) := (others => '0');
  signal s_pb   : std_logic_vector(g_PBs - 1 downto 0) := (others => '0');

  -- U7 Signals (IO_Control)
  signal s_min    : std_logic_vector( 3 downto 0) := (others => '0');
  signal s_c0     : std_logic_vector( 3 downto 0) := (others => '0');
  signal s_c1     : std_logic_vector( 3 downto 0) := (others => '0');
  signal s_c2     : std_logic_vector( 3 downto 0) := (others => '0');
  signal s_c3     : std_logic_vector( 3 downto 0) := (others => '0');
  signal s_DUMMY  : std_logic_vector(15 downto 0) := (others => '0');

  -----------------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------------
  component clkPrescale is
    generic(g_SOURCEHZ  : integer   := 100e6;  -- Frequency of the Master Clock HZ
            g_TARGETHZ  : integer   :=   1e3;  -- Desired Frequency in HZ
            g_OUTACTIVE : std_logic :=   '1';  -- Defines ACTIVE state of output
            g_RSTACTIVE : std_logic :=   '0'   -- Defines ACTIVE state for RST_i
            );
    port( -- Inputs
          CLK_i : in std_logic;
          RST_i : in std_logic;
          -- Outputs
          OUT_o: out std_logic
        );
  end component;

  component mux4to1
    -- Use generics with "generic map (target => value)" when instantiating
    generic(DataWidth : integer);  -- Define DataWidth of Input- and Output Signal
    port (
    -- Inputs
    IN0_i : in std_logic_vector(DataWidth - 1 downto 0);  -- Input 1
    IN1_i : in std_logic_vector(DataWidth - 1 downto 0);  -- Input 2
    IN2_i : in std_logic_vector(DataWidth - 1 downto 0);  -- Input 3
    IN3_i : in std_logic_vector(DataWidth - 1 downto 0);  -- Input 4
    SEL_i : in std_logic_vector(1 downto 0);        -- Input Select Signal
    -- Outputs
    OUT_o : out std_logic_vector(DataWidth - 1 downto 0)
    );
  end component;

  component ioCtrl is
    generic(  g_SOURCEHZ    : integer range 1 to 100e6 := 100e6;  -- Board Clock Frequency in Hz
              g_PBINPUTS    : integer   :=  5;            --  Number of PushButtons (excl. CPU_RESET)
              g_SWINPUTS    : integer   := 16;            --  Number of Switches
              g_DEBTIME     : integer   := 10;            --  Debounce Time in MasterClock Ticks
              g_RSTACTIVE   : std_logic := '0'            --  Active State of RESET INPUT
            );

    port( CLK_i     : in  std_logic;                      --  Clock Input 1kHz
          RST_i     : in  std_logic;                      --  Reset Input
          -- Inputs from real world
          SW_i      : in  std_logic_vector(g_SWs-1 downto 0); --  Switch Inputs
          PB_i      : in  std_logic_vector(g_PBs-1 downto 0); --  Push-Button Inputs
          -- Inputs from internal counter
          CNTR0_i   : in  std_logic_vector( 3 downto 0); --  Counter Input Digit 1
          CNTR1_i   : in  std_logic_vector( 3 downto 0); --  Counter Input Digit 2
          CNTR2_i   : in  std_logic_vector( 3 downto 0); --  Counter Input Digit 3
          CNTR3_i   : in  std_logic_vector( 3 downto 0); --  Counter Input Digit 4
          -- Outputs to the 7 Segment
          SS_o      : out std_logic_vector( 7 downto 0); --  Seven-Segment Output
          SS_SEL_o  : out std_logic_vector( 3 downto 0); --  Seven-Segment Selector Output
          -- Debounced Outputs for internal use
          SWSYNC_o  : out std_logic_vector(g_SWs-1 downto 0); --  Syncronized Switches Output
          PBSYNC_o  : out std_logic_vector(g_PBs-1 downto 0)  --  Syncronized Push-Buttons Output
        );
  end component;

  component counter is
    generic (g_RSTACTIVE   : std_logic := '0');  --  Active State of RESET INPUT
    port(
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
  end component;

begin -- Beginn struc

  -----------------------------------------------------------------------------
  -- U1 : Speed Mux - Muxes the speed for the counter
  -----------------------------------------------------------------------------
  U1 : clkPrescale
      generic map(  g_SOURCEHZ  =>  g_SOURCEHZ,
                    g_TARGETHZ  =>  c_CntFreq1000Hz, -- 1kHz
                    g_OUTACTIVE =>  '1',
                    g_RSTACTIVE =>  g_RSTACTIVE
                  )

      port map( CLK_i => CLK_i,
                RST_i => RST_i,
                OUT_o => s_1khz_out
              );

  U2 : clkPrescale
      generic map(  g_SOURCEHZ  =>  g_SOURCEHZ,
                    g_TARGETHZ  =>  c_CntFreq1Hz, -- 1Hz
                    g_OUTACTIVE =>  '1',
                    g_RSTACTIVE =>  g_RSTACTIVE
                  )

      port map( CLK_i => CLK_i,
                RST_i => RST_i,
                OUT_o => s_1hz_out
              );

  U3 : clkPrescale
      generic map(  g_SOURCEHZ  =>  g_SOURCEHZ,
                    g_TARGETHZ  =>  c_CntFreq10Hz, -- 10Hz
                    g_OUTACTIVE =>  '1',
                    g_RSTACTIVE =>  g_RSTACTIVE
                  )

      port map( CLK_i => CLK_i,
                RST_i => RST_i,
                OUT_o => s_10hz_out
              );

  U4 : clkPrescale
      generic map(  g_SOURCEHZ  =>  g_SOURCEHZ,
                    g_TARGETHZ  =>  c_CntFreq100Hz, -- 100Hz
                    g_OUTACTIVE =>  '1',
                    g_RSTACTIVE =>  g_RSTACTIVE
                  )

      port map( CLK_i => CLK_i,
                RST_i => RST_i,
                OUT_o => s_100hz_out
              );

  -----------------------------------------------------------------------------
  -- U5 : Speed Mux - Muxes the speed for the counter
  -----------------------------------------------------------------------------
  U5 : mux4to1
    -- Link the genercis
    generic map(DataWidth => 1)
    -- Link the ports
    port map(
      -- Inputs
      IN0_i(0) => s_1khz_out,
      IN1_i(0) => s_1hz_out,
      IN2_i(0) => s_10hz_out,
      IN3_i(0) => s_100hz_out,
      SEL_i => s_sw(15 downto 14),
      -- Outputs
      OUT_o(0) => s_SPEED_out
    );

  -----------------------------------------------------------------------------
  -- U6 : Base Mux - Muxes the Base for the counter
  -----------------------------------------------------------------------------
  U6 : mux4to1
    -- Link the genercis
    generic map(DataWidth => 4)
    -- Link the ports
    port map(
      -- Inputs
      IN0_i => c_CntBaseDEC,
      IN1_i => c_CntBaseHEX,
      IN2_i => c_CntBaseOCT,
      IN3_i => c_CntBaseBIN,
      SEL_i => s_sw(1 downto 0),
      -- Outputs
      OUT_o => s_BASE_out
    );

  -----------------------------------------------------------------------------
  -- U7 : IO Control - Debounces Inputs and controls the 7-Segment
  -----------------------------------------------------------------------------
  U7 : ioCtrl
  generic map(  g_SOURCEHZ  => g_SOURCEHZ,
                g_PBINPUTS  => g_PBs,
                g_SWINPUTS  => g_SWs,
                g_DEBTIME   => c_DEBTIME,
                g_RSTACTIVE => g_RSTACTIVE)
  port map(
  CLK_i  => CLK_i,
  RST_i  => RST_i,
  SW_i   => SW_i,
  PB_i   => PB_i,
  CNTR0_i  => s_c0,
  CNTR1_i  => s_c1,
  CNTR2_i  => s_c2,
  CNTR3_i  => s_c3,
  SS_o   => SS_o,
  SS_SEL_o => SS_Sel_o,
  SWSYNC_o => s_sw,
  PBSYNC_o => s_pb
  );

  -----------------------------------------------------------------------------
  -- U8 : Counter - Counts and provides Result to IO Control
  -----------------------------------------------------------------------------
  U8 : counter
  generic map(g_RSTACTIVE => g_RSTACTIVE)
  port map(
  -- Inputs
  CLK_i     => CLK_i,
  RST_i     => RST_i,
  ENA_i     => s_SPEED_out,
  CNT_UP_i  => s_pb(2),
  CNT_DOWN_i  => s_pb(3),
  CNT_HLD_i   => s_pb(1),
  CNT_RST_i => s_pb(0),
  CNT_MIN_i => s_min,
  CNT_MAX_i => s_BASE_out,
  -- Outputs
  CNTR0_o   => s_c0,
  CNTR1_o   => s_c1,
  CNTR2_o   => s_c2,
  CNTR3_o   => s_c3,
  CNTRVAL_o   => s_DUMMY
  );

end struc;
