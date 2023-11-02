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
    signal count_reg : STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin
    process (Clk)
    begin
        if clk'EVENT AND clk = '1' then
            if Enable = '1' then
                if count_reg = "1001" then
                    count_reg <= "0000";
                else
                    count_reg <= count_reg + 1;
                end if;
            end if;
        end if;
    end process;

    Count <= count_reg;

end Behavioral;