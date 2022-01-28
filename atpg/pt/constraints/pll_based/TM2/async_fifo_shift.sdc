
# PrimeTime (R) Tcl script created by tmax2pt.tcl
# Creation time: Fri Jan 28 02:48:20 2022
# tmax2pt.tcl version: N-2017.09: 2017/08/04 18:10:33 
# arguments: ./pt/constraints/pll_based/TM2/async_fifo_shift.sdc -mode shift -replace -wft _default_WFT_


# Note: any existing constraints or exceptions may invalidate those
# here.  Uncomment the following to reset everything except the linked
# design.
# reset_design

set timing_enable_preset_clear_arcs true

    

# clocks
suppress_message UITE-210
create_clock -name wclk_wft1 -period 	    100 -waveform { 45 55 } [get_ports wclk]
create_clock -name rclk_wft1 -period 	    100 -waveform { 45 55 } [get_ports rclk]
# Clock wrst_n is constrained off, so no create_clock command is printed for it.
# Clock rrst_n is constrained off, so no create_clock command is printed for it.
create_clock -name ate_wclk_wft1 -period 100 -waveform { 45 55 } [get_ports ate_wclk]
create_clock -name ate_rclk_wft1 -period 100 -waveform { 45 55 } [get_ports ate_rclk]
unsuppress_message UITE-210

# Note: uncomment any of the following sections as appropriate.
#
## pre-layout design
#set clock_delay 0
#set_clock_latency $clock_delay [all_clocks]
#
## post-layout design
#set_propagated_clock [all_clocks]
#
#set intra_clock_skew 0
#set inter_clock_skew 0
#set_clock_uncertainty $intra_clock_skew [all_clocks]
#foreach_in_collection from_clock [all_clocks] {
#  foreach_in_collection to_clock [all_clocks] {
#    if {[get_attribute $from_clock full_name] !=
#        [get_attribute $to_clock full_name]} {
#      set_clock_uncertainty $inter_clock_skew -from $from_clock -to $to_clock
#    }
#  }
#}
    

# virtual clocks for PI, PO & PIO events
suppress_message UITE-121
create_clock -name forcePI_wft1 -period 100     -waveform { 0 1 } 
create_clock -name measurePO_wft1 -period 100     -waveform { 0 40 } 
unsuppress_message UITE-121

# PI & PIO settings
set_case_analysis 1 [get_ports wrst_n]
set_input_delay 0 -clock forcePI_wft1                 [get_ports wen]
set_input_delay 0 -clock forcePI_wft1                 [get_ports wptr_clr]
set_input_delay 0 -clock forcePI_wft1                 [get_ports wdata[7]]
set_input_delay 0 -clock forcePI_wft1                 [get_ports wdata[6]]
set_input_delay 0 -clock forcePI_wft1                 [get_ports wdata[5]]
set_input_delay 0 -clock forcePI_wft1                 [get_ports wdata[4]]
set_input_delay 0 -clock forcePI_wft1                 [get_ports wdata[3]]
set_input_delay 0 -clock forcePI_wft1                 [get_ports wdata[2]]
set_input_delay 0 -clock forcePI_wft1                 [get_ports wdata[1]]
set_input_delay 0 -clock forcePI_wft1                 [get_ports wdata[0]]
set_case_analysis 1 [get_ports rrst_n]
set_input_delay 0 -clock forcePI_wft1                 [get_ports ren]
set_input_delay 0 -clock forcePI_wft1                 [get_ports rptr_clr]
set_input_delay 0 -clock forcePI_wft1                 [get_ports near_full_mrgn[4]]
set_input_delay 0 -clock forcePI_wft1                 [get_ports near_full_mrgn[3]]
set_input_delay 0 -clock forcePI_wft1                 [get_ports near_full_mrgn[2]]
set_input_delay 0 -clock forcePI_wft1                 [get_ports near_full_mrgn[1]]
set_input_delay 0 -clock forcePI_wft1                 [get_ports near_full_mrgn[0]]
set_input_delay 0 -clock forcePI_wft1                 [get_ports near_empty_mrgn[4]]
set_input_delay 0 -clock forcePI_wft1                 [get_ports near_empty_mrgn[3]]
set_input_delay 0 -clock forcePI_wft1                 [get_ports near_empty_mrgn[2]]
set_input_delay 0 -clock forcePI_wft1                 [get_ports near_empty_mrgn[1]]
set_input_delay 0 -clock forcePI_wft1                 [get_ports near_empty_mrgn[0]]
set_input_delay 0 -clock forcePI_wft1                 [get_ports test_si]
set_case_analysis 1 [get_ports test_se]
set_case_analysis 1 [get_ports atpg_mode]
set_case_analysis 1 [get_ports test_mode]
set_case_analysis 0 [get_ports occ_rst]
set_case_analysis 1 [get_ports occ_mode]
set_case_analysis 1 [get_ports pll_bypass]
set_case_analysis 0 [get_ports test_mode1]
set_input_delay 0 -clock forcePI_wft1                 [get_ports test_si_1]
set_input_delay 0 -clock forcePI_wft1                 [get_ports test_si_2]
set_input_delay 0 -clock forcePI_wft1                 [get_ports test_si_3]

