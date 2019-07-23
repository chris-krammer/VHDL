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
-- Filename: io_ctrl_.vhd
--
-- Date of Creation: Sun Dec 16 21:33:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Sun Dec 16 21:33:00 2018
--
-- Design Unit: io_ctrl (Entity)
--
-- Description: Debounces Inputs and manages the Outputs to 7-Segment
--
--------------------------------------------------------------------------------------------------
--
-- CVS Change Log:
--
--
--------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity io_ctrl is

  port (CLK_i		:	in	std_logic;							--	Clock Input 1kHz
		FCLK_i		:	in	std_logic;							--	Fast Clock for Display
		RST_i		:	in	std_logic;							--	Reset Input High Active
		SW_i		:	in	std_logic_vector (15 downto 0);		--  Switch Inputs
		PB_i		:	in	std_logic_vector ( 3 downto 0);		--  Push-Button Inputs
		CNTR0_i		:	in	std_logic_vector ( 3 downto 0);		--  Counter Input Digit 1
		CNTR1_i		:	in	std_logic_vector ( 3 downto 0);		--  Counter Input Digit 2
		CNTR2_i		:	in	std_logic_vector ( 3 downto 0);		--  Counter Input Digit 3
		CNTR3_i		:	in	std_logic_vector ( 3 downto 0);		--  Counter Input Digit 4
		SS_o		:	out	std_logic_vector ( 7 downto 0);		--  Seven-Segment Output
		SS_SEL_o	:	out	std_logic_vector ( 3 downto 0);		--  Seven-Segment Selector Output
		SWSYNC_o	:	out std_logic_vector (15 downto 0);		--  Syncronized Switches Output
		PBSYNC_o	:	out std_logic_vector ( 3 downto 0)		--  Syncronized Push-Buttons Output
		);
  end io_ctrl;
		

