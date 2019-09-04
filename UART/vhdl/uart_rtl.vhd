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
-- Contact: es19m001@technikum-wien.at                                                          --
--------------------------------------------------------------------------------------------------
-- Author: Christopher Krammer
--
-- Filename: uart_rtl.vhd
--
-- Date of Creation: Wed Sep 04 07:30:00 2019
--
-- Version: 1.0
--
-- Date of Creation: Wed Sep 04 07:30:00 2019
--
-- Design Unit: uart (Architecture)
--
-- Description: UART Entity for Asynchronous communication
--------------------------------------------------------------------------------------------------
-- CVS Change Log:
--
--------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of uart is
  -- Constants to determine the single bit durations
    -- Used to determine the Bit duration depending on the BAUD rate
  constant c_TICKSPERBIT  : integer range 0 to g_SOURCEHZ         := (g_SOURCEHZ / g_BAUDRATE);
  constant c_SAMPLECNT    : integer range 0 to c_TICKSPERBIT / 2  := (c_TICKSPERBIT -1 ) / 2;

  -- State-Machines for TX and RX
  type t_tx_sm  is (t_tx_idle, t_tx_startBit, t_tx_dataBit, t_tx_parityBit, t_tx_stopBit, t_tx_DONE);
  type t_rx_sm  is (t_rx_idle, t_rx_startBit, t_rx_dataBit, t_rx_parityBit, t_rx_stopBit, t_rx_DONE);
  signal s_tx_sm  : t_tx_sm := t_tx_idle;
  signal s_rx_sm  : t_rx_sm := t_rx_idle;

  -- Signals to keep track of databits to be sent or have been receveived
  signal s_tx_bitIndex : integer range 0 to g_DATABITS;
  signal s_rx_bitIndex : integer range 0 to g_DATABITS;

  -- Signal to keep track of how many STOP bits have to be sent or received
  signal s_tx_stopBitIndex : integer range 1 to g_STOPBITS := 1;
  signal s_rx_stopBitIndex : integer range 1 to g_STOPBITS := 1;

  -- Signals to count the duration of a single bit
  signal s_tx_clkCNT  : integer range 0 to c_TICKSPERBIT;
  signal s_rx_clkCNT  : integer range 0 to c_TICKSPERBIT;

  -- Register to hold the TX and RX data
  signal s_tx_data      : std_logic_vector(g_DATABITS - 1 downto 0) := (others => '0');
  signal s_rx_data_reg  : std_logic_vector(g_DATABITS - 1 downto 0) := (others => '0');
  signal s_rx_data      : std_logic_vector(g_DATABITS - 1 downto 0) := (others => '0');

  -- Parity bits for TX and RX
  signal s_tx_parity : std_logic_vector(g_DATABITS downto 0) := (others => '0');
  signal s_rx_parity : std_logic_vector(g_DATABITS downto 0) := (others => '0');
  signal s_tx_parityBit : std_logic := '0';
  signal s_rx_parityBit : std_logic := '0';
  signal s_rx_calc_parityBit : std_logic := '0';

  -- Registers for RX to reduce metastability
  signal s_rx_bit_reg : std_logic := '0';
  signal s_rx_bit     : std_logic := '0';

  -- Signals for RX ERRORs
  signal s_rx_error_stopBit   : std_logic := '0'; -- Error receiving STOPBITS
  signal s_rx_error_parityBit : std_logic := '0'; -- Error receiving PARITYBIT

  -- Signals to Indicate Finish
  signal s_tx_done  : std_logic := '0';
  signal s_rx_done  : std_logic := '0';


