----------------------------------------------------------------------------------
-- Company:  Bell Labs
-- Engineer: Timo Pfau
-- 
-- Create Date:    14:18:24 07/29/2011 
-- Design Name: 
-- Module Name:    uart_tx - rtl 
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

library UNIMACRO;
use UNIMACRO.vcomponents.all;


----------------------------------------------------------------------------------
-- Entity
----------------------------------------------------------------------------------

entity uart_tx is
  generic (
	 use_handshake     : boolean := true;
   log2_oversampling : integer := 4);
  port ( 
    RST     : in  std_logic;
    WRCLK   : in  std_logic;
    CLKOSX  : in  std_logic;
    WREN    : in  std_logic;
    CTS     : in  std_logic;
    WRCOUNT : out std_logic_vector(10 downto 0);
    RDCOUNT : out std_logic_vector(10 downto 0);
    WRDATA  : in  std_logic_vector(7 downto 0);
    WRRDY   : out std_logic;
    TXD     : out std_logic);
end uart_tx;


----------------------------------------------------------------------------------
-- Architecture
----------------------------------------------------------------------------------

architecture rtl of uart_tx is

  
----------------------------------------------------------------------------------
-- Signals
----------------------------------------------------------------------------------

  type STATE_TYPE is (st0_idle, st1_send_start_bit, st2_send_data_bits, st3_send_stop_bit); 
  
  signal STATE, NEXT_STATE : STATE_TYPE; 
   
  signal FIFO_FULL    : std_logic;
  signal FIFO_EMPTY   : std_logic;
  signal RDEN         : std_logic;
  signal RDDATA       : std_logic_vector(7 downto 0);
--  signal RDCOUNT      : std_logic_vector(10 downto 0);
--  signal WRCOUNT      : std_logic_vector(10 downto 0);
  signal DIVCTR       : std_logic_vector(log2_oversampling-1 downto 0);
  signal DIVPULSE     : std_logic;
  signal BYTECTR      : std_logic_vector(2 downto 0);
  signal BYTECTRINC   : std_logic;
  signal TXDATA       : std_logic;
  signal NEXT_TXDATA  : std_logic;
  
begin

----------------------------------------------------------------------------------
-- Component Instantiation
----------------------------------------------------------------------------------

  -- Dual-Clock First-In, First-Out (FIFO) RAM Buffer
  FIFO_inst : FIFO_DUALCLOCK_MACRO
    generic map (
      DEVICE                  => "VIRTEX6", -- Target Device: "VIRTEX5", "VIRTEX6" 
      ALMOST_FULL_OFFSET      => X"000F",   -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET     => X"000F",   -- Sets the almost empty threshold
      DATA_WIDTH              => 8,         -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE               => "18Kb",    -- Target BRAM, "18Kb" or "36Kb" 
      FIRST_WORD_FALL_THROUGH => FALSE)     -- Sets the FIFO FWFT to TRUE or FALSE
    port map (
      ALMOSTEMPTY => open,                  -- 1-bit output almost empty
      ALMOSTFULL  => FIFO_FULL,             -- 1-bit output almost full
      DO          => RDDATA,                -- Output data, width defined by DATA_WIDTH parameter
      EMPTY       => FIFO_EMPTY,            -- 1-bit output empty
      FULL        => open,                  -- 1-bit output full
      RDCOUNT     => RDCOUNT,               -- Output read count, width determined by FIFO depth
      RDERR       => open,                  -- 1-bit output read error
      WRCOUNT     => WRCOUNT,               -- Output write count, width determined by FIFO depth
      WRERR       => open,                  -- 1-bit output write error
      DI          => WRDATA,                -- Input data, width defined by DATA_WIDTH parameter
      RDCLK       => CLKOSX,                -- 1-bit input read clock
      RDEN        => RDEN,                  -- 1-bit input read enable
      RST         => RST,                   -- 1-bit input reset
      WRCLK       => WRCLK,                 -- 1-bit input write clock
      WREN        => WREN);                 -- 1-bit input write enable


----------------------------------------------------------------------------------
-- Concurrent Statements
----------------------------------------------------------------------------------

  -- Write ready signal for FIFO
  WRRDY <= not FIFO_FULL;

  -- Register for FSM
  sync_proc : process (CLKOSX, RST)
  begin
    if RST = '1' then
      STATE  <= st0_idle;
      TXDATA <= '1';
      TXD    <= '1';
    elsif rising_edge(CLKOSX) then
      STATE  <= NEXT_STATE;
      TXDATA <= NEXT_TXDATA;
      TXD    <= TXDATA;
    end if;
  end process sync_proc;
 
  -- Finite state machine (FSM)
  fsm_proc : process (STATE, TXDATA, CTS, DIVPULSE, FIFO_EMPTY, RDDATA, BYTECTR)
  begin
    -- Default values
    NEXT_STATE  <= STATE;  --default is to stay in current state
    NEXT_TXDATA <= TXDATA;
    RDEN        <= '0';
    BYTECTRINC  <= '0';
    if (DIVPULSE = '1') then
      case STATE is
        when st0_idle =>
          if (FIFO_EMPTY = '0') and (CTS = '0' or not use_handshake) then
            NEXT_STATE  <= st1_send_start_bit;
            NEXT_TXDATA <= '0';
            RDEN        <= '1';
            BYTECTRINC  <= '1';
          end if;
        when st1_send_start_bit =>
          NEXT_STATE  <= st2_send_data_bits;
          NEXT_TXDATA <= RDDATA(conv_integer(BYTECTR));
          BYTECTRINC  <= '1';
        when st2_send_data_bits =>
          NEXT_TXDATA <= RDDATA(conv_integer(BYTECTR));
          if (BYTECTR = "111") then
            NEXT_STATE <= st3_send_stop_bit;
          else
            BYTECTRINC <= '1';
          end if;
        when st3_send_stop_bit =>
          NEXT_STATE  <= st0_idle;
          NEXT_TXDATA <= '1';
        when others => null;
      end case;      
    end if;
  end process fsm_proc;
  
  -- Clock enable pulse
  DIVPULSE <= '1' when (DIVCTR = 2**log2_oversampling-1) else '0';
  
  -- Counter
  ctr_proc : process (CLKOSX, RST)
  begin
    if RST = '1' then
      DIVCTR  <= (others => '0');
      BYTECTR <= (others => '1');
    elsif rising_edge(CLKOSX) then
      DIVCTR <= DIVCTR + 1;
      if BYTECTRINC = '1' then
        BYTECTR <= BYTECTR + 1;
      end if;
    end if;
  end process ctr_proc;

end rtl;
