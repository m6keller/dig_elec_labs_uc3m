library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity die is
    port (
        Reset: in std_logic;
        Clk: in std_logic;
        Enable: in std_logic;
        sel: in unsigned(1 downto 0);
        seg: out std_logic_vector(6 downto 0); -- Low level active
        an: out std_logic_vector(3 downto 0) -- Low level active
    );
end die;

architecture Behavioral of die is
    signal CounterEnable : std_logic := '0'; -- Signal to control counter enable
    signal CounterValue : std_logic_vector(3 downto 0); -- Signal to store counter value

    -- Other signal declarations and components (e.g., timer, decoders)

begin
    -- Counter instantiation
    counter_instance: entity work.counter
        port map (
            Clk => Clk,                 -- Connect to the same clock signal
            Enable => CounterEnable,    -- Connect to the counter enable signal
            Count => CounterValue       -- Connect to the output of the counter
        );

    -- Timer logic to generate a 1 ms enable signal
    process (Clk)
    begin
        -- Implement timer logic to generate a 1 ms enable signal
        -- The timer output should control the CounterEnable signal
    end process;

    -- Display logic (connecting CounterValue to the 7-segment display)

    -- Other VHDL logic for the die entity

end Behavioral;
