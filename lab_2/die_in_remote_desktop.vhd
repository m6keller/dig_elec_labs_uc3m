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
    signal CounterValue : std_logic_vector(3 downto 0) := "0000"; -- Signal to store counter value

    component counter is
        port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            count : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

begin
    counter_instance: counter
        port map (
            Clk => Clk,               -- Connect to the same clock signal
            Reset => CounterEnable,  -- Connect to the counter enable signal
            Count => CounterValue     -- Connect to the output of the counter
        );
    process(clk)
    begin
       -- an <= CounterValue;  -- Update to use the CounterValue signal
    end process;
    
    process(sel)
    begin
      case sel is
        when "00" => an <= "1110";
        when "01" => an <= "1101";
        when "10" => an  <= "1011";
        when others => an <= "0111";
    end case;
  end process;
    