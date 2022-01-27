#-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-#
#									#
#		*** design constraints and exceptions  ***		#
#			*** for at_speed capture  ***			#
#									#
#-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-#

# Clock Period
set period_src_clk	3.0
set period_dest_clk	7.0

# Clock Transition
set transition_src_clk		0.12	;# src_clk max_transition
set transition_dest_clk		0.28	;# dest_clk max_transition

#-----------------------------------------------------------------------
# Clock Definitions
#-----------------------------------------------------------------------
create_clock -name src_clk  -period $period_src_clk [get_ports wclk]
create_clock -name dest_clk -period $period_dest_clk [get_ports rclk]
set_clock_groups -asynchronous -group [get_clocks src_clk] -group [get_clocks dest_clk]

#-----------------------------------------------------------------------
# Clock Transition
#-----------------------------------------------------------------------

set_clock_transition -max $transition_src_clk [get_clocks src_clk]
set_clock_transition -max $transition_dest_clk [get_clocks dest_clk]

#-----------------------------------------------------------------------
# Constrain the Design to be in TEST MODE
#-----------------------------------------------------------------------
set_case_analysis 1 [get_ports wrst_n]
set_case_analysis 1 [get_ports rrst_n]
set_case_analysis 1 [get_ports atpg_mode]
set_case_analysis 0 [get_ports test_se]
set_case_analysis 0 [get_ports occ_rst]
set_case_analysis 1 [get_ports occ_mode]
set_case_analysis 0 [get_ports pll_bypass]

#-----------------------------------------------------------------------
# define false paths
#-----------------------------------------------------------------------
set_false_path -through occ_rclk/fast_clk_clkgt/cg_latch_reg
set_false_path -through occ_rclk/slow_clk_clkgt/cg_latch_reg


