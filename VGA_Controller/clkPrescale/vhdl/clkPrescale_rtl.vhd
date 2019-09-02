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
-- Author: Christopher Krammer
--
-- Filename: clkPrescale_rtl.vhd
--
-- Date of Creation: Sun Dec 16 21:33:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Sun Dec 16 21:33:00 2018
--
-- Design Unit: clkPrescale (Architecture)
--
-- Description: Prescales MasterClock
--        Generic g_SOURCEHZ defines MasterClock Frequency in HZ (integer)
--        Generic g_TARGETHZ defines TargetClock Frequency in HZ (integer)
--
-- !! KEEP IN MIND: THE OUTPUT SHOULD ONLY BE USED AS ENABLE SIGNAL, _NOT_ AS CLOCK SIGNAL
-- !! KEEP IN MIND: SIGNAL IS _NOT_ ROUTED VIA CLOCK-TREE
--------------------------------------------------------------------------------------------------
--
-- CVS Change Log:
--
--
--------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of clkPrescale is
  signal s_out        : std_logic := NOT g_OUTACTIVE;
  signal s_prescaler  : unsigned(31 downto 0) := to_unsigned((g_SOURCEHZ / g_TARGETHZ), 32);
  signal s_counter    : unsigned(31 downto 0) := (others => '0');

begin

  -- Throw an error if g_TARGETHZ is equal or greater than g_SOURCEHZ
  assert (g_TARGETHZ < g_SOURCEHZ) report lf &
    "**   g_TARGETHZ MUST BE SMALLER THAN g_SOURCEHZ" & lf &
    "**   g_TARGETHZ should be less than: " & integer'image(g_SOURCEHZ) & " Hz" & lf &
    "**   g_TARGETHZ currently is       : " & integer'image(g_TARGETHZ) & " Hz" severity error;

  -- Start of actual logic
  seq_proc : process(CLK_i, RST_i)

    begin

      -- ASYNCH RESET
      if (RST_i = g_RSTACTIVE) then
        -- RESET COUNTER AND SET
        -- SIGNALS TO INITIAL STATE
        s_out <= NOT g_OUTACTIVE;
        s_counter <= (others => '0');

      -- SEQUENTIAL LOGIC
      elsif (rising_edge(CLK_i)) then
        -- IF COUNTER REACHES PRESET VALUE
        -- RESET COUNTER AND SET SIGNALS TO ACTIVE STATE
        -- OTHERWHISE INCREMENT COUNTER

        if (s_counter = (s_prescaler-1)) then
          s_counter <= (others => '0');
          s_out <= g_OUTACTIVE;

        else
          s_counter <= s_counter + 1;
          s_out <= NOT g_OUTACTIVE;

        end if;
      end if;
  end process;

  -- Asign signals to Outputs
  OUT_o <= s_out;

end architecture rtl;
