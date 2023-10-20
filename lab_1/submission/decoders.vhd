----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.10.2023 09:19:32
-- Design Name: 
-- Module Name: decoders - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoders is
    Port ( sel : in STD_LOGIC_VECTOR (1 downto 0);
           data : in STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end decoders;

architecture Behavioral of decoders is

begin
  process(sel)
  begin
    case sel is
      when "00" =>
        an  <= "1110";
      when "01" =>
        an  <= "1101";
      when "10" =>
        an  <= "1011";
      when others =>
        an  <= "0111";
    end case;
  end process;
  
  process(data)
  begin
    case data is
      when "0000" =>
        seg <= "0000001";
      when "0001" =>
        seg <= "1001111";
      when "0010" =>
        seg <= "0010010";
      when "0011" =>
        seg <= "0000110";
      when "0100" =>
        seg <= "1001100";
      when "0101" =>
        seg <= "0100100";
      when "0110" =>
        seg <= "1100000";
      when "0111" =>
        seg <= "0001111";
      when "1000" =>
        seg <= "0000000";
      when "1001" =>
        seg <= "0001100";
      when others =>
        seg <= "1111111";  -- Default to all segments off
    end case;
  end process;

end Behavioral;
