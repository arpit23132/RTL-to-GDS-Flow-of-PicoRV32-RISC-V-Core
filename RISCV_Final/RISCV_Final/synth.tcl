# --- Setup ---
set TOP_NAME           picorv32
set LIB_FILES          { ./slow.lib }
set SDC_FILE           [file normalize ./constraints.sdc]
set HDL_DEFINES        {ENABLE_IRQ=0 ENABLE_TRACE=0 ENABLE_PCPI=0}

# Library + search path
set_db lib_search_path [list . [pwd]]
foreach lib $LIB_FILES { read_lib $lib }

# Deterministic / LEC-friendly settings
set_db hdl_unconnected_value 0
set_db optimize_merge_flops false
set_db lp_insert_clock_gating false
set_db syn_opt_effort low
# (optional) a little global effort is fine:
#set_db syn_global_effort medium

# --- Read + elaborate RTL ---
read_hdl -define $HDL_DEFINES ./picorv32.v
elaborate $TOP_NAME

# --- Constraints ---
read_sdc $SDC_FILE

# --- Synthesis flow ---
syn_generic
syn_map
syn_opt

# --- Netlist & LEC dofile ---
# Only add "-lec" here if you actually did RETIMING. Otherwise omit -lec (per the manual).
# write_hdl -lec > final.v
write_hdl           > final.v

# Composite compare dofile (RTL?fv_map, then fv_map?final)
# This is the simplest, most robust flow for LEC.
write_do_lec -golden_design rtl -revised_design final.v -logfile lec.log > lec_script.tcl

