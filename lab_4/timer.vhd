library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity timer is
    Port ( 
        Clk : in STD_LOGIC;
        Reset : in STD_LOGIC;
        Enable : in STD_LOGIC;
        Overflow : out STD_LOGIC
    );
end timer;

architecture Behavioral of timer is
    signal count_reg : natural range 0 to 999999 := 0;
    signal overflow_signal : std_logic := '0';

begin
    process (Clk, Reset)
    begin
        if Reset = '1' then
            count_reg <= 0;
            overflow_signal <= '0';
        elsif rising_edge(Clk) then
            if count_reg = 999999 then
                count_reg <= 0;
                overflow_signal <= '1';
            else
                count_reg <= count_reg + 1;
                overflow_signal <= '0';
            end if;
        end if;
    end process;

    Overflow <= overflow_signal;
end Behavioral;