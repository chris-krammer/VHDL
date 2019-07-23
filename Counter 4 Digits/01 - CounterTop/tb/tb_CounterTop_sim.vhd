--------------------------------------------------------------------------------------------------
--                                                --
--                                                --
--        F A C H H O C H S C H U L E   -   T E C H N I K U M W I E N         --
--                                                --
--                                                --
--------------------------------------------------------------------------------------------------
--                                                --
-- Web: http://www.technikum-wien.at/                             --
--                                                --
-- Contact: christopher.krammer@technikum-wien.at                       --
--                                                --
--------------------------------------------------------------------------------------------------
--
--
-- Author: Christopher Krammer
--
-- Filename: tb_CounterTop_sim.vhd
--
-- Date of Creation: Mon Dec 17 12:30:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Fri Dec 14 12:30:00 2018
--
-- Design Unit: CounterTop (Testbench Entity)
--
-- Description: Tests the CounterTop @ 1 kHz with Decimal Base (Default Values for CKr)
--
-- FYI: This might take a bit to run... There are all Entities in the simulation visible
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

architecture sim of tb_CounterTop is

  constant ClockFrequencyHz : integer := 100e6; -- 100 MHz
  constant ClockPeriod      : time    := 1000 ms / ClockFrequencyHz;

  component CounterTop
    port (
      -- Inputs from Basys 3 Bord (High Active)
      CLK_i : in std_logic; -- Master Clock Input
        -- W5
      RST_i : in std_logic; -- High Active Reset
        -- BTNC, U18
      PB_i  : in std_logic_vector( 3 downto 0);
        -- PB_i(0) -> Count Value RESET,  BTNR, T17
        -- PB_i(1) -> Count Value HOLD,   BTNL, W19
        -- PB_i(2) -> Count UPWARDS,    BTNU, T18
        -- PB_i(3) -> Count DOWNWARDS,    BTND, U17
      SW_i  : in std_logic_vector(15 downto 0);
        -- SW_i( 1: 0) -> Set BASE      SW1 , V16 : SW0 , V17
        -- SW_i(13: 2) -> NOT USED
        -- SW_i(15:14) -> Set SPEED     SW15, R2  : SW14, T1
      
      -- Outputs for Basys 3 Board (Low Active)
      SS_Sel_o  : out std_logic_vector(3 downto 0);
        -- SS_Sel_o(0) -> En/Disabled Digit 0,  AN0, U2
        -- SS_Sel_o(1) -> En/Disabled Digit 1,  AN1, U4
        -- SS_Sel_o(2) -> En/Disabled Digit 2,  AN2, V4
        -- SS_Sel_o(3) -> En/Disabled Digit 3,  AN3, W4
      SS_o    : out std_logic_vector(7 downto 0)
        -- SS_o(0) -> En/Disabled Segment DP, V7
        -- SS_o(1) -> En/Disabled Segment CG, U7
        -- SS_o(2) -> En/Disabled Segment CF, V5
        -- SS_o(3) -> En/Disabled Segment CE, U5
        -- SS_o(4) -> En/Disabled Segment CD, V8
        -- SS_o(5) -> En/Disabled Segment CC, U8
        -- SS_o(6) -> En/Disabled Segment CB, W6
        -- SS_o(7) -> En/Disabled Segment CA, W7  
    );
  end component;

  signal s_Clk    : std_logic := '1'; -- Clock Signal
  signal s_Rst    : std_logic := '1'; -- Reset Signal
  signal s_pb     : std_logic_vector( 3 downto 0) := "0000"; -- PushButtons
  signal s_sw     : std_logic_vector(15 downto 0) := "0000000000000000"; -- Switches
  signal s_ss_sel   : std_logic_vector( 3 downto 0) := "0000"; -- 7-Segment Select Signal
  signal s_ss     : std_logic_vector( 7 downto 0) := "00000000"; -- 7-Segment Load

