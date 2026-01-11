REAd IMplementation Information fv/picorv32 -golden fv_map -revised finalv
SET PARAllel Option -threads 1,4 -norelease_license
SET COmpare Options -threads 1,4
SET UNDEfined Cell black_box -noascend -both
ADD SEarch Path . /home/arpit23132/Desktop/RISCV_Final -library -both
REAd LIbrary -liberty -both /home/arpit23132/Desktop/RISCV_Final/slow.lib /home/arpit23132/Desktop/RISCV_Final/slow.lib
REAd DEsign -verilog95 -golden -lastmod -noelab fv/picorv32/fv_map.v.gz
ELAborate DEsign -golden -root picorv32
REAd DEsign -verilog95 -revised -lastmod -noelab final.v
ELAborate DEsign -revised -root picorv32
REPort DEsign Data
REPort BLack Box
SET FLatten Model -seq_constant
SET FLatten Model -seq_constant_x_to 0
SET FLatten Model -nodff_to_dlat_zero
SET FLatten Model -nodff_to_dlat_feedback
SET FLatten Model -hier_seq_merge
SET ANalyze Option -auto -report_map
SET SYstem Mode lec
REPort UNmapped Points -summary
REPort UNmapped Points -notmapped
ADD COmpared Points -all
COMpare
REPort COmpare Data -class nonequivalent -class abort -class notcompared
REPort VErification -verbose
REPort STatistics
REPort VErification
WRIte VErification Information
REPort VErification Information
REPort IMplementation Information
RESET
SET VErification Information rtl_fv_map_db
REAd IMplementation Information fv/picorv32 -revised fv_map
SET PARAllel Option -threads 1,4 -norelease_license
SET COmpare Options -threads 1,4
SET UNDEfined Cell black_box -noascend -both
ADD SEarch Path . /home/arpit23132/Desktop/RISCV_Final -library -both
REAd LIbrary -liberty -both /home/arpit23132/Desktop/RISCV_Final/slow.lib /home/arpit23132/Desktop/RISCV_Final/slow.lib
SET UNDRiven Signal 0 -golden
SET NAming Style rc -golden
SET NAming Rule %s[%d] -instance_array -golden
SET NAming Rule %s_reg -register -golden
SET NAming Rule %L.%s %L[%d].%s %s -instance -golden
SET NAming Rule %L.%s %L[%d].%s %s -variable -golden
SET NAming Rule -ungroup_separator _ -golden
SET HDl Options -const_port_extend
SET HDl Options -VERILOG_INCLUDE_DIR incdir:sep:src:cwd
ADD SEarch Path . -design -golden
REAd DEsign -define ENABLE_IRQ=0 -define ENABLE_TRACE=0 -define ENABLE_PCPI=0 -define SYNTHESIS -merge\
   bbox -golden -lastmod -noelab -verilog2k picorv32.v
ELAborate DEsign -golden -root picorv32 -rootonly -rootonly
REAd DEsign -verilog95 -revised -lastmod -noelab fv/picorv32/fv_map.v.gz
ELAborate DEsign -revised -root picorv32
UNIQuify -all -nolib -golden
REPort DEsign Data
REPort BLack Box
SET FLatten Model -seq_constant
SET FLatten Model -seq_constant_x_to 0
SET FLatten Model -nodff_to_dlat_zero
SET FLatten Model -nodff_to_dlat_feedback
SET FLatten Model -hier_seq_merge
SET FLatten Model -balanced_modeling
SET ANalyze Option -auto -report_map
WRIte HIer_compare Dofile hier_tmp2.lec.do -noexact_pin_match -constraint -usage -replace -balanced_extraction -input_output_pin_equivalence\
   -prepend_string "report_design_data; report_unmapped_points -summary; report_unmapped_points -notmapped; analyze_datapath -module -verbose ; eval analyze_datapath -flowgraph -verbose"
RUN HIer_compare hier_tmp2.lec.do -dynamic_hierarchy
REPort HIer_compare Result -dynamicflattened
REPort VErification -hier -verbose
WRIte VErification Information
REPort VErification Information
REPort IMplementation Information
SET SYstem Mode lec
ANAlyze RESults -logfiles lec.log
EXIt -f
