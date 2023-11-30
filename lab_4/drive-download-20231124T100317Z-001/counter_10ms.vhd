library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_10ms is
    Port ( 
        Clk : in STD_LOGIC;
        Reset : in STD_LOGIC;
        Enable : in STD_LOGIC;
        CarryOut : out STD_LOGIC
    );
end counter_10ms;

architecture Behavioral of counter_10ms is
    signal timer_count : natural range 0 to 99 := 0;
    signal carry_out : std_logic := '0';
begin

       

  process (Clk, Reset)
   begin
       if Reset = '1' then
            timer_count <= 0;
           elsif rising_edge(Clk) then
              if Enable = '1' then 
                 if timer_count = 99 then
                            carry_out <= '1';
                             timer_count <= 0;
                         else
                            timer_count <= timer_count + 1;
                            carry_out <= '0';
                        end if;
                        CarryOut <= carry_out;
               end if;
           end if;
   end process;
   
 
 
end Behavioral;