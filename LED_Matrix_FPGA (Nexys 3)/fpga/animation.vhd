library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.MATH_REAL.ALL;

entity animation is
	port (
	  clk           : in  STD_LOGIC;
	  rst           : in  STD_LOGIC;
	  ram_address   : in  STD_LOGIC_VECTOR ( 8 downto 0);
	  ram_data      : out STD_LOGIC_VECTOR (47 downto 0));
end animation;


architecture rtl of animation is

  constant rgb_res : integer := 24;
  
  signal red1   : std_logic_vector(7 downto 0);
  signal red2   : std_logic_vector(7 downto 0);
  signal green1 : std_logic_vector(7 downto 0);
  signal green2 : std_logic_vector(7 downto 0);
  signal blue1  : std_logic_vector(7 downto 0);
  signal blue2  : std_logic_vector(7 downto 0);

  signal r1 : std_logic_vector(rgb_res-1 downto 0);
  signal r2 : std_logic_vector(rgb_res-1 downto 0);
  signal g1 : std_logic_vector(rgb_res-1 downto 0);
  signal g2 : std_logic_vector(rgb_res-1 downto 0);
  signal b1 : std_logic_vector(rgb_res-1 downto 0);
  signal b2 : std_logic_vector(rgb_res-1 downto 0);

  signal r1_sign : std_logic;
  signal r2_sign : std_logic;
  signal g1_sign : std_logic;
  signal g2_sign : std_logic;
  signal b1_sign : std_logic;
  signal b2_sign : std_logic;

  signal r1_lfsr : std_logic_vector(17 downto 0);
  signal r2_lfsr : std_logic_vector(19 downto 0);
  signal g1_lfsr : std_logic_vector(22 downto 0);
  signal g2_lfsr : std_logic_vector(24 downto 0);
  signal b1_lfsr : std_logic_vector(27 downto 0);
  signal b2_lfsr : std_logic_vector(30 downto 0);

  signal clk_ena : std_logic;
  signal buf_address : std_logic_vector(8 downto 0);
  
begin

  lfsr_proc : process (rst, clk)
  begin
    if rst = '1' then
	   r1_lfsr <= (others => '1');
	   r2_lfsr <= (others => '1');
	   g1_lfsr <= (others => '1');
	   g2_lfsr <= (others => '1');
	   b1_lfsr <= (others => '1');
	   b2_lfsr <= (others => '1');
	 elsif rising_edge(clk) then
	   if clk_ena = '1' then
		  r1_lfsr <= r1_lfsr(16 downto 0) & (r1_lfsr(17) xor r1_lfsr(10));
		  r2_lfsr <= r2_lfsr(18 downto 0) & (r2_lfsr(19) xor r2_lfsr(16));
		  g1_lfsr <= g1_lfsr(21 downto 0) & (g1_lfsr(22) xor g1_lfsr(17));
		  g2_lfsr <= g2_lfsr(23 downto 0) & (g2_lfsr(24) xor g2_lfsr(21));
		  b1_lfsr <= b1_lfsr(26 downto 0) & (b1_lfsr(27) xor b1_lfsr(24));
		  b2_lfsr <= b2_lfsr(29 downto 0) & (b2_lfsr(30) xor b2_lfsr(27));
		end if;
	 end if;
  end process lfsr_proc;

  rgb_proc : process (rst, clk)
  begin
    if rst = '1' then
	   r1 <= (others => '0');
	   r2 <= (others => '0');
	   g1 <= (others => '0');
	   g2 <= (others => '0');
	   b1 <= (others => '0');
	   b2 <= (others => '0');
		r1_sign <= '1';
		r2_sign <= '1';
		g1_sign <= '1';
		g2_sign <= '1';
		b1_sign <= '1';
		b2_sign <= '1';
	 elsif rising_edge(clk) then
	   if clk_ena = '1' then
		  if (r1_lfsr(1 downto 0) = 0) then 
		    if (r1_sign = '1') then r1 <= r1 + 1; 
			 else r1 <= r1 - 1; end if;
		  end if;
		  if (r1 = 2**rgb_res-2) then r1_sign <= '0';
		  elsif (r1 = 1) then r1_sign <= '1'; end if;
		  if (r2_lfsr(6 downto 0) = 0) then 
		    if (r2_sign = '1') then r2 <= r2 + 1; 
			 else r2 <= r2 - 1; end if;
		  end if;
		  if (r2 = 2**rgb_res-2) then r2_sign <= '0';
		  elsif (r2 = 1) then r2_sign <= '1'; end if;
		  if (g1_lfsr(5 downto 0) = 0) then 
		    if (g1_sign = '1') then g1 <= g1 + 1; 
			 else g1 <= g1 - 1; end if;
		  end if;
		  if (g1 = 2**rgb_res-2) then g1_sign <= '0';
		  elsif (g1 = 1) then g1_sign <= '1'; end if;
		  if (g2_lfsr(1 downto 0) = 0) then 
		    if (g2_sign = '1') then g2 <= g2 + 1; 
			 else g2 <= g2 - 1; end if;
		  end if;
		  if (g2 = 2**rgb_res-2) then g2_sign <= '0';
		  elsif (g2 = 1) then g2_sign <= '1'; end if;
		  if (b1_lfsr(4 downto 0) = 0) then 
		    if (b1_sign = '1') then b1 <= b1 + 1; 
			 else b1 <= b1 - 1; end if;
		  end if;
		  if (b1 = 2**rgb_res-2) then b1_sign <= '0';
		  elsif (b1 = 1) then b1_sign <= '1'; end if;
		  if (b2_lfsr(2 downto 0) = 0) then 
		    if (b2_sign = '1') then b2 <= b2 + 1; 
			 else b2 <= b2 - 1; end if;
		  end if;
		  if (b2 = 2**rgb_res-2) then b2_sign <= '0';
		  elsif (b2 = 1) then b2_sign <= '1'; end if;
		end if;
	 end if;
  end process rgb_proc;

  -- Clock enable
  ena_proc : process (clk)
  begin
    if rising_edge(clk) then
	   buf_address <= ram_address;
      if buf_address = ram_address then
		  clk_ena <= '0';
	   else
		  clk_ena <= '1';
		end if;
	 end if;
  end process ena_proc;

  red1   <= r1(rgb_res-1 downto rgb_res-8);
  red2   <= r2(rgb_res-1 downto rgb_res-8);
  green1 <= g1(rgb_res-1 downto rgb_res-8);
  green2 <= g2(rgb_res-1 downto rgb_res-8);
  blue1  <= b1(rgb_res-1 downto rgb_res-8);
  blue2  <= b2(rgb_res-1 downto rgb_res-8);
  
  ram_data <= blue2 & green2 & red2 & blue1 & green1 & red1;
  
end rtl;