begin

  -- TODO:
  -- ERROR HANDLING FOR WRONG GENERICS
  -- Throw an error if g_TARGETHZ is equal or greater than g_SOURCEHZ
  -- assert (g_TARGETHZ < g_SOURCEHZ) report lf &
  --  "**   g_TARGETHZ MUST BE SMALLER THAN g_SOURCEHZ" & lf &
  --  "**   g_TARGETHZ should be less than: " & integer'image(g_SOURCEHZ) & " Hz" & lf &
  --  "**   g_TARGETHZ currently is       : " & integer'image(g_TARGETHZ) & " Hz" severity error;

  ------------------------------------------------------------------------------------------------
  -- Process to clock in the RX input
  -- Since it might come from a different clock domain
  -- Metastability has to be taken into account
  p_SAMPLE_RX : process(CLK_i, RST_i)
  begin

    if (RST_i = g_RSTACTIVE) then
      s_rx_bit_reg  <= '1';
      s_rx_bit      <= '1';

    elsif (CLK_i'event and CLK_i = '1') then
      s_rx_bit_reg  <=  RX_i;
      s_rx_bit      <= s_rx_bit_reg;

    end if;
  end process p_SAMPLE_RX;
  ------------------------------------------------------------------------------------------------

  ------------------------------------------------------------------------------------------------
  -- Parity bit calculation for TX and RX
  GEN_TX_PARITY : if g_PARITYBIT = '1' generate
    s_tx_parity(0) <= g_PARITY_EO;
    GEN_TX_PARITY_LOGIC : for i in 0 to g_DATABITS - 1 generate
      s_tx_parity(i + 1) <= s_tx_parity(i) XOR s_tx_data(i);
    end generate GEN_TX_PARITY_LOGIC;
    s_tx_parityBit <= s_tx_parity(g_DATABITS);
  end generate GEN_TX_PARITY;

  GEN_RX_PARITY : if g_PARITYBIT = '1' generate
    s_rx_parity(0) <= g_PARITY_EO;
    GEN_RX_PARITY_LOGIC : for i in 0 to g_DATABITS - 1 generate
      s_rx_parity(i + 1) <= s_rx_parity(i) XOR s_rx_data(i);
    end generate GEN_RX_PARITY_LOGIC;
    s_rx_calc_parityBit <= s_rx_parity(g_DATABITS);
  end generate GEN_RX_PARITY;

  -- Determine if RX parity is correct
  with g_PARITYBIT select s_rx_error_parityBit <= s_rx_parity(g_DATABITS) xor s_rx_parityBit when '1',
                                                  '0' when others;
  ------------------------------------------------------------------------------------------------


  ------------------------------------------------------------------------------------------------
  p_UART_TX : process(CLK_i, RST_i)
  begin

    if (RST_i = g_RSTACTIVE) then
      TX_BUSY_o <= '0'; -- Drive Outputs LOW
      TX_o      <= '1'; -- Drive Outputs HIGH (IDLE)
      TX_FIN_o  <= '0';
      s_tx_sm   <= t_tx_idle;

    elsif (CLK_i'event and CLK_i = '1') then

      case s_tx_sm is

        -- IDLE STATE
        when t_tx_idle  =>
          TX_BUSY_o     <= '0'; -- Drive Outputs LOW
          TX_o          <= '1'; -- Drive Outputs HIGH (IDLE)
          TX_FIN_o      <= '0';
          s_tx_clkCNT   <= 0;
          s_tx_bitIndex <= 0;
          s_tx_stopBitIndex <= 1;

          if (TX_EN_i = '1') then
            s_tx_data <= TX_DATA_i;
            s_tx_sm   <= t_tx_startBit;

          else
            s_tx_sm   <= t_tx_idle;

          end if;

        -- STARTBIT HAS TO BE SENT (ALWAYS 0)
        when t_tx_startBit =>
          TX_BUSY_o <= '1'; -- Indicatate transmission in progress
          TX_o      <= '0'; -- Send Startbit

          -- Count until duration of bit is over
          if (s_tx_clkCNT = c_TICKSPERBIT - 1) then
            s_tx_clkCNT  <= 0;
            s_tx_sm      <= t_tx_dataBit;

          else
            s_tx_clkCNT <= s_tx_clkCNT + 1;
            s_tx_sm      <= t_tx_startBit;

          end if;

        -- DATABIT HAS TO BE SENT
        when t_tx_dataBit =>
          TX_BUSY_o <= '1'; -- Indicate transmission in progress
          TX_o      <= s_tx_data(s_tx_bitIndex); -- Send databit

          -- Count until duration of bit is over
          if (s_tx_clkCNT = c_TICKSPERBIT - 1) then
            s_tx_clkCNT   <= 0;

            -- Iterate through the databits
            if (s_tx_bitIndex = g_DATABITS - 1) then  -- Last databit has been sent
              s_tx_bitIndex <= 0;

              if (g_PARITYBIT = '1' ) then            -- Check if parity bit has been enabled
                s_tx_sm       <= t_tx_parityBit;      -- Switch to send paritybit

              else
                s_tx_sm       <= t_tx_stopBit;        -- Switch to send stopbit

              end if;

            else
              s_tx_bitIndex <= s_tx_bitIndex + 1;
              s_tx_sm       <= t_tx_dataBit;

            end if;

          else
            s_tx_clkCNT <= s_tx_clkCNT + 1;
            s_tx_sm      <= t_tx_dataBit;

          end if;

        -- PARITYBIT HAS TO BE SENT (IF ENABLED)
        when t_tx_parityBit =>
          TX_BUSY_o <= '1'; -- Indicate transmission in progress
          TX_o      <= s_tx_parityBit; -- Send parityBit

          -- Count until duration of bit is over
          if (s_tx_clkCNT = c_TICKSPERBIT - 1) then
            s_tx_clkCNT  <= 0;
            s_tx_sm      <= t_tx_stopBit;

          else
            s_tx_clkCNT <= s_tx_clkCNT + 1;
            s_tx_sm      <= t_tx_parityBit;

          end if;

        -- STOPBIT HAS TO BE SENT
        when t_tx_stopBit =>
          TX_BUSY_o <= '1'; -- Indicate transmission in progress
          TX_o      <= '1'; -- Send stopBit

          -- Count until duration of bit is over
          if (s_tx_clkCNT = c_TICKSPERBIT - 1) then
            s_tx_clkCNT  <= 0;

            -- Check if second Stop bit has to be sent
            if (s_tx_stopBitIndex = g_STOPBITS) then
              s_tx_sm  <= t_tx_DONE;

            else
              s_tx_stopBitIndex  <= s_tx_stopBitIndex + 1;
              s_tx_sm  <= t_tx_stopBit;

            end if;

          else
            s_tx_clkCNT <= s_tx_clkCNT + 1;
            s_tx_sm     <= t_tx_stopBit;

          end if;

        -- Only one Master Clock Cylce
        when t_tx_DONE =>
          TX_BUSY_o <= '0';
          TX_FIN_o  <= '1';
          s_tx_sm   <= t_tx_idle;

        when others =>
          s_tx_sm <= t_tx_idle;

      end case;
    end if;
  end process p_UART_TX;
  ------------------------------------------------------------------------------------------------

  ------------------------------------------------------------------------------------------------
  p_UART_RX : process(CLK_i, RST_i)
  begin

    if (RST_i = g_RSTACTIVE) then
      RX_BUSY_o <= '0'; -- Drive Outputs LOW
      RX_FIN_o  <= '0';
      s_rx_sm   <= t_rx_idle;

    elsif (CLK_i'event and CLK_i = '1') then

      case s_rx_sm is

        -- IDLE STATE
        when t_rx_idle  =>
          RX_BUSY_o     <= '0'; -- Drive Outputs LOW
          RX_FIN_o  <= '0';
          s_rx_clkCNT   <= 0;
          s_rx_bitIndex <= 0;
          s_rx_stopBitIndex <= 1;

          if (s_rx_bit = '0') then  -- START BIT DETECTED
            s_rx_sm   <= t_rx_startBit;

          else
            s_rx_sm   <= t_rx_idle;

          end if;

        -- STARTBIT HAS TO BE RECEIVED
        when t_rx_startBit =>

          -- Check if Start bit is still zero and not just a fluctuation
          if (s_rx_clkCNT = c_SAMPLECNT) then
            if (s_rx_bit = '0') then
              s_rx_clkCNT  <= 0;   -- Starting from here we always count to the middle of the bit
              RX_BUSY_o    <= '1'; -- Indicate transmission in progress
              s_rx_sm      <= t_rx_dataBit;

            else
              s_rx_sm <= t_rx_idle;

            end if;

          else
            s_rx_clkCNT <= s_rx_clkCNT + 1;
            s_rx_sm      <= t_rx_startBit;

          end if;

        -- DATABIT HAS TO BE RECEIVED
        when t_rx_dataBit =>
          RX_BUSY_o <= '1'; -- Indicate transmission in progress

          -- Count until half of the duration of bit is over
          if (s_rx_clkCNT = c_TICKSPERBIT - 1) then
            s_rx_clkCNT   <= 0;
            s_rx_data_reg(s_rx_bitIndex) <= s_rx_bit;

            -- Iterate through the databits
            if (s_rx_bitIndex = g_DATABITS - 1) then  -- Last databit has been sent
              s_rx_bitIndex <= 0;

              if (g_PARITYBIT = '1' ) then            -- Check if parity bit has been enabled
                s_rx_sm       <= t_rx_parityBit;      -- Switch to send paritybit
              else
                s_rx_sm       <= t_rx_stopBit;        -- Switch to send stopbit

              end if;

            else
              s_rx_bitIndex <= s_rx_bitIndex + 1;
              s_rx_sm       <= t_rx_dataBit;

            end if;

          else
            s_rx_clkCNT <= s_rx_clkCNT + 1;
            s_rx_sm     <= t_rx_dataBit;

          end if;

        -- PARITYBIT HAS TO BE RECEIVED
        when t_rx_parityBit =>
          RX_BUSY_o <= '1'; -- Indicatate transmission in progress

          -- Count until half of the duration of bit is over
          if (s_rx_clkCNT = c_TICKSPERBIT - 1) then
            s_rx_clkCNT     <= 0;
            s_rx_parityBit  <= s_rx_bit;
            s_rx_sm         <= t_rx_stopBit;

          else
            s_rx_clkCNT  <= s_rx_clkCNT + 1;
            s_rx_sm      <= t_rx_parityBit;

          end if;

        -- STOPBIT HAS TO BE RECEIVED
        when t_rx_stopBit =>
          RX_BUSY_o <= '1'; -- Indicatate transmission in progress

          -- Count until half of the duration of bit is over
          if (s_rx_clkCNT = c_TICKSPERBIT - 1) then
            s_rx_clkCNT   <= 0;

            -- Check if Stop bit is active
            if (s_rx_bit = '1') then
              -- Check if second Stop bit has to be received
              if (s_rx_stopBitIndex = g_STOPBITS) then
                s_rx_data <= s_rx_data_reg;
                s_rx_sm  <= t_rx_DONE;

              else
                s_rx_stopBitIndex  <= s_rx_stopBitIndex + 1;
                s_rx_sm  <= t_rx_stopBit;


              end if;

            else
              s_rx_error_stopBit <= '1';  -- Indicate STOPBIT ERROR
            end if;

          else
            s_rx_clkCNT <= s_rx_clkCNT + 1;
            s_rx_sm     <= t_rx_stopBit;

          end if;

        -- Only one Master Clock Cylce
        when t_rx_DONE =>
          RX_BUSY_o <= '0';
          RX_FIN_o  <= '1';
          s_rx_sm   <= t_rx_idle;

        when others =>
          s_rx_sm <= t_rx_idle;

      end case;
    end if;
  end process p_UART_RX;
  ------------------------------------------------------------------------------------------------

  -- Output Assignment
  RX_DATA_o    <= s_rx_data;
  RX_ERR_o(0)  <= s_rx_error_parityBit;
  RX_ERR_o(1)  <= s_rx_error_stopBit;

end architecture; -- rtl