# PO and PIO settings
set_output_delay 0 -clock measurePO_wft1             [get_ports rdata[7]] -clock_fall
set_output_delay 0 -clock measurePO_wft1             [get_ports rdata[6]] -clock_fall
set_output_delay 0 -clock measurePO_wft1             [get_ports rdata[5]] -clock_fall
set_output_delay 0 -clock measurePO_wft1             [get_ports rdata[4]] -clock_fall
set_output_delay 0 -clock measurePO_wft1             [get_ports rdata[3]] -clock_fall
set_output_delay 0 -clock measurePO_wft1             [get_ports rdata[2]] -clock_fall
set_output_delay 0 -clock measurePO_wft1             [get_ports rdata[1]] -clock_fall
set_output_delay 0 -clock measurePO_wft1             [get_ports rdata[0]] -clock_fall
set_output_delay 0 -clock measurePO_wft1             [get_ports full] -clock_fall
set_output_delay 0 -clock measurePO_wft1             [get_ports empty] -clock_fall
set_output_delay 0 -clock measurePO_wft1             [get_ports near_full] -clock_fall
set_output_delay 0 -clock measurePO_wft1             [get_ports near_empty] -clock_fall
set_output_delay 0 -clock measurePO_wft1             [get_ports over_flow] -clock_fall
set_output_delay 0 -clock measurePO_wft1             [get_ports under_flow] -clock_fall
set_output_delay 0 -clock measurePO_wft1             [get_ports test_so] -clock_fall
set_output_delay 0 -clock measurePO_wft1             [get_ports test_so_1] -clock_fall
set_output_delay 0 -clock measurePO_wft1             [get_ports test_so_2] -clock_fall
set_output_delay 0 -clock measurePO_wft1             [get_ports test_so_3] -clock_fall

# -nopi_changes

# black_boxes, and empty_boxes

# nonscan sequential elements 
set_false_path -to [get_cells LOCKUP]
set_false_path -to [get_cells occ_wclk/fast_clk_clkgt/cg_latch_reg]
set_case_analysis 0 occ_wclk/fast_clk_clkgt/cg_latch_reg/Q
set_false_path -to [get_cells occ_wclk/slow_clk_clkgt/cg_latch_reg]
set_case_analysis 1 occ_wclk/slow_clk_clkgt/cg_latch_reg/Q
set_false_path -to [get_cells occ_rclk/fast_clk_clkgt/cg_latch_reg]
set_case_analysis 0 occ_rclk/fast_clk_clkgt/cg_latch_reg/Q
set_false_path -to [get_cells occ_rclk/slow_clk_clkgt/cg_latch_reg]
set_case_analysis 1 occ_rclk/slow_clk_clkgt/cg_latch_reg/Q
set_false_path -to [get_cells LOCKUP1]
set_false_path -to [get_cells occ_wclk/U_clk_control_i_0/pipeline_or_tree_l_reg]
set_false_path -to [get_cells occ_wclk/U_clk_control_i_0/fast_clk_enable_l_reg]
set_false_path -to [get_cells occ_wclk/U_clk_control_i_0/slow_clk_enable_l_reg]
set_false_path -to [get_cells occ_wclk/U_clk_control_i_0/load_n_meta_0_l_reg]
set_false_path -to [get_cells occ_wclk/U_clk_control_i_0/load_n_meta_1_l_reg]
set_false_path -to [get_cells occ_wclk/U_clk_control_i_0/load_n_meta_2_l_reg]
set_false_path -to [get_cells occ_wclk/U_clk_control_i_0/U_cycle_ctr_i/count_int_reg_0_]
set_false_path -to [get_cells occ_wclk/U_clk_control_i_0/U_cycle_ctr_i/count_int_reg_1_]
set_false_path -to [get_cells occ_wclk/U_clk_control_i_0/U_cycle_ctr_i/count_int_reg_2_]
set_false_path -to [get_cells occ_wclk/U_clk_control_i_0/U_cycle_ctr_i/count_int_reg_3_]
set_false_path -to [get_cells occ_wclk/U_clk_control_i_0/U_cycle_ctr_i/tercnt_n_reg_reg]
set_false_path -to [get_cells occ_rclk/U_clk_control_i_0/pipeline_or_tree_l_reg]
set_false_path -to [get_cells occ_rclk/U_clk_control_i_0/fast_clk_enable_l_reg]
set_false_path -to [get_cells occ_rclk/U_clk_control_i_0/slow_clk_enable_l_reg]
set_false_path -to [get_cells occ_rclk/U_clk_control_i_0/load_n_meta_0_l_reg]
set_false_path -to [get_cells occ_rclk/U_clk_control_i_0/load_n_meta_1_l_reg]
set_false_path -to [get_cells occ_rclk/U_clk_control_i_0/load_n_meta_2_l_reg]
set_false_path -to [get_cells occ_rclk/U_clk_control_i_0/U_cycle_ctr_i/count_int_reg_0_]
set_false_path -to [get_cells occ_rclk/U_clk_control_i_0/U_cycle_ctr_i/count_int_reg_1_]
set_false_path -to [get_cells occ_rclk/U_clk_control_i_0/U_cycle_ctr_i/count_int_reg_2_]
set_false_path -to [get_cells occ_rclk/U_clk_control_i_0/U_cycle_ctr_i/count_int_reg_3_]
set_false_path -to [get_cells occ_rclk/U_clk_control_i_0/U_cycle_ctr_i/tercnt_n_reg_reg]

# masked scan cells