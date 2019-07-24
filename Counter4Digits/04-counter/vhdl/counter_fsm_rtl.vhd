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
-- Filename: counter_fsm.vhd
--
-- Date of Creation: Sun Dec 16 21:33:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Sun Dec 16 21:33:00 2018
--
-- Design Unit: counter_fsm (Architecture)
--
-- Description: Counts either up or down.
--				Min and Max values can be changed
--
--				Asynchronous:
--					-	Reset
--					-	Output handling
--						THEORETICALLY! The OUTPUTS are realised using concurrent statements
--						Outputs are driven by signals which are updated synchronous with the clock
--						-> Output Signal assginment occurs if the right hand side changes
--						
--				Synchronous:
--					-	State change (Thats pretty nasty... If 1Hz is selected Buttons have to be 1 Sec active...)
--					-	Counting for v_Ones, v_Tens, v_Huns and v_Thou
--					-	Signal assignment of s_Ones, s_Tens, s_Huns and s_Thou
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

architecture rtl of counter_fsm is

  -----------------------------------------------------------------------------------------------------------------------------	
	-- State definitions
  -----------------------------------------------------------------------------------------------------------------------------		
	type t_state is (cnt_reset, cnt_hold, cnt_up, cnt_down, cnt_reset_val);
	signal s_state		: t_state;
	signal s_prev_state	: t_state;
  -----------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------	
	-- Signal definitions
  -----------------------------------------------------------------------------------------------------------------------------	
	signal s_Ones	: unsigned( 3 downto 0) := (others => '0');	-- Counter Values for the Ones Digit		000X
	signal s_Tens	: unsigned( 3 downto 0) := (others => '0');	-- Counter Values for the Tens Digit		00X0
	signal s_Huns	: unsigned( 3 downto 0) := (others => '0');	-- Counter Values for the Hundreds Digit	0X00	
	signal s_Thou	: unsigned( 3 downto 0) := (others => '0');	-- Counter Values for the Thousands Digit	X000
	signal s_Count	: unsigned(15 downto 0)	:= (others => '0'); -- Concatenated 16 bit Counter Value
	signal s_MIN	: unsigned( 3 downto 0) := unsigned(CNT_MIN_i);
	signal s_MAX	: unsigned( 3 downto 0) := unsigned(CNT_MAX_i);
  -----------------------------------------------------------------------------------------------------------------------------
	
  -----------------------------------------------------------------------------------------------------------------------------	
	-- Procedure to Count Up
  -----------------------------------------------------------------------------------------------------------------------------	
    procedure CountUpWrap(	signal Counter 		: inout unsigned;
							constant StartValue	: in 	unsigned; 
							constant WrapValue	: in    unsigned; 
							constant Enable   	: in    boolean;
							variable Wrapped  	: out   boolean) is
		begin
			if Enable then
				if Counter = WrapValue then
					Wrapped := true;
					Counter <= StartValue;
				else
					Wrapped := false;
					Counter <= Counter + 1;
				end if;
			else
				Wrapped := false;
			end if;
	end procedure;
  -----------------------------------------------------------------------------------------------------------------------------	
  -----------------------------------------------------------------------------------------------------------------------------		
	-- Procedure to Count Up
  -----------------------------------------------------------------------------------------------------------------------------	
	procedure CountDownWrap(signal Counter		: inout unsigned;
							constant StartValue	: in 	unsigned;
							constant WrapValue	: in    unsigned;
							constant Enable   	: in    boolean; 
							variable Wrapped  	: out   boolean) is
		begin
			if Enable then
				if Counter = WrapValue then
					Wrapped := true;
					Counter <= StartValue;
				else
					Wrapped := false;
					Counter <= Counter - 1;
				end if;
			else
				Wrapped := false;
			end if;
    end procedure;
  -----------------------------------------------------------------------------------------------------------------------------


  begin
  
  -----------------------------------------------------------------------------------------------------------------------------		
	-- Counter Process
  -----------------------------------------------------------------------------------------------------------------------------	
