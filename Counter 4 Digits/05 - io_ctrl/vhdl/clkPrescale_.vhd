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
-- Design Unit: clkPrescale (Entity)
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

entity clkPrescale is

port(
	-- Inputs
	CLK_i	: in std_logic;
	RST_i	: in std_logic; -- HIGH Active Reset
	SOURCEHZ_i: in std_logic_vector(31 downto 0) := b"00000101111101011110000100000000"; -- 100MHz
	TARGETHZ_i: in std_logic_vector(31 downto 0) := b"00000000000000000000001111101000"; --   1kHz
	
	-- Outputs
	OUT_o: out std_logic
	);
end entity;