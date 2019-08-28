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
-- Filename: ioCtrl_rtl.vhd
--
-- Date of Creation: Sun Dec 16 21:33:00 2018
--
-- Version: 2.0
--
-- Date of Latest Version: Sun Dec 16 21:33:00 2018
--
-- Design Unit: mux4to1 (Architecture)
--
-- Description: Syncs and debounces the inputs from mechanical inputs
--------------------------------------------------------------------------------------------------
--
-- CVS Change Log:
--
--
--------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of debouncer is

  constant c_COUNTERTARGET  : integer range 0 to g_SOURCEHZ := (g_SOURCEHZ / (1000 / g_DEBTIME ));

  signal s_flipflops    : STD_LOGIC_VECTOR(1 downto 0); --input flip flops
  signal s_counter_set  : STD_LOGIC;                    --sync reset to zero
  signal s_OUT          : STD_LOGIC;

begin

  s_counter_set <= s_flipflops(0) xor s_flipflops(1);  --determine when to start/reset counter

  process(CLK_i, RST_i)
    variable v_count :  integer range 0 to c_COUNTERTARGET;  --counter for timing
  begin
    if(RST_i = g_RSTACTIVE) then              --reset
      s_flipflops(1 downto 0) <= "00";          --clear input flipflops
      s_OUT <= '0';                          --clear result register

    elsif(CLK_i'event and CLK_i = '1') then   --rising clock edge
      s_flipflops(0) <= IN_i;                 --store button value in 1st flipflop
      s_flipflops(1) <= s_flipflops(0);       --store 1st flipflop value in 2nd flipflop

      if(s_counter_set = '1') then            --reset counter because input is changing
        v_count := 0;                         --clear the counter
      elsif(v_count < c_COUNTERTARGET) then   --stable input time is not yet met
        v_count := v_count + 1;               --increment counter
      else                                    --stable input time is met
        s_OUT <= s_flipflops(1);              --output the stable value
      end if;
    end if;
  end process;

-- Assign Signals to Ouputs
OUT_o <=  s_OUT;

end architecture ; -- rtl
