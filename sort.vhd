library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sort is

  generic (
    WIDTH   : natural := 16;
    MAX_LEN : natural := 10);

  port (
    clk   : in std_logic;
    reset : in std_logic;

    ain_tvalid : in std_logic;
    ain_tready : in std_logic;
    ain_tdata  : in std_logic_vector(WIDTH-1 downto 0);
    ain_tlast  : in std_logic;

    aout_tvalid : out std_logic;
    aout_tready : in  std_logic;
    aout_tdata  : out std_logic_vector(WIDTH-1 downto 0);
    aout_tlast  : out std_logic
    );

end entity sort;


architecture rtl of sort is
  type my_array is array (0 to MAX_LEN) of std_logic_vector(WIDTH-1 downto 0);
  signal arr      : my_array := (others => (others => '0'));
  signal first_el : integer  := MAX_LEN;
  signal len      : integer  := 0;

begin  -- architecture rtl

  sync_sort : process (clk, reset) is
    variable cnt : integer := 0;
  begin  -- process sync_sort
    if reset = '1' then                 -- asynchronous reset (active high)
      arr      <= (others => (others => '0'));
      first_el <= MAX_LEN;
      len      <= 0;

    elsif clk'event and clk = '1' then  -- rising clock edge

      if ain_tvalid = '1' and ain_tready = '1' then

        cnt := 0;
        for i in first_el to first_el+len loop
          if ain_tdata > arr(i) then
            cnt      := cnt + 1;
            arr(i-1) <= arr(i);
          end if;
        end loop;  -- i

        arr(first_el -1 + cnt) <= ain_tdata;

        first_el <= first_el - 1;
        len      <= len + 1;
      else
        aout_tvalid <= '1';

      end if;

    end if;
  end process sync_sort;

  aout_tdata <= arr(MAX_LEN/2);


end architecture rtl;
