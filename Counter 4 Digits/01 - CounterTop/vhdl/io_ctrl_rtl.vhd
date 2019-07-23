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
-- Filename: io_ctrl_rtl.vhd
--
-- Date of Creation: Sun Dec 16 21:33:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Sun Dec 16 21:33:00 2018
--
-- Design Unit: io_ctrl (Architecture)
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
use ieee.numeric_std.all;

architecture rtl of io_ctrl is
  signal swsync		: std_logic_vector(15 downto 0) := (others => '0');
  signal pbsync		: std_logic_vector( 3 downto 0) := (others => '0');
  signal s_sel		: std_logic_vector( 1 downto 0) := (others => '0');
  signal s_ss_sel	: std_logic_vector( 3 downto 0) := (others => '0');
  signal s_ss		: std_logic_vector( 7 downto 0) := (others => '0');
  signal s_pbFF1	: std_logic_vector( 3 downto 0) := (others => '0');
  signal s_pbFF2	: std_logic_vector( 3 downto 0) := (others => '0');
  signal s_pbFF3	: std_logic_vector( 3 downto 0) := (others => '0');
  signal s_swFF1	: std_logic_vector(15 downto 0) := (others => '0');
  signal s_swFF2	: std_logic_vector(15 downto 0) := (others => '0');
  signal s_swFF3	: std_logic_vector(15 downto 0) := (others => '0');
  
  component mux4to1 is
    -- Use generics with "generic map (target => value)" when instantiating
    generic(DataWidth	: integer);  -- Define DataWidth of Input- and Output Signals
    port (
	  -- Inputs
	  IN0_i	: in std_logic_vector(DataWidth - 1 downto 0);	-- Input 1
	  IN1_i	: in std_logic_vector(DataWidth - 1 downto 0);	-- Input 2
	  IN2_i : in std_logic_vector(DataWidth - 1 downto 0);	-- Input 3
	  IN3_i	: in std_logic_vector(DataWidth - 1 downto 0);	-- Input 4
	  SEL_i	: in std_logic_vector(1 downto 0);	-- Input Select Signal
	  -- Outputs
	  OUT_o	: out std_logic_vector(DataWidth - 1 downto 0)	-- Output
	);
  end component mux4to1;
  
  ---------------------------------------------------------------------------------
  -- Procedure to simulate 3 FlipFlips in Series with an AND of all three FF-Outputs
  ---------------------------------------------------------------------------------
  procedure Debounce( signal s_In	: in std_logic;
					  signal s_FF1	: inout std_logic;
					  signal s_FF2	: inout std_logic;
					  signal s_FF3	: inout std_logic;
					  signal s_Out	: out std_logic) is  
  begin  
	s_FF3 <= s_FF2;
	s_FF2 <= s_FF1;
	s_FF1 <= s_In;

	s_Out <= s_FF1 AND s_FF2 AND s_FF3;
  end procedure;	
  
  ---------------------------------------------------------------------------------
  -- Function to set the correct segments based on the io_ctrl value
  --------------------------------------------------------------------------------- 
  function SS_Val(CalcVal : std_logic_vector(3 downto 0)) return std_logic_vector is
  begin
	case CalcVal is
	  when x"0" =>	return b"00000011";
	  when x"1" =>	return b"10011111";
	  when x"2" =>	return b"00100101";
	  when x"3" =>	return b"00001101";
	  when x"4" =>	return b"10011001";
	  when x"5" =>	return b"01001001";
	  when x"6" =>	return b"01000001";
	  when x"7" =>	return b"00011111";
	  when x"8" =>	return b"00000001";
	  when x"9" =>	return b"00001001";
	  when x"A" =>	return b"00010001";
	  when x"B" =>	return b"11000001";
	  when x"C" =>	return b"01100011";
	  when x"D" =>	return b"10000101";
	  when x"E" =>	return b"01100001";
	  when x"F" =>	return b"01110001";
	  when others => return x"FF"; -- All OFF
    end case;
  end function SS_Val;
  

