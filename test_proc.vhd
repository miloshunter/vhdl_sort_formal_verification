library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_proc is
  generic (
    WIDTH   : natural := 16;
    MAX_LEN : natural := 850);

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
    rand_length    : in std_logic_vector(7 downto 0);
    rand_num       : in std_logic_vector(WIDTH-1 downto 0)
    );

end entity test_proc;


architecture simulating_process of test_proc is
  type state_t is (s_idle, s_write, s_wait, s_read);
  signal state : state_t := s_idle;

  signal length : integer;
  signal cnt    : integer;

begin  -- architecture simulating_process


  case state is
    when s_idle =>

      if rand_operation = "010" then
        length <= unsigned(rand_length);
        cnt    <= 0;
        state  <= s_write;
      end if;

    when s_write =>

      ain_tvalid <= '1';
      ain_tdata  <= rand_num;

    when s_wait =>;


    when s_read =>;


    when others => null;
  end case;



end architecture simulating_process;
