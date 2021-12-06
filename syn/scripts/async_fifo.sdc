reset_design

# Clock Period
set period_src_clk	3
set period_dest_clk	5

# Clock Latency
set src_latency_src_clk		0.7	;# maximum src_clock source latency is 0.7ns
set src_latency_dest_clk	1.1	;# maximum dest_clock source latency is 1.1ns
set net_latency_src_clk		0.3	;# maximum src_clock network latency is 0.3ns
set net_latency_dest_clk	0.5	;# maximum dest_clock network latency is 0.5ns

# Clock Uncertainty 		(MAX"setup" > SKEW + JITTER + SETUP_MARGIN)
set uncertainty_src_clk		0.15	;# src_clk intraclock max uncertainty
set uncertainty_dest_clk	0.25	;# dest_clk intraclock max uncertainty
set uncertainty_src_clk_dest	0.15	;# src_clk to dest_clck interclock max uncertainty
set uncertainty_dest_clk_src	0.15	;# dest_clk to src_clck interclock max uncertainty

# Clock Transition
set transition_src_clk		0.12	;# src_clk max_transition
set transition_dest_clk		0.20	;# dest_clk max_transition

#-----------------------------------------------------------------------
# Clock Definitions
#-----------------------------------------------------------------------
create_clock -name src_clk  -period $period_src_clk [get_ports wclk]
create_clock -name dest_clk -period $period_dest_clk [get_ports rclk]
set_clock_groups -asynchronous -group [get_clocks src_clk] -group [get_clocks dest_clk]

#-----------------------------------------------------------------------
# Clock Latency
#-----------------------------------------------------------------------
# Source Latency

set_clock_latency -source -max $src_latency_src_clk [get_clocks src_clk]
set_clock_latency -source -max $dest_latency_src_clk [get_clocks dest_clk]

# Network Latency

set_clock_latency -max $net_latency_src_clk [get_clocks src_clk]
set_clock_latency -max $net_latency_src_clk [get_clocks dest_clk]

#-----------------------------------------------------------------------
# Clock Uncertainty
#-----------------------------------------------------------------------
# Intraclock_Uncertainty

set_clock_uncertainty -setup $uncertainty_src_clk [get_clocks src_clk]
set_clock_uncertainty -setup $uncertainty_dest_clk [get_clocks des_clk]

# Interclock_Uncertainty

set_clock_uncertainty -setup -from src_clk -to dest_clk $uncertainty_src_clk_dest
set_clock_uncertainty -setup -from dest_clk -to src_clk $uncertainty_dest_clk_src

#-----------------------------------------------------------------------
# Clock Transition
#-----------------------------------------------------------------------

set_clock_transition -max $transition_src_clk [get_clocks src_clk]
set_clock_transition -max $transition_dest_clk [get_clocks dest_clk]


#-----------------------------------------------------------------------
# TIME BUDGETING 40% of clock period available for i/p and o/p paths
#-----------------------------------------------------------------------
# Inputs and outputs delay for write domain

set src_ports_delay "expr {$period_src_clk * 0.6}"

# Inputs and outputs delay for read domain

set dest_ports_delay "expr {$period_dest_clk * 0.6}"

#-----------------------------------------------------------------------
# Input Arrival Time
#-----------------------------------------------------------------------
# Inputs from write domain

set_input_delay -max -clock src_clk $src_ports_delay \
	-source_latency_included -network_latency_included\
	[remove_from_collection [all_inputs] [get_ports "r* near_empty_mrgn wclk"]]

# Inputs from read domain

set_input_delay -max -clock dest_clk $dest_ports_delay \
	-source_latency_included -network_latency_included\
	[remove_from_collection [all_inputs] [get_ports "w* near_full_mrgn rclk"]]

#-----------------------------------------------------------------------
# Output Delay "setup requirements for outputs"
#-----------------------------------------------------------------------
# Outputs to write domain

set_output_delay -max -clock src_clk $src_ports_delay \
	-source_latency_included -network_latency_included \
	[get_ports "full near_full over_flow"]

# Outputs to read domain

set_output_delay -max -clock dest_clk $dest_ports_delay \
	-source_latency_included -network_latency_included \
	[get_ports "empty near_empty under_flow rdata"]

#-----------------------------------------------------------------------
# Input Tansition
#-----------------------------------------------------------------------
# All input ports except clocks and resets are driven by bufbd1 buffers

set_driving_cell -max -lib_cell bufbd1 \
 [remove_from_collection [all_inputs] [get_ports "*clk"]]

set_input_transition -max 0.12 [get_ports *rst]

#-----------------------------------------------------------------------
# Output Load
#-----------------------------------------------------------------------
# All outputs except rdata drive 2x bufbd7 loads

set_load -max [remove_from_collection [all_outputs] [get_ports rdata]]\
	[expr {2 * [load_of cb13fs120_tsmc_max/bufbd7/I]}] 

set_load -max 0.025 [get_ports rdata]


