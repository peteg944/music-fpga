

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fpga_top is
    Port ( clk           : in  STD_LOGIC;
           led           : out STD_LOGIC;
           bluetooth_rxd : out STD_LOGIC;
           bluetooth_txd : in  STD_LOGIC;
           display_rgb1  : out STD_LOGIC_VECTOR (2 downto 0);
           display_rgb2  : out STD_LOGIC_VECTOR (2 downto 0);
           display_addr  : out STD_LOGIC_VECTOR (3 downto 0);
           display_clk   : out STD_LOGIC;
           display_oe    : out STD_LOGIC;
           display_lat   : out STD_LOGIC;
           usb_rxd       : out STD_LOGIC;
           usb_txd       : in  STD_LOGIC;
			  height        : in  STD_LOGIC_VECTOR (3 downto 0);
			  mode			 : in  STD_LOGIC;
			  on_off			 : in  STD_LOGIC;
			  sysclk			 : in  STD_LOGIC;
			  pll_locked    : in  STD_LOGIC;
			  xn_index		 : in  STD_LOGIC_VECTOR (7 downto 0)
			  );
end fpga_top;


architecture rtl of fpga_top is

--component pll
--	port
--	 (-- Clock in ports
--	  CLK_IN           : in     std_logic;
--	  -- Clock out ports
--	  CLK_OUT1          : out    std_logic;
--	  CLK_OUT2          : out    std_logic;
--	  -- Status and control signals
--	  RESET             : in     std_logic;
--	  LOCKED            : out    std_logic
--	 );
--end component;

component uart_rx
  generic (
   log2_oversampling : integer := 7);
  port ( 
    RST      : in  std_logic;
    RDCLK    : in  std_logic;
    CLKOSX   : in  std_logic;
    RXD      : in  std_logic;
    RDADDR   : in  std_logic_vector(8 downto 0);
    RDDATA   : out std_logic_vector(47 downto 0);
	 FRAMESEL : out std_logic);
end component;

component display_control
	port (
	  clk           : in  STD_LOGIC;
	  rst           : in  STD_LOGIC;
	  display_ena   : in  STD_LOGIC;
	  ram_data      : in  STD_LOGIC_VECTOR (47 downto 0);
	  ram_address   : out STD_LOGIC_VECTOR ( 8 downto 0);
	  display_rgb1  : out STD_LOGIC_VECTOR ( 2 downto 0);
	  display_rgb2  : out STD_LOGIC_VECTOR ( 2 downto 0);
	  display_addr  : out STD_LOGIC_VECTOR ( 3 downto 0);
	  display_clk   : out STD_LOGIC;
	  display_oe    : out STD_LOGIC;
	  display_lat   : out STD_LOGIC);
end component;

component animationV
	port (
	  clk           : in  STD_LOGIC;
	  rst           : in  STD_LOGIC;
	  height			 : in  STD_LOGIC_VECTOR ( 3 downto 0);
	  ram_address   : in  STD_LOGIC_VECTOR ( 8 downto 0);
	  ram_data      : out STD_LOGIC_VECTOR (47 downto 0);
	  mode			 : in STD_LOGIC;
	  xn_index		 : in STD_LOGIC_VECTOR (7 downto 0);
	  on_off			 : in STD_LOGIC);
end component;

--signal sysclk     : std_logic;
signal uart_clk   : std_logic;
--signal pll_locked : std_logic;
signal rst        : std_logic;

signal rgb_addr  : std_logic_vector(8 downto 0);
signal rgb_data  : std_logic_vector(47 downto 0);
signal rgb_frame : std_logic;

signal uart_active : std_logic;
signal uart_data   : std_logic_vector(47 downto 0);
signal anim_data   : std_logic_vector(47 downto 0);

signal gnd0 : std_logic := '0';
signal vcc0 : std_logic := '1';
--signal height : std_logic_vector(3 downto 0) := "0011";

begin

--led <= pll_locked and rgb_frame;
rst <= not pll_locked;

bluetooth_rxd <= '1';
usb_rxd <= '1';

--pll_inst : pll
--  port map
--   (-- Clock in ports
--    CLK_IN => clk,
--    -- Clock out ports
--    CLK_OUT1 => sysclk,
--    CLK_OUT2 => uart_clk,
--    -- Status and control signals
--    RESET  => gnd0,
--    LOCKED => pll_locked);

rx_i : uart_rx
  generic map (
   log2_oversampling => 7)
  port map ( 
    RST      => rst,
    RDCLK    => sysclk,
    CLKOSX   => uart_clk,
    --RXD      => bluetooth_txd,
    RXD      => usb_txd,
    RDADDR   => rgb_addr,
    RDDATA   => uart_data,
	 FRAMESEL => rgb_frame);

disp_i : display_control
	port map (
	  clk           => sysclk,
	  rst           => rst,
	  display_ena   => vcc0,
	  ram_data      => rgb_data,
	  ram_address   => rgb_addr,
	  display_rgb1  => display_rgb1,
	  display_rgb2  => display_rgb2,
	  display_addr  => display_addr,
	  display_clk   => display_clk,
	  display_oe    => display_oe,
	  display_lat   => display_lat);

anim_i : animationV
	port map (
	  clk           => sysclk,
	  rst           => rst,
	  height 		 => height, 
	  ram_address   => rgb_addr,
	  ram_data      => anim_data,
	  mode			 => mode,
	  xn_index		 => xn_index,
	  on_off			 => on_off);

  --rgb_data <= uart_data when (uart_active = '1') else anim_data;
  rgb_data <= anim_data;
  
uart_proc : process (rst, sysclk)
begin
  if rst = '1' then
    uart_active <= '1';
  elsif rising_edge(sysclk) then
    if rgb_frame = '0' then
	   uart_active <= '1';
    end if;
  end if;
end process uart_proc;

end rtl;
