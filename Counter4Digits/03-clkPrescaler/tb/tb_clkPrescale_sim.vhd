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
-- Filename: tb_clkPrescale_sim.vhd
--
-- Version: 1.0
--
-- Design Unit: tb_clkPrescale (Testbench)
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
use IEEE.numeric_std.all;

architecture sim of tb_clkPrescale is

  constant ClockFrequencyHz : integer := 100e6; -- 100 MHz
  constant ClockPeriod      : time    := 1000 ms / ClockFrequencyHz;
  
  constant SClockFrequencyHz  : integer := 1e3; -- 1kHz
  constant SClockPeriod     : time := 1000 ms / SClockFrequencyHz;
  
  component clkPrescale is
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
      OUT_o : out std_logic
    );
    end component;
  
  -- General Signals
  signal s_Clk    : std_logic := '0'; -- BoardClock
  signal s_SClk   : std_logic := '0'; -- SlowClock
  signal s_RST    : std_logic := '1'; -- Reset Signal
  signal s_SEL    : std_logic_vector(1 downto 0) := "00";
  
  signal SHZ        : integer range 0 to 100e6 := 100e6;
  signal THZ        : integer range 0 to 100e6 := 1e6;
  signal THZ1kHz    : integer range 0 to 100e6 := 1000;
  signal THZ100HZ   : integer range 0 to 100e6 := 100;
  signal THZ50HZ    : integer range 0 to 100e6 := 50;
  signal THZ1MHZ    : integer range 0 to 100e6 := 10000000;
  
  signal s_Out1    : std_logic;
  signal s_Out2    : std_logic;
  signal s_Out3    : std_logic;
  signal s_Out4    : std_logic;


  
begin

  i_clk1 : clkPrescale
    generic map(g_SOURCEHZ => SHZ,
                g_TARGETHZ => THZ50HZ)
    -- Link the ports 
    port map(
      -- Inputs
      CLK_i => s_Clk,
      RST_i => s_RST,
      -- Outputs
      OUT_o => s_Out1
    );

  i_clk2 : clkPrescale
    generic map(g_SOURCEHZ => SHZ,
                g_TARGETHZ => THZ100HZ)
    -- Link the ports 
    port map(
      -- Inputs
      CLK_i => s_Clk,
      RST_i => s_RST,
      -- Outputs
      OUT_o => s_Out2
     );

  i_clk3 : clkPrescale
    generic map(g_SOURCEHZ => SHZ,
                g_TARGETHZ => THZ1KHZ)
    -- Link the ports 
    port map(
      -- Inputs
      CLK_i => s_Clk,
      RST_i => s_RST,
      -- Outputs
      OUT_o => s_Out3
     );

  i_clk4 : clkPrescale
    generic map(g_SOURCEHZ => 9000,
                g_TARGETHZ => 10000)
    -- Link the ports 
    port map(
      -- Inputs
      CLK_i => s_Clk,
      RST_i => s_RST,
      -- Outputs
      OUT_o => s_Out4
     );

-- Process for generating the clock
  s_Clk   <= not s_Clk  after ClockPeriod / 2;
  s_SClk  <= not s_SClk after SClockPeriod  / 2;
  
    -- Testbench sequence
p_test : process is
  begin
  
-- 0 ms
  wait until rising_edge(s_Clk);
  wait until rising_edge(s_Clk); 
  s_Rst <= '0';

  
  wait;
-- End defined in sim.do
    end process;
end architecture;