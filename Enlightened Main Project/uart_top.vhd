----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:03:00 07/31/2011 
-- Design Name: 
-- Module Name:    uart_top - rtl 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


----------------------------------------------------------------------------------
-- Entity
----------------------------------------------------------------------------------

entity uart_top is
  generic (
	 use_handshake     : boolean := true;
   log2_oversampling : integer := 4);
  port ( 
    CLK200P : in  std_logic;
    CLK200N : in  std_logic;
    RXD     : in  std_logic;
    CTS     : in  std_logic;
    LED     : out std_logic_vector(7 downto 0);
    TXD     : out std_logic;
    RTS     : out std_logic);
end uart_top;


----------------------------------------------------------------------------------
-- Architecture
----------------------------------------------------------------------------------

architecture rtl of uart_top is
  
  
----------------------------------------------------------------------------------
-- Component Declaration
----------------------------------------------------------------------------------

  -- Clock manager
  component mmcm200
    port (
      -- Clock in ports
      CLK200_P : in  std_logic;
      CLK200_N : in  std_logic;
      -- Clock out ports
      CLK100   : out std_logic;
      CLKOSX   : out std_logic;
      -- Status and control signals
      RESET    : in  std_logic;
      LOCKED   : out std_logic);
  end component;

  -- Integrated controller
  component icon_cs
    port (
      CONTROL0 : inout std_logic_vector(35 downto 0));
  end component;

  -- Virtual input/output
  component vio_cs
    port (
      CONTROL   : inout std_logic_vector(35 downto 0);
      CLK       : in  std_logic;
      SYNC_IN   : in  std_logic_vector(54 downto 0);
      ASYNC_OUT : out std_logic_vector( 1 downto 0);
      SYNC_OUT  : out std_logic_vector(12 downto 0));
  end component;


----------------------------------------------------------------------------------
-- Signals
----------------------------------------------------------------------------------

  signal VIO_CONTROL   : std_logic_vector(35 downto 0);
  signal VIO_ASYNC_OUT : std_logic_vector( 1 downto 0);
  signal VIO_SYNC_OUT  : std_logic_vector(12 downto 0);
  signal VIO_SYNC_IN   : std_logic_vector(54 downto 0);
  
  signal CLK         : std_logic;
  signal CLKOSX      : std_logic;
  signal MMCM_LOCKED : std_logic;
  signal MMCM_RST    : std_logic;
  signal UART_RST    : std_logic;

  signal WREN   : std_logic;
  signal RDEN   : std_logic;
  signal WRDATA : std_logic_vector(7 downto 0);
  signal RDDATA : std_logic_vector(7 downto 0);
  signal WRRDY  : std_logic;
  signal RDRDY  : std_logic;
  
  signal TX_WRCOUNT : std_logic_vector(10 downto 0);
  signal TX_RDCOUNT : std_logic_vector(10 downto 0);
  signal RX_WRCOUNT : std_logic_vector(10 downto 0);
  signal RX_RDCOUNT : std_logic_vector(10 downto 0);
  
  signal RTS_INT : std_logic;
  signal CTS_INT : std_logic;

  signal RDEN_SWITCH : std_logic;
  signal RDEN_PULSE  : std_logic;
  signal WREN_SWITCH : std_logic;
  signal WREN_PULSE  : std_logic;
  signal WRSEL       : std_logic;
  signal WRDATA_VIO  : std_logic_vector(7 downto 0);

  
----------------------------------------------------------------------------------
-- Attributes
----------------------------------------------------------------------------------

  -- Synplicity black box declaration
  attribute syn_black_box : boolean;
  attribute syn_black_box of icon_cs : component is true;
  attribute syn_black_box of  vio_cs : component is true;

begin

