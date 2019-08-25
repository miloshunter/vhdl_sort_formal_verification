library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sort is

  generic (
    WIDTH   : natural := 16;
    MAX_LEN : natural := 100);

  port (
    clk   : in std_logic;
    reset : in std_logic;

    ain_tvalid : in  std_logic;
    ain_tready : out std_logic;
    ain_tdata  : in  std_logic_vector(WIDTH-1 downto 0);
    ain_tlast  : in  std_logic;

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
  type state_t is (s_idle, s_sorting, s_output);
  signal state    : state_t  := s_idle;
  signal out_cnt  : integer  := 0;

begin  -- architecture rtl

  sync_sort : process (clk, reset) is
    variable cnt : integer := 0;
  begin  -- process sync_sort
    if reset = '1' then                 -- asynchronous reset (active high)
      arr      <= (others => (others => '0'));
      first_el <= MAX_LEN;
      len      <= 0;

    elsif clk'event and clk = '1' then  -- rising clock edge

      if state = s_idle then
        -- ------------------- IDLE

        arr         <= (others => (others => '0'));
        first_el    <= MAX_LEN;
        len         <= 0;
        out_cnt     <= 0;
        aout_tlast  <= '0';
        aout_tdata  <= (others => '0');
        aout_tvalid <= '0';


        if ain_tvalid = '1' then
          state      <= s_sorting;
          ain_tready <= '1';
        end if;


      elsif state = s_sorting and ain_tvalid = '1' then
        -- ------------------- SORTING

        cnt := 0;
        for i in 1 to MAX_LEN loop
          if (i >= first_el) and (i <= first_el + len) then
            if ain_tdata > arr(i) then
              cnt      := cnt + 1;
              arr(i-1) <= arr(i);
            end if;
          end if;
        end loop;  -- i

        arr(first_el -1 + cnt) <= ain_tdata;

        first_el <= first_el - 1;
        len      <= len + 1;

        if ain_tlast = '1' then
          out_cnt    <= first_el + 1;
          aout_tdata <= arr(first_el);
          state      <= s_output;
          ain_tready <= '0';
        end if;



      elsif state = s_output then
        -- ------------------- OUTPUT



        ain_tready  <= '0';
        aout_tvalid <= '1';
        if (aout_tready = '1') then
          out_cnt    <= out_cnt + 1;
          aout_tdata <= arr(out_cnt);
        end if;

        if out_cnt = (first_el + len) then
          aout_tlast <= '1';
          state      <= s_idle;

        end if;

      end if;

    end if;
  end process sync_sort;


end architecture rtl;
