library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
end entity top;

architecture rtl of top is
  constant WIDTH   : natural := 16;
  constant MAX_LEN : natural := 100;

  signal clk            : std_logic;
  signal reset          : std_logic;
  signal ain_tvalid     : std_logic;
  signal ain_tready     : std_logic;
  signal ain_tdata      : std_logic_vector(WIDTH-1 downto 0);
  signal ain_tlast      : std_logic;
  signal aout_tvalid    : std_logic;
  signal aout_tready    : std_logic;
  signal aout_tdata     : std_logic_vector(WIDTH-1 downto 0);
  signal aout_tlast     : std_logic;
  signal rand_operation : std_logic_vector(2 downto 0);
  signal rand_length    : std_logic_vector(3 downto 0);
  signal rand_num       : std_logic_vector(WIDTH-1 downto 0);
begin  -- architecture rtl
  test_proc_1 : entity work.test_proc
    generic map (
      WIDTH   => WIDTH,
      MAX_LEN => MAX_LEN)
    port map (
      clk            => clk,
      reset          => reset,
      ain_tvalid     => ain_tvalid,
      ain_tready     => ain_tready,
      ain_tdata      => ain_tdata,
      ain_tlast      => ain_tlast,
      aout_tvalid    => aout_tvalid,
      aout_tready    => aout_tready,
      aout_tdata     => aout_tdata,
      aout_tlast     => aout_tlast,
      rand_operation => rand_operation,
      rand_length    => rand_length,
      rand_num       => rand_num);

  sort_1 : entity work.sort
    generic map (
      WIDTH   => WIDTH,
      MAX_LEN => MAX_LEN)
    port map (
      clk         => clk,
      reset       => reset,
      ain_tvalid  => ain_tvalid,
      ain_tready  => ain_tready,
      ain_tdata   => ain_tdata,
      ain_tlast   => ain_tlast,
      aout_tvalid => aout_tvalid,
      aout_tready => aout_tready,
      aout_tdata  => aout_tdata,
      aout_tlast  => aout_tlast);


end architecture rtl;
