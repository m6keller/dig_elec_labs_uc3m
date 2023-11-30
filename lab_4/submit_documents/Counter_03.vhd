library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Entity to count from 0 to 3 to control the 7-segment display
entity Counter_03 is
    Port ( 
        Clk : in STD_LOGIC;
        Reset : in STD_LOGIC;
        Count : out STD_LOGIC_VECTOR(1 downto 0);
        Enable : in STD_LOGIC
    );
end Counter_03;

architecture Behavioral of Counter_03 is
    signal count_reg : unsigned(1 downto 0) := "00";
begin

  process (Clk, Reset)
   begin
       if Reset = '1' then 
            count_reg <= "00";
           elsif rising_edge(Clk) then
              if Enable = '1' then 
                    if count_reg = "11" then
                count_reg <= "00";
                else
                   count_reg <= count_reg + 1;
                end if;
                   Count <= std_logic_vector(count_reg);
           end if;
       end if;
   end process;
   

end Behavioral;