--------------------------------------------------------------------------------
-- Company:  Bell Labs
-- Engineer: Timo Pfau
--
-- Create Date:   18:45:02 07/29/2011
-- Design Name:   
-- Module Name:   C:/tpfau/Alcatel-Lucent/FMF-MIMO/FPGA/UART/uart_tb.vhd
-- Project Name:  UART
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: uart_rx, uart_tx
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY uart_tb IS
END uart_tb;
 
ARCHITECTURE behavior OF uart_tb IS 
 
  -- Component Declaration for the Unit Under Test (UUT)
  component uart_tx
    generic (
	    use_handshake     : boolean := true;
      log2_oversampling : integer := 4);
    port ( 
      RST    : in  std_logic;
      WRCLK  : in  std_logic;
      CLKOSX : in  std_logic;
      WREN   : in  std_logic;
      CTS    : in  std_logic := '1';
      WRDATA : in  std_logic_vector(7 downto 0);
      WRRDY  : out std_logic;
      TXD    : out std_logic);
  end component;
    
  component uart_rx
    generic (
	    use_handshake     : boolean := true;
      log2_oversampling : integer := 4);
    port ( 
      RST    : in  std_logic;
      RDCLK  : in  std_logic;
      CLKOSX : in  std_logic;
      RXD    : in  std_logic;
      RDEN   : in  std_logic;
      RTS    : out std_logic := '1';
      RDDATA : out std_logic_vector(7 downto 0);
      RDRDY  : out std_logic);
  end component;

   -- Parameters
   constant use_handshake     : boolean := true;
   constant log2_oversampling : integer := 6;
   
   -- Inputs
   signal RST     : std_logic := '0';
   signal CLK     : std_logic := '0';
   signal CLK16TX : std_logic := '0';
   signal CLK16RX : std_logic := '0';
   signal RXD     : std_logic := '0';
   signal CTS     : std_logic := '0';
   signal RDEN    : std_logic := '0';
   signal WREN    : std_logic := '0';
   signal WRDATA  : std_logic_vector(7 downto 0) := (others => '0');

 	-- Outputs
   signal RTS    : std_logic;
   signal TXD    : std_logic;
   signal RDDATA : std_logic_vector(7 downto 0);
   signal RDRDY  : std_logic;
   signal WRRDY  : std_logic;

   -- Clock period definitions
   constant CLK_period     : time :=  1 ns;
   constant CLK16TX_period : time := 2.3 ns;
   constant CLK16RX_period : time := 2.4 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
  tx_inst : uart_tx
    generic map (
      use_handshake => use_handshake)
    port map ( 
      RST    => RST,
      WRCLK  => CLK,
      CLKOSX => CLK16TX,
      WREN   => WREN,
      CTS    => CTS,
      WRDATA => WRDATA,
      WRRDY  => WRRDY,
      TXD    => TXD);

  rx_inst : uart_rx
    generic map (
      use_handshake => use_handshake)
    port map ( 
      RST    => RST,
      RDCLK  => CLK,
      CLKOSX => CLK16RX,
      RXD    => RXD,
      RDEN   => RDEN,
      RTS    => RTS,
      RDDATA => RDDATA,
      RDRDY  => RDRDY);

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 
   CLK16TX_process :process
   begin
		CLK16TX <= '0';
		wait for CLK16TX_period/2;
		CLK16TX <= '1';
		wait for CLK16TX_period/2;
   end process;
 
   CLK16RX_process :process
   begin
		CLK16RX <= '0';
		wait for CLK16RX_period/2;
		CLK16RX <= '1';
		wait for CLK16RX_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for 100 ns;	
        RST <= '1';
      wait for 500 ns;	
        RST <= '0';
      wait for 400 ns;	
        WREN <= '1';
      wait for 9 us;	
        RDEN <= '1';
      wait for 10 us;	
        WREN <= '0';
      wait for 10 us;	
        WREN <= '1';
        RDEN <= '0';
      wait;
   end process;

  CTS <= RTS;
  RXD <= TXD;

  ctr_proc : process (CLK)
  begin
    if rising_edge(CLK) then
      WRDATA <= WRDATA + 1;
    end if;
  end process ctr_proc;
END;
