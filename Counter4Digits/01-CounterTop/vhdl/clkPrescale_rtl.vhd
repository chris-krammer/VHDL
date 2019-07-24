--------------------------------------------------------------------------------------------------
--																								--
-- 																								--
-- 				F A C H H O C H S C H U L E 	- 	T E C H N I K U M W I E N					--
-- 																								--
-- 						 																		--
--------------------------------------------------------------------------------------------------
--																								--
-- Web: http://www.technikum-wien.at/															--
-- 																								--
-- Contact: christopher.krammer@technikum-wien.at												--
--																								--
--------------------------------------------------------------------------------------------------
--
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
--				Signal SOURCEHZ_i defines MasterClock Frequency in HZ (32bit)
--				Signal TARGETHZ_i defines TargetClock Frequency in HZ (32bit)
--
-- !! KEEP IN MIND: NEW FREQUENCY IS UPDATED DURING CLOCK LOW.
--					THIS MEANS THE ACTUAL PERIOD WILL BE FINISHED BEFORE THE NEW PERIOD WILL START
--					EXCEPTION: RESET
--
-- !! KEEP IN MIND: OUTPUT IS NOT UPDATED IF WRONG INPUTS APPLIED
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

	signal s_out 			: std_logic := '1';
	signal s_prescaler		: std_logic_vector(31 downto 0);

begin

	process(CLK_i, RST_i, SOURCEHZ_i, TARGETHZ_i)
		variable v_prescaler	: unsigned(31 downto 0) := ((unsigned(SOURCEHZ_i)) / (unsigned(TARGETHZ_i))) / 2;
		variable v_counter		: unsigned(31 downto 0) := (others => '0');

		begin
		
			if (RST_i = '1') then
				s_out <= '1';
				v_counter := (others => '0');
				v_prescaler	:= ((unsigned(SOURCEHZ_i)) / (unsigned(TARGETHZ_i))) / 2; -- Update the Prescaler value at the RESET
			elsif(rising_edge(CLK_i)) then
				if (v_counter = (v_prescaler-1)) then
					v_counter := (others => '0');
					if (s_out = '0') then -- Update the Prescaler value at the end of the Clock Cylce to prevent glitching
						v_prescaler	:= ((unsigned(SOURCEHZ_i)) / (unsigned(TARGETHZ_i))) / 2;
					end if;
					s_out <= not s_out;
				else
					v_counter := v_counter + 1;
					s_prescaler <= std_logic_vector(v_prescaler);

				end if;
			end if;
	end process;
		
	OUT_o <= s_out;
	
end architecture rtl;