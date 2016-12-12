library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity uart_rx is
  generic (
   log2_oversampling : integer := 4);
  port ( 
    RST      : in  std_logic;
    RDCLK    : in  std_logic;
    CLKOSX   : in  std_logic;
    RXD      : in  std_logic;
    RDADDR   : in  std_logic_vector(8 downto 0);
    RDDATA   : out std_logic_vector(47 downto 0);
	 FRAMESEL : out std_logic);
end uart_rx;

architecture rtl of uart_rx is

  type STATE_TYPE is (st0_idle, st1_read_start_bit, st2_read_data_bits, st3_read_stop_bit); 
  
  signal STATE, NEXT_STATE : STATE_TYPE; 
   
  signal WREN         : std_logic;
  signal WRRST        : std_logic;
  signal WRDATA       : std_logic_vector(7 downto 0);
--signal WRCOUNT      : std_logic_vector(10 downto 0);
--signal RDCOUNT      : std_logic_vector(10 downto 0);
  signal DIVCTR       : std_logic_vector(log2_oversampling-1 downto 0);
  signal DIVCTREN     : std_logic;
  signal BYTECTR      : std_logic_vector(2 downto 0);
  signal BYTECTRINC   : std_logic;
  signal RXDATA       : std_logic;
  signal NEXT_WRDATA  : std_logic_vector(7 downto 0);
  
  signal we_red   : std_logic_vector(1 downto 0);
  signal we_green : std_logic_vector(1 downto 0);
  signal we_blue  : std_logic_vector(1 downto 0);
  
  signal rdaddr_ext : std_logic_vector(9 downto 0);
  signal rd_msb     : std_logic;
  
  signal rgb_ctr       : std_logic_vector(1 downto 0);
  signal wr_addr       : std_logic_vector(10 downto 0);
  signal wr_addr_short : std_logic_vector(9 downto 0);
  signal wr_inc        : std_logic;
  
