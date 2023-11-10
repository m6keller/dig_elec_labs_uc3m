library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity die is
    port (
        Reset: in std_logic;
        Clk: in std_logic;
        Enable: in std_logic;
--        sel: in unsigned(1 downto 0);
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
    signal timer_count : natural range 0 to 999999 := 0;
    signal millisecondEnable : STD_LOGIC := '0';
begin
process (Clk, Reset)
   begin

       if Reset = '1' then
            timer_count <= 0;
           elsif rising_edge(Clk) then
              timer_count <= timer_count + 1;
               if timer_count = 99999 then
                  timer_count  <= 0;
                end if;
           end if;
end process;

millisecondEnable <= '1' when timer_count = 99999 else '0';

    counter_instance_ms: counter
        generic map (
            MAX_COUNT => 9,
            OUT_MAX => "1001"
        )
        port map (
            Clk => Clk,               -- Connect to the same clock signal
            Enable => Enable,
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
          Enable => ThousandthsCarryOut,
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
            Enable => HundredthsCarryOut,
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
            Enable => TenthsCarryOut,
            Reset => Reset,  -- Connect to the counter enable signal
            Count => CounterValueSeconds,     -- Connect to the output of the counter
            CarryOut => SecondsCarryOut
        );


      
      counter_instance_display: counter
         generic map (
          MAX_COUNT => 24999,
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
--  process(Clk)
--  begin
--     HundredthsEnable <= '0';
    
----    if rising_edge(ThousandthsCarryOut) then
--    if ThousandthsCarryOut = '1' then

--        HundredthsEnable <= '1';
--    end if;

--  end process;
  
--  process(Clk)
--  begin
--    TenthsEnable <= '0';
--    if HundredthsCarryOut = '1' and ThousandthsCarryOut = '1' then
--        TenthsEnable <= '1';
--    end if;
    
--  end process;
  
--  process(Clk)
--  begin
--    SecondsEnable <='0';
--    if TenthsCarryOut = '1' and TenthsEnable = '1' then
--        SecondsEnable<='1';
--    end if;
--  end process;
    
--   process(DisplayCounter4Bytes)
--   begin
--   end process;
   
   process(Clk)
   begin
       DisplayCounter <= DisplayCounter4Bytes(1 downto 0);
    case DisplayCounter is
        when "00" => 
            cur_counter <= CounterValueMs;
             an <= "1110";
        when 
            "01" => cur_counter <= CounterValueSeconds;
            an <= "1101";
        when "10" => 
            cur_counter <= CounterValueTenths;
            an  <= "1011";
        when others => 
            cur_counter <= CounterValueHundredths;
            an <= "0111";
    end case;
    
    case cur_counter is
      when "0000" => seg <= "0000001";
      when "0001" => seg <= "1001111";
      when "0010" => seg <= "0010010";
      when "0011" => seg <= "0000110";
      when "0100" => seg <= "1001100";
      when "0101" => seg <= "0100100";
      when "0110" => seg <= "1100000";
      when "0111" => seg <= "0001111";
      when "1000" => seg <= "0000000";
      when "1001" => seg <= "0001100";
      when others => seg <= "1111111";  -- Default to all segments off
      end case;
    end process;
    

end Behavioral;