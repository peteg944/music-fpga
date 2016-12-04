library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.MATH_REAL.ALL;

entity gamma_table is
  generic (
    color_res : natural := 8;
	 gamma     : real    := 1.0);
  port ( 
	 CLK     : in  std_logic;
	 val_in  : in  std_logic_vector(color_res-1 downto 0);
	 val_out : out std_logic_vector(color_res-1 downto 0));
end gamma_table;


architecture rtl of gamma_table is
  
  type LUT_TYPE is array(2**color_res-1 downto 0) of std_logic_vector(color_res-1 downto 0);
  
  function LUT_init (c : integer; g : real) return LUT_TYPE is
    variable lut_var     : LUT_TYPE;
    variable lut_element : integer;
  begin
    for i in 0 to 2**c-1 loop
	   lut_element := integer(real(2**c-1) * ((real(i)/(real(2**c-1)))**g));
	   lut_var(i)  := conv_std_logic_vector(lut_element, c);
	 end loop;
	 return lut_var;
  end LUT_init;
  
  constant gamma_lut : LUT_TYPE := LUT_init(color_res, gamma);

  
begin

  lut_proc : process (CLK)
  begin
    if rising_edge(CLK) then
	   val_out <= gamma_lut(conv_integer(val_in));
	 end if;
  end process lut_proc;
  
end rtl;
