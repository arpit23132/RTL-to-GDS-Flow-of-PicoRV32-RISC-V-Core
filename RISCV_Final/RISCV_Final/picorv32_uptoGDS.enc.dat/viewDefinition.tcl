if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name timing_lib\
   -timing\
    [list ${::IMEX::libVar}/mmmc/slow.lib]
create_rc_corner -name default_rc_corner\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0
create_delay_corner -name delay_1\
   -early_library_set timing_lib\
   -late_library_set timing_lib
create_constraint_mode -name sdc_1\
   -sdc_files\
    [list ${::IMEX::libVar}/mmmc/dft_constraints.sdc]
create_analysis_view -name view_1 -constraint_mode sdc_1 -delay_corner delay_1
set_analysis_view -setup [list view_1] -hold [list view_1]
