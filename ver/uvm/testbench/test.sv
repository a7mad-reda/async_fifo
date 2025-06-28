program automatic test;

  // Import UVM base classes and user-defined test package
  import uvm_pkg::*;
  import fifo_test_pkg::*;

  initial begin
    //-----------------------------------------------------------------------
    // Bind virtual interfaces to UVM resource database
    // Allows components to retrieve interface handles by name during runtime
    //-----------------------------------------------------------------------
    // Set the read/write interface (rd_wr_if) with resource name "async_fifo_vif"
    uvm_resource_db#(virtual rd_wr_if)::set("async_fifo_vif", "", async_fifo_test_top.async_fifo_if);

    // Set the reset interface (rst_if) with resource name "reset_vif"
    uvm_resource_db#(virtual rst_if)::set("reset_vif", "", async_fifo_test_top.reset_if);

    // Set the configuration register interface (cfg_if) with resource name "cfg_vif"
    uvm_resource_db#(virtual cfg_if)::set("cfg_vif", "", async_fifo_test_top.reg_if);

    //-----------------------------------------------------------------------
    // Format simulation time for easier readability in log messages
    // -9 : display time in nanoseconds
    //  1 : display one digit after the decimal point
    // "ns" : time unit string
    // 10 : minimum field width
    //-----------------------------------------------------------------------
    $timeformat(-9, 1, "ns", 10);

    //-----------------------------------------------------------------------
    // Start the UVM testbench
    // The specific test is selected using the +UVM_TESTNAME=... argument
    //-----------------------------------------------------------------------
    run_test();
  end

endprogram
