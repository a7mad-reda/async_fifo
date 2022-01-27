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

# DFT Signals used for dft_drc
set_dft_signal -view existing_dft -type	reset	   -port wrst_n	   -active_state 0
set_dft_signal -view existing_dft -type	reset 	   -port rrst_n	   -active_state 0
set_dft_signal -view existing_dft -type ScanEnable -port test_se   -active_state 1
set_dft_signal -view existing_dft -type constant   -port atpg_mode -active_state 1
# -- # PLLL-Generated Clocks
set_dft_signal -view existing_dft -type ScanClock  -port wclk	   -timing {45 55}
set_dft_signal -view existing_dft -type ScanClock  -port rclk      -timing {45 55}  
# -- # ATE Clocks
create_port -direction in ate_wclk
create_port -direction in ate_rclk
set_dft_signal -view existing_dft -type ScanClock  -port ate_wclk  -timing {45 55}
set_dft_signal -view existing_dft -type ScanClock  -port ate_rclk  -timing {45 55}
# -- # Model ATE clocks as free runnig clocks
set_dft_signal -view existing_dft -type oscillator -port ate_wclk  
set_dft_signal -view existing_dft -type oscillator -port ate_rclk  

# DFT Signals used for insert_dft
set_dft_signal -view spec -type ScanDataIn  -port test_si
set_dft_signal -view spec -type ScanDataOut -port test_so
set_dft_signal -view spec -type ScanEnable  -port test_se
# -- # OCC Controller Interface Signals
create_port -direction in occ_rst
create_port -direction in occ_mode
create_port -direction in pll_bypass
set_dft_signal -view spec -type pll_reset  -port occ_rst
set_dft_signal -view spec -type TestMode   -port occ_mode
set_dft_signal -view spec -type pll_bypass -port pll_bypass

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
set_dft_signal -view spec -type TestData    -port ate_wclk
set_dft_signal -view spec -type TestData    -port ate_rclk
set_dft_signal -view spec -type TestData    -port wrst_n
set_dft_signal -view spec -type TestData    -port rrst_n
set_dft_signal -view spec -type TestMode    -port atpg_mode -active_state 1

# AutoFix Cofiguration
set_autofix_configuration -type clock -control_signal atpg_mode -method mux -test_data ate_wclk
set_autofix_configuration -type clock -control_signal atpg_mode -method mux -test_data ate_rclk
set_autofix_configuration -type reset -control_signal atpg_mode -method mux -test_data wrst_n
set_autofix_configuration -type reset -control_signal atpg_mode -method mux -test_data rrst_n
set_autofix_configuration -type bidirectional -method input

#-----------------------------------------------------------------------
# 04 _ Specify Scan Architecture In Preparation For Scan Insertion
#-----------------------------------------------------------------------
# Enable PLL on-chip clock controller capability 
set_dft_configuration -clock_controller enable
set_app_var test_occ_insert_clock_gating_cells true
# Configuring the OCC Controllers to be synthesized
set_dft_clock_controller \
	-cell_name 		occ_wclk	\
	-design_name		snps_clk_mux	\
	-pllclocks 		wclk		\
	-ateclocks		ate_wclk	\
	-chain_count		1		\
	-cycles_per_clock	8		\
	-test_mode_port 	occ_mode
set_dft_clock_controller \
	-cell_name 		occ_rclk	\
	-design_name		snps_clk_mux	\
	-pllclocks 		rclk		\
	-ateclocks		ate_rclk	\
	-chain_count		1		\
	-cycles_per_clock	8		\
	-test_mode_port 	occ_mode

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
report_dft_clock_controller -view spec > ./reports/test/occ_ctrl.rpt

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

exec touch ./reports/test/coverage_est.rpt
set rpt_file [open ./reports/test/coverage_est.rpt w]
close $rpt_file

foreach Mode { TM1 TM2 TM2 TM4 } {

current_test_mode $Mode
# Run DRC with PLL internal clocks enabled during capture
set_dft_drc_configuration -pll_bypass disable
dft_drc >> ./reports/test/dft_drc.rpt
# Run DRC with external clocks enabled during capture
set_dft_drc_configuration -pll_bypass enable
dft_drc >> ./reports/test/dft_drc.rpt

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
exec mkdir -p ../atpg/dftc_protocols
foreach Mode { TM1 TM2 TM3 TM4 } {
# Write out combined PLL enabled/bypassed test protocol
write_test_protocol -test_mode $Mode -out ../atpg/dftc_protocols/async_fifo_$Mode.spf
}

#----------------------------------------------------------------------
# Stop Recording SVF Optimization changes
#----------------------------------------------------------------------
set_svf -off

exit
