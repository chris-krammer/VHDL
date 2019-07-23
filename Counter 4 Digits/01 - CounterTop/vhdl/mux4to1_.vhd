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
-- Filename: mux4to1_.vhd
--
-- Date of Creation: Sun Dec 16 21:33:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Sun Dec 16 21:33:00 2018
--
-- Design Unit: mux4to1 (Entity)
--
-- Description: Selects one of the four inputs and copies it to the output
--
--
--
--
--------------------------------------------------------------------------------------------------
--
-- CVS Change Log:
--
--
--------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux4to1 is
  -- Use generics with "generic map (target => value)" when instantiating
  generic(DataWidth	: integer);  -- Define DataWidth of Input- and Output Signals

  port (
		-- Inputs
		IN0_i	: in std_logic_vector(DataWidth - 1 downto 0);	-- Input 1
		IN1_i	: in std_logic_vector(DataWidth - 1 downto 0);	-- Input 2
		IN2_i   : in std_logic_vector(DataWidth - 1 downto 0);	-- Input 3
		IN3_i	: in std_logic_vector(DataWidth - 1 downto 0);	-- Input 4
		
		SEL_i	: in std_logic_vector(1 downto 0);	-- Input Select Signal
		
		-- Outputs
		OUT_o	: out std_logic_vector(DataWidth - 1 downto 0)	-- Output
		);
end entity;