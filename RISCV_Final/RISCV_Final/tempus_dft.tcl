# ============================================================
# Tempus STA for DFT-Inserted Netlist (Functional Mode)
# ============================================================

# --- Setup ---
file mkdir sta_after_dft_maxfreq/reports
set report_dir sta_after_dft_maxfreq/reports

# --- Load libraries and design ---
read_lib slow.lib
read_verilog dft_netlist.v
set_top_module picorv32

# --- Read DFT SDC constraints ---
read_sdc dft_constraints.sdc

# --- Apply functional mode case analysis ---
# Disable scan/DFT logic during STA
#set_case_analysis 0 [get_ports test_mode]
#set_case_analysis 0 [get_ports shift_en]

# --- Sanity check on clocks and constraints ---
check_timing > $report_dir/check_timing_dft_maxfreq.rpt
report_clocks > $report_dir/clocks_dft_maxfreq.rpt
report_case_analysis > $report_dir/case_analysis_dft_maxfreq.rpt

# --- Timing analysis ---
report_timing > $report_dir/timing_report_dft_maxfreq.rpt

# Detailed path-based report
report_timing -retime path_slew_propagation -max_path 50 -nworst 50 -path_type full_clock \
    > $report_dir/pba_dft_maxfreq.rpt

# --- Coverage and summary reports ---
report_analysis_coverage > $report_dir/analysis_coverage_dft_maxfreq.rpt
report_analysis_summary > $report_dir/analysis_summary_dft_maxfreq.rpt
report_constraints -all_violators > $report_dir/allviolations_dft_maxfreq.rpt

# --- Optional DFT-specific reports ---
# report_disable_timing > $report_dir/disabled_timing_dft_maxfreq.rpt
# report_exceptions > $report_dir/exceptions_dft_maxfreq.rpt

# ============================================================
# End of Tempus DFT STA Script
# ============================================================

