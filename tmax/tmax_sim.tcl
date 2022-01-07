source $env(SYNOPSYS_TMAX)/auxx/syn/tmax/tmax2pt.tcl
set top_design "async_fifo"
set test_modes {TM1 TM2 TM3 TM4}
foreach mode $test_modes {

#------------------------------------------------------------------------
# 00 _ Save TetraMax Transcript to Log File
#------------------------------------------------------------------------
set_messages -log ./logs/tmax_atpg.log -replace 

#------------------------------------------------------------------------
# 01 _ Restore image saved after previous ATPG
#------------------------------------------------------------------------

read_image ./imgs/${top_design}_${mode}.img.gz
report_pattern -summary

#------------------------------------------------------------------------
# 02 _ Reference the previously generated patterns
#------------------------------------------------------------------------
set_pattern -external ./patterns/gzip/${top_design}.pats_${mode}.gz
report_pattern -summary

#------------------------------------------------------------------------
# 03 _ Generate some reports
#------------------------------------------------------------------------
if {! [file exist ./reports/sim]} {exec mkdir ./reports/sim }
if {! [file exist ./reports/sim/${mode}]} {exec mkdir ./reports/sim/${mode} }
report_pattern -ext -all -type > ./reports/sim/${mode}/pattern_detail.rpt
report_scan_cell -all > ./reports/sim/${mode}/can_cell.rpt

#------------------------------------------------------------------------
# 04 _ Save simulation testbench
#------------------------------------------------------------------------
if {! [file exist ./max_sim/logs]} {exec mkdir ./max_sim/logs }
if {! [file exist ./max_sim/logs/${mode}]} {exec mkdir ./max_sim/logs/${mode} }
if {! [file exist ./max_sim/parallel]} {exec mkdir ./max_sim/parallel }
if {! [file exist ./max_sim/parallel/${mode}]} {exec mkdir ./max_sim/parallel/${mode} }
# parallel simulation testbench 
write_testbench -input ./patterns/${top_design}_${mode}.stil \
	-output ./max_sim/parallel/${mode}/pat_parallel_tb \
	-parameter {-parallel -replace -log ./max_sim/logs/${mode}/pat_parallel_tb.log} 

if {! [file exist ./max_sim/serial]} {exec mkdir ./max_sim/serial }
if {! [file exist ./max_sim/serial/${mode}]} {exec mkdir ./max_sim/serial/${mode} }
# parallel simulation testbench with back annotated delay
write_testbench -input ./patterns/${top_design}_${mode}.stil \
	-output ./max_sim/serial/${mode}/pat_serial_tb \
	-parameter {-serial -replace \
	-log ./max_sim/logs/${mode}/pat_serial_tb.log -sdf_file ./sdf/async_fifo.sdf} 

#------------------------------------------------------------------------
# 05 _ Generate Timing Constraints for STA
#------------------------------------------------------------------------
if {! [file exist ./max_sim/pt]} {exec mkdir ./max_sim/pt }
if {! [file exist ./max_sim/pt/${mode}]} {exec mkdir ./max_sim/pt/${mode} }
write_timing_constraints ./max_sim/pt/${mode}/${top_design}_shift.tcl -mode shift -replace
write_timing_constraints ./max_sim/pt/${mode}/${top_design}_capture.tcl -mode capture -replace

build -force



}
quit

