-------------------------------------------------------------------------------
-- Title      : Testbench for design "sort"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sort_tb.vhd
-- Author     : milos  <milos@milos-desktop>
-- Company    : 
-- Created    : 2019-08-21
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
-- 2019-08-21  1.0      milos Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity sort_tb is

end entity sort_tb;

-------------------------------------------------------------------------------

architecture bla of sort_tb is

  -- component generics
  constant WIDTH   : natural := 16;
  constant MAX_LEN : natural := 20;

  -- component ports
  signal reset       : std_logic;
  signal ain_tvalid  : std_logic;
  signal ain_tready  : std_logic;
  signal ain_tdata   : std_logic_vector(WIDTH-1 downto 0);
  signal ain_tlast   : std_logic;
  signal aout_tvalid : std_logic;
  signal aout_tready : std_logic;
  signal aout_tdata  : std_logic_vector(WIDTH-1 downto 0);
  signal aout_tlast  : std_logic;

  -- clock
  signal Clk : std_logic := '1';

begin  -- architecture bla

  -- component instantiation
  DUT : entity work.sort
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

  ain_tvalid <= '1' after 40 ns, '0' after 240 ns, '1' after 540 ns, '0' after 880 ns;
  ain_tlast  <= '1' after 220 ns, '0' after 240 ns, '1' after 860 ns, '0' after 880 ns;

  aout_tready <= '1' after 300 ns;

  ain_tdata <= std_logic_vector(to_unsigned(10, 16)) after 40 ns,
               std_logic_vector(to_unsigned(5, 16))  after 80 ns,
               std_logic_vector(to_unsigned(7, 16))  after 100 ns,
               std_logic_vector(to_unsigned(12, 16)) after 120 ns,
               std_logic_vector(to_unsigned(3, 16))  after 140 ns,
               std_logic_vector(to_unsigned(3, 16))  after 160 ns,
               std_logic_vector(to_unsigned(20, 16)) after 180 ns,
               std_logic_vector(to_unsigned(2, 16))  after 200 ns,
               std_logic_vector(to_unsigned(6, 16))  after 220 ns,
               std_logic_vector(to_unsigned(0, 16))  after 240 ns,
               std_logic_vector(to_unsigned(10, 16)) after 540 ns,
               std_logic_vector(to_unsigned(5, 16))  after 580 ns,
               std_logic_vector(to_unsigned(7, 16))  after 600 ns,
               std_logic_vector(to_unsigned(12, 16)) after 620 ns,
               std_logic_vector(to_unsigned(3, 16))  after 640 ns,
               std_logic_vector(to_unsigned(3, 16))  after 660 ns,
               std_logic_vector(to_unsigned(20, 16)) after 680 ns,
               std_logic_vector(to_unsigned(2, 16))  after 700 ns,
               std_logic_vector(to_unsigned(6, 16))  after 720 ns,
               std_logic_vector(to_unsigned(50, 16)) after 740 ns,
               std_logic_vector(to_unsigned(52, 16)) after 760 ns,
               std_logic_vector(to_unsigned(56, 16)) after 780 ns,
               std_logic_vector(to_unsigned(50, 16)) after 800 ns,
               std_logic_vector(to_unsigned(52, 16)) after 820 ns,
               std_logic_vector(to_unsigned(56, 16)) after 840 ns,
               std_logic_vector(to_unsigned(50, 16)) after 860 ns;




  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here

    wait until Clk = '1';
  end process WaveGen_Proc;



end architecture bla;

