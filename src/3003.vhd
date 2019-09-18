LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity intel_3003 is
  generic(
          g_INPUT_WIDTH  : integer := 8;
          g_OUTPUT_WIDTH : integer := 9
          );
  port( Y7_Y0 : in std_logic_vector(g_INPUT_WIDTH - 1 downto 0);

        X7_X0 : in std_logic_vector(g_INPUT_WIDTH - 1 downto 0);

        CN    : in std_logic;

        ECN8 : in std_logic;

        CN8_CN1 : out std_logic_vector(g_OUTPUT_WIDTH - 1 downto 1)
        );
end;

architecture behavior of intel_3003 is
  signal in_XCN          : std_logic_vector(g_INPUT_WIDTH downto 0) := X7_X0 & (not CN) ;
  signal out_carry_result    : std_logic_vector(g_OUTPUT_WIDTH - 1 downto 1);
  signal w_gen_carry_1         : std_logic_vector(1 downto 0);
  signal w_gen_carry_2         : std_logic_vector(2 downto 0);
  signal w_gen_carry_3         : std_logic_vector(3 downto 0);
  signal w_gen_carry_4         : std_logic_vector(4 downto 0);
  signal w_gen_carry_5         : std_logic_vector(5 downto 0);
  signal w_gen_carry_6         : std_logic_vector(6 downto 0);
  signal w_gen_carry_7         : std_logic_vector(7 downto 0);
  signal w_gen_carry_8         : std_logic_vector(8 downto 0);

  type t_Signal is array (1 to 8) of std_logic_vector(g_OUTPUT_WIDTH - 1 downto 0);
  signal carry_internal : t_Signal := (w_gen_carry_1, w_gen_carry_2, w_gen_carry_3, w_gen_carry_4, w_gen_carry_5, w_gen_carry_6, w_gen_carry_7, w_gen_carry_8);

  function and_reduce_XYvector(in_XCNvec : in std_logic_vector; in_vecY : in std_logic_vector; carry_stage : in integer; iteration : in integer) return std_logic is
    variable res : std_logic := '1';

    begin

    if iteration = 0 then
      for i in 0 to (carry_stage - 1) loop
        res := res and in_vecY(i);
      end loop;

      res := res and in_XCNvec(0);
    else
      for i in (iteration - 1) to (carry_stage - 1) loop
        res := res and in_vecY(i);
      end loop;

      res := res and in_XCNvec(iteration);
    end if;

    return res;
  end function;

  function or_reduce(vector : std_logic_vector) return std_logic is
    variable res : std_logic := '0';
    begin
    for i in vector'range loop
      res := res or vector(i);
    end loop;
    return res;
  end function;

  begin

  g_CARRY_GENERATION: for s in 1 to 8 generate
    g_SUBROUTINE_INTERNAL: for i in 0 to s generate
      carry_internal(i)(s) <= and_reduce_XYvector(in_XCN, Y7_Y0, s, i);
    end generate;

    out_carry_result(s) <= or_reduce(carry_internal(s)) when ((s /= 8) or (ECN8 = '1'))
                           else 'Z';
  end generate;

  CN8_CN1 <= out_carry_result;

  end behavior;
