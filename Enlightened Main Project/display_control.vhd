library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.MATH_REAL.ALL;

entity display_control is
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
end display_control;


architecture rtl of display_control is

  constant gamma    : real    := 2.8;
  constant wait_max : integer := 3;
  constant wait_res : integer := integer(ceil(log2(real(2*wait_max+1))));
  
  signal pwm_ctr : std_logic_vector(8 downto 0);
  signal pwm_inc : std_logic;
  signal row_inc : std_logic;
  signal col_inc : std_logic;

  signal red1   : std_logic_vector(7 downto 0);
  signal red2   : std_logic_vector(7 downto 0);
  signal green1 : std_logic_vector(7 downto 0);
  signal green2 : std_logic_vector(7 downto 0);
  signal blue1  : std_logic_vector(7 downto 0);
  signal blue2  : std_logic_vector(7 downto 0);

  signal wait_ctr : std_logic_vector(wait_res-1 downto 0);
  signal wait_ena : std_logic;

  --signal address_inc : std_logic;
  signal address_ctr : std_logic_vector(8 downto 0);

  signal next_oe  : std_logic;
  signal disp_oe  : std_logic;
  signal disp_lat : std_logic;
  signal disp_clk : std_logic;
  
  type fsm_type is (st0_idle, st1_clock_high, st2_clk_low, st3_inc_ctr, st4_latch, st5_oe_high, st6_oe_low); 
  signal state, next_state : fsm_type;

begin

	red1_i : entity work.gamma_table
	  generic map (
		 color_res => 8,
		 gamma     => gamma)
	  port map ( 
		 CLK     => clk,
		 val_in  => ram_data(7 downto 0),
		 val_out => red1);

	green1_i : entity work.gamma_table
	  generic map (
		 color_res => 8,
		 gamma     => gamma)
	  port map ( 
		 CLK     => clk,
		 val_in  => ram_data(15 downto 8),
		 val_out => green1);

	blue1_i : entity work.gamma_table
	  generic map (
		 color_res => 8,
		 gamma     => gamma)
	  port map ( 
		 CLK     => clk,
		 val_in  => ram_data(23 downto 16),
		 val_out => blue1);

	red2_i : entity work.gamma_table
	  generic map (
		 color_res => 8,
		 gamma     => gamma)
	  port map ( 
		 CLK     => clk,
		 val_in  => ram_data(31 downto 24),
		 val_out => red2);

	green2_i : entity work.gamma_table
	  generic map (
		 color_res => 8,
		 gamma     => gamma)
	  port map ( 
		 CLK     => clk,
		 val_in  => ram_data(39 downto 32),
		 val_out => green2);

	blue2_i : entity work.gamma_table
	  generic map (
		 color_res => 8,
		 gamma     => gamma)
	  port map ( 
		 CLK     => clk,
		 val_in  => ram_data(47 downto 40),
		 val_out => blue2);

  pwm_proc : process (rst, clk)
  begin
    if rst = '1' then
	   pwm_ctr <= (others => '0');
	 elsif rising_edge(clk) then
	   if pwm_inc = '1' then
		  if pwm_ctr = 256 then
		    pwm_ctr <= (others => '0');
		  else
		    pwm_ctr <= pwm_ctr + 1;
		  end if;
		end if;
	 end if;
  end process pwm_proc;

  wait_proc : process (clk)
  begin
    if rising_edge(clk) then
	   if wait_ena = '0' then
		  wait_ctr <= (others => '0');
		else
		  wait_ctr <= wait_ctr + 1;
		end if;
	 end if;
  end process wait_proc;

  addr_proc : process (rst, clk)
  begin
    if rst = '1' then
	   address_ctr <= (others => '0');
	 elsif rising_edge(clk) then
	   if col_inc = '1' then
		  if (pwm_inc = '1') and (row_inc = '0') then
		    address_ctr <= address_ctr(8 downto 5) & "00000";
		  else
			 address_ctr <= address_ctr + 1;
		  end if;
		end if;
	 end if;
  end process addr_proc;

  -- Display outputs
  display_rgb1(0) <= '1' when (pwm_ctr < ('0' &   red1)) else '0';
  display_rgb1(1) <= '1' when (pwm_ctr < ('0' & green1)) else '0';
  display_rgb1(2) <= '1' when (pwm_ctr < ('0' &  blue1)) else '0';
  display_rgb2(0) <= '1' when (pwm_ctr < ('0' &   red2)) else '0';
  display_rgb2(1) <= '1' when (pwm_ctr < ('0' & green2)) else '0';
  display_rgb2(2) <= '1' when (pwm_ctr < ('0' &  blue2)) else '0';

  ram_address <= address_ctr;

  -- Display latch
  disp_proc : process (clk)
  begin
    if rising_edge(clk) then
	   display_oe  <= disp_oe;
      display_lat <= disp_lat;
	   display_clk <= disp_clk;
		if (disp_oe = '1') and (disp_lat = '1') then
        display_addr <= address_ctr(8 downto 5);
		end if;
	 end if;
  end process disp_proc;


  fsm_proc : process (rst, clk)
  begin
    if rst = '1' then
	   state <= st0_idle;
	   disp_oe  <= '0';
	 elsif rising_edge(clk) then
	   state <= next_state;
	   disp_oe  <= next_oe;
	 end if;
  end process fsm_proc;
  
   next_proc : process (state, display_ena, wait_ctr, address_ctr, pwm_ctr, disp_oe)
   begin
      --declare default state for next_state to avoid latches
      next_state  <= state;  --default is to stay in current state
		next_oe     <= disp_oe;
		row_inc     <= '0';
		col_inc     <= '0';
		pwm_inc     <= '0';
		wait_ena    <= '0';
	   disp_clk    <= '1';
	   disp_lat    <= '0';
      --insert statements to decode next_state
      --below is a simple example
      case (state) is
         when st0_idle =>
            if display_ena = '1' then
               next_state <= st1_clock_high;
            end if;
         when st1_clock_high =>
				if wait_ctr = wait_max then
               next_state <= st2_clk_low;
				else 
				   wait_ena   <= '1';
            end if;
         when st2_clk_low =>
            disp_clk <= '0';
				if wait_ctr = wait_max then
               if address_ctr(4 downto 0) = 31 then
						if pwm_ctr = 0 then
						  next_state <= st5_oe_high;
						else
						  next_state <= st4_latch;
						end if;
					else
						next_state <= st3_inc_ctr;
					end if;
				else 
				   wait_ena <= '1';
            end if;
			when st3_inc_ctr =>
				wait_ena <= '1';
				col_inc  <= '1';
				if address_ctr(4 downto 0) = 31 then
					pwm_inc <= '1';
				end if;
				if pwm_ctr = 256 then
					row_inc <= '1';
				end if;
				if disp_oe = '1' then
				  next_state <= st6_oe_low;
				else
				  next_state <= st1_clock_high;
				end if;
			when st4_latch =>
				disp_lat <= '1';
				if wait_ctr = 2*wait_max then
              next_state <= st3_inc_ctr;
				else 
				   wait_ena <= '1';
            end if;
			when st5_oe_high =>
				next_oe <= '1';
				if wait_ctr = 2*wait_max then
              next_state <= st4_latch;
				else 
				   wait_ena <= '1';
            end if;
			when st6_oe_low =>
				if wait_ctr = 2*wait_max then
				  next_oe <= '0';
              next_state <= st1_clock_high;
				else 
				   wait_ena <= '1';
            end if;
      end case;      
   end process next_proc;

end rtl;
