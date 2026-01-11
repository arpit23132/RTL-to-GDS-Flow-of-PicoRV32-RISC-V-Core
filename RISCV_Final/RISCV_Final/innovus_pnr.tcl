#----------------------------------------------------------------------------------POWER_PLANNING------------------------------------------------------------------------------------------

# Adding Rings
addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -center 1 -stacked_via_top_layer Metal9 -type core_rings -jog_distance 1.2 -threshold 1.2 -nets {VSS VDD} -follow core -stacked_via_bottom_layer Metal1 -layer {bottom Metal8 top Metal8 right Metal9 left Metal9} -width 1.8 -spacing 0.8 -offset 2.5

# Adding Stripes
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit Metal9 -max_same_layer_jog_length 2.0 -padcore_ring_bottom_layer_limit Metal7 -number_of_sets 12 -skip_via_on_pin Standardcell -stacked_via_top_layer Metal9 -padcore_ring_top_layer_limit Metal9 -spacing 0.8 -merge_stripes_value 1.2 -layer Metal8 -block_ring_bottom_layer_limit Metal7 -width 0.8 -nets {VDD VSS} -stacked_via_bottom_layer Metal1


set delaycal_use_default_delay_limit 1000 
setDelayCalMode -reportOutBound true

#For Power Planning Net Routing
globalNetConnect VDD -type pgpin -pin VDD -override -verbose -netlistOverride
globalNetConnect VSS -type pgpin -pin VSS -override -verbose -netlistOverride
sroute -nets {VDD VSS} -allowLayerChange 1 -layerChangeRange {Metal1 Metal9}

#All these reports are for 'Before Physical Design'
#report_timing -early -view {view_1} -max_paths 100 > $report_dir/hold_analysis_before_placement.txt
#report_timing -late  -max_paths 100 > $report_dir/setup_analysis_before_placement.txt
#report_timing > $report_dir/timing_report.rpt
#report_timing -retime path_slew_propagation -max_path 50 -nworst 50 -path_type full_clock > $report_dir/pba.rpt
#report_power -rail_analysis_format VS -outfile $report_dir/power.rpt
#report_area -detail > $report_dir/area.rpt
#reportGateCount -level 5 -limit 100 > $report_dir/gate_count.rpt
#report gates -level 5 -limit 100 > $report_dir/gates.rpt

#----------------------------------------------------------------------------------PLACEMENT------------------------------------------------------------------------------------------

#/*Sanity check of Scan chain dft before Placement*/

# >>> CHANGED: your netlist has only one scan chain (DFT_sdi_1 / DFT_sdo_1)
specifyScanChain scan1 -start DFT_sdi_1 -stop DFT_sdo_1
#specifyScanChain scan2 -start DFT_sdi_2 -stop DFT_sdo_2   ;# not present in your design

#Actual Placement
setPlaceMode -fp false
placeDesign

#fix_drc -layer METAL2 -type Mar -all

#----------------------------------------------------------------------------------CTS------------------------------------------------------------------------------------------

#/*Clock Tree Synthesis*/

set_ccopt_mode -cts_buffer_cells {CLKBUFX12 CLKBUFX16 CLKBUFX2 CLKBUFX20 CLKBUFX3 CLKBUFX4 CLKBUFX6 CLKBUFX8 CLKINVX1 CLKINVX12 CLKINVX16 CLKINVX2 CLKINVX20 CLKINVX3 CLKINVX4 CLKINVX6 CLKINVX8} -cts_opt_priority all


create_ccopt_clock_tree_spec -file $report_dir/cts_spec/ccopt_new.spec -keep_all_sdc_clocks -views {view_1 view_1}
source $report_dir/cts_spec/ccopt_new.spec 

# Ccopt_design is a super command. Capable of doing complete CTS
ccopt_design -check_prerequisites
ccopt_design -outDir $report_dir/CTS_timing 
optDesign -postCTS


# Check for any violations:

report_constraint -all_violators > all_constraint_violators_postCTS

report_timing -max_path 200 -nworst 200 > $report_dir/post_CTS_report/timing_setup_report_GBA_buff.rpt
report_timing -max_path 200 -nworst 200 -early > $report_dir/post_CTS_report/timing_hold_report_GBA_buff.rpt
report_timing -retime path_slew_propagation -max_path 200 -nworst 200 -format retime_slew > $report_dir/post_CTS_report/timing_setup_report_PBA_buff.rpt
report_timing -retime path_slew_propagation -max_path 200 -nworst 200 -early -format retime_slew > $report_dir/post_CTS_report/timing_hold_report_PBA_buff.rpt

