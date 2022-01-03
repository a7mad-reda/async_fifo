#-----------------------------------------------------------------------
# Clear DC Environment
#-----------------------------------------------------------------------
remove_design -design
remove_test_protocol

#-----------------------------------------------------------------------
# set formaity file
#-----------------------------------------------------------------------
set_svf ../fm/async_fifo_test.svf

#-----------------------------------------------------------------------
# 01 _ Read Desgin
#-----------------------------------------------------------------------
read_ddc ./mapped/async_fifo.ddc
current_design	async_fifo
link

#-----------------------------------------------------------------------
# Declare test components in preparation for create_test_protocol
#-----------------------------------------------------------------------
# Tester Timing Configuration
set test_default_period		100
set test_default_delay		0
set test_default_bidir_delay	0
set test_default_strobe		40

# DFT Signals used during during dft_drc
create_port -direction in test_clk
set_dft_signal -view existing_dft -type ScanClock  -port test_clk  -timing {45 55}
set_dft_signal -view existing_dft -type	reset	   -port wrst_n	   -active_state 0
set_dft_signal -view existing_dft -type	reset 	   -port rrst_n	   -active_state 0
set_dft_signal -view existing_dft -type ScanEnable -port test_se   -active_state 1
set_dft_signal -view existing_dft -type constant   -port atpg_mode -active_state 1

# DFT Signals used during insert_dft
set_dft_signal -view spec -type ScanDataIn  -port test_si
set_dft_signal -view spec -type ScanDataOut -port test_so
set_dft_signal -view spec -type ScanEnable  -port test_se

# Create Ports "Undefined ports in RTL"
create_port -direction in test_mode1
set_dft_signal -view spec -type TestMode -port [list test_mode test_mode1]
for {set i 1} {$i < 4} {incr i} {
	create_port -direction in test_si_$i				;
	set_dft_signal -view spec -type ScanDataIn  -port test_si_$i	;
	create_port -direction out test_so_$i				;
	set_dft_signal -view spec -type ScanDataOut -port test_so_$i	;
}

#-----------------------------------------------------------------------
# 02 _ Create Test Protocol and Pre_insertion dft_drc
#-----------------------------------------------------------------------
create_test_protocol -capture_procedure multi_clock

#-----------------------------------------------------------------------
# 03 _ Pre Scan Insertion DFT_DRC
#-----------------------------------------------------------------------
if { ![file exist reports] } { exec mkdir reports }
if { ![file exist ./reports/test] } { exec mkdir ./reports/test }
exec touch ./reports/test/dft_drc.rpt
set rpt_file [open ./reports/test/dft_drc.rpt w]
puts $rpt_file "#-----------------------------------------------------------------------"
puts $rpt_file "# Pre Scan Insertion DFT_DRC 						"
puts $rpt_file "#-----------------------------------------------------------------------"
puts $rpt_file ""
close $rpt_file
# Enable Enhanced Reporting
set test_disable_enhanced_dft_drc_reporting FALSE
dft_drc >> ./reports/test/dft_drc.rpt

#-----------------------------------------------------------------------
# AutoFix Configuration for DRC Violation
#-----------------------------------------------------------------------
# Enable AutoFixing for Clocks and Resets
current_design "async_fifo"
set_dft_configuration	-fix_clock	enable
set_dft_configuration	-fix_set	enable
set_dft_configuration	-fix_reset	enable

# Declare Signals Used For AutoFixing
set_dft_signal -view spec -type TestData    -port test_clk
set_dft_signal -view spec -type TestData    -port wrst_n
set_dft_signal -view spec -type TestData    -port rrst_n
set_dft_signal -view spec -type TestMode    -port atpg_mode -active_state 1

# AutoFix Cofiguration
set_autofix_configuration -type clock -control_signal atpg_mode -method mux -test_data test_clk
set_autofix_configuration -type reset -control_signal atpg_mode -method mux -test_data wrst_n
set_autofix_configuration -type reset -control_signal atpg_mode -method mux -test_data rrst_n
set_autofix_configuration -type bidirectional -method input

