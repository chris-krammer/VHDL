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
-- !! KEEP IN MIND: NEW FREQUENCY IS UPDATED DURING CLOCK LOW.
--          THIS MEANS THE ACTUAL PERIOD WILL BE FINISHED BEFORE
--          THE NEW PERIOD WILL START
--          EXCEPTION: RESET
--
-- !! KEEP IN MIND: OUTPUT IS NOT UPDATED IF WRONG INPUTS APPLIED
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
    generic(g_SOURCEHZ : integer := 100e6,
            g_TARGETHZ : integer :=   1e3);
    port(
      -- Inputs
      CLK_i : in std_logic;
      RST_i : in std_logic; -- HIGH Active Reset
    
      -- Outputs
      OUT_o: out std_logic
    );
    end component;
  
  component mux4to1
    generic(DataWidth : integer); -- Define DataWidth of Input- and Output Signals
    port (
      -- Inputs
      IN0_i : in std_logic_vector(DataWidth - 1 downto 0);  -- Input 1
      IN1_i : in std_logic_vector(DataWidth - 1 downto 0);  -- Input 2
      IN2_i : in std_logic_vector(DataWidth - 1 downto 0);  -- Input 3
      IN3_i : in std_logic_vector(DataWidth - 1 downto 0);  -- Input 4
      SEL_i : in std_logic_vector(1 downto 0);  -- Input Select Signal
      -- Outputs
      OUT_o : out std_logic_vector(DataWidth - 1 downto 0)  -- Output
    );
  end component;
  
  -- General Signals
  signal s_Clk    : std_logic := '0'; -- BoardClock
  signal s_SClk   : std_logic := '0'; -- SlowClock
  signal s_RST    : std_logic := '1'; -- Reset Signal
  signal s_SEL    : std_logic_vector(1 downto 0) := "00";
  
  signal SHZ        : integer range 0 to 100e6 := 100e6
  signal THZ        : integer range 0 to 100e6 := 1e6
  signal THZ1kHz    : integer range 0 to 100e6 := 1000;
  signal THZ100HZ   : integer range 0 to 100e6 := 100;
  signal THZ0HZ     : integer range 0 to 100e6 := 0;
  signal THZ33MHZ  : integer range 0 to 100e6 := 33000000;
  
  signal s_Out    : std_logic;
  
begin

  i_mux : mux4to1
    generic map(DataWidth => integer'image(SHZ'length))
    -- Link the ports 
    port map(
      -- Inputs
      IN0_i =>  THZ1kHZ,
      IN1_i =>  THZ100HZ,
      IN2_i =>  THZ0HZ,
      IN3_i =>  THZ101MHZ,   
      SEL_i =>  s_SEL,
      -- Outputs
      OUT_o => THZ
    );

-- The Device Under Test (DUT)
  i_pre : clkPrescale   
    generic map(g_SOURCEHZ => SHZ,
                g_TARGETHZ => THZ)
    -- Link the ports 
    port map(
      -- Inputs
      IN0_i =>  THZ1kHZ,
      IN1_i =>  THZ100HZ,
      IN2_i =>  THZ0HZ,
      IN3_i =>  THZ33MHZ,   
      SEL_i =>  s_SEL,
      -- Outputs
      OUT_o => THZ
    );

-- Process for generating the clock
  s_Clk   <= not s_Clk  after ClockPeriod / 2;
  s_SClk  <= not s_SClk after SClockPeriod  / 2;
  
    -- Testbench sequence
p_test : process is
  begin
  
  -- NOTE: The NEW Frequency is updated on RST or on (OUT_o = 0 AND Counter expired)
  -- -> Current Period will be finished, regardless what happens at the inputs (except the reset...)
  
  --    1 Hz -> t = 1000 ms  -> t/2 = 500ms
  --   10 Hz -> t =  100 ms  -> t/2 =  50ms
  --  100 Hz -> t =   10 ms  -> t/2 =   5ms
  -- 1000 Hz -> t =    1 ms  -> t/2 = 500us
  
-- 0 ms
  s_SEL <= "00"; -- 1000 Hz
  s_Rst <= '0';
  wait for 2600 us;
  -- OUT_o should currently be LOW
-- 2,6 ms

  s_SEL <= "01"; -- 100 Hz
  -- Previouse Cycle should finish first (400µs left), then 100 Hz should be omitted
  wait for 12400 us;
  -- OUT_o should currently be HIGH
-- 15 ms
  
  s_SEL <= "00"; -- 1 kHz
  -- Previouse Cycle should finish first (8ms left), then 1kHz should be omitted
  wait for 10 ms; 
-- 25 ms
  
  s_SEL <= "10"; -- 0 Hz -> 1st invalid Input
  -- Previous cycle should finish first
  -- OUT_o should be LOW afterwards
  wait for 10 ms;
-- 35 ms  

  s_SEL <= "01"; -- 100 Hz
  -- Since no previouse Cycle needs to be finished, OUT_o will be set to '1'
  -- and normal operation with 100 Hz should start
  wait for 18 ms;
-- 53 ms
  
  s_SEL <= "11"; -- 100.000.001 Hz (MasterClock + 1) -> 2nd invalid Input
  -- Previous cycle should finish first
  -- OUT_o should be LOW afterwards
  wait for 10 ms;
-- 63 ms  

  s_SEL <= "00"; -- 1 kHz
  -- Since no previouse Cycle needs to be finished, OUT_o will be set to '1'
  -- and normal operation with 100 Hz should start
  wait for 3 ms;
-- 66 ms

  s_Rst <= '1';
  wait for 100 ns;
-- 66,0001 ms

  s_Rst <= '0';
  
    wait;
-- End defined in sim.do
    end process;
end architecture;