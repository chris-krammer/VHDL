--------------------------------------------------------------------------------------------------
--                                                                                              --
--                                                                                              --
--                  F A C H H O C H S C H U L E   -   T E C H N I K U M W I E N                 --
--                                                                                              --
--                                                                                              --
--------------------------------------------------------------------------------------------------
--                                                                                              --
-- Web: http://www.technikum-wien.at/                                                           --
--                                                                                              --
-- Contact: christopher.krammer@technikum-wien.at                                               --
--------------------------------------------------------------------------------------------------
--
--
-- Author: Christopher Krammer
--
-- Filename: tb_ioCtrl_sim.vhd
--
-- Date of Creation: Mon Dec 17 12:30:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Fri Dec 14 12:30:00 2018
--
-- Design Unit: ioCtrl (Testbench Entity)
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

architecture sim of tb_ioCtrl is

    -- We're slowing down the clock to speed up simulation time
    constant ClockFrequencyHz : integer := 100e6; -- 100 MHz
    constant ClockPeriod      : time    := 1000 ms / ClockFrequencyHz;
    constant c_PBs : integer range 0 to 4 := 4;
    constant c_SWs : integer range 0 to 16 := 16;

	component ioCtrl
  	generic(  g_PBINPUTS    : integer   :=  5;            --  Number of PushButtons (excl. CPU_RESET)
  	          g_SWINPUTS    : integer   := 16;            --  Number of Switches
  	          g_SYNCSTAGES  : integer   :=  1;            --  Number of SyncStages to be realised
  	          g_DEBTIME     : integer   := 10;            --  Debounce Time in MasterClock Ticks
  	          g_RSTACTIVE   : std_logic := '1'            --  Active State of RESET INPUT
  	        );

	  	port( CLK_i     : in  std_logic;                      --  Clock Input 1kHz
	  	      --FCLK_i    : in  std_logic;                      --  Clock for 7-Segment (expected 4kHz)
	  	      RST_i     : in  std_logic;                      --  Reset Input
	  	      SW_i      : in  std_logic_vector(g_SWINPUTS-1 downto 0); --  Switch Inputs
	  	      PB_i      : in  std_logic_vector(g_PBINPUTS-1 downto 0); --  Push-Button Inputs
	  	      CNTR0_i   : in  std_logic_vector( 3 downto 0); --  Counter Input Digit 1
	  	      CNTR1_i   : in  std_logic_vector( 3 downto 0); --  Counter Input Digit 2
	  	      CNTR2_i   : in  std_logic_vector( 3 downto 0); --  Counter Input Digit 3
	  	      CNTR3_i   : in  std_logic_vector( 3 downto 0); --  Counter Input Digit 4
	  	      SS_o      : out std_logic_vector( 7 downto 0); --  Seven-Segment Output
	  	      SS_SEL_o  : out std_logic_vector( 3 downto 0); --  Seven-Segment Selector Output
	  	      SWSYNC_o  : out std_logic_vector(g_SWINPUTS-1 downto 0); --  Syncronized Switches Output
	  	      PBSYNC_o  : out std_logic_vector(g_PBINPUTS-1 downto 0)  --  Syncronized Push-Buttons Output
	  	    );
	end component;

	--component clkPrescale
	--port (-- Inputs
	--	  CLK_i		: in std_logic; -- Clock Input 100MHz
	--	  RST_i		: in std_logic; -- HIGH Active Reset
	--	  SOURCEHZ_i: in std_logic_vector(31 downto 0) := b"00000101111101011110000100000000"; -- 100MHz
	--	  TARGETHZ_i: in std_logic_vector(31 downto 0) := b"00000000000000000000001111101000"; --   1kHz

	--	  -- Outputs
	--	  OUT_o: out std_logic
	--	  );
	--end component;

	-- General Signals
	signal s_CLK		: std_logic := '1';	-- BoardClock
	--signal s_FCLK		: std_logic := '1';	-- FastClock
	signal s_RST		: std_logic := '1';	-- Reset Signal
	-- Prescaler Signals
	--signal s_SClk		: std_logic := '1';	-- SlowClock
	--signal SHZ			: std_logic_vector(31 downto 0) := x"05F5E100"; -- 100  MHz
	--signal THZ1kHz		: std_logic_vector(31 downto 0) := x"000003E8"; -- 1000 Hz
	--signal THZ4kHz		: std_logic_vector(31 downto 0) := x"00000FA0"; -- 4000 Hz
	--signal THZ100HZ		: std_logic_vector(31 downto 0) := x"00000064"; -- 100	Hz
	--signal THZ10HZ		: std_logic_vector(31 downto 0) := x"0000000A"; -- 10	Hz
	--signal THZ1HZ		: std_logic_vector(31 downto 0) := x"00000001"; -- 1	Hz
	-- ioCtrl Signals
	signal s_SW_in		: std_logic_vector(c_SWs-1 downto 0) := (others => '0');
	signal s_SW_out		: std_logic_vector(c_SWs-1 downto 0) := (others => '0');
	signal s_PB_in		: std_logic_vector(c_PBs-1 downto 0) := (others => '0');
	signal s_PB_out		: std_logic_vector(c_PBs-1 downto 0) := (others => '0');
	signal s_SS_out		: std_logic_vector( 7 downto 0) := (others => '0');
	signal s_SS_SEL_out	: std_logic_vector( 3 downto 0) := (others => '0');

