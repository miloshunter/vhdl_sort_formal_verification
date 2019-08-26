clear -all
analyze -vhdl2k {sort.vhd}
analyze -vhdl2k {test_proc.vhd}
analyze -vhdl2k {top.vhd}
elaborate -vhdl -top {top}
clock clk -factor 1 -phase 1
reset -expression {reset}
prove -bg -all

