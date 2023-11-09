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
    signal CounterValueMs : std_logic_vector(3 downto 0) := "0000"; -- Signal to store counter value
    signal CounterValueHundredths : std_logic_vector(3 downto 0) := "0000"; -- Signal to store counter value
    signal CounterValueTenths : std_logic_vector(3 downto 0) := "0000"; -- Signal to store counter value
    signal CounterValueSeconds : std_logic_vector(3 downto 0) := "0000"; -- Signal to store counter value
    
    signal SecondsEnable: std_logic := '0';
    signal TenthsEnable: std_logic := '0';
    signal HundredthsEnable: std_logic := '0';

    
    signal ThousandthsCarryOut: std_logic := '0';
    signal HundredthsCarryOut: std_logic := '0';
    signal TenthsCarryOut: std_logic := '0';
    signal SecondsCarryOut: std_logic := '0';


    signal DisplayCounter4Bytes: std_logic_vector(3 downto 0) := "0000";
    signal DisplayCounter: std_logic_vector(1 downto 0) := "00";

    signal ClkDisplayOut: std_logic := '0';
    signal cur_counter: std_logic_vector(3 downto 0) := "0000";



    component counter is
        generic (
            MAX_COUNT : natural;
            OUT_MAX : std_logic_vector(3 downto 0)

        );
        port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            enable : in STD_LOGIC;
            count : out STD_LOGIC_VECTOR(3 downto 0);
            CarryOut : out STD_LOGIC
        );
    end component;

begin
    counter_instance_ms: counter
        generic map (
            MAX_COUNT => 9,
            OUT_MAX => "1001"
        )
        port map (
            Clk => Clk,               -- Connect to the same clock signal
            Enable => Clk,
            Reset => Reset,  -- Connect to the counter enable signal
            Count => CounterValueMs,     -- Connect to the output of the counter
            CarryOut => ThousandthsCarryOut
        );
    
    counter_instance_hundredths: counter
        generic map (
            MAX_COUNT => 9,
            OUT_MAX => "1001"
        )
        port map (
          Clk => Clk,               -- Connect to the same clock signal
          Enable => HundredthsEnable,
          Reset => Reset,  -- Connect to the counter enable signal
          Count => CounterValueHundredths,     -- Connect to the output of the counter
          CarryOut => HundredthsCarryOut
      );


    counter_instance_tenths: counter
        generic map (
            MAX_COUNT => 9,
            OUT_MAX => "1001"
        )
        port map (
            Clk => Clk,               -- Connect to the same clock signal
            Enable => TenthsEnable,
            Reset => Reset,  -- Connect to the counter enable signal
            Count => CounterValueTenths,     -- Connect to the output of the counter
            CarryOut => TenthsCarryOut
        );

    counter_instance_seconds: counter
        generic map (
            MAX_COUNT => 9,
            OUT_MAX => "1001"
        )
        port map (
            Clk => Clk,               -- Connect to the same clock signal
            Enable => SecondsEnable,
            Reset => Reset,  -- Connect to the counter enable signal
            Count => CounterValueSeconds,     -- Connect to the output of the counter
            CarryOut => SecondsCarryOut
        );


      
      counter_instance_display: counter
         generic map (
          MAX_COUNT => 249,
          OUT_MAX => "0011"
        )
        port map (
          Clk => Clk,               -- Connect to the same clock signal
          Enable => Enable,
          Reset => Reset,  -- Connect to the counter enable signal
          Count => DisplayCounter4Bytes,     -- Connect to the output of the counter
          CarryOut => ClkDisplayOut
      );
      
--    HundredthsEnable <= '1' when rising_edge(ThousandthsCarryOut) else '0';
  process(ThousandthsCarryOut)
  begin
     HundredthsEnable <= '0';
    
    if rising_edge(ThousandthsCarryOut) then
        HundredthsEnable <= '1';
    end if;

  end process;
  
  process(Clk)
  begin
    TenthsEnable <= '0';
    if HundredthsCarryOut = '1' and ThousandthsCarryOut = '1' then
        TenthsEnable <= '1';
    end if;
    
  end process;
  
  process(Clk)
  begin
    SecondsEnable <='0';
    if TenthsCarryOut = '1' and TenthsEnable = '1' then
        SecondsEnable<='1';
    end if;
  end process;
    
   process(DisplayCounter4Bytes)
   begin
        DisplayCounter <= DisplayCounter4Bytes(1 downto 0);
   end process;
   process(ClkDisplayOut)
   begin
    case DisplayCounter is
        when "00" => cur_counter <= CounterValueMs;
        when "01" => cur_counter <= CounterValueSeconds;
        when "10" => cur_counter <= CounterValueTenths;
        when others => cur_counter <= CounterValueHundredths;
    end case;
    case DisplayCounter is
        when "00" => an <= "1110";
        when "01" => an <= "1101";
        when "10" => an  <= "1011";
        when others => an <= "0111";
    end case;
    
    case cur_counter is
      when "0000" => seg <= "1111110";
      when "0001" => seg <= "0110000";
      when "0010" => seg <= "1101101";
      when "0011" => seg <= "1111001";
      when "0100" => seg <= "0110011";
      when "0101" => seg <= "1011011";
      when "0110" => seg <= "0001111";
      when "0111" => seg <= "1110000";
      when "1000" => seg <= "1111111";
      when "1001" => seg <= "1110011";
      when others => seg <= "0000000";  -- Default to all segments off
      end case;
    end process;
    

end Behavioral;

