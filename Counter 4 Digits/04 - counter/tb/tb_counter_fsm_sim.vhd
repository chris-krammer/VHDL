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
-- Filename: tb_plsGen_sim.vhd
--
-- Date of Creation: Mon Dec 17 12:30:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Fri Dec 14 12:30:00 2018
--
-- Design Unit: plsGen (Testbench Entity)
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

architecture sim of tb_counter_fsm is

	-- Simulate Board MasterClock
    constant ClockFrequencyHz : integer := 100e6; -- 100 MHz
    constant ClockPeriod      : time    := 1000 ms / ClockFrequencyHz;
	
	component clkPrescale
	port(
	-- Inputs
	CLK_i	: in std_logic;
	RST_i	: in std_logic; -- HIGH Active Reset
	SOURCEHZ_i: in std_logic_vector(31 downto 0) := b"00000101111101011110000100000000"; -- 100MHz
	TARGETHZ_i: in std_logic_vector(31 downto 0) := b"00000000000000000000001111101000"; --   1kHz
	
	-- Outputs
	OUT_o: out std_logic -- New Clock Signal
	);
	end component;
	
	component counter_fsm
	port (
		-- Inputs	
		CLK_i	: in std_logic;	-- Board Clock
		RST_i   : in std_logic;	-- High Active reset
		CNT_UP_i	: in std_logic;	-- Changes Direction to count up
		CNT_DOWN_i	: in std_logic;	-- Changes Direction to count down
		CNT_HLD_i   : in std_logic;	-- Stops the counter
		CNT_RST_i   : in std_logic;	-- Resets the counter value
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
	
	component counter
	port (
		-- Inputs	
		CLK_i	: in std_logic;	-- Board Clock
		RST_i   : in std_logic;	-- High Active reset
		CNT_UP_i	: in std_logic;	-- Changes Direction to count up
		CNT_DOWN_i	: in std_logic;	-- Changes Direction to count down
		CNT_HLD_i   : in std_logic;	-- Stops the counter
		CNT_RST_i   : in std_logic;	-- Resets the counter value
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

	-- General Signals
    signal s_Clk		: std_logic := '1';	-- BoardClock
	signal s_SClk		: std_logic;		-- SlowClock
    signal s_RST		: std_logic := '1';	-- Reset Signal
	signal s_UP			: std_logic := '0';	-- Input to count up
	signal s_DOWN		: std_logic := '0';	-- Input to count down
	signal s_HLD		: std_logic := '0';	-- Input to stop counter
	signal s_CNT_RST	: std_logic := '0'; -- Resets the counter value
	-- Signals for clkPrescale
	signal s_SHZ		: std_logic_vector(31 downto 0) := b"00000101111101011110000100000000";	-- 100MHz
    signal s_THZ		: std_logic_vector(31 downto 0) := b"00000000000000000010011100010000";	--  10kHz
	-- Signals for DEC counter
	signal s_DEC_CNT_MIN	: std_logic_vector( 3 downto 0) := x"0";
	signal s_DEC_CNT_MAX	: std_logic_vector( 3 downto 0) := x"9";
	signal s_CNTR0_DEC		: std_logic_vector( 3 downto 0);	-- Ones-Output from counter
	signal s_CNTR1_DEC		: std_logic_vector( 3 downto 0);	-- Tens-Output from counter
	signal s_CNTR2_DEC		: std_logic_vector( 3 downto 0);	-- Huns-Output from counter
	signal s_CNTR3_DEC		: std_logic_vector( 3 downto 0);	-- Thou-Output from counter
	signal s_CNTRVAL_DEC	: std_logic_vector(15 downto 0);	-- Total-Output from counter
	signal s_CNTR0_DEC_fsm	: std_logic_vector( 3 downto 0);	-- Ones-Output from counter
	signal s_CNTR1_DEC_fsm	: std_logic_vector( 3 downto 0);	-- Tens-Output from counter
	signal s_CNTR2_DEC_fsm	: std_logic_vector( 3 downto 0);	-- Huns-Output from counter
	signal s_CNTR3_DEC_fsm	: std_logic_vector( 3 downto 0);	-- Thou-Output from counter
	signal s_CNTRVAL_DEC_fsm: std_logic_vector(15 downto 0);	-- Total-Output from counter
	-- Signals for HEX counter
	signal s_HEX_CNT_MIN	: std_logic_vector( 3 downto 0) := x"0";
	signal s_HEX_CNT_MAX	: std_logic_vector( 3 downto 0) := x"F";
	signal s_CNTR0_HEX		: std_logic_vector( 3 downto 0);	-- Ones-Output from counter
	signal s_CNTR1_HEX		: std_logic_vector( 3 downto 0);	-- Tens-Output from counter
	signal s_CNTR2_HEX		: std_logic_vector( 3 downto 0);	-- Huns-Output from counter
	signal s_CNTR3_HEX		: std_logic_vector( 3 downto 0);	-- Thou-Output from counter
	signal s_CNTRVAL_HEX	: std_logic_vector(15 downto 0);	-- Total-Output from counter
	-- Signals for OCT counter
	signal s_OCT_CNT_MIN	: std_logic_vector( 3 downto 0) := x"0";
	signal s_OCT_CNT_MAX	: std_logic_vector( 3 downto 0) := x"7";
	signal s_CNTR0_OCT		: std_logic_vector( 3 downto 0);	-- Ones-Output from counter
	signal s_CNTR1_OCT		: std_logic_vector( 3 downto 0);	-- Tens-Output from counter
	signal s_CNTR2_OCT		: std_logic_vector( 3 downto 0);	-- Huns-Output from counter
	signal s_CNTR3_OCT		: std_logic_vector( 3 downto 0);	-- Thou-Output from counter
	signal s_CNTRVAL_OCT	: std_logic_vector(15 downto 0);	-- Total-Output from counter
	-- Signals for BIN counter
	signal s_BIN_CNT_MIN	: std_logic_vector( 3 downto 0) := x"0";
	signal s_BIN_CNT_MAX	: std_logic_vector( 3 downto 0) := x"1";
	signal s_CNTR0_BIN		: std_logic_vector( 3 downto 0);	-- Ones-Output from counter
	signal s_CNTR1_BIN		: std_logic_vector( 3 downto 0);	-- Tens-Output from counter
	signal s_CNTR2_BIN		: std_logic_vector( 3 downto 0);	-- Huns-Output from counter
	signal s_CNTR3_BIN		: std_logic_vector( 3 downto 0);	-- Thou-Output from counter
	signal s_CNTRVAL_BIN	: std_logic_vector(15 downto 0);	-- Total-Output from counter

begin

-- Process for generating the clock
    s_Clk <= not s_Clk 	after ClockPeriod / 2;

-- The Device Under Test (DUT)
	-- Generate 1kHz Clock Signal
    i_clk : clkPrescale
	-- Link the generics
    --generic map(
	--	) -- NO ";" at then end of generic map ()
		
	-- Link the ports	
    port map(
		-- Inputs
		CLK_i 	=> s_Clk,
		RST_i 	=> s_RST,
		SOURCEHZ_i	=> s_SHZ,
		TARGETHZ_i	=> s_THZ,		
		
		-- Outputs
		OUT_o => s_SClk
		);
		
-- The Device Under Test (DUT)
	-- Create Counter instance, DECIMAL
    i_counter_DEC_fsm : counter_fsm
	-- Link the ports	
    port map(
		-- Inputs
		CLK_i 	=> s_SClk,
		RST_i 	=> s_RST,
		CNT_UP_i	=> s_UP,
		CNT_DOWN_i	=> s_DOWN,
		CNT_HLD_i	=> s_HLD,
		CNT_RST_i	=> s_CNT_RST,
		CNT_MIN_i	=> s_DEC_CNT_MIN,
		CNT_MAX_i	=> s_DEC_CNT_MAX,
		
		-- Outputs
		cntr0_o => s_CNTR0_DEC_fsm,
		cntr1_o => s_CNTR1_DEC_fsm,
		cntr2_o => s_CNTR2_DEC_fsm,
		cntr3_o => s_CNTR3_DEC_fsm,
		cntrVal_o => s_CNTRVAL_DEC_fsm
		);
		
-- The Device Under Test (DUT)
	-- Create Counter instance, DECIMAL
    i_counter_DEC : counter
	-- Link the ports	
    port map(
		-- Inputs
		CLK_i 	=> s_SClk,
		RST_i 	=> s_RST,
		CNT_UP_i	=> s_UP,
		CNT_DOWN_i	=> s_DOWN,
		CNT_HLD_i	=> s_HLD,
		CNT_RST_i	=> s_CNT_RST,
		CNT_MIN_i	=> s_DEC_CNT_MIN,
		CNT_MAX_i	=> s_DEC_CNT_MAX,
		
		-- Outputs
		cntr0_o => s_CNTR0_DEC,
		cntr1_o => s_CNTR1_DEC,
		cntr2_o => s_CNTR2_DEC,
		cntr3_o => s_CNTR3_DEC,
		cntrVal_o => s_CNTRVAL_DEC
		);
		
-- The Device Under Test (DUT)
	-- Create Counter instance, HEXADEZIMAL
    i_counter_HEX : counter_fsm
	-- Link the ports	
    port map(
		-- Inputs
		CLK_i 	=> s_SClk,
		RST_i 	=> s_RST,
		CNT_UP_i	=> s_UP,
		CNT_DOWN_i	=> s_DOWN,
		CNT_HLD_i	=> s_HLD,
		CNT_RST_i	=> s_CNT_RST,
		CNT_MIN_i	=> s_HEX_CNT_MIN,
		CNT_MAX_i	=> s_HEX_CNT_MAX,
		
		-- Outputs
		cntr0_o => s_CNTR0_HEX,
		cntr1_o => s_CNTR1_HEX,
		cntr2_o => s_CNTR2_HEX,
		cntr3_o => s_CNTR3_HEX,
		cntrVal_o => s_CNTRVAL_HEX
		);
		
-- The Device Under Test (DUT)
	-- Create Counter instance, OCTAL
    i_counter_OCT : counter_fsm
	-- Link the ports	
    port map(
		-- Inputs
		CLK_i 	=> s_SClk,
		RST_i 	=> s_RST,
		CNT_UP_i	=> s_UP,
		CNT_DOWN_i	=> s_DOWN,
		CNT_HLD_i	=> s_HLD,
		CNT_RST_i	=> s_CNT_RST,
		CNT_MIN_i	=> s_OCT_CNT_MIN,
		CNT_MAX_i	=> s_OCT_CNT_MAX,
		
		-- Outputs
		cntr0_o => s_CNTR0_OCT,
		cntr1_o => s_CNTR1_OCT,
		cntr2_o => s_CNTR2_OCT,
		cntr3_o => s_CNTR3_OCT,
		cntrVal_o => s_CNTRVAL_OCT
		);		

-- The Device Under Test (DUT)
	-- Create Counter instance, BINARY
    i_counter_BIN : counter_fsm
	-- Link the ports	
    port map(
		-- Inputs
		CLK_i 	=> s_SClk,
		RST_i 	=> s_RST,
		CNT_UP_i	=> s_UP,
		CNT_DOWN_i	=> s_DOWN,
		CNT_HLD_i	=> s_HLD,
		CNT_RST_i	=> s_CNT_RST,
		CNT_MIN_i	=> s_BIN_CNT_MIN,
		CNT_MAX_i	=> s_BIN_CNT_MAX,
				
		-- Outputs
		cntr0_o => s_CNTR0_BIN,
		cntr1_o => s_CNTR1_BIN,
		cntr2_o => s_CNTR2_BIN,
		cntr3_o => s_CNTR3_BIN,
		cntrVal_o => s_CNTRVAL_BIN
		);		

    -- Testbench sequence
	-- !! Attention: Takes quite long to simulate since SimTime is around 3 seconds
    process is
    begin

-- 0 ms	
		wait until rising_edge(s_CLK);
		wait until rising_edge(s_CLK);
		
        -- Take the DUT out of reset
	    s_RST <= '0';
		
		-- Set Counting Direction
		wait for 1 ns;
		s_UP <= '1';
		wait for 100 us;
		s_UP <= '0';
		
		-- Reset DUT again and set Counting Direction
		wait for 14070 us;
		s_RST <= '1';
		wait for 30 ns;
		s_RST <= '0';
		wait for 1 ns;
		s_UP <= '1';
		wait for 100 us;
		s_UP <= '0';

		-- Reset only the Counter value
		wait for 28066504 ns;
		s_CNT_RST <= '1';
		wait for 100 us;
		s_CNT_RST <= '0';
		
		-- Chnage DUTs MAX value, reset and release counting upwards
		wait for 2 ms;
		s_DEC_CNT_MAX <= x"5";
		wait for 1 us;
		s_RST <= '1';
		wait for 1 ns;
		s_RST <= '0';
		wait for 1 ns;
		s_UP <= '1';
		wait for 100 us;
		s_UP <= '0';
		

        wait;
    end process;

end architecture;