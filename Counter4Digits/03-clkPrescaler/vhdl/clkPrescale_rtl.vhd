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

architecture rtl of clkPrescale is

  signal s_preLoad  : integer range 0 to g_SOURCEHZ - 1; -- PreLoad containtin ratio
  signal s_count    : integer range 0 to g_SOURCEHZ - 1; -- Counter
  signal s_out      : std_logic := '0';            -- Output SIGNAL
 

begin

  s_preLoad <= (g_SOURCEHZ / g_TARGETHZ);
    
  process(CLK_i, RST_i)
  
    begin
      -- Asynchronous Reset
      if (RST_i = '1') then
        s_out   <= '0';
        s_count <= 0;

      elsif(rising_Edge(CLK_i)) then
        if(s_count = s_preLoad -1) then
          s_count <= 0;
          s_out <= not s_out;

        else
          s_count <= s_count + 1;

        end if;
      end if;
  end process;

  OUT_o <= s_out;

end architecture rtl;