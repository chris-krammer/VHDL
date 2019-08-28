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
-- Filename: tb_clkPrescale_sim.vhd
--
-- Date of Creation: Mon Dec 17 12:30:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Fri Dec 14 12:30:00 2018
--
-- Design Unit: clkPrescale (Testbench Entity)
--
-- Description: Prescales the clock as enable signal for internal modules
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

architecture sim of tb_clkPrescale is

  constant ClockFrequencyHz : integer := 100e6; -- 100 MHz
  constant ClockPeriod      : time    := 1000 ms / ClockFrequencyHz;

  --component clkPrescale
  --  generic(  g_SOURCEHZ  : integer   := 100e6;  -- Frequency of the Master Clock HZ
  --            g_TARGETHZ  : integer   :=   1e3;  -- Desired Frequency in HZ
  --            g_OUTACTIVE : std_logic :=   '1'  -- Defines ACTIVE state of output
  --          );
  --port(
  --      -- Inputs
  --      CLK_i : in std_logic;
  --      RST_i : in std_logic; -- HIGH Active Reset

  --      -- Outputs
  --      OUT_o: out std_logic
  --    );
  --end component;

  -- General Signals
  signal s_Clk    : std_logic := '1'; -- BoardClock
  signal s_RST    : std_logic := '0'; -- Reset Signal
  signal s_Out1k  : std_logic;        -- Output from DUT i_pre1k
  signal s_Out2k  : std_logic;        -- Output from DUT i_pre2k
  signal s_Out3k  : std_logic;        -- Output from DUT i_pre3k
  signal s_Out4k  : std_logic;        -- Output from DUT i_pre4k

begin

-- The Device Under Test (DUT)
  i_pre1k : clkPrescale
    -- Link the generics
    generic map(  g_SOURCEHZ    => 100e6,
                  g_TARGETHZ    =>   1e3,
                  g_OUTACTIVE   =>   '1'
                )
    -- Link the ports
    port map(
    -- Inputs
    CLK_i   => s_Clk,
    RST_i   => s_RST,
    -- Outputs
    OUT_o => s_Out1k
    );

    i_pre2k : clkPrescale
    -- Link the generics
    generic map(  g_SOURCEHZ    => 100e6,
                  g_TARGETHZ    =>   2e3,
                  g_OUTACTIVE   =>   '1'
                )
    -- Link the ports
    port map(
    -- Inputs
    CLK_i   => s_Clk,
    RST_i   => s_RST,
    -- Outputs
    OUT_o => s_Out2k
    );

    i_pre3k : clkPrescale
    -- Link the generics
    generic map(  g_SOURCEHZ    => 100e6,
                  g_TARGETHZ    =>  33e3,
                  g_OUTACTIVE   =>   '1'
                )
    -- Link the ports
    port map(
    -- Inputs
    CLK_i   => s_Clk,
    RST_i   => s_RST,
    -- Outputs
    OUT_o => s_Out3k
    );

    i_pre101M : clkPrescale
    -- Link the generics
    generic map(  g_SOURCEHZ    => 100e6,
                  g_TARGETHZ    => 101e6,
                  g_OUTACTIVE   =>   '1'
                )
    -- Link the ports
    port map(
    -- Inputs
    CLK_i   => s_Clk,
    RST_i   => s_RST,
    -- Outputs
    OUT_o => s_Out4k
    );

-- Process for generating the clock
  s_Clk   <= not s_Clk  after ClockPeriod / 2;

    -- Testbench sequence
p_test : process is
  begin

  --    1 Hz -> t = 1000 ms  -> t/2 = 500ms
  --   10 Hz -> t =  100 ms  -> t/2 =  50ms
  --  100 Hz -> t =   10 ms  -> t/2 =   5ms
  -- 1000 Hz -> t =    1 ms  -> t/2 = 500us

-- 0 ms
wait until rising_edge(s_Clk);
wait until rising_edge(s_Clk);

  -- Take DUT out of Reset
  s_Rst <= '1';
  wait for 3218 us;

  -- Reset DUT
  s_Rst <= '0';
  wait for 1 us;
  s_Rst <= '1';


  wait;
-- End defined in sim.do
    end process;
end architecture;
