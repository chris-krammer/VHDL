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
-- Filename: CounterTop_struc.vhd
--
-- Date of Creation: Sun Dec 16 21:33:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Sun Dec 16 21:33:00 2018
--
-- Design Unit: CounterTop (Struc Architecture)
--
-- Description: This is the full Counter Design
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

architecture struc of CounterTop is

  -----------------------------------------------------------------------------
  -- Constants
  ----------------------------------------------------------------------------- 
  constant c_MasterClkFreqHz	: std_logic_vector(31 downto 0) := x"05F5_E100"; -- MasterClock Frequency from Board in Hz
  constant c_CntFreq1Hz			: std_logic_vector(31 downto 0) := x"0000_0001"; -- Counter Speed 1Hz
  constant c_CntFreq10Hz		: std_logic_vector(31 downto 0) := x"0000_000A"; -- Counter Speed 10Hz
  constant c_CntFreq100Hz		: std_logic_vector(31 downto 0) := x"0000_0064"; -- Counter Speed 100Hz  
  constant c_CntFreq1000Hz		: std_logic_vector(31 downto 0) := x"0000_03E8"; -- Counter Speed 1000Hz
  constant c_CntFreq4000Hz		: std_logic_vector(31 downto 0) := x"0000_0FA0"; -- 7-Seg Refresh Speed (Digits * c_CntFreq1000Hz)
  constant c_CntBaseDEC			: std_logic_vector( 3 downto 0) := x"9";		 -- Counter Max for Decimal counter
  constant c_CntBaseHEX			: std_logic_vector( 3 downto 0) := x"F";		 -- Counter Max for Hexadecimal counter
  constant c_CntBaseOCT			: std_logic_vector( 3 downto 0) := x"7";		 -- Counter Max for Octal counter
  constant c_CntBaseBIN			: std_logic_vector( 3 downto 0) := x"1";		 -- Counter Max for Binary counter
 
  -----------------------------------------------------------------------------
  -- Signals
  ----------------------------------------------------------------------------- 
  -- General Signals
  signal s_CLK	: std_logic;
  signal s_RST	: std_logic;
  
  -- U1 Signals (SPEED MUX)
  signal s_SPEED_out	: std_logic_vector(31 downto 0);
  
  -- U2 Signals (BASE MUX)
  signal s_BASE_out		: std_logic_vector( 3 downto 0);
  
  -- U3 Signals (1kHz Prescaler)
  signal s_1khz_out		: std_logic;
  
  -- U4 Signals (4kHz Prescaler)
  signal s_4khz_out		: std_logic;

  -- U5 Signals (Counter speed Prescaler)
  signal s_VarHz_out	: std_logic;
  
  -- U6 Signals (IO_Control)
  signal s_sw		: std_logic_vector(15 downto 0) := (others => '0');
  signal s_pb		: std_logic_vector( 3 downto 0) := (others => '0');
  
  -- U7 Signals (IO_Control)  
  signal s_min 		: std_logic_vector( 3 downto 0) := (others => '0');
  signal s_c0		: std_logic_vector( 3 downto 0) := (others => '0');
  signal s_c1		: std_logic_vector( 3 downto 0) := (others => '0');
  signal s_c2		: std_logic_vector( 3 downto 0) := (others => '0');
  signal s_c3		: std_logic_vector( 3 downto 0) := (others => '0');
  signal s_DUMMY 	: std_logic_vector(15 downto 0) := (others => '0'); 
 
  -----------------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------------
  component clkPrescale
    port(
	  -- Inputs
	  CLK_i	: in std_logic; -- Board Clock
	  RST_i	: in std_logic; -- HIGH Active Asynchronous Reset
	  SOURCEHZ_i: in std_logic_vector(31 downto 0) := b"00000101111101011110000100000000"; -- 100MHz
	  TARGETHZ_i: in std_logic_vector(31 downto 0) := b"00000000000000000000001111101000"; --   1kHz
	  -- Outputs
	  OUT_o: out std_logic
	);
  end component;
  
  component mux4to1
    -- Use generics with "generic map (target => value)" when instantiating
    generic(DataWidth	: integer);  -- Define DataWidth of Input- and Output Signal
    port (
	  -- Inputs
	  IN0_i	: in std_logic_vector(DataWidth - 1 downto 0);	-- Input 1
	  IN1_i	: in std_logic_vector(DataWidth - 1 downto 0);	-- Input 2
	  IN2_i : in std_logic_vector(DataWidth - 1 downto 0);	-- Input 3
	  IN3_i	: in std_logic_vector(DataWidth - 1 downto 0);	-- Input 4
	  SEL_i	: in std_logic_vector(1 downto 0);				-- Input Select Signal
	  -- Outputs
	  OUT_o	: out std_logic_vector(DataWidth - 1 downto 0)
	);
  end component;
  
  component io_ctrl
    port(
	  -- Inputs
	  CLK_i		:	in	std_logic;							-- Board Clock
	  FCLK_i	:	in	std_logic;							--	Fast Clock for Display
	  RST_i		:	in	std_logic;							-- HIGH Active Asynchronous Reset
	  SW_i		:	in	std_logic_vector (15 downto 0);		-- Switch Inputs
	  PB_i		:	in	std_logic_vector ( 3 downto 0);		-- Push-Button Inputs
	  CNTR0_i	:	in	std_logic_vector ( 3 downto 0);		-- Counter Input Digit 1
	  CNTR1_i	:	in	std_logic_vector ( 3 downto 0);		-- Counter Input Digit 2
	  CNTR2_i	:	in	std_logic_vector ( 3 downto 0);		-- Counter Input Digit 3
	  CNTR3_i	:	in	std_logic_vector ( 3 downto 0);		-- Counter Input Digit 4
	  -- Outputs
	  SS_o		:	out	std_logic_vector ( 7 downto 0);		-- Seven-Segment Output
	  SS_SEL_o	:	out	std_logic_vector ( 3 downto 0);		-- Seven-Segment Selector Output
	  SWSYNC_o	:	out std_logic_vector (15 downto 0);		-- Syncronized Switches Output
	  PBSYNC_o	:	out std_logic_vector ( 3 downto 0)		-- Syncronized Push-Buttons Output
	);
  end component;

  component counter_fsm
    port (
	  -- Inputs	
	  CLK_i		: in std_logic;	-- Board Clock
	  RST_i  	: in std_logic;	-- HIGH Active Asynchronous Reset
	  CNT_UP_i	: in std_logic;	-- Count Direction UP
	  CNT_DOWN_i: in std_logic;	-- Count Direction DOWN
	  CNT_HLD_i : in std_logic;	-- Count STOP
	  CNT_RST_i	: in std_logic; -- Resets the counter value
	  CNT_MIN_i	: in std_logic_vector(3 downto 0); -- MIN Value for one digit (BIN: 1, OCT: 7, DEC: 9, HEX: 15)
	  CNT_MAX_i	: in std_logic_vector(3 downto 0); -- MAX Value for one digit (BIN: 0, OCT: 0, DEC: 0, HEX:  0)
	  -- Outputs
	  CNTR0_o	:	out std_logic_vector( 3 downto 0);	-- Holds the Ones Values
	  CNTR1_o	:	out std_logic_vector( 3 downto 0);	-- Holds the Tens Values
	  CNTR2_o	:	out std_logic_vector( 3 downto 0);	-- Holds the Huns Values
	  CNTR3_o	:	out std_logic_vector( 3 downto 0);	-- Holds the Thou Values
	  CNTRVAL_o :	out std_logic_vector(15 downto 0)	-- Holds the current counter value
	);  
  end component;
 
