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
-- Filename: tb_mux4to1_sim.vhd
--
-- Date of Creation: Mon Dec 17 12:30:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Fri Dec 14 12:30:00 2018
--
-- Design Unit: mux4to1 (Testbench Entity)
--
-- Description: Manages the interface and the outputs
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

architecture sim of tb_mux4to1 is

  -- We're slowing down the clock to speed up simulation time
  constant ClockFrequencyHz : integer := 100e6; -- 100 MHz
  constant ClockPeriod      : time    := 1000 ms / ClockFrequencyHz;

  constant SClockFrequencyHz : integer := 1e3; -- 1 kHz
  constant SClockPeriod      : time    := 1000 ms / SClockFrequencyHz;
	
  constant DataWidth1 : integer := 4;
  constant DataWidth2 : integer := 8;
  constant DataWidth3 : integer := 16;	
	
  component mux4to1
    generic(DataWidth	: integer range 1 to 16 := 16); -- Define DataWidth of Input- and Output Signals
	
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
  end component;

  -- General Signals
  signal s_Clk		: std_logic := '1';	-- Board Clock
  signal s_SClk		: std_logic := '1';		-- Slow Clock
  signal s_Rst		: std_logic := '1';	-- Reset Signal
  
  signal s_SEL		: std_logic_vector(1 downto 0) := "00";

  signal s_IN0		: std_logic_vector(DataWidth1-1 downto 0) := "0001";
  signal s_IN1		: std_logic_vector(DataWidth1-1 downto 0) := "0010";
  signal s_IN2		: std_logic_vector(DataWidth1-1 downto 0) := "0100";
  signal s_IN3		: std_logic_vector(DataWidth1-1 downto 0) := "1000";
  signal s_OU1		: std_logic_vector(DataWidth1-1 downto 0);

  signal s_IN4		: std_logic_vector(DataWidth2-1 downto 0) := "00000001";
  signal s_IN5		: std_logic_vector(DataWidth2-1 downto 0) := "00000010";
  signal s_IN6		: std_logic_vector(DataWidth2-1 downto 0) := "00000100";
  signal s_IN7		: std_logic_vector(DataWidth2-1 downto 0) := "00001000";
  signal s_OU2		: std_logic_vector(DataWidth2-1 downto 0);

  signal s_IN8		: std_logic_vector(DataWidth3-1 downto 0) := "0000000000000001";
  signal s_IN9		: std_logic_vector(DataWidth3-1 downto 0) := "0000000000000010";
  signal s_IN10		: std_logic_vector(DataWidth3-1 downto 0) := "0000000000000100";
  signal s_IN11		: std_logic_vector(DataWidth3-1 downto 0) := "0000000000001000";
  signal s_OU3		: std_logic_vector(DataWidth3-1 downto 0);

begin

-- The Device Under Test (DUT)
  -- Create mux4to1 instance, D0
  i_mux4to1_D0 : mux4to1
  generic map(DataWidth => DataWidth1) -- NO ";" at then end of generic map ()
  -- Link the ports	
  port map(
	-- Inputs
	IN0_i 	=> s_IN0,
	IN1_i 	=> s_IN1,
	IN2_i 	=> s_IN2,
	IN3_i	=> s_IN3,
	SEL_i	=> s_SEL,
	-- Outputs
	OUT_o => s_OU1
  );	

-- The Device Under Test (DUT)
  -- Create mux4to1 instance, D1
  i_mux4to1_D1 : mux4to1
  generic map(DataWidth => DataWidth2) -- NO ";" at then end of generic map ()
  -- Link the ports	
  port map(
	-- Inputs
	IN0_i 	=> s_IN4,
	IN1_i 	=> s_IN5,
	IN2_i 	=> s_IN6,
	IN3_i	=> s_IN7,
	SEL_i	=> s_SEL,
	-- Outputs
	OUT_o => s_OU2
  );
  
-- The Device Under Test (DUT)
  -- Create mux4to1 instance, D2
  i_mux4to1_D2 : mux4to1
  generic map(DataWidth => DataWidth3) -- NO ";" at then end of generic map ()
  -- Link the ports	
  port map(
	-- Inputs
	IN0_i 	=> s_IN8,
	IN1_i 	=> s_IN9,
	IN2_i 	=> s_IN10,
	IN3_i	=> s_IN11,
	SEL_i	=> s_SEL,
	-- Outputs
	OUT_o => s_OU3
  );


-- Process for generating the clock
  s_Clk 	<= not s_Clk	after ClockPeriod	/ 2;
  s_SClk	<= not s_SClk 	after SClockPeriod	/ 2;
	
-- Process for generating the Select Signal
p_sel : process(s_SClk, s_Rst)
  begin
	if (s_Rst = '1') then
	  s_SEL <= "00";
	elsif(rising_edge(s_SClk)) then
	  s_SEL <= std_logic_vector(unsigned(s_SEL)+1);
	end if;			
  end process p_sel;
	
    -- Testbench sequence
p_test : process is
  begin

-- 0 ms	
	wait until rising_edge(s_SClk);
    wait until rising_edge(s_SClk);
-- 2 ms
    -- Take the DUT out of reset
	s_Rst <= '0';
									-- SEL
    wait until rising_edge(s_SClk); -- 00
	wait until rising_edge(s_SClk);	-- 01
	wait until rising_edge(s_SClk);	-- 02
	wait until rising_edge(s_SClk);	-- 03

    wait until rising_edge(s_SClk); -- 00
	wait until rising_edge(s_SClk);	-- 01
	wait until rising_edge(s_SClk);	-- 02
	wait until rising_edge(s_SClk);	-- 03

    wait until rising_edge(s_SClk); -- 00
	wait until rising_edge(s_SClk);	-- 01
    -- Reset
	s_Rst <= '1';
	
    end process;

end architecture;