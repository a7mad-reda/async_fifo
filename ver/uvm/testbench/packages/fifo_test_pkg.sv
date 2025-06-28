package fifo_test_pkg;

  import uvm_pkg::*;
  import fifo_stimulus_pkg::*;
  import fifo_env_pkg::*;

  `include "../testbench/tests/test_base.sv"
  `include "../testbench/tests/test_fifo_traffic.sv"
  `include "../testbench/tests/test_fifo_traffic_cb.sv"
  `include "../testbench/tests/test_reg_bfm.sv"
  `include "../testbench/tests/test_reg_ral_auto.sv"
  `include "../testbench/tests/test_reg_ral_directed.sv"

endpackage