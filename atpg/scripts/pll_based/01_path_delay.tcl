#-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-#
#									#
#		*** path delay fault model ***				#
#		--> at speed testing for critical paths			#
#		--> critical paths generated by primetime		#
#		--> scan_modes 3 basic_scan - 1 compression_scan 'TM4'	#
#		--> shift -> ate_clock and capture -> on-chip clock	#
#									#
#-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-#

set top_design "async_fifo"
set occ_mode "pll_based"
set fault "path_delay"
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

# don't vary inputs and mask outputs during capture
set_delay -nopi_change
add_po_mask -all

# launch and capture with the same clock
set_delay -common_launch_capture

# avoid pattern simulation failure
set_drc -nodslave_remodel -noreclassify_invalid_dslaves

run_drc -patternexec ${mode}

#------------------------------------------------------------------------
# 03 _ Control and Run ATPG
#------------------------------------------------------------------------
set_fault -model path_delay  

# read critical paths generated by primetime
add_delay_path ./pt/crit_paths/${occ_mode}/${mode}/wclk-wclk_path.rep 
add_delay_path ./pt/crit_paths/${occ_mode}/${mode}/rclk-rclk_path.rep 

if { $mode != "TM4" } {
	add_nofaults -module *COMPRESSOR*
}

add_faults -all
set_atpg -full_seq_abort_limit 100
run_atpg -auto full_sequential_only

#write currents fault for later direct credit 
if {! [file exist ./faults/${occ_mode}/${mode}] } \
	{ exec mkdir -p ./faults/${occ_mode}/${mode} }
write_faults ./faults/${occ_mode}/${mode}/${fault}.flt -all -replace

#------------------------------------------------------------------------
# 04 _ Generate needed files " reports, images, patterns,testbenches "
#------------------------------------------------------------------------
source -e ./scripts/0F_capture_results.tcl

#------------------------------------------------------------------------
# 05 _ Generate Clocks Reports
#------------------------------------------------------------------------
report_clocks -intclocks  >  ./reports/${occ_mode}/${fault}/${mode}/clocks.rpt
report_clocks -pllclocks >>  ./reports/${occ_mode}/${fault}/${mode}/clocks.rpt
report_clocks -matrix >>  ./reports/${occ_mode}/${fault}/${mode}/clocks.rpt


build -force

}
exit