#-----------------------------------------------------------------------
# 04 _ Specify Scan Architecture In Preparation For Scan Insertion
#-----------------------------------------------------------------------
# Declare Test Modes used in Multi-Mode
set_dft_configuration -mode_decoding_style binary
set_dft_configuration -scan_compression enable
define_test_mode TM1 -view spec -encoding {test_mode1 0 test_mode 0} -usage scan
define_test_mode TM2 -view spec -encoding {test_mode1 0 test_mode 1} -usage scan
define_test_mode TM3 -view spec -encoding {test_mode1 1 test_mode 0} -usage scan
define_test_mode TM4 -view spec -encoding {test_mode1 1 test_mode 1} -usage scan_compression

# Set Scan Configuration for each Mode
set_dft_insertion_configuration -preserve_design_name true
set_dft_insertion_configuration -synthesis_optimization none
set_scan_configuration -insert_terminal_lockup disable

set_scan_configuration -chain_count 4 -test_mode TM1 -clock_mixing no_mix
set_scan_configuration -chain_count 2 -test_mode TM2 -clock_mixing no_mix
set_scan_configuration -chain_count 1 -test_mode TM3 -clock_mixing mix_clocks
set_scan_compression_configuration -minimum_compression 5 \
	-base_mode TM1 -test_mode TM4

remove_test_protocol
create_test_protocol -capture_procedure multi_clock

#-----------------------------------------------------------------------
# 05 _ Preview Scan Architecture In Preparation For Scan Insertion
#-----------------------------------------------------------------------
preview_dft -show scan_summary > ./reports/test/preview_dft.rpt
preview_dft -test_points -all >> ./reports/test/preview_dft.rpt

#-----------------------------------------------------------------------
# 06 _ Scan Stitching and applying AutoFix
#-----------------------------------------------------------------------
insert_dft
# Rerun Optimization After Scan Insertion
compile_ultra -incremental -scan

#-----------------------------------------------------------------------
#  07 _ Post Scan Insertion DFT_DRC and Coverage Estimation for each Mode
#-----------------------------------------------------------------------
set rpt_file [open ./reports/test/dft_drc.rpt a]
puts $rpt_file "#-----------------------------------------------------------------------"
puts $rpt_file "# Post Scan Insertion DFT_DRC 						"
puts $rpt_file "#-----------------------------------------------------------------------"
puts $rpt_file ""
close $rpt_file
dft_drc >> ./reports/test/dft_drc.rpt

exec touch ./reports/test/coverage_est.rpt
set rpt_file [open ./reports/test/coverage_est.rpt w]
close $rpt_file

foreach Mode { TM1 TM2 TM2 TM4 } {
current_test_mode $Mode
set rpt_file [open ./reports/test/coverage_est.rpt a]
puts $rpt_file "#-----------------------------------------------------------------------"
puts $rpt_file "# Current Mode >> $Mode		 					"
puts $rpt_file "#-----------------------------------------------------------------------"
puts $rpt_file ""
close $rpt_file
dft_drc -coverage_estimate >> ./reports/test/coverage_est.rpt
}

#-----------------------------------------------------------------------
#  08 _ Handoff Design
#-----------------------------------------------------------------------
change_names -rules verilog -hierarchy
write_scan_def -o mapped_scan/async_fifo.scandef
check_scan_def
write_file -format verilog -hier -out mapped_scan/async_fifo.v
write_file -format ddc -hier -out mapped_scan/async_fifo.ddc
set test_stil_netlist_format verilog
exec mkdir ../tmax
foreach Mode { TM1 TM2 TM3 TM4 } {
write_test_protocol -test_mode $Mode -out ../tmax/async_fifo_$Mode.spf
}

#-----------------------------------------------------------------------
# Stop Recording SVF Optimization changes
#-----------------------------------------------------------------------
set_svf -off

exit
