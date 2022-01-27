#-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-#
#									#
#		*** common script for all faults ***			#
#		1) read design and simualtion library			#
#		2) build test model 					#
#									#
#-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-#

#------------------------------------------------------------------------
# 00 _ Save TetraMax Transcript to Log File
#------------------------------------------------------------------------
if { $mode == {TM1} } { 

if { ! [file exist ./logs/${occ_mode}/${fault}] } \
	{ exec mkdir -p ./logs/${occ_mode}/${fault} }

set_messages -log ./logs/${occ_mode}/${fault}/tmax_atpg.log -replace  

#------------------------------------------------------------------------
# 01 _ Read Libraries and Design
#------------------------------------------------------------------------
if { ! [file exist ./reports/${occ_mode}/${fault}] } \
	{ exec mkdir -p ./reports/${occ_mode}/${fault} }

read_netlist ../libs/mw_lib/tmax/libs.v.gz
read_netlist ../syn/mapped_scan/${top_design}.v

report_modules -undefined > ./reports/${occ_mode}/${fault}/01_read.rpt

}

#------------------------------------------------------------------------
# 02 _ Build ATPG Design Model
#------------------------------------------------------------------------
run_build_model  $top_design

report_modules -summary >  ./reports/${occ_mode}/${fault}/02_build.rpt
report_modules -errors  >> ./reports/${occ_mode}/${fault}/02_build.rpt
