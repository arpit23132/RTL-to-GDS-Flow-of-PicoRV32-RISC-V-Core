#creating directories for report
#file mkdir placement_reports_1/after_placement_report
#file mkdir placement_reports_1/before_placement_report
file mkdir placement_reports_1/post_CTS_opt
#Making Directory to store all the reports post CTS optimization
file mkdir placement_reports_1/routing_report
#Creates Directory to store all the routing reports
file mkdir placement_reports_1/post_CTS_report

set report_dir placement_reports_1
#Set the name of directory as report_dir to use further in the script

file mkdir placement_reports_1/routing_report
#Creates Directory to store all the routing reports
file mkdir placement_reports_1/post_CTS_report

set init_gnd_net VSS 
# naming the GND net as VSS
set init_io_file pin_location.io 
#Setting up IO placement file
set init_lef_file gsclib090_translated_ref.lef 
#LEF file for physical design
set init_mmmc_file rtl_module.view
set init_pwr_net VDD 
#naming the Power net as VDD

# >>> CHANGED: top module + netlist for YOUR design
set init_top_cell picorv32 
#Defining top module
set init_verilog dft_netlist.v 
#Setting the netlist

init_design 
#Initial the innovus design session. This command typically reads the LEF,netlist, and other initization variables. Creates the design database for placement, routing.

#----------------------------------------------------------------------------------FLOOR_PLANNING------------------------------------------------------------------------------------------

setDesignMode -process 90 -flowEffort standard
# Setting the technology as 90nm and flow effort as Standard

#/* Sanity check before Floorplanning*/
checkDesign -physicalLibrary; 	#Sanity check of physical library -lef file
#Runs a check of Physical Library
checkDesign -timingLibrary; 	#Sanity check of timing library 
checkDesign -netlist; 		#Sanity check of dft netlist
check_timing; 			#Sanity check of timing reports of min and max path


#Actual Floor Plainnng
getIoFlowFlag
setIoFlowFlag 0
#disables automated IO placement flows


#floorplanning die siting according to Innovus LRM
floorPlan -fplanOrigin center -site gsclib090site -r 1 0.65 10.0 10.0 10.0 10.0
setResizeFPlanMode -shiftBased true -ioMoveWithEdge true
resizeFloorplan -xSize 2 -ySize 2
# Placement site 
#Did some changes using GUI
