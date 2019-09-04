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
-- Filename: uart_.vhd
--
-- Date of Creation: Wed Sep 04 07:30:00 2019
--
-- Version: 1.0
--
-- Date of Creation: Wed Sep 04 07:30:00 2019
--
-- Design Unit: uart (Entity)
--
-- Description: UART Entity for Asynchronous communication
--------------------------------------------------------------------------------------------------
-- CVS Change Log:
--
--------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uart is
  generic(  -- General GENERICS
            g_SOURCEHZ  : integer range 1 to 100e6  :=  100e6;  -- Board Master Clock
            g_RSTACTIVE : std_logic := '1';                     -- Board Reset ACTIVE level
            -- Entity specific GENERICS
            g_BAUDRATE  : integer range 1 to 100e6  :=  9600;   -- UART: BAUD Rate
            g_DATABITS  : integer range 5 to 9      :=     8;   -- UART: DATABITS to transmit and receive
            g_STOPBITS  : integer range 1 to 2      :=     1;   -- UART: Number of STOPBITS used
            g_PARITYBIT : std_logic                 :=   '0';   -- UART: PARITY used (1) or not (0)
            g_PARITY_EO : std_logic                 :=   '0'   -- UART: PARITY EVEN (0) or ODD (1)
          );
  port( -- General Inputs
        CLK_i     : in std_logic;                                 -- Board Master Clock
        RST_i     : in std_logic;                                 -- Board Master Reset
        -- TX Inputs
        TX_EN_i   : in std_logic;                                 -- Initiate data transmission
        TX_DATA_i : in std_logic_vector(g_DATABITS - 1 downto 0); -- Data to transmit
        -- RX Inputs
        RX_i      : in std_logic;                                 -- Receive Input Pin
        -- TX Outputs
        TX_o      : out std_logic;                                -- Transmit Output Pin
        TX_BUSY_o : out std_logic;                                -- Transmit BUSY indication
        TX_FIN_o  : out std_logic;                                -- Transmit FINISHED indication
        -- RX Outputs
        RX_ERR_o  : out std_logic_vector(1 downto 0);             -- Receive Error (start. parity, stop)
        RX_BUSY_o : out std_logic;                                -- Receive BUSY indication
        RX_DATA_o : out std_logic_vector(g_DATABITS - 1 downto 0); -- Received Data
        RX_FIN_o  : out std_logic                                -- Receive FINISHED indication
      );
end entity uart;
