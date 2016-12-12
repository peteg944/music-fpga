----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:16:23 09/05/2013 
-- Design Name: 
-- Module Name:    bram - syn 
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bram is
    generic (
		 addr_res : integer := 8;
		 d_res    : integer := 32);
	 port (
		 RCLK  : in  std_logic;
		 WCLK  : in  std_logic;
		 WE    : in  std_logic;
		 ADDRI : in  std_logic_vector(addr_res-1 downto 0);
		 ADDRO : in  std_logic_vector(addr_res-1 downto 0);
		 DI    : in  std_logic_vector(d_res-1 downto 0);
		 DO    : out std_logic_vector(d_res-1 downto 0));
end bram;

architecture syn of bram is

  type ram_type is array (2**addr_res-1 downto 0) of std_logic_vector (d_res-1 downto 0);

  function init_ram (a, d : integer) return ram_type is
    variable ram : ram_type;
	 variable x : integer;
  begin
    for x in 0 to 2**a-1 loop
	   ram(x) := conv_std_logic_vector((x*(2**(d+1))/(2**(a-1))) mod (2**a), d);
		--ram(x) := (others => '1');
	 end loop;
	 return ram;
  end function;

  signal RAM : ram_type := init_ram(addr_res, d_res);

begin

    process (WCLK)
    begin
       if rising_edge(WCLK) then
         if WE = '1' then
           RAM(conv_integer(ADDRI)) <= DI;
         end if;
		end if;
    end process;

    process (RCLK)
    begin
       if rising_edge(RCLK) then
         DO <= RAM(conv_integer(ADDRO));
       end if;
    end process;

end syn;
