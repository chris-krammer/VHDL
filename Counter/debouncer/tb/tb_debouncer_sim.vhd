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
-- Filename: tb_debouncer_sim.vhd
--
-- Date of Creation: Mon Dec 17 12:30:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Fri Dec 14 12:30:00 2018
--
-- Design Unit: ioCtrl (Testbench Entity)
--
-- Description: Syncs and debounces the inputs from mechanical inputs
--------------------------------------------------------------------------------------------------
--
-- CVS Change Log:
--
--
--------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture sim of tb_debouncer is

  constant c_CLOCKFREQUENCYHZ : integer := 100e6;   -- 100 MHz
  constant c_CLOCKPERIOD      : time    := 1000 ms / c_CLOCKFREQUENCYHZ;
  constant c_RSTACTIVE        : std_logic := '1';
  constant c_PB               : integer range 0 to 4 := 4;
  constant c_SW               : integer range 0 to 16 := 16;

  signal s_CLK  : std_logic := '1'; -- BoardClock
  signal s_RST  : std_logic := '1'; -- Reset Signal

  signal s_PBIN   : std_logic_vector(c_PB - 1 downto 0) := (others => '0');
  signal s_PBOUT  : std_logic_vector(c_PB - 1 downto 0) := (others => '0');
  signal s_SWIN   : std_logic_vector(c_SW - 1 downto 0) := (others => '0');
  signal s_SWOUT  : std_logic_vector(c_SW - 1 downto 0) := (others => '0');

  component debouncer
    generic(g_SOURCEHZ      : integer range 1 to 100e6 := 100e6;  -- Board Clock Frequency in Hz
            g_DEBTIME       : integer range 1 to 100 := 10;       -- Debounce Time in ms
            g_RSTACTIVE     : std_logic := '1'                    -- Reset ACTIVE state
          );
    port( --  Inputs
          CLK_i : in std_logic;  -- Board Clock
          RST_i : in std_logic;  -- Reset
          IN_i  : in std_logic;  -- Input to be debounced

          -- Outputs
          OUT_o : out std_logic
        );
  end component;

begin

  -- Process for generating the clock
  s_CLK <= not s_CLK  after c_CLOCKPERIOD / 2;

  GEN_PB_DEBOUNCER : for i in 0 to (c_PB - 1) generate
    PB_DEBx : entity work.debouncer(rtl)
      generic map(
        g_SOURCEHZ  => c_CLOCKFREQUENCYHZ,
        g_DEBTIME   => 10,
        g_RSTACTIVE => c_RSTACTIVE
        )
      port map(
        CLK_i => s_CLK,
        RST_i => s_RST,
        IN_i  => s_PBIN(i),
        OUT_o => s_PBOUT(i)
        );
  end generate GEN_PB_DEBOUNCER;

  GEN_SW_DEBOUNCER : for i in 0 to (c_SW - 1) generate
    SW_DEBx : entity work.debouncer(rtl)
      generic map(
        g_SOURCEHZ  => c_CLOCKFREQUENCYHZ,
        g_DEBTIME   => 10,
        g_RSTACTIVE => c_RSTACTIVE
        )
      port map(
        CLK_i => s_CLK,
        RST_i => s_RST,
        IN_i  => s_SWIN(i),
        OUT_o => s_SWOUT(i)
        );
  end generate GEN_SW_DEBOUNCER;

-- Testbench sequence for RESET
p_RES : process is
begin

  --  0ms
    wait until rising_edge(s_CLK);
    wait until rising_edge(s_CLK);

    -- Release the DUT
    s_RST <= '0';

    wait for 5 ms;

    -- Reset
    s_RST <= '1';
    wait for 3 ms;
    s_RST <= '0';

    wait for 33500 us;

    -- Reset
    s_RST <= '1';
    wait for 3 ms;
    s_RST <= '0';

    wait for 36500 us;

    -- Reset
    s_RST <= '1';
    wait for 3 ms;
    s_RST <= '0';

    wait;
  end process;

