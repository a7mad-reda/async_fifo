package fifo_stimulus_pkg;

  import uvm_pkg::*;
// Define a sequencer for configuration transactions

  `include "../testbench/RdWrAgent/rd_wr_tr.sv"
  
  `include "../testbench/fifo_callback.sv"
  `include "../testbench/user_callback.sv"


  `include "../testbench/RdWrAgent/rd_wr_seq.sv"
  `include "../testbench/RdWrAgent/rd_wr_rst_seq.sv"

  `include "../testbench/RstAgent/rst_tr.sv"
  `include "../testbench/RstAgent/rst_seq.sv"

  `include "../testbench/CfgAgent/cfg_tr.sv"
  `include "../testbench/CfgAgent/cfg_sqr.sv"

  `include "../compile/ral_dut_regmodel.sv"
  `include "../testbench/CfgAgent/cfg_seq.sv"

  `include "../testbench/rst_top_sqr.sv"
  `include "../testbench/rst_top_seq.sv"

  `include "../testbench/fifo_top_sqr.sv"
  `include "../testbench/fifo_top_seq.sv"

endpackage