library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decoders is
  Port (
    sel  : in  std_logic_vector(1 downto 0);
    data : in  std_logic_vector(3 downto 0);
    seg  : out std_logic_vector(6 downto 0); -- Low level active
    an   : out std_logic_vector(3 downto 0)  -- Low level active
  );
end decoders;

architecture Behavioral of decoders is
begin
  process(sel)
  begin
    case sel is
      when "00" =>
        seg <= "0000010";
        an  <= "0001";
      when "01" =>
        seg <= "0000100";
        an  <= "0010";
      when "10" =>
        seg <= "0001000";
        an  <= "0100";
      when others =>
        seg <= "1000000";
        an  <= "1000";
    end case;
  end process;
  
  process(data)
  begin
    case data is
      when "0000" =>
        seg <= "1111110";
      when "0001" =>
        seg <= "0110000";
      when "0010" =>
        seg <= "1101101";
      when "0011" =>
        seg <= "1111001";
      when "0100" =>
        seg <= "0110011";
      when "0101" =>
        seg <= "1011011";
      when "0110" =>
        seg <= "0001111";
      when "0111" =>
        seg <= "1110000";
      when "1000" =>
        seg <= "1111111";
      when "1001" =>
        seg <= "1110011";
      when others =>
        seg <= "0000000";  -- Default to all segments off
    end case;
  end process;


end Behavioral;
