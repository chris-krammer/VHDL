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
-- Filename: CounterTop_.vhd
--
-- Date of Creation: Sun Dec 16 21:33:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Sun Dec 16 21:33:00 2018
--
-- Design Unit: CounterTop (Entity)
--
-- Description: Counts up or down and displays the current value through the four onboard 7-Segments
--				Counter is able to: 
--				- hold counter value
--				- reset counter value
--				- reset counter value and continue with the last direction or hold (BTNR)
--				- count up
--				- count down
--				- change counter base (DEC, HEX, OCT, BIN) (requires RESET (BTNC OR BTNR))
--				- change the counting frequency (1kHz, 1Hz, 10Hz, 100Hz)
--
--------------------------------------------------------------------------------------------------
--
-- CVS Change Log:
--
--
--------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity CounterTop is
  
  port (
	-- Inputs from Basys 3 Bord (High Active)
	CLK_i : in std_logic;	-- Master Clock Input
	  -- W5
	RST_i	: in std_logic; -- Reset
	  -- BTNC, U18
	PB_i	: in std_logic_vector( 3 downto 0);
	  -- PB_i(0) -> Count Value RESET,	BTNR, T17
	  -- PB_i(1) -> Count Value HOLD,	BTNL, W19
	  -- PB_i(2) -> Count UPWARDS, 		BTNU, T18
	  -- PB_i(3) -> Count DOWNWARDS, 	BTND, U17
	SW_i	: in std_logic_vector(15 downto 0);
	  -- SW_i( 1: 0) -> Set BASE		SW1 , V16 : SW0 , V17
	  -- SW_i(13: 2) -> NOT USED
	  -- SW_i(15:14) -> Set SPEED		SW15, R2  : SW14, T1
	
	-- Outputs for Basys 3 Board (Low Active)
	SS_Sel_o	: out std_logic_vector(3 downto 0);
	  -- SS_Sel_o(0) -> En/Disabled Digit 0, 	AN0, U2
	  -- SS_Sel_o(1) -> En/Disabled Digit 1,	AN1, U4
	  -- SS_Sel_o(2) -> En/Disabled Digit 2,	AN2, V4
	  -- SS_Sel_o(3) -> En/Disabled Digit 3,	AN3, W4
	SS_o		: out std_logic_vector(7 downto 0)
	  -- SS_o(0) -> En/Disabled Segment DP, V7
	  -- SS_o(1) -> En/Disabled Segment CG, U7
	  -- SS_o(2) -> En/Disabled Segment CF, V5
	  -- SS_o(3) -> En/Disabled Segment CE, U5
	  -- SS_o(4) -> En/Disabled Segment CD, V8
	  -- SS_o(5) -> En/Disabled Segment CC, U8
	  -- SS_o(6) -> En/Disabled Segment CB, W6
	  -- SS_o(7) -> En/Disabled Segment CA, W7
  );
  
end CounterTop;