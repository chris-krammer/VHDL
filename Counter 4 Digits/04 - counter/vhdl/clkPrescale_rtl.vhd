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
-- Filename: clkPrescale_rtl.vhd
--
-- Date of Creation: Sun Dec 16 21:33:00 2018
--
-- Version: 1.0
--
-- Date of Latest Version: Sun Dec 16 21:33:00 2018
--
-- Design Unit: clkPrescale (Architecture)
--
-- Description: Prescales MasterClock
--				Signal SOURCEHZ_i defines MasterClock Frequency in HZ (32bit)
--				Signal TARGETHZ_i defines TargetClock Frequency in HZ (32bit)
--
-- !! KEEP IN MIND: NEW FREQUENCY IS UPDATED DURING CLOCK LOW.
--					THIS MEANS THE ACTUAL PERIOD WILL BE FINISHED BEFORE THE NEW PERIOD WILL START
--					EXCEPTION: RESET
--
-- !! KEEP IN MIND: OUTPUT IS NOT UPDATED IF WRONG INPUTS APPLIED
--------------------------------------------------------------------------------------------------
--
-- CVS Change Log:
--
--
--------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of clkPrescale is

  signal s_out 			: std_logic := '1';

begin
	  
  process(CLK_i, RST_i, SOURCEHZ_i, TARGETHZ_i)
    variable v_newPre		: unsigned (31 downto 0) := to_unsigned(1, 32);
    variable v_prescaler	: unsigned (31 downto 0) := to_unsigned(1, 32);
	variable v_counter		: unsigned (31 downto 0) := (others => '0');
	variable v_valid		: boolean := false;
  
  begin
    -- Asynchronous Reset
    if (RST_i = '1') then
      s_out 		<= '1';
	  v_counter 	:= (others => '0');
	  v_newPre		:= to_unsigned(1, 32);
	  v_prescaler	:= to_unsigned(1, 32);
	  v_valid 		:= false;
	  
	  
    -- Only if inputs SOURCEHZ_i and TARGETHZ_i are ok, Normal Operation will be continued
	elsif ((unsigned(SOURCEHZ_i) > 0) and (unsigned(TARGETHZ_i) > 0) and (unsigned(TARGETHZ_i) < (unsigned(SOURCEHZ_i)+1))) then
	  -- Inputs are OK -> Update new Prescaler
	  v_newPre	:= ((unsigned(SOURCEHZ_i)) / (unsigned(TARGETHZ_i))) / 2;
	
	  -- Inputs are OK -> Normal Operation @ Rising Clock Edge
	  if(rising_edge(CLK_i)) then
	    -- Counter has expired
	    if(v_counter = (v_prescaler-1)) then
		  -- Reset Counter
	      v_counter := (others => '0');
		 		  
		  -- inputs recovered to valid values
		  if (not v_valid) then
		    s_out 		<= '1';
		    v_prescaler	:= v_newPre;
			v_valid 	:= true;
			
		    -- If cycle is not valid (Inputs changed from N.OK -> OK)
		    -- Update ONLY the variable, no Output manipulation here
		    -- This is needed to get rid of 1 cylce spikes:
		    ---------------------------------------------------------
		    -- w/o v_valid
		    -- Inputs N.OK -> OK
		    -- s_Out = 0: _______|_|--|__|--|		
		    -- s_Out = 1: -------|-|__|--|__|
		    ---------------------------------------------------------
		    -- w/ v_valid
		    -- Inputs N.OK -> OK
		    -- s_Out = 0: ________|--|__|--|		
		    -- s_Out = 1: --------|__|--|__|
		    ---------------------------------------------------------
			
		  -- If Output is HIGH and Cycle is VALID -> Update Output and keep actual Prescaler			
		  -- New Frequency is omitted AFTER current cycle
	  	  elsif (s_out = '1' and v_valid) then
		    s_out <= '0';
	  	    v_prescaler := v_prescaler;
			
		  -- If Output is LOW and Cycle is VALID -> Update Output and load new Prescaler
	  	  elsif (s_out = '0' and v_valid) then
		    s_out <= '1';
	  	    v_prescaler	:= v_newPre;
			
		  else
			s_out <= 'X'; -- If anything else happens, set the Output 'X'
	  	  end if;
		  
	    else
		  -- If Rising Clock Edge and Counter NOT expired, increase counter by 1
	      v_counter := v_counter + 1;
	    end if;
	  end if;
	  
	else
	
	  if(rising_edge(CLK_i)) then
	  -- If Inputs are not OK (SOURCEHZ_i < TARGETHZ_i etc.)	
      -- If Inputs have been OK previously
	    if (v_valid) then
	      if(v_counter = (v_prescaler-1)) then
		    -- Reset Counter
	        v_counter := (others => '0');
		    -- If Output is LOW and Cycle is VALID -> Update Output and load new Prescaler
		    -- New Frequency is omitted AFTER current cycle
	  	    if (s_out = '0' and v_valid) then
			  v_valid := false;
			  v_counter 	:= (others => '0');
			  v_prescaler 	:= to_unsigned(1, 32);
		    -- If Output is HIGH and Cycle is VALID -> Update Output and keep actual Prescaler
	  	    elsif (s_out = '1' and v_valid) then
		      s_out <= '0';
	  	      v_prescaler := v_prescaler;
		    else
			  s_out <= 'X'; -- If anything else happens, set the Output 'X'
		    end if;
		  else
		    -- If Rising Clock Edge and Counter NOT expired, increase counter by 1
	        v_counter := v_counter + 1;
		  end if;
		else
		 v_counter 		:= (others => '0');
		 v_newPre		:= to_unsigned(1, 32);
		 v_prescaler	:= to_unsigned(1, 32); 
		 v_valid 		:= false; 
		 
		end if;		
	  end if;
	end if;
  end process;
  
  OUT_o <= s_out;

end architecture rtl;