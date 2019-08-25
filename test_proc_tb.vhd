-------------------------------------------------------------------------------
-- Title      : Testbench for design "test_proc"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : test_proc_tb.vhd
-- Author     : milos  <milos@milos-desktop>
-- Company    : 
-- Created    : 2019-08-25
-- Last update: 2019-08-25
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-08-25  1.0      milos Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.uniform;
use ieee.math_real.floor;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity test_proc_tb is

end entity test_proc_tb;

-------------------------------------------------------------------------------

architecture proc_tb of test_proc_tb is

  -- component generics
  constant WIDTH   : natural := 16;
  constant MAX_LEN : natural := 100;

  -- component ports
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

  -- clock
  signal Clk : std_logic := '1';

begin  -- architecture proc_tb

  -- component instantiation
  DUT : entity work.test_proc
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
  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
    variable seed1 : positive := 1;
    variable seed2 : positive := 1;
    variable x     : real;
    variable y     : integer;
  begin
    -- insert signal assignments here
    uniform(seed1, seed2, x);
    y        := integer(floor(x * 10.0));
    rand_num <= std_logic_vector(to_unsigned(y, 16));

    uniform(seed1, seed2, x);
    y           := integer(floor(x * 1024.0));
    rand_length <= std_logic_vector(to_unsigned(y, 4));

    uniform(seed1, seed2, x);
    y              := integer(floor(x * 1024.0));
    rand_operation <= std_logic_vector(to_unsigned(y, 3));
    wait until Clk = '1';
  end process WaveGen_Proc;



end architecture proc_tb;

