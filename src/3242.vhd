LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity intel_3242 is
  generic(
          g_ADDRESS_WITDH : integer := 14;
          g_OUTPUT_WIDHT  : integer := 7
          );
  port( A13_A0 : in std_logic_vector(g_ADDRESS_WITDH - 1 downto 0);

        REFRESH_EN : in std_logic;
        ROW_EN :     in std_logic;
        COUNT_INV :  in std_logic;

        O6_O0 : out std_logic_vector(g_OUTPUT_WIDHT - 1 downto 0);

        ZERO_DETECT_INV : out std_logic
        );
end;

architecture behavior of intel_3242 is
  signal w_row_en_inv : std_logic;
  signal w_refresh_en_inv : std_logic;
  signal w_count : std_logic;
  signal w_counter_out : std_logic_vector(6 downto 0);
  signal w_zero_detect : std_logic;

  begin

  w_count <= not COUNT_INV;

  p_COUNTER: process(w_count) begin
    if (rising_edge(w_count)) then
      w_counter_out <= std_logic_vector(to_unsigned(to_integer(unsigned(w_counter_out)) + 1, 7));
    end if;
  end process;

  g_ZERO_DETECT: for i in 0 to 4 generate
    w_zero_detect <= w_zero_detect and w_counter_out(i) and w_counter_out(i + 1);
  end generate g_ZERO_DETECT;

  ZERO_DETECT_INV <= not w_zero_detect;

  g_GENERATE_OUTPUT: for i in 0 to g_OUTPUT_WIDHT - 1 generate
    O6_O0(i) <=  not(
                      (w_counter_out(i) and REFRESH_EN) or
                      (ROW_EN and w_refresh_en_inv and A13_A0(i)) or
                      (A13_A0(i + 7) and w_refresh_en_inv and w_row_en_inv)
                    );
  end generate g_GENERATE_OUTPUT;

  end behavior;
