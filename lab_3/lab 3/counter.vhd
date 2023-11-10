library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
    Generic (
        MAX_COUNT : natural;
        OUT_MAX : std_logic_vector(3 downto 0) := "1001"
    );
    Port ( 
        Clk : in STD_LOGIC;
        Reset : in STD_LOGIC;
        Enable : in STD_LOGIC;
        Count : out STD_LOGIC_VECTOR(3 downto 0);
        CarryOut : out STD_LOGIC
    );
end counter;

architecture Behavioral of counter is
    signal count_reg : unsigned(3 downto 0) := "0000";
    signal timer_count : natural range 0 to 999999 := 0;
    signal timer_output : std_logic := '0';
    signal carry_out : std_logic := '0';
begin

       
       CarryOut <= '1' when count_reg = unsigned(OUT_MAX) and Enable = '1' else '0';
    
  process (Clk, Reset)
   begin

       if Reset = '1' then
            count_reg <= "0000";
           elsif rising_edge(Clk) then
              if Enable = '1' then 
                     count_reg <= count_reg + 1;
                        if count_reg = unsigned(OUT_MAX) then
--                            carry_out <= '1';
                            count_reg <= "0000";
--                        else
--                            count_reg <= count_reg + 1;
----                            carry_out <= '0';
                        end if;
                       
--                        CarryOut <= carry_out;

           end if;
       end if;
 

   end process;
 Count <= std_logic_vector(count_reg);
end Behavioral;