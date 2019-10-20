LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity intel_3404 is
  generic(
          g_LATCH_WIDTH : integer := 6
          );
  port( D6_D1 : in std_logic_vector(g_LATCH_WIDTH - 1 downto 0);

        O6_O1 : out std_logic_vector(g_LATCH_WIDTH - 1 downto 0);

        W1    : in std_logic;
        W2    : in std_logic
        );
end;

architecture behavior of intel_3404 is
  signal w_wr1_inv : std_logic;
  signal w_wr2_inv : std_logic;

  begin

    w_wr1_inv <= not W1;
    w_wr2_inv <= not W2;

    p_LATCH: process(D6_D1, w_wr1_inv, w_wr2_inv) begin
        if(w_wr1_inv = '1') then
            for i in 0 to 3 loop
                O6_O1(i) <= not D6_D1(i);
            end loop;
        end if;
        if(w_wr2_inv = '1') then
            for i in 4 to g_LATCH_WIDTH - 1 loop
                O6_O1(i) <= not D6_D1(i);
            end loop;
        end if;
    end process;

  end behavior;