begin -- Beginn struc

  -----------------------------------------------------------------------------
  -- U1 : Speed Mux - Muxes the speed for the counter
  -----------------------------------------------------------------------------
  U1 : mux4to1
  -- Link the genercis
  generic map(DataWidth => 32)
  -- Link the ports
  port map(
    -- Inputs
    IN0_i => c_CntFreq1000Hz,
	IN1_i => c_CntFreq1Hz,
	IN2_i => c_CntFreq10Hz,
	IN3_i => c_CntFreq100Hz,
	SEL_i => s_sw(15 downto 14),
	-- Outputs
	OUT_o => s_SPEED_out
  );
  
  -----------------------------------------------------------------------------
  -- U2 : Base Mux - Muxes the Base for the counter
  -----------------------------------------------------------------------------
  U2 : mux4to1
  -- Link the genercis
  generic map(DataWidth => 4)
  -- Link the ports
  port map(
    -- Inputs
    IN0_i => c_CntBaseDEC,
	IN1_i => c_CntBaseHEX,
	IN2_i => c_CntBaseOCT,
	IN3_i => c_CntBaseBIN,
	SEL_i => s_sw(1 downto 0),
	-- Outputs
	OUT_o => s_BASE_out
  );

  -----------------------------------------------------------------------------
  -- U3 : 1kHz Prescaler - Generates 1kHz Clock Signal for IO Control
  -----------------------------------------------------------------------------
  U3 : clkPrescale
  -- Link the ports	
  port map(
    -- Inputs
	CLK_i 	=> CLK_i,
	RST_i 	=> RST_i,
	SOURCEHZ_i	=> c_MasterClkFreqHz,
	TARGETHZ_i	=> c_CntFreq1000Hz,		
	-- Outputs
	OUT_o	=> s_1khz_out
  );

  -----------------------------------------------------------------------------
  -- U4 : 4kHz Prescaler - Generates 4kHz Clock Signal for 7-Segment
  -----------------------------------------------------------------------------
  U4 : clkPrescale
  -- Link the ports	
  port map(
    -- Inputs
	CLK_i 	=> CLK_i,
	RST_i 	=> RST_i,
	SOURCEHZ_i	=> c_MasterClkFreqHz,
	TARGETHZ_i	=> c_CntFreq4000Hz,		
	-- Outputs
	OUT_o	=> s_4khz_out
  );

  -----------------------------------------------------------------------------
  -- U5 : VarHz Prescaler - Generates Clock Signal for Counter (based on U1)
  -----------------------------------------------------------------------------
  U5 : clkPrescale
  -- Link the ports	
  port map(
    -- Inputs
	CLK_i 	=> CLK_i,
	RST_i 	=> RST_i,
	SOURCEHZ_i	=> c_MasterClkFreqHz,
	TARGETHZ_i	=> s_SPEED_out,		
	-- Outputs
	OUT_o	=> s_VarHz_out
  );

  -----------------------------------------------------------------------------
  -- U6 : IO Control - Debounces Inputs and controls the 7-Segment
  -----------------------------------------------------------------------------
  U6 : io_ctrl
  port map(
	CLK_i	 => s_1khz_out,
	FCLK_i	 => s_4khz_out,
	RST_i	 => RST_i,
	SW_i	 => SW_i,
	PB_i	 => PB_i,
	CNTR0_i	 => s_c0,
	CNTR1_i	 => s_c1,
	CNTR2_i	 => s_c2,
	CNTR3_i	 => s_c3,
	SS_o	 => SS_o,
	SS_SEL_o => SS_Sel_o,
	SWSYNC_o => s_sw,
	PBSYNC_o => s_pb
  );

  -----------------------------------------------------------------------------
  -- U7 : Counter - Counts and provides Result to IO Control
  -----------------------------------------------------------------------------
  U7 : counter_fsm
  port map(
	-- Inputs	
	CLK_i		=> s_VarHz_out,
	RST_i   	=> RST_i,
	CNT_UP_i	=> s_pb(2),
	CNT_DOWN_i	=> s_pb(3),
	CNT_HLD_i   => s_pb(1),
	CNT_RST_i	=> s_pb(0),
	CNT_MIN_i	=> s_min,
	CNT_MAX_i	=> s_BASE_out,
	-- Outputs
	CNTR0_o		=> s_c0,
	CNTR1_o		=> s_c1,
	CNTR2_o		=> s_c2,
	CNTR3_o		=> s_c3,
	CNTRVAL_o 	=> s_DUMMY
  );
  
end struc;