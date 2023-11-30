library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reflejos_tb is
end reflejos_tb;

architecture Behavioral of reflejos_tb is
    signal Reset, Clk, Enable : std_logic;
    signal seg : std_logic_vector(6 downto 0);
    signal an : std_logic_vector(3 downto 0);

begin
    uut: entity work.reflejos
        port map (
            Reset => Reset,
            Clk => Clk,
            Enable => Enable,
            seg => seg,
            an => an
        );

    -- Generate clock signal
    process
    begin
--        Enable <= '1';
        Clk <= '0';
        wait for 5 ns;
        Clk <= '1';
        wait for 5 ns;
    end process;

    -- Stimulus process
    process
    begin
        Reset <= '0';
        wait for 10 ns;
        Reset <= '1';
        wait for 10 ns;

        -- Test case 1: Button press
        wait for 10 ns;
        Reset <= '0';
        wait for 10 ns;
        -- You can add more test cases or iterations here as needed
        
          -- Test case 2: Another button press after reaction time measurement
        Enable <= '1';
        wait for 10 ns;
        Enable <= '0';
        wait for 10 ns;
        Enable <= '1';
        wait for 50 ns;
        
        
        Enable <= '1';
        wait for 10 ns;
        Enable <= '0';
        wait for 10 ns;
        Enable <= '1';
        wait for 50 ns;
        
        Enable <= '1';
        wait for 10 ns;
        Enable <= '0';
        wait for 10 ns;
        Enable <= '1';
        wait for 50 ns;
        
         Enable <= '1';
               wait for 10 ns;
               Enable <= '0';
               wait for 10 ns;
               Enable <= '1';
               wait for 50 ns;
               
                Enable <= '1';
                      wait for 10 ns;
                      Enable <= '0';
                      wait for 10 ns;
                      Enable <= '1';
                      wait for 1100 ms;
        
        

        -- Add more test cases or iterations as needed
        -- Ensure to include scenarios for edge cases and different system states
    end process;

end Behavioral;