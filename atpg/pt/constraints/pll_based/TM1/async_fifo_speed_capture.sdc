###############################################################################
#
# Created by PrimeTime write_sdc on Fri Jan 28 02:47:47 2022
#
###############################################################################

set sdc_version 2.1

set_units -time ns -capacitance pF -current uA -voltage V -resistance kOhm
###############################################################################
#  
# Units
# capacitive_load_unit           : 1 pF
# current_unit                   : 1e-06 A
# resistance_unit                : 1 kOhm
# time_unit                      : 1 ns
# voltage_unit                   : 1 V
###############################################################################
set_operating_conditions -analysis_type on_chip_variation  -library [get_libs \
 {sc_max.db:cb13fs120_tsmc_max}] 
###############################################################################
# Clock Related Information
###############################################################################
create_clock -name src_clk -period 3 -waveform { 0 1.5 } [get_ports {wclk}]
set_clock_transition -rise -max  0.12 [get_clocks {src_clk}]
set_clock_transition -fall -max  0.12 [get_clocks {src_clk}]
create_clock -name dest_clk -period 7 -waveform { 0 3.5 } [get_ports {rclk}]
set_clock_transition -rise -max  0.28 [get_clocks {dest_clk}]
set_clock_transition -fall -max  0.28 [get_clocks {dest_clk}]
set_clock_groups -asynchronous -name src_clk_1 -group [get_clocks {src_clk}] \
 -group [get_clocks {dest_clk}]
###############################################################################
# Point to Point exceptions
###############################################################################
set_false_path -from [get_clocks {dest_clk}] -to [get_clocks {src_clk}]
set_false_path -from [get_clocks {src_clk}] -to [get_clocks {dest_clk}]
set_false_path -through [get_pins {occ_rclk/fast_clk_clkgt/cg_latch_reg/Q}] 
set_false_path -through [get_pins {occ_rclk/slow_clk_clkgt/cg_latch_reg/Q}] 
set_case_analysis 1 [get_ports {wrst_n}]
set_case_analysis 1 [get_ports {rrst_n}]
set_case_analysis 1 [get_ports {atpg_mode}]
set_case_analysis 0 [get_ports {test_se}]
set_case_analysis 0 [get_ports {occ_rst}]
set_case_analysis 1 [get_ports {occ_mode}]
set_case_analysis 0 [get_ports {pll_bypass}]
set_case_analysis 0 [get_ports {test_mode}]
set_case_analysis 0 [get_ports {test_mode1}]
###############################################################################
# POCV Information
###############################################################################
