set top_design "async_fifo"

#------------------------------------------------------------------------
# 00 _ Save TetraMax Transcript to Log File
#------------------------------------------------------------------------
set_messages -log ./logs/tmax_atpg.log -replace 

#------------------------------------------------------------------------
# 01 _ Read Libraries and Design
#------------------------------------------------------------------------
read_netlist ../libs/mw_lib/tmax/libs.v.gz
read_netlist ../syn/mapped_scan/${top_design}.v
report_modules -undefined > ./reports/01_read.rpt

#------------------------------------------------------------------------
# 02 _ Build the ATPG Design Model
#------------------------------------------------------------------------
set test_modes [list TM1 TM2 TM3 TM4]
foreach mode $test_modes {
	exec mkdir ./reports/mode_$mode

run_build_model  $top_design
report_modules -summary >  ./reports/02_build.rpt
report_modules -errors  >> ./reports/02_build.rpt

#------------------------------------------------------------------------
# 03 _ Read Test Protocol and Check Dft Ruls
#------------------------------------------------------------------------
set_drc ./test_protocols/${top_design}_${mode}.spf
run_drc

#------------------------------------------------------------------------
# 04 _ Control and Run ATPG
#------------------------------------------------------------------------
# Setup ATPG
if { $mode != "TM4" } {
	add_nofaults -module *COMPRESSOR*
}
add_faults -all
report_summaries sequential_depths

# Run ATPG
set_atpg -abort 100
run_atpg -auto basic_scan_only

set_atpg -capture_cycles 5
run_atpg -auto fast_sequential_only

set_atpg -full_seq_atpg
set_atpg -full_seq_time 0
set_atpg -full_seq_abort_limit 10
run_atpg -auto full_sequential_only

# Review Test Coverage
set_faults -pt_credit 0 -au_credit 0
set_faults -summary verbose -fault_coverage -report collapsed
set_patterns -histogram_summary
set_faults -fault_coverage
report_summaries >  ./reports/mode_${mode}/01_coverage.rpt
report_faults -class {nd au} -level 4 23 \
	>  ./reports/mode_${mode}/04_nd_au_faults.rpt
analyze_faults -class nd >>  ./reports/mode_${mode}/02_nd_au_faults.rpt
analyze_faults -class au >>  ./reports/mode_${mode}/02_nd_au_faults.rpt

#------------------------------------------------------------------------
# 05 _ Write ATPG Patterns
#------------------------------------------------------------------------
write_patterns patterns/${top_design}_${mode}.stil  -format stil \
	-unified_stil_flow -replace
if {! [file exist ./patterns/gzip]} { exec mkdir ./patterns/gzip }
write_patterns ./patterns/gzip/${top_design}.pats_${mode}.gz -format binary -compress gzip -replace

#------------------------------------------------------------------------
# 05 _ Write Image File for Later Diagnosis
#------------------------------------------------------------------------
write_image ./imgs/${top_design}_${mode}.img.gz -compress gzip -replace -violations 


build -force

}
exit
echo "Finshed"
