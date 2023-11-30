
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity StateController is
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
end StateController;


ARCHITECTURE behavioural OF StateController IS
	TYPE state is (Paused, Restarted, WaitingRandom, Counting);
	SIGNAL cur_state, next_state: state;
begin
	process(Clk, Reset) -- Process for FSM to change states
	begin 
		if reset = '1' then cur_state <= Paused;
		elsif rising_edge(Clk) then cur_state <= next_state;
		end if;
	end process;

	process(cur_state, Button, EoC_rand)
	begin
		case cur_state is
            when Paused => 
                clear <= '0';
                enable <= '0';
                if button = '1' then next_state <= Restarted;
                else next_state <= Paused;
                end if;
            when Restarted => 
                clear <= '1';
                enable <= '0';
                if button = '1' then next_state <= WaitingRandom;
                else next_state <= Restarted;
                end if;

            when WaitingRandom => 
                clear <= '0';
                enable <= '0';
                if EoC_rand= '1' then next_state <= Counting;
                else next_state <= WaitingRandom;
                end if;

            when Counting=> 
                clear <= '0';
                enable <= '1';
                if button = '1' then next_state <= Paused;
                else next_state <= Counting;
                end if;
        end case;   
	end process;


end behavioural;