begin

  i_gen : for i in 1 downto 0 generate  
   -- RAM for red color
	ram_red : entity work.bram
    generic map (
		 addr_res => 10,
		 d_res    => 8)
	 port map (
		 RCLK  => RDCLK,
		 WCLK  => CLKOSX,
		 WE    => we_red(i),
		 ADDRI => wr_addr_short,
		 ADDRO => rdaddr_ext,
		 DI    => WRDATA,
		 DO    => RDDATA(i*24+7 downto i*24));

   -- RAM for green color
	ram_green : entity work.bram
    generic map (
		 addr_res => 10,
		 d_res    => 8)
	 port map (
		 RCLK  => RDCLK,
		 WCLK  => CLKOSX,
		 WE    => we_green(i),
		 ADDRI => wr_addr_short,
		 ADDRO => rdaddr_ext,
		 DI    => WRDATA,
		 DO    => RDDATA(i*24+15 downto i*24+8));

   -- RAM for blue color
	ram_blue : entity work.bram
    generic map (
		 addr_res => 10,
		 d_res    => 8)
	 port map (
		 RCLK  => RDCLK,
		 WCLK  => CLKOSX,
		 WE    => we_blue(i),
		 ADDRI => wr_addr_short,
		 ADDRO => rdaddr_ext,
		 DI    => WRDATA,
		 DO    => RDDATA(i*24+23 downto i*24+16));
  end generate i_gen;

  -- Register for FSM
  sync_proc : process (CLKOSX, RST)
  begin
    if RST = '1' then
      STATE  <= st0_idle;
      WRDATA <= (others => '0');
      RXDATA <= '1';
    elsif rising_edge(CLKOSX) then
      STATE  <= NEXT_STATE;
      WRDATA <= NEXT_WRDATA;
      RXDATA <= RXD;
    end if;
  end process sync_proc;
 
  -- Finite state machine (FSM)
  fsm_proc : process (STATE, RXDATA, WRDATA, DIVCTR, BYTECTR)
  begin
    -- Default values
    NEXT_STATE  <= STATE;  --default is to stay in current state
    NEXT_WRDATA <= WRDATA;
    DIVCTREN    <= '1';
    BYTECTRINC  <= '0';
    WREN        <= '0';
	 WRRST       <= '0';
    case STATE is
      when st0_idle =>
        if (RXDATA = '0') then
          NEXT_STATE <= st1_read_start_bit;
        else
          DIVCTREN <= '0';
        end if;
      when st1_read_start_bit =>
        if DIVCTR(log2_oversampling-1) = '1' then
          NEXT_STATE <= st2_read_data_bits;
          BYTECTRINC <= '1';
          DIVCTREN   <= '0';
        end if;
      when st2_read_data_bits =>
        if (DIVCTR = 2**log2_oversampling-1) then
          NEXT_WRDATA(conv_integer(BYTECTR)) <= RXDATA;
          if (BYTECTR = "111") then
            NEXT_STATE <= st3_read_stop_bit;
          else
            BYTECTRINC <= '1';
          end if;
        end if;
      when st3_read_stop_bit =>
        if (DIVCTR = 2**log2_oversampling-1) then
          NEXT_STATE <= st0_idle;
          if WRDATA = 1 then
			   WREN  <= '0';
			   WRRST <= RXDATA;
          else
			   WREN  <= RXDATA;
			   WRRST <= '0';
		    end if;
        end if;
    end case;      
  end process fsm_proc;
  
  -- Clock divide counter
  div_proc : process (CLKOSX)
  begin
    if rising_edge(CLKOSX) then
      if DIVCTREN = '1' then
        DIVCTR <= DIVCTR + 1;
      else
        DIVCTR <= (others => '0');
      end if;
    end if;
  end process div_proc;

  -- Byte counter
  byte_proc : process (CLKOSX, RST)
  begin
    if RST = '1' then
      BYTECTR <= (others => '1');
    elsif rising_edge(CLKOSX) then
      if BYTECTRINC = '1' then
        BYTECTR <= BYTECTR + 1;
      end if;
    end if;
  end process byte_proc;

  -- RGB color select
  we_red(0)   <= not wr_addr(9) when ((WREN = '1') and (rgb_ctr = "00")) else '0';
  we_green(0) <= not wr_addr(9) when ((WREN = '1') and (rgb_ctr = "01")) else '0';
  we_blue(0)  <= not wr_addr(9) when ((WREN = '1') and (rgb_ctr = "10")) else '0';
  we_red(1)   <= wr_addr(9) when ((WREN = '1') and (rgb_ctr = "00")) else '0';
  we_green(1) <= wr_addr(9) when ((WREN = '1') and (rgb_ctr = "01")) else '0';
  we_blue(1)  <= wr_addr(9) when ((WREN = '1') and (rgb_ctr = "10")) else '0';

  -- RAM control signals
  rgb_proc : process (CLKOSX, RST)
  begin
    if RST = '1' then
      rgb_ctr <= (others => '0');
		wr_addr <= (others => '0');	 
	 elsif rising_edge(CLKOSX) then
      if WRRST = '1' then
        rgb_ctr <= (others => '0');
		  wr_addr(9 downto 0) <= (others => '0');
		elsif WREN = '1' then
        if rgb_ctr = "10" then
		    rgb_ctr <= (others => '0');
		    wr_addr <= wr_addr + 1;
		  else
		    rgb_ctr <= rgb_ctr + 1;
		  end if;
      end if;
    end if;
  end process rgb_proc;


  -- Clock domain crossing 
  rd_proc : process (RDCLK)
  begin
    if rising_edge(RDCLK) then
      rd_msb <= not wr_addr(10);
		FRAMESEL <= rd_msb;
    end if;
  end process rd_proc;

  rdaddr_ext <= rd_msb & RDADDR;
  wr_addr_short <= wr_addr(10) & wr_addr(8 downto 0);

end rtl;
