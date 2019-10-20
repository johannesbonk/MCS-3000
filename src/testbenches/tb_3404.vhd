LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity testbench_3404 is
  generic(
          g_LATCH_WIDTH : integer := 6
          );
end;

architecture tb of testbench_3404 is
  constant DELTA_TIME : time := 2ns;

  signal D6_D1 : std_logic_vector(g_LATCH_WIDTH - 1 downto 0);
  signal O6_O1 : std_logic_vector(g_LATCH_WIDTH - 1 downto 0);
  signal W1 : std_logic;
  signal W2 : std_logic;

  begin

  DUT : entity intel_3404
        port map(D6_D1 => D6_D1,
                 O6_O1 => O6_O1,
                 W1 => W1,
                 W2 => W2
                );

  p_SIMULATION : process
    variable l_4b : std_logic_vector(3 downto 0);
    variable l_2b : std_logic_vector(5 downto 4);
    begin
        W2 <= '0'; -- both W2 controlled outputs constantly inverted
        W1 <= '0'; -- initial state of W1
        wait for DELTA_TIME;
        for i in 0 to 2**4 - 1 loop
          l_4b := std_logic_vector(to_unsigned(i, 4));
          D6_D1(3 downto 0) <= l_4b;
          wait for DELTA_TIME;
          W1 <= '1';
          wait for DELTA_TIME;
            for k in 0 to 2**g_LATCH_WIDTH - 1 loop
                D6_D1 <= std_logic_vector(to_unsigned(k, g_LATCH_WIDTH));
                wait for DELTA_TIME;
                assert ((not D6_D1(5 downto 4)) = O6_O1(5 downto 4)) and (O6_O1(3 downto 0) = not l_4b)
                report "Unexpected result at " &
                        "W1 = '1'" & "; " &
                        "W2 = '0'" & "; " &
                        "result expected 4 bit latch: " & integer'image(to_integer(unsigned(not l_4b))) & "; " &
                        "result 4 bit latch: " & integer'image(to_integer(unsigned(O6_O1(3 downto 0)))) & "; " &
                        "result expected 2 bit latch: " & integer'image(to_integer(unsigned(not D6_D1(5 downto 4)))) & "; " &
                        "result 2 bit latch:  " & integer'image(to_integer(unsigned(O6_O1(5 downto 4))))
                        severity error;
            end loop;
          W1 <= '0';
          wait for DELTA_TIME;
          end loop;

          W1 <= '0'; -- all 4 W1 controlled outputs constantly inverted
          W2 <= '0'; -- W2 initial state
          wait for DELTA_TIME;
          for i in 0 to 2**2 - 1 loop
            l_2b := std_logic_vector(to_unsigned(i, 2));
            D6_D1(5 downto 4) <= l_2b;
            wait for DELTA_TIME;
            W2 <= '1';
            wait for DELTA_TIME;
              for k in 0 to 2**g_LATCH_WIDTH - 1 loop
                  D6_D1 <= std_logic_vector(to_unsigned(k, g_LATCH_WIDTH));
                  wait for DELTA_TIME;
                  assert ((not D6_D1(3 downto 0)) = O6_O1(3 downto 0)) and (O6_O1(5 downto 4) = not l_2b)
                  report "Unexpected result at " &
                          "W1 = '0'" & "; " &
                          "W2 = '1'" & "; " &
                          "result expected 2 bit latch: " & integer'image(to_integer(unsigned(not l_2b))) & "; " &
                          "result 2 bit latch: " & integer'image(to_integer(unsigned(O6_O1(5 downto 4)))) & "; " &
                          "result expected 4 bit latch: " & integer'image(to_integer(unsigned(not D6_D1(3 downto 0)))) & "; " &
                          "result 4 bit latch:  " & integer'image(to_integer(unsigned(O6_O1(3 downto 0))))
                          severity error;
              end loop;
            W2 <= '0';
            wait for DELTA_TIME;
            end loop;

    wait; --make process wait for an infinite timespan
  end process;

  end tb;
