if {! [file exist ./reports]} { exec mkdir ./reports }
set top_design "async_fifo"

#---------------------------------------------------------------------
# 01 _ Load Libraries
#---------------------------------------------------------------------
set TARGET_LIBRARY_FILES "../../../libs/mw_lib/sc/LM/sc_max.db"
set_app_var target_library $TARGET_LIBRARY_FILES
set_app_var link_library "* $target_library"


foreach mode [list TM1 TM2 TM3 TM4] {
	foreach type [list shift capture] {
		remove_design -all
#---------------------------------------------------------------------
# 02 _ Read_Design
#---------------------------------------------------------------------
read_verilog ../../../syn/mapped_scan/${top_design}.v
current_design ${top_design}
link

#---------------------------------------------------------------------
# 03 _ Apply Timing Constraints
#---------------------------------------------------------------------
source ./${mode}/${top_design}_${type}.tcl

#---------------------------------------------------------------------
# 04 _ check For Timing Violations
#---------------------------------------------------------------------
report_constraints -all_violators > ./reports/${mode}_${type}.rpt
report_analysis_coverage >> ./reports/${mode}_${type}.rpt

	}
}

#---------------------------------------------------------------------
# 05 _ Generate SDF Bacl Annotated Delay
#---------------------------------------------------------------------
if {! [file exist ../sdf]} { exec mkdir ../sdf }
write_sdf ../sdf/${top_design}.sdf

exit


