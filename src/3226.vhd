LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity intel_3226 is
  generic(
          g_BUFFER_IO_WIDTH : integer := 4
          );
  port( DI3_DI0 : in std_logic_vector(g_BUFFER_IO_WIDTH - 1 downto 0);

        DO3_DO0 : out std_logic_vector(g_BUFFER_IO_WIDTH - 1 downto 0);

        DB3_DB0 : out std_logic_vector(g_BUFFER_IO_WIDTH - 1 downto 0);

        CS :  in std_logic;
        DCE : in std_logic
        );
end;

architecture behavior of intel_3226 is
  type t_Signal is array (0 to g_BUFFER_IO_WIDTH - 1) of std_logic;
  signal w_first_buf_out : t_Signal;  --rename

  begin

  g_FIRST_STAGE_SIGNALS: for i in DB3_DB0'range generate
    w_first_buf_out(i) <= 'Z' when (((not DCE) and (not CS)) = '0') else
                          (not DI3_DI0(i));
   DB3_DB0(i) <= w_first_buf_out(i);
  end generate g_FIRST_STAGE_SIGNALS;

  g_SECOND_STAGE_SIGNALS: for i in DO3_DO0'range generate
    DO3_DO0(i) <= 'Z' when ((DCE and (not CS)) = '0') else
                  (not w_first_buf_out(i));
  end generate g_SECOND_STAGE_SIGNALS;

  end behavior;
