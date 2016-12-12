--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:10:21 09/05/2013
-- Design Name:   
-- Module Name:   C:/Users/Shahriar Shahramian/Desktop/32x32LEDMatrix/fpga/fpga_tb.vhd
-- Project Name:  fpga
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fpga_top
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY fpga_tb IS
END fpga_tb;
 
ARCHITECTURE behavior OF fpga_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fpga_top
    PORT(
         clk : IN  std_logic;
         led : OUT  std_logic;
         bluetooth_rxd : OUT  std_logic;
         bluetooth_txd : IN  std_logic;
         display_rgb1 : OUT  std_logic_vector(2 downto 0);
         display_rgb2 : OUT  std_logic_vector(2 downto 0);
         display_addr : OUT  std_logic_vector(3 downto 0);
         display_clk : OUT  std_logic;
         display_oe : OUT  std_logic;
         display_lat : OUT  std_logic;
         usb_rxd : OUT  std_logic;
         usb_txd : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal bluetooth_txd : std_logic := '1';
   signal usb_txd : std_logic := '1';

 	--Outputs
   signal led : std_logic;
   signal bluetooth_rxd : std_logic;
   signal display_rgb1 : std_logic_vector(2 downto 0);
   signal display_rgb2 : std_logic_vector(2 downto 0);
   signal display_addr : std_logic_vector(3 downto 0);
   signal display_clk : std_logic;
   signal display_oe : std_logic;
   signal display_lat : std_logic;
   signal usb_rxd : std_logic;

   -- Clock period definitions
   constant clk_period : time := 31250 ps;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fpga_top PORT MAP (
          clk => clk,
          led => led,
          bluetooth_rxd => bluetooth_rxd,
          bluetooth_txd => bluetooth_txd,
          display_rgb1 => display_rgb1,
          display_rgb2 => display_rgb2,
          display_addr => display_addr,
          display_clk => display_clk,
          display_oe => display_oe,
          display_lat => display_lat,
          usb_rxd => usb_rxd,
          usb_txd => usb_txd
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
END;
