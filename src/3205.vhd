LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity intel_3205 is
  generic(
          g_ADDRESS_WIDTH : integer := 3;
          g_OUTPUT_WIDTH  : integer := 8;
          g_ENABLE_WIDTH  : integer := 3
          );
  port( A2_A0 : in std_logic_vector(g_ADDRESS_WIDTH - 1 downto 0);

        O7_O0 : out std_logic_vector(g_OUTPUT_WIDTH - 1 downto 0);

        E3_E1 : in std_logic_vector(g_ENABLE_WIDTH - 1 downto 0)
        );
end;

architecture behavior of intel_3205 is
  signal w_en : std_logic;

  begin

  w_en <= E3_E1(2) and (not E3_E1(1)) and (not E3_E1(0));

  g_DECODER_OUT: for i in O7_O0'range generate
   O7_O0(i) <= '1' when (w_en = '0') or (not (to_integer(unsigned(A2_A0)) = i)) else '0';
  end generate g_DECODER_OUT;

end behavior;
