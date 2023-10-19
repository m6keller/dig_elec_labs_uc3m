library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decoders_tb is
end decoders_tb;

architecture testbench of decoders_tb is
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

  stimulus_process : process
  begin
    for sel_value in 0 to 3 loop
      for data_value in 0 to 9 loop
        sel_tb  <= std_logic_vector(to_unsigned(sel_value, sel_tb'length));
        data_tb <= std_logic_vector(to_unsigned(data_value, data_tb'length));
        wait for 10 ns;  
      end loop;
    end loop;
    wait;
  end process;

end testbench;