begin -- rtl

  -----------------------------------------------------------------------------
  -- Debounce buttons and switches
  -- Debounces each element of the vector on its own
  -----------------------------------------------------------------------------
  p_debounce: process (CLK_i, RST_i)
  begin -- process debounce
  
    if (RST_i = '1') then -- asynchronous reset (active high)
	s_swFF1	<= (others => '0');
	s_swFF2	<= (others => '0');
	s_swFF3	<= (others => '0');
	s_pbFF1	<= (others => '0');
	s_pbFF2	<= (others => '0');
	s_pbFF3	<= (others => '0');
    swsync	<= (others => '0');
	pbsync	<= (others => '0');
	
	elsif (rising_edge(CLK_i)) then -- rising clock edge
	  -- Debounce PushButtons
	  Debounce(PB_i( 0), s_pbFF1( 0), s_pbFF2( 0), s_pbFF3( 0), pbsync( 0));
	  Debounce(PB_i( 1), s_pbFF1( 1), s_pbFF2( 1), s_pbFF3( 1), pbsync( 1));
	  Debounce(PB_i( 2), s_pbFF1( 2), s_pbFF2( 2), s_pbFF3( 2), pbsync( 2));
	  Debounce(PB_i( 3), s_pbFF1( 3), s_pbFF2( 3), s_pbFF3( 3), pbsync( 3));
	  -- Debounce Switches
	  Debounce(SW_i( 0), s_swFF1( 0), s_swFF2( 0), s_swFF3( 0), swsync( 0));
	  Debounce(SW_i( 1), s_swFF1( 1), s_swFF2( 1), s_swFF3( 1), swsync( 1));
	  Debounce(SW_i( 2), s_swFF1( 2), s_swFF2( 2), s_swFF3( 2), swsync( 2));
	  Debounce(SW_i( 3), s_swFF1( 3), s_swFF2( 3), s_swFF3( 3), swsync( 3));
	  Debounce(SW_i( 4), s_swFF1( 4), s_swFF2( 4), s_swFF3( 4), swsync( 4));
	  Debounce(SW_i( 5), s_swFF1( 5), s_swFF2( 5), s_swFF3( 5), swsync( 5));
	  Debounce(SW_i( 6), s_swFF1( 6), s_swFF2( 6), s_swFF3( 6), swsync( 6));
	  Debounce(SW_i( 7), s_swFF1( 7), s_swFF2( 7), s_swFF3( 7), swsync( 7));
	  Debounce(SW_i( 8), s_swFF1( 8), s_swFF2( 8), s_swFF3( 8), swsync( 8));
	  Debounce(SW_i( 9), s_swFF1( 9), s_swFF2( 9), s_swFF3( 9), swsync( 9));
	  Debounce(SW_i(10), s_swFF1(10), s_swFF2(10), s_swFF3(10), swsync(10));	
	  Debounce(SW_i(11), s_swFF1(11), s_swFF2(11), s_swFF3(11), swsync(11));
	  Debounce(SW_i(12), s_swFF1(12), s_swFF2(12), s_swFF3(12), swsync(12));
	  Debounce(SW_i(13), s_swFF1(13), s_swFF2(13), s_swFF3(13), swsync(13));	
	  Debounce(SW_i(14), s_swFF1(14), s_swFF2(14), s_swFF3(14), swsync(14));	
	  Debounce(SW_i(15), s_swFF1(15), s_swFF2(15), s_swFF3(15), swsync(15));
	  
	end if;
  end process p_debounce;
  
  SWSYNC_o <= swsync;
  PBSYNC_o <= pbsync;
  
  ----------------------------------------------------------------------------
  -- Display controller for the 7-segment display
  -- Segment is ACTIVE when Signal is LOW!!
  -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------
    -- SELECT Generator for MUX (2 bit select)
    -- 00 -> 01 -> 10 -> 11 -> 00 ..
    -- ATTENTION: Uses FCLK_i as Trigger and Clock
    --   Fastest Counting Freq = 1 kHz = Period of 7-Segment
    --   -> each of the 4 7-Segments should be lit once per Period
    --   -> 4 * 1 kHz => 4 kHz Clock needed
    ----------------------------------------------------------------------------- 
    p_displaycontrol : process (FCLK_i, RST_i)
    begin -- process displaycontroler
	
	  if(RST_i = '1') then
      -- Reset condition is not needed here,
	  -- since during the RESET something is shown on the display
      elsif (rising_edge(FCLK_i)) then -- rising clock edge
	    s_sel <= std_logic_vector( unsigned(s_sel) + 1 );
	  end if;

    end process p_displaycontrol;

    -----------------------------------------------------------------------------
    -- DIGIT LOAD MUX - Controlled by p_displaycontrol
    -- Instance U1 of mux4to1
    -----------------------------------------------------------------------------
    U1 : mux4to1
    generic map (DataWidth => 8)
    port map (IN0_i => SS_Val(cntr0_i),
			  IN1_i => SS_Val(cntr1_i),
			  IN2_i => SS_Val(cntr2_i),
			  IN3_i => SS_Val(cntr3_i),
			  SEL_i => s_sel,
			  OUT_o => s_ss
			  );
			  
    -----------------------------------------------------------------------------
    -- DIGIT SEL MUX - Controlled by p_displaycontrol
    -- Instance U2 of mux4to1
    -----------------------------------------------------------------------------
    U2 : mux4to1
    generic map (DataWidth => 4)
    port map (IN0_i => b"1110",
			  IN1_i => b"1101",
			  IN2_i => b"1011",
			  IN3_i => b"0111",
			  SEL_i => s_sel,
			  OUT_o => s_ss_sel
			  );
  
  SS_o <= s_ss when RST_i = '0' else b"11111111";
  SS_SEL_o <= s_ss_sel;
  
end rtl;