#Optimizing design if timing violation
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postCTS; # for setup violation
optDesign -postCTS -hold; #for hold violation

#report_timing -max_path 200 -nworst 200 > $report_dir/post_CTS_opt/timing_setup_report_GBA_buff.rpt
#report_timing -max_path 200 -nworst 200 -early > $report_dir/post_CTS_opt/timing_hold_report_GBA_buff.rpt
#report_timing -retime path_slew_propagation -max_path 200 -nworst 200 -format retime_slew > $report_dir/post_CTS_opt/timing_setup_report_PBA_buff.rpt
#report_timing -retime path_slew_propagation -max_path 200 -nworst 200 -early -format retime_slew > $report_dir/post_CTS_opt/timing_hold_report_PBA_buff.rpt
report_area -detail > $report_dir/post_CTS_opt/area.rpt
#report_power -rail_analysis_format VS -outfile $report_dir/post_CTS_opt/power.rpt


#----------------------------------------------------------------------------------ROUTING------------------------------------------------------------------------------------------

#/*Global & Detail Routing*/
setNanoRouteMode -quiet -timingEngine {}
setNanoRouteMode -quiet -routeWithSiPostRouteFix 0
setNanoRouteMode -quiet -drouteStartIteration default
setNanoRouteMode -quiet -routeTopRoutingLayer default
setNanoRouteMode -quiet -routeBottomRoutingLayer default

setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven false
setNanoRouteMode -quiet -routeWithSiDriven false
routeDesign -globalDetail

#/*Writing SDF file with interconnect and gates delay*/
write_sdf -ideal_clock_network placement_reports_1/routing_report/physical_design_picorv32.sdf

# To check for unplaced/unconnected cells:
verifyConnectivity > $report_dir/routing_report/post_detailedRoute_verifyConnectivity.rpt

# Report routing and wirelength informations:
reportRoute > $report_dir/routing_report/postDetailRoute_reportRoute.rpt
reportWire placement_reports_1/routing_report/postDetailRoute_reportWire.rpt


# Gate Analysis
reportGateCount -level 5 -limit 100 -outfile $report_dir/routing_report/gate_count.rpt

# Timing Analysis
report_timing -max_path 100 -nworst 100 > $report_dir/routing_report/timing_setup_report_GBA.rpt
report_timing -max_path 100 -nworst 100 -early > $report_dir/routing_report/timing_hold_report_GBA.rpt
report_timing -retime path_slew_propagation -max_path 100 -nworst 100 -format retime_slew > $report_dir/routing_report/timing_setup_report_PBA.rpt
report_timing -retime path_slew_propagation -max_path 100 -nworst 100 -early -format retime_slew > $report_dir/routing_report/timing_hold_report_PBA.rpt

#Extras Timing Report
report_timing -early -view {view_1} -max_paths 100 > $report_dir/routing_report/timing_post_PnR_early.txt
report_timing -late  -max_paths 100 > $report_dir/routing_report/timing_post_PnR_late.txt
report_timing > $report_dir/routing_report/timing_report.rpt

# Area Analysis
report_area -detail > $report_dir/routing_report/area.rpt

#/*Power Analysis*/
set_power_analysis_mode -reset
set_power_analysis_mode -method static -analysis_view view_1 -corner max -create_binary_db true -write_static_currents true -honor_negative_energy true -ignore_control_signals true
set_power_output_dir -reset
set_power_output_dir ./
set_default_switching_activity -reset
set_default_switching_activity -input_activity 0.2 -period 4
read_activity_file -reset
set_power -reset
set_powerup_analysis -reset
set_dynamic_power_simulation -reset
report_power -rail_analysis_format VS -outfile $report_dir/routing_report/power.rpt
report_power -outfile $report_dir/routing_report/power_report.rpt
#----------------------------------------------------------------------------------GDS------------------------------------------------------------------------------------------
# DRC Report generation:
verify_drc > $report_dir/routing_report/post_route_DRC_vio.rpt

#/*Generating GDS*/
streamOut picorv32_0.5.gds -mapFile streamOut.map -libName DesignLib -units 2000 -mode ALL

#/*Saving the Design*/
saveNetlist picorv32_post_route_netlist_0.5.v
defOut -floorplan -netlist -routing picorv32_0.5.def
saveDesign picorv32_uptoGDS.enc

gui -show

