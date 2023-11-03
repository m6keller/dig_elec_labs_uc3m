library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity die_tb is
end die_tb;

architecture Behavioral of die_tb is
    signal Reset, Clk, Enable : std_logic;
    signal sel : unsigned(1 downto 0);
    signal seg : std_logic_vector(6 downto 0);
    signal an : std_logic_vector(3 downto 0);

begin
    uut: entity work.die
        port map (
            Reset => Reset,
            Clk => Clk,
            Enable => Enable,
            sel => sel,
            seg => seg,
            an => an
        );

    -- Generate clock signal
    process
    begin
        Clk <= '0';
        wait for 1 ns;
        Clk <= '1';
        wait for 1 ns;
    end process;
    
    process
    begin
        sel <= "00";
        wait for 100 ns;
        sel <= "01";
        wait for 100 ns;
        sel <= "10";
        wait for 100 ns;
        sel <= "11";
        wait for 100 ns;
        
    end process;

    -- Generate different signals for enable and reset
    process
    begin
        Reset <= '0';
        Enable <= '1';
        
        wait for 15 ns;
        Enable <= '0';

        wait for 17 ns;
      
    end process;

end Behavioral;