----------------------------------------------------------------------------------
-- Component Instantiation
----------------------------------------------------------------------------------

  -- ChipScope integrated controller
  icon_inst : icon_cs
    port map (
      CONTROL0 => VIO_CONTROL);

  -- ChipScope virtual input/output
  vio_inst : vio_cs
    port map (
      CONTROL   => VIO_CONTROL,
      CLK       => CLK,
      SYNC_IN   => VIO_SYNC_IN,
      ASYNC_OUT => VIO_ASYNC_OUT,
      SYNC_OUT  => VIO_SYNC_OUT);

  -- Clock manager
  mmcm_i : mmcm200
    port map (
      -- Clock in ports
      CLK200_P => CLK200P,
      CLK200_N => CLK200N,
      -- Clock out ports
      CLK100   => CLK,
      CLKOSX   => CLKOSX,
      -- Status and control signals
      RESET    => MMCM_RST,
      LOCKED   => MMCM_LOCKED);

	-- Universal asynchonous transmitter
  tx_inst : entity work.uart_tx
    generic map (
      use_handshake     => use_handshake,
      log2_oversampling => log2_oversampling)
    port map ( 
      RST    => UART_RST,
      WRCLK  => CLK,
      CLKOSX => CLKOSX,
      WREN   => WREN,
      CTS    => CTS_INT,
      WRCOUNT => TX_WRCOUNT,
      RDCOUNT => TX_RDCOUNT,
      WRDATA => WRDATA,
      WRRDY  => WRRDY,
      TXD    => TXD);

	-- Universal asynchonous receiver
  rx_inst : entity work.uart_rx
    generic map (
      use_handshake     => use_handshake,
      log2_oversampling => log2_oversampling)
    port map ( 
      RST    => UART_RST,
      RDCLK  => CLK,
      CLKOSX => CLKOSX,
      RXD    => RXD,
      RDEN   => RDEN,
      RTS    => RTS_INT,
      WRCOUNT => RX_WRCOUNT,
      RDCOUNT => RX_RDCOUNT,
      RDDATA => RDDATA,
      RDRDY  => RDRDY);


----------------------------------------------------------------------------------
-- Concurrent Statements
----------------------------------------------------------------------------------

  -- Virtual inputs
  VIO_SYNC_IN <= (TX_RDCOUNT & TX_WRCOUNT & RX_RDCOUNT & RX_WRCOUNT & WRRDY & RDRDY & RDDATA & MMCM_LOCKED);
  
  -- Virtual outputs
  UART_RST    <= VIO_ASYNC_OUT(1);
  MMCM_RST    <= VIO_ASYNC_OUT(0);
  RDEN_SWITCH <= VIO_SYNC_OUT(12);
  RDEN_PULSE  <= VIO_SYNC_OUT(11);
  WREN_SWITCH <= VIO_SYNC_OUT(10);
  WREN_PULSE  <= VIO_SYNC_OUT(9);
  WRSEL       <= VIO_SYNC_OUT(8);
  WRDATA_VIO  <= VIO_SYNC_OUT(7 downto 0);
  
  -- Request/Clear To Send
  RTS <= RTS_INT;
  CTS_INT <= CTS;
  
  -- Read/Write enable & selector for tx data
  wr_proc : process (CLK)
  begin
    if rising_edge(CLK) then
      RDEN <= RDEN_SWITCH or RDEN_PULSE;
      WREN <= WREN_SWITCH or WREN_PULSE;
      if WRSEL = '1' then
        WRDATA <= WRDATA_VIO;
      else
        WRDATA <= RDDATA;
      end if;
    end if;
  end process wr_proc;
  
  -- LED outputs
  led_proc : process (CLK)
  begin
    if rising_edge(CLK) then
      LED(0) <= MMCM_RST;
      LED(1) <= UART_RST;
      LED(2) <= RTS_INT;
      LED(3) <= CTS_INT;
      LED(4) <= RDEN;
      LED(5) <= WREN;
      LED(6) <= '0';
      LED(7) <= '1';
    end if;
  end process led_proc;

  
end rtl;
