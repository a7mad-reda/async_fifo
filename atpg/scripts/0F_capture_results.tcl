#-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-#
#									#
#		*** common script for all faults ***			#
#		1) generate required reports				#
#		2) write test patterns					#
#		3) write testbenches for pattern validation		#
#		4) write images for post testing diagnosis		#
#									#
#-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-#

#------------------------------------------------------------------------
# 01 _ Generate ATPG Summaries and Reports
#------------------------------------------------------------------------
if { ! [file exist ./reports/${occ_mode}/${fault}/${mode}] } \
	{ exec mkdir -p ./reports/${occ_mode}/${fault}/${mode} }

# reports setting
set_faults -pt_credit 0 -au_credit 0
set_faults -summary verbose -fault_coverage -report collapsed
set_patterns -histogram_summary
set_faults -fault_coverage

# report coverage
report_summaries >  ./reports/${occ_mode}/${fault}/${mode}/01_coverage.rpt

# report_clocks
report_clocks -intclocks  >  ./reports/${occ_mode}/${fault}/${mode}/clocks.rpt
report_clocks -pllclocks >>  ./reports/${occ_mode}/${fault}/${mode}/clocks.rpt
report_clocks -matrix    >>  ./reports/${occ_mode}/${fault}/${mode}/clocks.rpt

#------------------------------------------------------------------------
# 02 _ Write Image File for Later Post_Testing Diagnosis
#------------------------------------------------------------------------
if { ! [file exist ./imgs/${occ_mode}/${fault}] } \
	{ exec mkdir -p ./imgs/${occ_mode}/${fault} }

write_image ./imgs/${occ_mode}/${fault}/${top_design}_${mode}.img.gz \
	-compress gzip -replace -violations 

#------------------------------------------------------------------------
# 03 _ Write ATPG Patterns
#------------------------------------------------------------------------
if { ! [file exist ./patterns/${occ_mode}/${fault}/gzip] } \
{ exec mkdir -p ./patterns/${occ_mode}/${fault}/gzip }
if { ! [file exist ./patterns/${occ_mode}/${fault}/stil] } \
{ exec mkdir -p ./patterns/${occ_mode}/${fault}/stil }

write_patterns ./patterns/${occ_mode}/${fault}/stil/${top_design}_${mode}.stil  \
	-format stil -unified_stil_flow -replace
write_patterns ./patterns/${occ_mode}/${fault}/gzip/${top_design}_${mode}_pats.gz \
	-format binary -compress gzip -replace

#------------------------------------------------------------------------
# 04 _ Save simulation testbench
#------------------------------------------------------------------------
if {! [file exist ./max_sim/logs]} {exec mkdir -p ./max_sim/logs }
if {! [file exist ./max_sim/parallel/${occ_mode}/${fault}/${mode}]} \
	{exec mkdir -p ./max_sim/parallel/${occ_mode}/${fault}/${mode} }
if {! [file exist ./max_sim/serial/${occ_mode}/${fault}/${mode}]} \
	{exec mkdir -p ./max_sim/serial/${occ_mode}/${fault}/${mode} }

# parallel simulation testbench 
write_testbench -input ./patterns/${occ_mode}/${fault}/stil/${top_design}_${mode}.stil \
	-output ./max_sim/parallel/${occ_mode}/${fault}/${mode}/pat_parallel_tb \
	-parameter {-parallel -replace -log ./max_sim/logs/pat_parallel_tb.log} 
# parallel simulation testbench with back annotated delay
write_testbench -input ./patterns/${occ_mode}/${fault}/stil/${top_design}_${mode}.stil \
	-output ./max_sim/serial/${occ_mode}/${fault}/${mode}/pat_serial_tb \
	-parameter {-serial -replace \
	-log ./max_sim/logs/pat_serial_tb.log -sdf_file ../pt/sdf/async_fifo.sdf} 

