LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity intel_3216 is
  generic(
          g_BUFFER_IO_WIDTH : integer := 4
          );
  port( DI3_DI0 : in std_logic_vector(g_BUFFER_IO_WIDTH - 1 downto 0);

        DO3_DO0 : out std_logic_vector(g_BUFFER_IO_WIDTH - 1 downto 0);

        DB3_DB0 : inout std_logic_vector(g_BUFFER_IO_WIDTH - 1 downto 0);

        CS : in std_logic;
        DCE : in std_logic
        );
end;

architecture behavior of intel_3216 is
  type t_Signal is array (0 to 3) of std_logic;
  signal w_io : t_Signal;

  begin

  g_FIRST_STAGE_SIGNALS: for i in 0 to 3 generate
   w_io(i) <= DB3_DB0(i) when (((not DCE) and (not CS)) = '0') else DI3_DI0(i);
   DB3_DB0(i) <= w_io(i);
  end generate g_FIRST_STAGE_SIGNALS;

  g_SECOND_STAGE_SIGNALS: for i in 0 to 3 generate
    DO3_DO0(i) <= 'Z' when ((DCE and (not CS)) = '0') else w_io(i);
  end generate g_SECOND_STAGE_SIGNALS;

  end behavior;
