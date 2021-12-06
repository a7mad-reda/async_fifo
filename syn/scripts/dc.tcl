#---------------------------------------------------------------------
# Create Directories
#---------------------------------------------------------------------
if {![file exist bin]} { [exec mkdir bin] }
if {![file exist unmapped]} { [exec mkdir unmapped] }
if {![file exist mapped]} { [exec mkdir mapped] }
if {![file exist scripts]} { [exec mkdir scripts] }
if {![file exist reports]} { [exec mkdir reports] }

define_design_lib WORK -path bin

#---------------------------------------------------------------------
# User-defined variables for logical library setup
#---------------------------------------------------------------------

set ADDITIONAL_SEARCH_PATH        "../libs/mw_lib/sc/LM \
				   ./rtl ./scripts \
				   ./mapped ./unmapped ./rtl "          ;#  Directories containing logic libraries,
                                                                         #  logic design, script files, mapped files, RTL files.
set TARGET_LIBRARY_FILES          sc_max.db                   		;#  Logic cell library file
set SYMBOL_LIBRARY_FILES          sc.sdb                      		;#  Symbol library file

#------------------------------------------------------------------
# Logical Library Settings
#------------------------------------------------------------------
set_app_var search_path "$search_path $ADDITIONAL_SEARCH_PATH"
set_app_var target_library $TARGET_LIBRARY_FILES
set_app_var link_library "* $target_library"
set_app_var symbol_library $SYMBOL_LIBRARY_FILES

#------------------------------------------------------------------
# Verify Setting
#------------------------------------------------------------------
echo "\n------------------------------------------------------"
echo "\nLibrary Settings:"
echo "search_path:             $search_path"
echo "link_library:            $link_library"
echo "target_library:          $target_library"
echo "symbol_library:          $symbol_library"
echo "\n------------------------------------------------------"


set top_design async_fifo
#-----------------------------------------------------------------------
# set formaity file
#-----------------------------------------------------------------------
set_svf ../fm/async_fifo.svf

#-----------------------------------------------------------------------
# Reading Desgin "transilation
#-----------------------------------------------------------------------
analyze -library WORK -format verilog {../rtl/async_fifo.v}
analyze -library WORK -format verilog {../rtl/fifo_mem.v}
analyze -library WORK -format verilog {../rtl/rptr_empty.v}
analyze -library WORK -format verilog {../rtl/wptr_full.v}
analyze -library WORK -format verilog {../rtl/sync.v}
elaborate $top_design

current_design $top_design
link
check_design

#-----------------------------------------------------------------------
# Save Unmapped netlist 
#-----------------------------------------------------------------------
write_file -f ddc -hier -out unmapped/async_fifo.ddc

#-----------------------------------------------------------------------
# Apply and check the timing constraints 
#-----------------------------------------------------------------------
source ./scripts/async_fifo.sdc
check_timing

#-----------------------------------------------------------------------
# Set optimization Parameters
#-----------------------------------------------------------------------
# Maintain Memory block hierarchy
set_ungroup [get_cells "fifo_mem"] false
# Disable Boundary Optimization on Memory
set_boundary_optimization [get_cells "fifo_mem"] false
# Disable Constant Propagation on Memory
set_compile_directives \
	-constant_propagation false [get_cells "fifo_mem"]
# Maintain memory block hierarchy
set_ungroup [get_cells "*sync*"] false
# Prioritize setup timing over DRC violations
set_cost_priority -delay
# Set Host Option for less runtime
set_host_options -max_cores 4


#-----------------------------------------------------------------------
# Compile Design with Adaptive Retiming and Test ready Options
#-----------------------------------------------------------------------
compile_ultra -retime -scan

#-----------------------------------------------------------------------
# Final Area Recovery
#-----------------------------------------------------------------------
optimize_netlist -area

#-----------------------------------------------------------------------
# Find out what blocks have been auto-ungrouped
#-----------------------------------------------------------------------
report_hierarchy -noleaf

#-----------------------------------------------------------------------
# Generate reports
#-----------------------------------------------------------------------
# Report constraints violations
redirect -tee -file reports/constraints.rpt {report_constraint -all}
# Report timing_paths
redirect -tee -file reports/timing.rpt {report_timing -max_paths 10}
# Report Area
redirect -tee -file reports/area.rpt {report_area}
# Report Power
redirect -tee -file reports/power.rpt {report_power}
# Report cell
redirect -tee -file reports/cell.rpt {report_cell}

#-----------------------------------------------------------------------
# Save Mapped "compiled" Design
#-----------------------------------------------------------------------
write_file -f verilog -hier -out mapped/async_fifo.v
write_file -f ddc -hier -out mapped/async_fifo.ddc

#-----------------------------------------------------------------------
# Stop Recording SVF Optimization changes
#-----------------------------------------------------------------------
set_svf -off

exit


