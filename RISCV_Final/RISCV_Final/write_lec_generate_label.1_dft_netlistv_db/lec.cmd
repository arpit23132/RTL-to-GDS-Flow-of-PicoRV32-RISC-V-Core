SET PARAllel Option -threads 1,4 -norelease_license
SET COmpare Options -threads 1,4
SET UNDEfined Cell black_box -noascend -both
ADD SEarch Path . /cadence/GENUS191/tools.lnx86/lib/tech -library -both
REAd LIbrary -liberty -both /home/arpit23132/Desktop/RISCV_Final/slow.lib
REAd DEsign -verilog95 -golden -lastmod -noelab final.v
ELAborate DEsign -golden -root picorv32
REAd DEsign -verilog95 -revised -lastmod -noelab dft_netlist.v
ELAborate DEsign -revised -root picorv32
REPort DEsign Data
REPort BLack Box
SET FLatten Model -seq_constant
SET FLatten Model -seq_constant_x_to 0
SET FLatten Model -nodff_to_dlat_zero
SET FLatten Model -nodff_to_dlat_feedback
SET FLatten Model -hier_seq_merge
ADD PIn Constraints 0 test_mode -golden
ADD PIn Constraints 0 shift_en -golden
ADD IGnored Outputs DFT_sdo_1 -golden
ADD PIn Constraints 0 test_mode -revised
ADD PIn Constraints 0 shift_en -revised
ADD IGnored Outputs DFT_sdo_1 -revised
SET ANalyze Option -auto -report_map
SET SYstem Mode lec
REPort UNmapped Points -summary
REPort UNmapped Points -notmapped
ADD COmpared Points -all
COMpare
REPort COmpare Data -class nonequivalent -class abort -class notcompared
REPort VErification -verbose
REPort STatistics
WRIte VErification Information
REPort VErification Information
ANAlyze RESults -logfiles lec_dft.log
EXIt -f
