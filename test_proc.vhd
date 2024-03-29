library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_proc is
  generic (
    WIDTH   : natural := 16;
    MAX_LEN : natural := 100);

  port (
    clk   : in std_logic;
    reset : in std_logic;

    ain_tvalid : out std_logic;
    ain_tready : in  std_logic;
    ain_tdata  : out std_logic_vector(WIDTH-1 downto 0);
    ain_tlast  : out std_logic;

    aout_tvalid : in  std_logic;
    aout_tready : out std_logic;
    aout_tdata  : in  std_logic_vector(WIDTH-1 downto 0);
    aout_tlast  : in  std_logic;

    rand_operation : in std_logic_vector(2 downto 0);
    rand_length    : in std_logic_vector(3 downto 0);
    rand_num       : in std_logic_vector(WIDTH-1 downto 0)
    );

end entity test_proc;


architecture simulating_process of test_proc is
  type state_t is (s_idle, s_write, s_wait, s_read);
  signal state : state_t := s_idle;

  signal length : natural := 0;
  signal cnt    : natural := 0;

  -- psl P_check_intready: assert always ( {ain_tvalid='0';ain_tvalid='1'} |-> eventually! (ain_tready='1') );
  -- psl P_check_intlast: assert always ( {ain_tvalid='1' and ain_tready='1';ain_tvalid='0' and ain_tready='0'} |-> prev(prev(ain_tlast='0')) and prev(ain_tlast='1') and ain_tlast='0' );

  -- psl P_check_outtready: assert always ( {aout_tvalid='0';aout_tvalid='1'} |-> eventually! (aout_tready='1') );
  -- psl P_check_outtlast: assert always ( {aout_tvalid='1' and aout_tready='1';aout_tvalid='0' and aout_tready='0'} |-> prev(prev(aout_tlast='0')) and prev(aout_tlast='1') and aout_tlast='0' );

  -- psl P_check_if_sorted: assert always ( ( aout_tvalid='1' and aout_tready='1') |-> (aout_tdata >= prev(aout_tdata))  );

begin  -- architecture simulating_process

  sync_proc : process(clk, reset) is
  begin
    if reset = '1' then                 -- asynchronous reset (active high)
      cnt    <= 0;
      length <= 0;
      state  <= s_idle;
      ain_tlast <= '0';
      ain_tvalid <= '0';

    elsif clk'event and clk = '1' then  -- rising clock edge

      ain_tdata <= rand_num;

      case state is
        when s_idle =>

          if rand_operation = "010" then
            length <= to_integer(unsigned(rand_length)) + 1;
            cnt    <= 0;
            state  <= s_write;
          end if;

        when s_write =>

          ain_tvalid <= '1';

          if ain_tready = '1' then
            cnt <= cnt + 1;
          end if;

          if cnt = length then
            state     <= s_wait;
            ain_tlast <= '1';
          end if;


        when s_wait =>
          ain_tvalid <= '0';
          ain_tlast  <= '0';

          if aout_tvalid = '1' then
            aout_tready <= '1';
            state       <= s_read;
          end if;


        when s_read =>

          if aout_tlast = '1' then
            state       <= s_idle;
            aout_tready <= '0';
          end if;
        when others => null;
      end case;

    end if;
  end process sync_proc;

end architecture simulating_process;
