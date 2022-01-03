#-----------------------------------------------------------------------
# set formaity file
#-----------------------------------------------------------------------
set_svf ../fm/async_fifo.svf

#-----------------------------------------------------------------------
# Reading Desgin "transilation"
#-----------------------------------------------------------------------
set top_design "async_fifo"
analyze -library WORK -format verilog {../rtl/async_fifo.v}
analyze -library WORK -format verilog {../rtl/dpram.v}
analyze -library WORK -format verilog {../rtl/rptr_empty.v}
analyze -library WORK -format verilog {../rtl/wptr_full.v}
analyze -library WORK -format verilog {../rtl/sync.v}
analyze -library WORK -format verilog {../rtl/sync_rst.v}
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
# Apply Optimization Techniques
#-----------------------------------------------------------------------
# Maintain Memory block hierarchy
set_ungroup [get_cells "fifo_mem"] false

# Disable Boundary Optimization on Memory
set_boundary_optimization [get_cells "fifo_mem"] false

# Disable Constant Propagation on Memory
set_compile_directives \
	-constant_propagation false [get_cells "fifo_mem"]

# Maintain synchronizer block hierarchy
set_ungroup [get_cells "*sync*"] false

# Prioritize setup timing over DRC violations
set_cost_priority -delay

# Set Host Option for less runtime
set_host_options -max_cores 4

#-----------------------------------------------------------------------
# Compile Design with Adaptive Retiming and Scan replacement
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
change_names –rules verilog -hierarchy
write_file -f verilog -hier -out mapped/async_fifo.v
write_file -f ddc -hier -out mapped/async_fifo.ddc

#-----------------------------------------------------------------------
# Stop Recording SVF Optimization changes
#-----------------------------------------------------------------------
set_svf -off

exit


