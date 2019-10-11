LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity testbench_3205 is
  generic(
            g_ADDRESS_WIDTH : integer := 3;
            g_OUTPUT_WIDTH  : integer := 8;
            g_ENABLE_WIDTH  : integer := 3
            );
end;

architecture tb of testbench_3205 is
  constant DELTA_TIME : time := 2ns;

  signal A2_A0 : std_logic_vector(g_ADDRESS_WIDTH - 1 downto 0);
  signal O7_O0 : std_logic_vector(g_OUTPUT_WIDTH - 1 downto 0);
  signal E3_E1 : std_logic_vector(g_ENABLE_WIDTH - 1 downto 0);

  begin

  DUT : entity intel_3205
        port map(A2_A0 => A2_A0,
                 O7_O0 => O7_O0,
                 E3_E1 => E3_E1);

  p_SIMULATION : process
    variable res : integer;
    variable res_expected : integer;
    begin
        for enable in 0 to (2 ** E3_E1'length) - 1 loop
            for address in 0 to (2 ** A2_A0'length) -1 loop
                E3_E1 <= std_logic_vector(to_unsigned(enable, E3_E1'length));
                A2_A0 <= std_logic_vector(to_unsigned(address, A2_A0'length));
                wait for DELTA_TIME; --critical delay to read generated output
                res := to_integer(unsigned(O7_O0));
                if (E3_E1(2) and (not E3_E1(1)) and (not E3_E1(0))) = '0' then
                  res_expected := (2 ** g_OUTPUT_WIDTH) - 1;
                else
				          res_expected := ((2 **g_OUTPUT_WIDTH) - 1) - 2 ** address;
                end if;

                assert res = res_expected
                report "Unexpected result at " &
                        "enable: " & integer'image(enable) & "; " &
                        "address: " & integer'image(address) & "; " &
                        "result expected: " & integer'image(res_expected) & "; " &
                        "result: " & integer'image(res)
                severity error;
            end loop;
        end loop;
    wait; --make process wait for an infinite timespan
  end process;

  end tb;
