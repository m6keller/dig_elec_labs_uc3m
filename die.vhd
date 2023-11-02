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
    -- Signal declarations
    signal CounterEnable : std_logic := '0'; -- Signal to control counter enable
    signal CounterValue : std_logic_vector(3 downto 0) := "0000"; -- Signal to store counter value

    -- Include any other signal declarations and components here

    -- Instantiate the display logic
    component display_logic is
        port (
            sel: in unsigned(1 downto 0);
            data: in std_logic_vector(3 downto 0);
            seg: out std_logic_vector(6 downto 0);
            an: out std_logic_vector(3 downto 0)
        );
    end component;

begin
    -- Counter instantiation
    counter_instance: entity work.counter
        port map (
            Clk => Clk,               -- Connect to the same clock signal
            Enable => CounterEnable,  -- Connect to the counter enable signal
            Count => CounterValue     -- Connect to the output of the counter
        );

    -- Display logic instantiation
    display_instance: display_logic
        port map (
            sel => sel,
            data => CounterValue,  -- Connect CounterValue to the display data input
            seg => seg,
            an => an
        );

    -- Add any other component instantiations and connections here

    -- Enable control logic
    process (Reset, Clk, Enable)
    begin
        if Reset = '1' then
            CounterEnable <= '0'; -- Reset the enable signal on reset
        elsif clk’EVENT AND clk = ‘1’  then
            -- Control the enable signal based on the central button (BTNC)
            if Enable = '1' then
                CounterEnable <= '1'; -- Enable the counter
            else
                CounterEnable <= '0'; -- Disable the counter
            end if;
        end if;
    end process;

    -- Add any other VHDL logic for the die entity

end Behavioral;
