library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
    Port ( 
        Clk : in STD_LOGIC;
        Reset : in STD_LOGIC;
        Enable : in STD_LOGIC;
        Count : out STD_LOGIC_VECTOR(3 downto 0)
    );
end counter;

architecture Behavioral of counter is
    signal count_reg : unsigned(3 downto 0) := "0000";
    signal timer_count : natural range 0 to 99999 := 0;
    signal timer_output : std_logic := '0';
begin
  process (Clk, Reset)
   begin
       if Reset = '1' then
            timer_count <= 0;
       --if Enable = '1' then 
           elsif rising_edge(Clk) then
               timer_count <= timer_count + 1;
               if timer_count = 99999 then
                   timer_output <= '1';
                   
               elsif timer_count = 1000000 then
                   timer_output <= '0';
                   timer_count  <= 0;
               end if;
           --end if;
       end if;
   end process;
 
 
    process (Clk, Reset)
    begin
        if Reset = '1' then
            count_reg <= "0000";
         elsif rising_edge(Clk) then
            if Enable = '1' then
                if timer_output = '1' then
                    if count_reg = "1001" then
                        count_reg <= "0000";
                    else
                        count_reg <= count_reg + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    Count <= std_logic_vector(count_reg);

end Behavioral;
