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
  
  begin


  p_comb : process(SEL_i, IN0_i, IN1_i, IN2_i, IN3_i) is

    begin

      case SEL_i is
        when "00" => OUT_o <= IN0_i;
        when "01" => OUT_o <= IN1_i;
        when "10" => OUT_o <= IN2_i;
        when "11" => OUT_o <= IN3_i;
        when others => OUT_o <= (others => 'X'); -- 'U', 'X', '-', etc.
      end case;
    end process;
end architecture;