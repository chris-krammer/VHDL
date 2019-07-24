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
-- Design Unit: mux4to1 (Entitiy)
--
-- Description: Selects one of the four inputs and copies it to the output
--
--------------------------------------------------------------------------------
-- CVS Change Log:
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity mux4to1 is
  -- Use generics with "generic map (target => value)" when instantiating
  -- Define DataWidth of Input- and Output Signals
  generic(DataWidth : integer := 1);
  port(
    -- Inputs
    IN0_i : in std_logic_vector(DataWidth - 1 downto 0);  -- Input 1
    IN1_i : in std_logic_vector(DataWidth - 1 downto 0);  -- Input 2
    IN2_i : in std_logic_vector(DataWidth - 1 downto 0);  -- Input 3
    IN3_i : in std_logic_vector(DataWidth - 1 downto 0);  -- Input 4
    SEL_i : in std_logic_vector(1 downto 0);  -- Input Select Signal
    
    -- Outputs
    OUT_o : out std_logic_vector(DataWidth - 1 downto 0)  -- Output
  );
end entity;