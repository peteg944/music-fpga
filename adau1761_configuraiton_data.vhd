----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz<
-- 
-- Module Name:    adau1761_configuraiton_data - Behavioral 
-- Description: A script for the I3C2, which sends out I2c transactions to configure
--              the ADAU1761 codec.
--
-- See i3c2program for original source for script
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adau1761_configuraiton_data is
Port ( clk : in  STD_LOGIC;
           address : in  STD_LOGIC_VECTOR (9 downto 0);
           data : out  STD_LOGIC_VECTOR (8 downto 0));
end adau1761_configuraiton_data;

architecture Behavioral of adau1761_configuraiton_data is

begin
process(clk)
   begin
      if rising_edge(clk) then
         case address is
           when "0000000000" => data <= "011101111";-- delay for a while (~64ms)
           when "0000000001" => data <= "101110110";-- send 0x76 (write to reg)
           when "0000000010" => data <= "101000000";--  0x40
           when "0000000011" => data <= "100000000";--  0x00 (R0)
           when "0000000100" => data <= "100001110";--  0x0E (turn off PLL)
           when "0000000101" => data <= "011111111";-- STOP
           when "0000000110" => data <= "101110110";-- send 0x76
           when "0000000111" => data <= "101000000";--  0x40
           when "0000001000" => data <= "100000010";--  0x02 (R1)
           when "0000001001" => data <= "100000000";--  0x00 (denominator MSB)
           when "0000001010" => data <= "101111101";--  0x7D (denominator LSB -- 125)
           when "0000001011" => data <= "100000000";--  0x00 (numerator MSB)
           when "0000001100" => data <= "100001100";--  0x0C (numerator LSB -- 12)
           when "0000001101" => data <= "100100011";--  0x23 (PLL integer setting 4, input clock divider 4, fractional mode)
           when "0000001110" => data <= "100000001";--  0x01 (PLL enable)
           when "0000001111" => data <= "011111111";-- STOP
           when "0000010000" => data <= "011101111";-- delay for a while
           when "0000010001" => data <= "101110110";-- send 0x76
           when "0000010010" => data <= "101000000";--  0x40
           when "0000010011" => data <= "100000000";--  0x00 (R0)
           when "0000010100" => data <= "100001111";--  0x0F (core enable)
           when "0000010101" => data <= "011111111";-- STOP
           when "0000010110" => data <= "011101111";-- delay for a while
           when "0000010111" => data <= "101110110";-- send 0x76
           when "0000011000" => data <= "101000000";--  0x40
           when "0000011001" => data <= "100010101";--  0x15 (R15)
           when "0000011010" => data <= "100000001";--  0x01 (become I2S master)
           when "0000011011" => data <= "011111111";-- STOP
           when "0000011100" => data <= "101110110";-- send 0x76
           when "0000011101" => data <= "101000000";--  0x40
           when "0000011110" => data <= "100001010";--  0x0A (R4)
           when "0000011111" => data <= "100000001";--  0x01 (enable record mixer left)
           when "0000100000" => data <= "011111111";-- STOP
           when "0000100001" => data <= "101110110";-- send 0x76
           when "0000100010" => data <= "101000000";--  0x40
           when "0000100011" => data <= "100001011";--  0x0B (R5)
           when "0000100100" => data <= "100000101";--  0x05 (set record mixer left gain to 0dB)
           when "0000100101" => data <= "011111111";-- STOP
           when "0000100110" => data <= "101110110";-- send 0x76
           when "0000100111" => data <= "101000000";--  0x40
           when "0000101000" => data <= "100001100";--  0x0C (R6)
           when "0000101001" => data <= "100000001";--  0x01 (enable record mixer right)
           when "0000101010" => data <= "011111111";-- STOP
           when "0000101011" => data <= "101110110";-- send 0x76
           when "0000101100" => data <= "101000000";--  0x40
           when "0000101101" => data <= "100001101";--  0x0D (R7)
           when "0000101110" => data <= "100000101";--  0x05 (set record mixer right gain to 0dB)
           when "0000101111" => data <= "011111111";-- STOP
           when "0000110000" => data <= "101110110";-- send 0x76
           when "0000110001" => data <= "101000000";--  0x40
           when "0000110010" => data <= "100011100";--  0x1C (R22)
           when "0000110011" => data <= "100100001";--  0x21 (enable playback mixer left and un-mute left DAC input to this mixer)
           when "0000110100" => data <= "011111111";-- STOP
           when "0000110101" => data <= "101110110";-- send 0x76
           when "0000110110" => data <= "101000000";--  0x40
           when "0000110111" => data <= "100011110";--  0x1E (R23)
           when "0000111000" => data <= "101000001";--  0x41 (enable playback mixer right and un-mute right DAC input to this mixer)
           when "0000111001" => data <= "011111111";-- STOP
           when "0000111010" => data <= "101110110";-- send 0x76
           when "0000111011" => data <= "101000000";--  0x40
           when "0000111100" => data <= "100100011";--  0x23 (R29)
           when "0000111101" => data <= "111100111";--  0xE7 (set headphone playback left volume to 0dB, un-mute, enable)
           when "0000111110" => data <= "011111111";-- STOP
           when "0000111111" => data <= "101110110";-- send 0x76
           when "0001000000" => data <= "101000000";--  0x40
           when "0001000001" => data <= "100100100";--  0x24 (R30)
           when "0001000010" => data <= "111100111";--  0xE7 (set headphone playback right volume to 0dB, un-mute, enable)
           when "0001000011" => data <= "011111111";-- STOP
           when "0001000100" => data <= "101110110";-- send 0x76
           when "0001000101" => data <= "101000000";--  0x40
           when "0001000110" => data <= "100100101";--  0x25 (R31)
           when "0001000111" => data <= "111100111";--  0xE7 (set line-out playback left volume to 0dB, un-mute, **headphone mode**, so use 0xE6 for line-out)
           when "0001001000" => data <= "011111111";-- STOP
           when "0001001001" => data <= "101110110";-- send 0x76
           when "0001001010" => data <= "101000000";--  0x40
           when "0001001011" => data <= "100100110";--  0x26 (R32)
           when "0001001100" => data <= "111100111";--  0xE7 (set line-out playback right volume to 0dB, un-mute, **headphone mode**, so use 0xE6 for line-out)
           when "0001001101" => data <= "011111111";-- STOP
           when "0001001110" => data <= "101110110";-- send 0x76
           when "0001001111" => data <= "101000000";--  0x40
           when "0001010000" => data <= "100011001";--  0x19 (R19)
           when "0001010001" => data <= "100000011";--  0x03 (enable both left and right ADCs)
           when "0001010010" => data <= "011111111";-- STOP
           when "0001010011" => data <= "101110110";-- send 0x76
           when "0001010100" => data <= "101000000";--  0x40
           when "0001010101" => data <= "100101001";--  0x29 (R35)
           when "0001010110" => data <= "100000011";--  0x03 (enable playback for left and right channels)
           when "0001010111" => data <= "011111111";-- STOP
           when "0001011000" => data <= "101110110";-- send 0x76
           when "0001011001" => data <= "101000000";--  0x40
           when "0001011010" => data <= "100101010";--  0x2A (R36)
           when "0001011011" => data <= "100000011";--  0x03 (enable both left and right DACs)
           when "0001011100" => data <= "011111111";-- STOP
           when "0001011101" => data <= "101110110";-- send 0x76
           when "0001011110" => data <= "101000000";--  0x40
           when "0001011111" => data <= "111110010";--  0xF2 (R58)
           when "0001100000" => data <= "100000001";--  0x01 (set serial input data routing to: [L0,R0] -> DACs[L,R]
           when "0001100001" => data <= "011111111";-- STOP
           when "0001100010" => data <= "101110110";-- send 0x76
           when "0001100011" => data <= "101000000";--  0x40
           when "0001100100" => data <= "111110011";--  0xF3 (R59)
           when "0001100101" => data <= "100000001";--  0x01 (set serial output data routing to: ADCs[L,R] -> [L0,R0]
           when "0001100110" => data <= "011111111";-- STOP
           when "0001100111" => data <= "101110110";-- send 0x76
           when "0001101000" => data <= "101000000";--  0x40
           when "0001101001" => data <= "111111001";--  0xF9 (R65)
           when "0001101010" => data <= "101111111";--  0x7F (power up all modules of chip)
           when "0001101011" => data <= "011111111";-- STOP
           when "0001101100" => data <= "101110110";-- send 0x76
           when "0001101101" => data <= "101000000";--  0x40
           when "0001101110" => data <= "111111010";--  0xFA (R66)
           when "0001101111" => data <= "100000011";--  0x03 (enable DCOs 0 and 1, digital clock generators)
           when "0001110000" => data <= "011111111";-- STOP
           when "0001110001" => data <= "011111110";-- nop
           when "0001110010" => data <= "011111110";-- nop
           when "0001110011" => data <= "011111110";-- nop
           when "0001110100" => data <= "011111110";-- nop
           when "0001110101" => data <= "011111110";-- nop
           when "0001110110" => data <= "011111110";-- nop
           when "0001110111" => data <= "011111110";-- nop
           when "0001111000" => data <= "011101111";-- delay for a while
           when "0001111001" => data <= "000001111";-- jump to previous line
           when others => data <= (others =>'0');
        end case;
      end if;
   end process;
end Behavioral;

