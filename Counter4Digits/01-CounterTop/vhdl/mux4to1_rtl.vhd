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
-- Filename: mux4to1_.vhd
--
-- Version: 1.0
--
-- Design Unit: mux4to1 (Architectiure)
--
-- Description: Selects one of the four inputs and copies it to the output
--
--------------------------------------------------------------------------------
-- CVS Change Log:
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of mux4to1 is

  signal s_temp : std_logic_vector(DataWidth - 1 downto 0);
  
  begin
  
  p_comb : process(SEL_i, IN0_i, IN1_i, IN2_i, IN3_i) is

    begin

      case SEL_i is
        when "00" => s_temp <= IN0_i;
        when "01" => s_temp <= IN1_i;
        when "10" => s_temp <= IN2_i;
        when "11" => s_temp <= IN3_i;
        when others => s_temp <= (others => 'X'); -- 'U', 'X', '-', etc.
      end case;
    end process;

  -- Assign to output
  OUT_o <= s_temp;

end architecture;