begin


---- The Device Under Test (DUT)
--	-- Generate 1kHz Clock Signal
--    i_pre1k : clkPrescale
--	-- Link the ports
--    port map(
--		-- Inputs
--		CLK_i 	=> s_CLK,
--		RST_i 	=> s_RST,
--		SOURCEHZ_i	=> SHZ,
--		TARGETHZ_i	=> THZ1kHz,
--		-- Outputs
--		OUT_o	=> s_SClk
--		);

---- The Device Under Test (DUT)
--	-- Generate 4kHz Clock Signal
--    i_pre4k : clkPrescale
--	-- Link the ports
--    port map(
--		-- Inputs
--		CLK_i 	=> s_CLK,
--		RST_i 	=> s_RST,
--		SOURCEHZ_i	=> SHZ,
--		TARGETHZ_i	=> THZ4kHz,
--		-- Outputs
--		OUT_o	=> s_FCLK
--		);

-- The Device Under Test (DUT)
    i_io : ioCtrl
	-- Link the ports
  generic map(  g_PBINPUTS    => c_PBs,	--  Number of PushButtons (excl. CPU_RESET)
            		g_SWINPUTS    => c_SWs,	--  Number of Switches
            		g_SYNCSTAGES  => 1,	--  Number of SyncStages to be realised
            		g_DEBTIME     =>10,	--  Debounce Time in MasterClock Ticks
            		g_RSTACTIVE   =>'1'	--  Active State of RESET INPUT
          		)

  port map( CLK_i     => s_CLK,	--  Clock Input 1kHz
        		--FCLK_i    => open,	--  Clock for 7-Segment (expected 4kHz)
        		RST_i     => s_RST,	--  Reset Input
        		SW_i      => s_SW_in,	--  Switch Inputs
        		PB_i      => s_PB_in,	--  Push-Button Inputs
        		CNTR0_i   => x"0",	--  Counter Input Digit 1
        		CNTR1_i   => x"1",	--  Counter Input Digit 2
        		CNTR2_i   => x"2",	--  Counter Input Digit 3
        		CNTR3_i   => x"3",	--  Counter Input Digit 4
        		SS_o      => s_SS_out,	--  Seven-Segment Output
        		SS_SEL_o  => s_SS_SEL_out,	--  Seven-Segment Selector Output
        		SWSYNC_o  => s_SW_out,	--  Syncronized Switches Output
        		PBSYNC_o  => s_PB_out		--  Syncronized Push-Buttons Output
      		);

-- Process for generating the clock
s_CLK <= not s_CLK 	after ClockPeriod / 2;

-- Testbench sequence
    process is
    begin

	-- Clocks are outsourced
	-- Debouncing and Display Controller are testable

--  0ms
	  wait until rising_edge(s_CLK);
	  wait until rising_edge(s_CLK);
	  s_RST <= '0';
--	20 ns
	  wait for 1999980 ns;

--   2 ms
	-- Set SW0 and SW8 '1'
	  s_SW_in(0) <= '1';
	  wait for 300 us;
							s_SW_in(7) <= '1';
							wait for 400 us;
	-- +0.7 ms
	  s_SW_in(0) <= '0';
	  wait for 500 us;
							s_SW_in(7) <= '0';
							wait for 600 us;
	-- +1.1 ms
	  s_SW_in(0) <= '1';
	  wait for 900 us;
							s_SW_in(7) <= '1';
							wait for 1000 us;
	-- +1.9 ms
	  s_SW_in(0) <= '0';
	  wait for 500 us;
							s_SW_in(7) <= '0';
							wait for 600 us;
	-- +1.1 ms
	  s_SW_in(0) <= '1';
	  wait for 700 us;
							s_SW_in(7) <= '1';
	-- +0.7 ms
	--  5.5 ms

--	7.5 ms
	  wait for 10 ms;
--	17.5 ms
	-- Set SW0 and SW8 '0'
	  s_SW_in(0) <= '0';
	  wait for 300 us;
							s_SW_in(7) <= '0';
							wait for 300 us;
	  s_SW_in(0) <= '1';
	  wait for 500 us;
							s_SW_in(7) <= '1';
							wait for 600 us;
	  s_SW_in(0) <= '0';
							s_SW_in(7) <= '0';
	  wait for 5 ms;
--	59.2 ms

	-- Set PB0 '1'
	  s_PB_in(0) <= '1';
	  wait for 1000 us;
	  s_PB_in(0) <= '0';
	  wait for 1100 us;
	  s_PB_in(0) <= '1';
	  wait for 800 us;
	  s_PB_in(0) <= '0';
	  wait for 300 us;
	  s_PB_in(0) <= '1';
      wait for 5 ms;



	-- Reset
	  s_RST <= '1';
	  wait for 1 ns;
	  s_RST <= '0';

	wait;
    end process;

end architecture;
