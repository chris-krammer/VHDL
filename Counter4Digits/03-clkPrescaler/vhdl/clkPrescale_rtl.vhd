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
-- Filename: clkPrescale_rtl.vhd
--
-- Version: 1.0
--
-- Design Unit: clkPrescale (Architecture)
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

architecture rtl of clkPrescale is

  constant c_ratio  : integer range 0 to g_SOURCEHZ := (g_SOURCEHZ / g_TARGETHZ);
  signal s_count    : integer range 0 to g_SOURCEHZ := 0;
  signal s_out      : std_logic := '0';            -- Output SIGNAL
  signal s_err      : std_logic := '0';
 
begin

  s_err <= '1' when (c_ratio < 1) else '0';
    
  process(CLK_i, RST_i)

    begin
      -- Asynchronous Reset
      if (RST_i = '1') then
        s_out   <= '0';
        s_count <= 0;

      elsif(rising_Edge(CLK_i)) then
        if(s_err = '0') then 
          if(s_count = ((c_ratio / 2) - 1)) then
            s_count <= 0;
            s_out <= not s_out;

          else
            s_count <= s_count + 1;

          end if;
        end if;
      end if;
  end process;

  ERR_o <= s_err;
  OUT_o <= s_out;

end architecture rtl;