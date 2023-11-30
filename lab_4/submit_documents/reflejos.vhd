library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- This entity represents the top-level architecture of the system. 
-- It takes in the clock (Clk) signal, reset (Reset) signal, and button (Enable) signal,
-- and outputs the 7-segment display and the signals (seg) to dictate which display is being controlled (an).
entity reflejos is
  	port (
    	Reset:  in  std_logic;
    	Clk:    in  std_logic;
    	Enable: in  std_logic;
    	an: out std_logic_vector(3 downto 0);
        seg: out std_logic_vector(6 downto 0) -- Low level active an: out std_logic_vector(3 downto 0) -- Low level active
 	);
end reflejos;


architecture Behavioral of reflejos is
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

    signal TimerOverflow : STD_LOGIC := '0';
    signal Clear_out : STD_LOGIC := '0';
    signal Enable_out_out : STD_LOGIC := '0';
    
    signal counter_10_ms_display_carry_out : STD_LOGIC := '0';
    signal sel :  std_logic_vector(1 downto 0) := "00";
    signal data : std_logic_vector(3 downto 0) := "0000"; -- Signal to store counter value
    
    signal timer_count : natural range 0 to 999999 := 0;
    signal millisecondEnable : STD_LOGIC := '0';

    
    component Counter_03 is
        Port ( 
            Clk : in STD_LOGIC;
            Reset : in STD_LOGIC;
            Count : out STD_LOGIC_VECTOR(1 downto 0);
            Enable : in STD_LOGIC
        );
    end component;
    
    
    component counter_10ms is
        Port ( 
            Clk : in STD_LOGIC;
            Reset : in STD_LOGIC;
            Enable : in STD_LOGIC;
            CarryOut : out STD_LOGIC
        );
    end component;

   component EdgeDetector1 is
	Port (
		clk: in STD_LOGIC;
		reset: in STD_LOGIC;
		enable_in: in STD_LOGIC;
		enable_out: out STD_LOGIC
	);
    end component;


    component StateController is
    Port ( 
        -- below are direct inputs into system
        Clk : in STD_LOGIC;
        Reset: in STD_LOGIC;
        Button: in STD_LOGIC; -- this is called "Enable" in the top-level file
        -- below is output from random count
        EoC_rand: in STD_LOGIC;

        clear: out STD_LOGIC; -- whether or not to clear timers
            enable: out STD_LOGIC -- whether or not to enable timer counting 
            );
    end component;

    component timer is
	Port (
		Clk : in STD_LOGIC;
		Enable: in STD_LOGIC;
		Reset : in STD_LOGIC;
		Overflow : out STD_LOGIC
	);
	end component;

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
            CarryOut : out STD_LOGIC;
	Clear : in STD_LOGIC
        );
    end component;

Begin

    -- Base counter to divide clock frequency into milliseconds
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

    -- Enable millisecond counter every 1 millisecond based on frequency of the FPGA
    millisecondEnable <= '1' when timer_count = 99999 else '0';

    -- Counter to represent milliseconds to be displayed
    counter_instance_ms: counter
        generic map (
            MAX_COUNT => 9,
            OUT_MAX => "1001"
        )
        port map (
            Clk => Clk,               -- Connect to the same clock signal
            Enable => counterenable,
            Reset => Reset,  -- Connect to the counter enable signal
            Count => CounterValueMs,     -- Connect to the output of the counter
            CarryOut => ThousandthsCarryOut,
            	Clear => Clear_out

        );

    -- Counter to represent hundredths of a second to be displayed
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
          CarryOut => HundredthsCarryOut,
          	Clear => Clear_out

      );

    -- Counter to represent tenths of a second to be displayed
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
            CarryOut => TenthsCarryOut,
            	Clear => Clear_out

        );

    -- Counter to represent whole of a seconds to be displayed
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
            CarryOut => SecondsCarryOut,
            	Clear => Clear_out

        );



    -- Detect button presses
    Edgedetector_instance: EdgeDetector1
	Port map (
		Clk => Clk,
		Reset => Reset,
		Enable_in => Enable,
		Enable_out => Enable_out_out
	);
	
    -- Instance of the finite state machine used to dictate the behavior of the system (enable counting and clearing display)
    stateController_Instance: StateController
	Port map (
		Clk => Clk,
        Reset =>Reset,
        Button => Enable_out_out,
        -- below is output from random count
        EoC_rand => TimerOverflow,
        
        clear => Clear_out,
		enable => CounterEnable
		);

  timer_instance: timer
	Port map (
		Clk => Clk,
		Enable => '1', -- timer should always be on and only reset by "Reset" signal
		Reset => Reset,
		Overflow => TimerOverflow
	);
		
	-- counter to represent 10ms to control how fast displays are being switched
	counter_10ms_display_instance: counter_10ms
	  port map (  
	   Clk => Clk,  
            Reset => Reset,
          Enable => '1',
          CarryOut => counter_10_ms_display_carry_out
      );
      
    -- Counter to control which display is being activated
    counter_03_display_instance:counter_03
    port map ( 
        Clk => Clk,  
        Reset => Reset,
        Enable => counter_10_ms_display_carry_out,
        Count => sel
        );
	   
    -- Process to activate display based on counter_03_display_instance
	process(sel)
	begin
	   case sel is
           when "00" => an <= "1110";
               data <=CounterValueMs;
          when "01" => an <= "1101";
                data <=CounterValueHundredths;
          when "10" => an <= "1011";
                  data <=CounterValueTenths;
         when others => an <= "0111";
                data <=CounterValueSeconds;
        end case;

    end process;
            
    -- Process to decode the data to be displayed on the 7-segment display with active-low
    process(data)
    begin
    case data is
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