library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_decoders is

end tb_decoders;

architecture testbench of tb_decoders is

signal sel_tb    : std_logic_vector(1 downto 0) := "00";
  signal data_tb   : std_logic_vector(3 downto 0) := "0000";
  signal seg_tb    : std_logic_vector(6 downto 0);
  signal an_tb     : std_logic_vector(3 downto 0);

  component decoders
    Port (
      sel  : in  std_logic_vector(1 downto 0);
      data : in  std_logic_vector(3 downto 0);
      seg  : out std_logic_vector(6 downto 0);
      an   : out std_logic_vector(3 downto 0)
    );
  end component;

begin
  uut : decoders
    port map (
      sel  => sel_tb,
      data => data_tb,
      seg  => seg_tb,
      an   => an_tb
    );

    process
    begin
      sel_tb  <= "00"; -- Initialize sel_tb
      data_tb <= "0000"; -- Initialize data_tb
    
      -- First iteration
      wait for 10 ns;
      sel_tb  <= "01";
      wait for 10 ns;
      sel_tb  <= "10";
      wait for 10 ns;
      sel_tb  <= "11";
      wait for 10 ns;
    
      -- Reset sel_tb
      sel_tb  <= "00";
    
      -- Second iteration
      wait for 10 ns;
      data_tb <= "0001";
      wait for 10 ns;
      data_tb <= "0010";
      wait for 10 ns;
      data_tb <= "0011";
      wait for 10 ns;
      data_tb <= "0100";
      wait for 10 ns;
      data_tb <= "0101";
      wait for 10 ns;
      data_tb <= "0110";
      wait for 10 ns;
      data_tb <= "0111";
      wait for 10 ns;
      data_tb <= "1000";
      wait for 10 ns;
      data_tb <= "1001";
      wait for 10 ns;
    
      wait;
    end process;
    
end testbench;