#-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-#
#									#
#		*** primetime script for at speed faults  ***		#
#		1) STA for at-speed capture  				#
#		2) update exception from violation  			#
#		3) generate global slacks   				#
#		4) generate critical paths   				#
#		5) generate sdf back-annotated delay   			#
#		6) generate generate required reports   		#
#									#
#-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-#

source $env(TMAX_HOME)/auxx/syn/tmax/pt2tmax.tcl

set top_design "async_fifo"
set occ_mode "pll_based"
set test_modes [list TM1 TM2 TM3 TM4]

#---------------------------------------------------------------------
# 01 _ Load Libraries
#---------------------------------------------------------------------
set TARGET_LIBRARY_FILES "../libs/mw_lib/sc/LM/sc_max.db"
set_app_var target_library $TARGET_LIBRARY_FILES
set_app_var link_library "* $target_library"


foreach mode ${test_modes} {
if { $mode != {TM1} } { remove_design -all }
#---------------------------------------------------------------------
# 02 _ Read_Design
#---------------------------------------------------------------------
read_verilog ../syn/mapped_scan/${top_design}.v
current_design ${top_design}
link

#---------------------------------------------------------------------
# 03 _ Apply Timing Constraints
#---------------------------------------------------------------------
read_sdc ./scripts/${occ_mode}/TX_${top_design}_test.sdc
switch $mode {
	TM1 { set a 0 ; set b 0 ; }
	TM2 { set a 0 ; set b 1 ; }
	TM3 { set a 1 ; set b 0 ; }
	TM4 { set a 1 ; set b 1 ; }
}
set_case_analysis $a [get_ports test_mode ]
set_case_analysis $b [get_ports test_mode1]

#---------------------------------------------------------------------
# 04 _ Generate Timing Reports
#---------------------------------------------------------------------
if {! [file exist ./reports/${occ_mode}/pt/at_speed ]} \
	{ exec mkdir -p ./reports/${occ_mode}/pt/at_speed }
report_constraints -all_violators > ./reports/${occ_mode}/pt/at_speed/${mode}_capture.rpt
report_analysis_coverage >> ./reports/${occ_mode}/pt/at_speed/${mode}_capture.rpt

#---------------------------------------------------------------------
# 05 _ Update Exceptions to mask violations for Transion Fault ATPG
#---------------------------------------------------------------------
if {! [file exist ./pt/constraints/${occ_mode}/${mode} ]} \
	{ exec mkdir -p ./pt/constraints/${occ_mode}/${mode} }
write_exceptions_from_violations -delay_type min_max 
write_sdc ./pt/constraints/${occ_mode}/${mode}/${top_design}_speed_capture.sdc
report_analysis_coverage >> ./reports/${occ_mode}/pt/at_speed/${mode}_capture_updated.rpt

#---------------------------------------------------------------------
# 06 _ Generat Global Slacks for SDD ATPG
#---------------------------------------------------------------------
if {! [file exist ./pt/slacks/${occ_mode} ]} \
	{ exec mkdir -p ./pt/slacks/${occ_mode} }
report_global_slack > ./pt/slacks/${occ_mode}/${top_design}_${mode}.slack



#---------------------------------------------------------------------
# 07 _ Generat Critical Paths for Path Delay ATPG
#---------------------------------------------------------------------
if {! [file exist ./pt/crit_paths/${occ_mode}/${mode} ]} \
	{ exec mkdir -p ./pt/crit_paths/${occ_mode}/${mode} }
write_delay_paths -launch src_clk -capture src_clk -max_paths 60 \
	./pt/crit_paths/${occ_mode}/${mode}/wclk-wclk_path.rep   
write_delay_paths -launch dest_clk -capture dest_clk -max_paths 60 \
	./pt/crit_paths/${occ_mode}/${mode}/rclk-rclk_path.rep 

}

#---------------------------------------------------------------------
# 08 _ Generate SDF Bacl Annotated Delay include both the user and vioaltion exceptions
#---------------------------------------------------------------------
if {! [file exist ./pt/sdf]} { exec mkdir -p ./pt/sdf }
write_sdf ./pt/sdf/${top_design}.sdf

exit
