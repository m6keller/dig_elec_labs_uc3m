library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- EdgeDectector is used to detect a button pressed. This is necessary so that multiple button presses are not registered if the user holds down the button.
entity EdgeDetector1 is
	Port (
		clk: in STD_LOGIC;
		reset: in STD_LOGIC;
		enable_in: in STD_LOGIC;
		enable_out: out STD_LOGIC
	);
end EdgeDetector1;

ARCHITECTURE behavioural OF EdgeDetector1 is
	SIGNAL prev_enable_in: STD_LOGIC := '0';
begin
    process (reset, clk) begin
        if reset = '1' THEN prev_enable_in <= '0';
        elsif clk'EVENT AND clk = '1' THEN prev_enable_in <= enable_in;
        end if;
    end process;

    enable_out <= '1' WHEN enable_in = '1' and prev_enable_in = '0' ELSE '0'; 

end behavioural;