begin

  -- The Device Under Test (DUT)
  i_CounterTop : CounterTop
    port map(
      -- Inputs
      CLK_i => s_Clk,
      RST_i => s_Rst,
      PB_i  => s_pb,
      SW_i  => s_sw,
      -- Outputs
      SS_Sel_o => s_ss_sel,
      SS_o   => s_ss
    );
    

  -- Process for generating the clock
  s_Clk <= not s_Clk  after ClockPeriod / 2;
  
  -- Testbench sequence
  process is
    begin
      
      -- Take the DUT out of reset
      -- Counter should stay in HOLD
      wait until rising_edge(s_Clk);
      wait until rising_edge(s_Clk);
      -- 20 ns
      s_Rst <= '0';
        
      -- Set Counter to count up  
      wait until rising_edge(s_Clk);
      wait until rising_edge(s_Clk);
      -- 40 ns
      s_pb(2) <= '1';
      wait for 5 ms;
      -- 5 ms
      s_pb(2) <= '0';
        
      -- Set Counter to count down
      -- Counter should be at DEC20
      wait for 20 ms;
      -- 25 ms
      s_pb(3) <= '1';
      wait for 5 ms;
      -- 30 ms
      s_pb(3) <= '0';
        
      -- Let counter wrap from 0000 to 9999
      wait for 25 ms;
      -- 55 ms 
      
      -- Let counter continue for 12 ms and HOLD afterwards
      -- Counter should be somwhere at 998x-something
      wait for 12 ms;
      -- 67 ms
      s_pb(1) <= '1';
      wait for 6 ms;
      -- 73 ms
      s_pb(1) <= '0'; 
  
      -- Set Counter to count up
      wait for 10 ms;
      -- 83 ms
      s_pb(2) <= '1';
      wait for 5 ms;
      -- 88 ms
      s_pb(2) <= '0';
      
      -- Let counter wrap from 9999 to 0000
      wait for 17 ms;
      -- 105 ms;
      
      -- Stress Test: Priority Check
      -- Buttons UP, DOWN, HOLD and RESET are set at the same time
      -- acc. Project specification Priority is as followed
        -- RESET (BTNC)
        -- RESET (BTNR)
        -- HOLD
        -- Direction
      -- In my Design the counter is set to hold IF the reset is coming from BTNC (not debounced)
      -- Counter should be in hold as soon as s_Rst transitions from LOW to HIGH
      wait for 19999977 ns;
      s_pb <= (others => '1');
      s_Rst <= '1';
      -- 125.000017 ms ALL CLOCKS LOW
      wait for 5000013 ns;
      s_pb <= (others => '0');
      s_Rst <= '0';
      -- 130.00003 ms;
  
      -- Stress Test: Base Change
      -- During normal operation, change the BASE
      -- Keep running after BASE change -> counter should still have old base value
      -- RESET (BTNC OR BTNR) -> Reset Counter value and update the Counter MAX = BASE
      -- Reset is required as a change from a higher base to a lower base could cause
      -- some trouble (CountUpWrap and CountDnWrap)
      wait for 5 ms;
      -- 135 ms
      -- Set countdirection to UP
      s_pb(2) <= '1';
       wait for 5 ms;
      -- 140 ms
      s_pb(2) <= '0';
      wait for 5 ms;
      -- 145 ms
      -- Set new BASE to HEX
      s_sw(1 downto 0) <= "01";
      wait for 15 ms;
      -- 160 ms
      s_pb(0) <= '1'; -- No need to reset whole design
      wait for 5 ms;
      -- 165 ms
      s_pb(0) <= '0';
      wait for 5 ms;
      -- 170 ms
      -- Counter has been reset with BTNL -> automatically returns to prev mode
      wait for 12 ms;
      -- 182 ms
      -- Set new BASE to OCT
      s_sw(1 downto 0) <= "10";
      wait for 15 ms;
      -- 197 ms
      s_pb(0) <= '1'; -- No need to reset whole design
      wait for 5 ms;
      -- 202 ms
      s_pb(0) <= '0';
      wait for 5 ms;
      -- 207 ms
      -- Counter has been reset with BTNL -> automatically returns to prev mode
      wait for 12 ms;
      -- 219 ms
      -- Set new BASE to BIN
      s_sw(1 downto 0) <= "11";
      wait for 15 ms;
      -- 234 ms
      s_pb(0) <= '1'; -- No need to reset whole design
      wait for 5 ms;
      -- 239 ms
      s_pb(0) <= '0';
      wait for 5 ms;
      -- 244 ms
      -- Counter has been reset with BTNL -> automatically returns to prev mode
      wait for 12 ms;
      -- 256 ms
      -- Set new BASE to DEC
      s_sw(1 downto 0) <= "00";
      wait for 15 ms;
      -- 271 ms
      s_pb(0) <= '1'; -- No need to reset whole design
      wait for 5 ms;
      -- 276 ms
      s_pb(0) <= '0';
      wait for 5 ms;
      -- 281 ms
      -- Counter has been reset with BTNL -> automatically returns to prev mode
      wait for 12 ms;
      -- 293 ms

      -- Stress Test: Speed Change
      -- During normal operation, the counting speed will be increased
      -- Default (s_SW<15:14> = "00") is 1kHz
      -- Since a change in speed during normal operation has no side effect to the counter
      -- no RESET (BTNC or BTNL) is required
      wait for 7 ms; -- new_count = old_count + 7;
      -- 300 ms
      s_sw(15 downto 14) <= "11"; -- 100Hz
      wait for 25 ms; -- new_Count = old_count + 2;
      -- 325 ms   
      -- other frequencies are not tested, as 10Hz and 1 Hz would result in too high simulation times
      -- If interested, please see tb in folder "clkPrescaler"
        
        wait;
    end process;

end architecture;