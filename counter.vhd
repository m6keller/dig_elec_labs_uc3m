entity counter is
    Port ( 
        Clk : in STD_LOGIC;
        Enable : in STD_LOGIC;
        Count : out STD_LOGIC_VECTOR(3 downto 0)
    );
end counter;

architecture Behavioral of counter is
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

