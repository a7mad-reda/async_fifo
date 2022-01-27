#-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-#
#									#
#		*** primetime script for stuck-at faults  ***		#
#			*** pre pattern validation  ***			#
#		1) STA for at-stuck-at shift  				#
#		2) STA for at-stuck-at capture  			#
#		3) generate generate required reports   		#
#									#
#-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-#

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
	foreach type [list shift stuck_capture] {
		remove_design -all
#---------------------------------------------------------------------
# 02 _ Read_Design
#---------------------------------------------------------------------
read_verilog ../syn/mapped_scan/${top_design}.v
current_design ${top_design}
link

#---------------------------------------------------------------------
# 03 _ Apply Timing Constraints
#---------------------------------------------------------------------
read_sdc ./pt/constraints/${occ_mode}/${mode}/${top_design}_${type}.sdc

#---------------------------------------------------------------------
# 04 _ check For Timing Violations
#---------------------------------------------------------------------
if {! [file exist ./reports/${occ_mode}/pt/stuck_at ]} \
	{ exec mkdir -p ./reports/${occ_mode}/pt/stuck_at }
report_constraints -all_violators > ./reports/${occ_mode}/pt/stuck_at/${mode}_${type}.rpt
report_analysis_coverage >> ./reports/${occ_mode}/pt/stuck_at/${mode}_${type}.rpt

	}
}

#---------------------------------------------------------------------
# 05 _ Generate SDF Bacl Annotated Delay
#---------------------------------------------------------------------
if {! [file exist ./pt/sdf]} { exec mkdir -p ./pt/sdf }
write_sdf ./pt/sdf/${top_design}.sdf

exit