-- Testbench sequence for PB 0
  p_PB0 : process is
  begin

  --  0ms
    wait until rising_edge(s_CLK);
    wait until rising_edge(s_CLK);

    -- Pressed
    -- PB(3) bouncing
    s_PBIN(0) <= '1';
      wait for 50 us;
      s_PBIN(0) <= '0';
      wait for 41 us;
      s_PBIN(0) <= '1';
      wait for 800 us;
      s_PBIN(0) <= '0';
      wait for 10 us;
      s_PBIN(0) <= '1';

      wait for 12 ms;

    -- Released
    -- PB(3) bouncing
    s_PBIN(0) <= '0';
      wait for 25 us;
      s_PBIN(0) <= '1';
      wait for 50 us;
      s_PBIN(0) <= '0';
      wait for 176 us;
      s_PBIN(0) <= '1';
      wait for 176 us;
      s_PBIN(0) <= '0';

    wait for 15 ms;

    -- Pressed
    -- PB(3) bouncing
    s_PBIN(0) <= '1';
      wait for 50 us;
      s_PBIN(0) <= '0';
      wait for 41 us;
      s_PBIN(0) <= '1';
      wait for 800 us;
      s_PBIN(0) <= '0';
      wait for 10 us;
      s_PBIN(0) <= '1';

      wait for 11 ms;

    -- Released
    -- PB(3) bouncing
    s_PBIN(0) <= '0';
      wait for 25 us;
      s_PBIN(0) <= '1';
      wait for 50 us;
      s_PBIN(0) <= '0';
      wait for 176 us;
      s_PBIN(0) <= '1';
      wait for 176 us;
      s_PBIN(0) <= '0';

    wait for 12 ms;

    -- Pressed
    -- PB(3) bouncing
    s_PBIN(0) <= '1';
      wait for 50 us;
      s_PBIN(0) <= '0';
      wait for 41 us;
      s_PBIN(0) <= '1';
      wait for 800 us;
      s_PBIN(0) <= '0';
      wait for 10 us;
      s_PBIN(0) <= '1';

      wait for 17 ms;

    -- Released
    -- PB(3) bouncing
    s_PBIN(0) <= '0';
      wait for 25 us;
      s_PBIN(0) <= '1';
      wait for 50 us;
      s_PBIN(0) <= '0';
      wait for 176 us;
      s_PBIN(0) <= '1';
      wait for 176 us;
      s_PBIN(0) <= '0';

    wait;
  end process;

-- Testbench sequence for PB 1
  p_PB1 : process is
  begin

  --  0ms
    wait until rising_edge(s_CLK);
    wait until rising_edge(s_CLK);

    wait for 2 ms;

    -- Pressed
    -- PB(3) bouncing
    s_PBIN(1) <= '1';
      wait for 11 us;
      s_PBIN(1) <= '0';
      wait for 68 us;
      s_PBIN(1) <= '1';
      wait for 458 us;
      s_PBIN(1) <= '0';
      wait for 351 us;
      s_PBIN(1) <= '1';

      wait for 12 ms;

    -- Released
    -- PB(3) bouncing
    s_PBIN(1) <= '0';
      wait for 25 us;
      s_PBIN(1) <= '1';
      wait for 50 us;
      s_PBIN(1) <= '0';
      wait for 176 us;
      s_PBIN(1) <= '1';
      wait for 176 us;
      s_PBIN(1) <= '0';

    wait for 15 ms;

    -- Pressed
    -- PB(3) bouncing
    s_PBIN(1) <= '1';
      wait for 11 us;
      s_PBIN(1) <= '0';
      wait for 68 us;
      s_PBIN(1) <= '1';
      wait for 458 us;
      s_PBIN(1) <= '0';
      wait for 351 us;
      s_PBIN(1) <= '1';

      wait for 11 ms;

    -- Released
    -- PB(3) bouncing
    s_PBIN(1) <= '0';
      wait for 25 us;
      s_PBIN(1) <= '1';
      wait for 50 us;
      s_PBIN(1) <= '0';
      wait for 176 us;
      s_PBIN(1) <= '1';
      wait for 176 us;
      s_PBIN(1) <= '0';

    wait for 12 ms;

    -- Pressed
    -- PB(3) bouncing
    s_PBIN(1) <= '1';
      wait for 11 us;
      s_PBIN(1) <= '0';
      wait for 68 us;
      s_PBIN(1) <= '1';
      wait for 458 us;
      s_PBIN(1) <= '0';
      wait for 351 us;
      s_PBIN(1) <= '1';

      wait for 17 ms;

    -- Released
    -- PB(3) bouncing
    s_PBIN(1) <= '0';
      wait for 25 us;
      s_PBIN(1) <= '1';
      wait for 50 us;
      s_PBIN(1) <= '0';
      wait for 176 us;
      s_PBIN(1) <= '1';
      wait for 176 us;
      s_PBIN(1) <= '0';

    wait;
  end process;

