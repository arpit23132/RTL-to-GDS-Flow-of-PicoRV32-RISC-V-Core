
set_db information_level 2
set_db library {slow.lib}

read_hdl final.v
elaborate
read_sdc constraints.sdc

set_db dft_scan_style muxed_scan

define_test_mode    -name TM  -active high -create_port test_mode
define_shift_enable -name SE  -active high -create_port shift_en
define_test_clock   -name clk -domain clk_domain [get_ports clk]

check_dft_rules
#fix_dft_violations

convert_to_scan
connect_scan_chains -auto_create_chains
report dft_chains

set_db dft_apply_sdc_constraints true
write_sdc > dft_constraints.sdc
write_hdl -lec picorv32 > dft_netlist.v
report dft_registers > dft_registers.rpt

write_do_lec -golden_design final.v -revised_design dft_netlist.v -logfile lec_dft.log > lec_dft_script.tcl



