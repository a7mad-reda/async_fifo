#-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-#
#									#
#		*** small delay defect fault model ***			#
#		--> at speed testing based on path slacks		#
#		--> global slacks generated by primetime		#
#		--> scan_modes 3 basic_scan - 1 compression_scan 'TM4'	#
#		--> shift -> ate_clock and capture -> on-chip clock	#
#									#
#-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-#

set top_design "async_fifo"
set occ_mode "pll_based"
set fault "trans_sdd"
set test_modes [list TM1 TM2 TM3 TM4 ]

foreach mode $test_modes {
#------------------------------------------------------------------------
# 01 _ Read Design and Build the ATPG Design Model
#------------------------------------------------------------------------
source -e ./scripts/00_build.tcl

#------------------------------------------------------------------------
# 02 _ Read Test Protocol and set DRC constraints
#------------------------------------------------------------------------
set_drc ./dftc_protocols/${top_design}_${mode}.spf

# read timing exceptions
read_sdc ./pt/constraints/${occ_mode}/${mode}/${top_design}_speed_capture.sdc

# define pll clock as free running clock
add_clock 0 {wclk rclk} -refclock -shift

# constrain signals to certain values during capture
add_pi_constraints 1 {wrst_n rrst_n}
add_pi_constraints 0 test_se

# launch and capture with the same clock
set_delay -common_launch_capture

# avoid pattern simulation failure
set_drc -nodslave_remodel -noreclassify_invalid_dslaves

run_drc -patternexec ${mode}

#------------------------------------------------------------------------
# 03 _ Control and Run ATPG
#------------------------------------------------------------------------
set_fault -model transition  

# read global slacks generated by primetime
read_timing ./pt/slacks/${occ_mode}/${top_design}_${mode}.slack

if { $mode != "TM4" } {
	add_nofaults -module *COMPRESSOR*
}

add_faults -all
set_faults -summary verbose

# set slack setting << delta = detected_path_slack 'tdet' - smallest_path_slack 'tmgn' >>
set_delay -max_tmgn 30%
set_delay -max_delta_per_fault 0.3

run_atpg -auto

# write currents fault for later direct credit 
if {! [file exist ./faults/${occ_mode}/${mode}] } \
	{ exec mkdir -p ./faults/${occ_mode}/${mode} }
write_faults ./faults/${occ_mode}/${mode}/${fault}.flt -all -replace

#------------------------------------------------------------------------
# 04 _ Generate needed files " reports, images, patterns,testbenches "
#------------------------------------------------------------------------
source -e ./scripts/0F_capture_results.tcl

#------------------------------------------------------------------------
# 05 _ Generate Slack Reports
#------------------------------------------------------------------------
report_faults -slack tmgn   >  ./reports/${occ_mode}/${fault}/${mode}/slack.rpt
report_faults -slack tdet  >>  ./reports/${occ_mode}/${fault}/${mode}/slack.rpt
report_faults -slack delta >>  ./reports/${occ_mode}/${fault}/${mode}/slack.rpt



build -force

}
exit