-- Testbench sequence for PB 2
  p_PB2 : process is
  begin

  --  0ms
    wait until rising_edge(s_CLK);
    wait until rising_edge(s_CLK);

    wait for 6 ms;

    -- Pressed
    -- PB(3) bouncing
    s_PBIN(2) <= '1';
      wait for 45 us;
      s_PBIN(2) <= '0';
      wait for 21 us;
      s_PBIN(2) <= '1';
      wait for 354 us;
      s_PBIN(2) <= '0';
      wait for 353 us;
      s_PBIN(2) <= '1';

      wait for 12 ms;

    -- Released
    -- PB(3) bouncing
    s_PBIN(2) <= '0';
      wait for 25 us;
      s_PBIN(2) <= '1';
      wait for 50 us;
      s_PBIN(2) <= '0';
      wait for 176 us;
      s_PBIN(2) <= '1';
      wait for 176 us;
      s_PBIN(2) <= '0';

    wait for 15 ms;

    -- Pressed
    -- PB(3) bouncing
    s_PBIN(2) <= '1';
      wait for 45 us;
      s_PBIN(2) <= '0';
      wait for 21 us;
      s_PBIN(2) <= '1';
      wait for 354 us;
      s_PBIN(2) <= '0';
      wait for 353 us;
      s_PBIN(2) <= '1';

      wait for 11 ms;

    -- Released
    -- PB(3) bouncing
    s_PBIN(2) <= '0';
      wait for 25 us;
      s_PBIN(2) <= '1';
      wait for 50 us;
      s_PBIN(2) <= '0';
      wait for 176 us;
      s_PBIN(2) <= '1';
      wait for 176 us;
      s_PBIN(2) <= '0';

    wait for 12 ms;

    -- Pressed
    -- PB(3) bouncing
    s_PBIN(2) <= '1';
      wait for 45 us;
      s_PBIN(2) <= '0';
      wait for 21 us;
      s_PBIN(2) <= '1';
      wait for 354 us;
      s_PBIN(2) <= '0';
      wait for 353 us;
      s_PBIN(2) <= '1';

      wait for 17 ms;

    -- Released
    -- PB(3) bouncing
    s_PBIN(2) <= '0';
      wait for 25 us;
      s_PBIN(2) <= '1';
      wait for 50 us;
      s_PBIN(2) <= '0';
      wait for 176 us;
      s_PBIN(2) <= '1';
      wait for 176 us;
      s_PBIN(2) <= '0';

    wait;
  end process;

-- Testbench sequence for PB 3
  p_PB3 : process is
  begin

  --  0ms
    wait until rising_edge(s_CLK);
    wait until rising_edge(s_CLK);

    wait for 8 ms;

    -- Pressed
    -- PB(3) bouncing
    s_PBIN(3) <= '1';
      wait for 358 us;
      s_PBIN(3) <= '0';
      wait for 34 us;
      s_PBIN(3) <= '1';
      wait for 544 us;
      s_PBIN(3) <= '0';
      wait for 35 us;
      s_PBIN(3) <= '1';

      wait for 12 ms;

    -- Released
    -- PB(3) bouncing
    s_PBIN(3) <= '0';
      wait for 25 us;
      s_PBIN(3) <= '1';
      wait for 50 us;
      s_PBIN(3) <= '0';
      wait for 176 us;
      s_PBIN(3) <= '1';
      wait for 176 us;
      s_PBIN(3) <= '0';

    wait for 15 ms;

    -- Pressed
    -- PB(3) bouncing
    s_PBIN(3) <= '1';
      wait for 358 us;
      s_PBIN(3) <= '0';
      wait for 34 us;
      s_PBIN(3) <= '1';
      wait for 544 us;
      s_PBIN(3) <= '0';
      wait for 35 us;
      s_PBIN(3) <= '1';

      wait for 11 ms;

    -- Released
    -- PB(3) bouncing
    s_PBIN(3) <= '0';
      wait for 25 us;
      s_PBIN(3) <= '1';
      wait for 50 us;
      s_PBIN(3) <= '0';
      wait for 176 us;
      s_PBIN(3) <= '1';
      wait for 176 us;
      s_PBIN(3) <= '0';

    wait for 12 ms;

    -- Pressed
    -- PB(3) bouncing
    s_PBIN(3) <= '1';
      wait for 358 us;
      s_PBIN(3) <= '0';
      wait for 34 us;
      s_PBIN(3) <= '1';
      wait for 544 us;
      s_PBIN(3) <= '0';
      wait for 35 us;
      s_PBIN(3) <= '1';

      wait for 17 ms;

    -- Released
    -- PB(3) bouncing
    s_PBIN(3) <= '0';
      wait for 25 us;
      s_PBIN(3) <= '1';
      wait for 50 us;
      s_PBIN(3) <= '0';
      wait for 176 us;
      s_PBIN(3) <= '1';
      wait for 176 us;
      s_PBIN(3) <= '0';

    wait;
  end process;
end architecture sim;








