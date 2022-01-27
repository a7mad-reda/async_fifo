#-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-#
#									#
#		*** iddq fault model ***				#
#		--> scan_modes 3 basic_scan - 1 compression_scan 'TM4'	#
#		--> shift -> ate_clock and capture -> on-chip clock	#
#									#
#-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-#

set top_design "async_fifo"
set occ_mode "pll_based"
set fault "iddq"
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

# constrain signals to certain values during capture
add_pi_constraints 1 ren
add_pi_constraints 1 wen
add_pi_constraints 0 rptr_clr
add_pi_constraints 0 wptr_clr

# avoid pattern simulation failure
set_drc -nodslave_remodel -noreclassify_invalid_dslaves

run_drc -patternexec ${mode}_occ_bypass

#------------------------------------------------------------------------
# 03 _ Control and Run ATPG
#------------------------------------------------------------------------
set_faults -model iddq
# pseudo-stuck-at is the default
set_iddq -toggle      
add_faults -all
# budget of 20 IDDQ strobes
set_atpg -patterns 20   
run_atpg -auto_compression

# write currents fault for later direct credit 
if {! [file exist ./faults/${occ_mode}/${mode}] } \
	{ exec mkdir -p ./faults/${occ_mode}/${mode} }
write_faults ./faults/${occ_mode}/${mode}/${fault}.flt -all -replace

#------------------------------------------------------------------------
# 04 _ Generate needed files " reports, images, patterns,testbenches "
#------------------------------------------------------------------------
source -e ./scripts/0F_capture_results.tcl

#------------------------------------------------------------------------
# 05 _ Report "Not Detected and ATPG Untestable" Faults
#------------------------------------------------------------------------
report_faults -class {nd au} -level 4 23 \
	>  ./reports/${occ_mode}/${fault}/${mode}/02_nd_au_faults.rpt
analyze_faults -class nd >>  ./reports/${occ_mode}/${fault}/${mode}/02_nd_au_faults.rpt
analyze_faults -class au >>  ./reports/${occ_mode}/${fault}/${mode}/02_nd_au_faults.rpt



build -force

}
exit