p_CNT : process(s_state, CLK_i, RST_i, CNT_RST_i, CNT_HLD_i, CNT_UP_i, CNT_DOWN_i, CNT_MIN_i, CNT_MAX_i, s_MIN, s_MAX) is
			variable v_EN		: boolean;	-- signals counter wrap
			variable v_EN1		: boolean := true;	-- Enabled Ones Counting
			variable v_ENTENS	: boolean;	-- Enables Tens counting, Ones wrapped to zero
			variable v_ENHUNS	: boolean;	-- Enables Huns counting, Tens wrapped to zero
			variable v_ENTHOU	: boolean;	-- Enables Thou counting, Thou wrapped to zero

			begin
			
				if(RST_i = '1') then
				  	
				  -- Reset Counter signals
				  s_Ones	<= (others => '0');
				  s_Tens	<= (others => '0');
				  s_Huns	<= (others => '0');
				  s_Thou	<= (others => '0');
				  					
				  -- Get new Values for MIN and MAX
				  s_MIN	<= unsigned(CNT_MIN_i);
				  s_MAX	<= unsigned(CNT_MAX_i);
                  
				  -- Change to HOLD state
				  s_state <= cnt_hold;
				
				elsif(rising_edge(CLK_i)) then		
				  case s_state is
					when cnt_reset_val =>
						
						-- Reset Counter signals
						s_Ones	<= (others => '0');
						s_Tens	<= (others => '0');
						s_Huns	<= (others => '0');
						s_Thou	<= (others => '0');

						-- Get new Values for MIN and MAX
						s_MIN	<= unsigned(CNT_MIN_i);
						s_MAX	<= unsigned(CNT_MAX_i);

						-- Change to HOLD state
						s_state <= s_prev_state;
						
					when cnt_hold =>
						-- Save current state
						s_prev_state <= cnt_hold;
						
						if (CNT_RST_i = '1') then
							-- Change to RESET_VAL state
							s_state <= cnt_reset_val;
						elsif(CNT_UP_i = '1') then
							-- Change to UP state
							s_state <= cnt_up;
						elsif(CNT_DOWN_i = '1') then
							-- Change to DOWN state
							s_state <= cnt_down;
						else
							-- Stay in current state
							s_state <= cnt_hold;
						end if;	
									
					when cnt_up =>
						-- Save current state
						s_prev_state <= cnt_up;
						
						if(CNT_RST_i = '1')then
							-- Change to RESET state
							s_state <= cnt_reset_val;
						elsif(CNT_HLD_i = '1') then
							-- Change to HOLD state
							s_state <= cnt_hold;
						elsif(CNT_DOWN_i = '1') then
							-- Change to DOWN state
							s_state <= cnt_down;
						else
							-- Increment Count Values
							CountUpWrap(s_Ones,	s_MIN, s_MAX, v_EN1,     v_ENTENS);
							CountUpWrap(s_Tens, s_MIN, s_MAX, v_ENTENS,  v_ENHUNS);
							CountUpWrap(s_Huns,	s_MIN, s_MAX, v_ENHUNS,  v_ENTHOU);
							CountUpWrap(s_Thou,	s_MIN, s_MAX, v_ENTHOU,  v_EN);
											
							-- Stay in current state
							s_state <= cnt_up;
						end if;
						
					when cnt_down =>
						-- Save current state
						s_prev_state <= cnt_down;
						
						if(CNT_RST_i = '1')then
							-- Change to RESET state
							s_state <= cnt_reset_val;
						elsif(CNT_HLD_i = '1') then
							-- Change to HOLD state
							s_state <= cnt_hold;
						elsif(CNT_UP_i = '1') then
							-- Change to DOWN state
							s_state <= cnt_up;
						else
							-- Decrement Count Values
							CountDownWrap(s_Ones, s_MAX, s_MIN, v_EN1,	   v_ENTENS);
							CountDownWrap(s_Tens, s_MAX, s_MIN, v_ENTENS,  v_ENHUNS);
							CountDownWrap(s_Huns, s_MAX, s_MIN, v_ENHUNS,  v_ENTHOU);
							CountDownWrap(s_Thou, s_MAX, s_MIN, v_ENTHOU,  v_EN);
							
							-- Stay in state
							s_state <= cnt_down;							
						end if;
						
					when others =>
						-- Change to HOLD state
						s_state <= cnt_hold;						
				  end case;
				end if;
		end process p_CNT;
  -----------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------		
	-- Handling the outputs
  -----------------------------------------------------------------------------------------------------------------------------	
	-- (each line is a process itself sensitive to the right-hand side of "<=")
	-- "Concurrant Statement"				
	CNTRVal_o 	<= std_logic_vector(s_Thou & s_Huns & s_Tens & s_Ones);
	CNTR0_o		<= std_logic_vector(s_Ones);
	CNTR1_o		<= std_logic_vector(s_Tens);
	CNTR2_o		<= std_logic_vector(s_Huns);
	CNTR3_o		<= std_logic_vector(s_Thou);
  -----------------------------------------------------------------------------------------------------------------------------	
	
end architecture;