class test_base extends uvm_test;

  //--------------------------------------------------------
  // Utility and Field macros
  //--------------------------------------------------------
  // Register the test class with the UVM factory
  `uvm_component_utils(test_base)

  // Get instance of the UVM command line processor
  // get inputs from command line
  uvm_cmdline_processor clp = uvm_cmdline_processor::get_inst();

  // Declare virtual interfaces for different modules
  virtual rd_wr_if      fifo_vif;    // FIFO read/write interface
  virtual rst_if        reset_vif;   // Reset interface
  virtual cfg_if        cfg_vif;     // Configuration interface

  // Declare virtual sequencers
  rst_top_sqr           top_rst_sqr;   // Top-level reset sequencer
  fifo_top_sqr          top_fifo_sqr;  // Top-level FIFO sequencer

  // Declare FIFO environment
  fifo_env              env;

  //--------------------------------------------------------
  // Constructor function
  //--------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  //--------------------------------------------------------
  // Build Phase
  //--------------------------------------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Create the environment
    env = fifo_env::type_id::create("env", this);

    // Create top-level sequencers
    top_rst_sqr  = rst_top_sqr::type_id::create("top_rst_sqr", this);
    top_fifo_sqr = fifo_top_sqr::type_id::create("top_fifo_sqr", this);

    // Read virtual interfaces from UVM resource DB
    uvm_resource_db#(virtual rd_wr_if)::read_by_type("async_fifo_vif", fifo_vif , this);
    uvm_resource_db#(virtual rst_if)::read_by_type("reset_vif"       , reset_vif, this);
    uvm_resource_db#(virtual cfg_if)::read_by_type("cfg_vif"         , cfg_vif  , this);

    // Set virtual interfaces for agents and scoreboard
    uvm_config_db#(virtual rst_if)::set(this  , "env.rst_agt", "rst_vif", reset_vif);
    uvm_config_db#(virtual cfg_if)::set(this  , "env.cfg_agt", "vif"    , cfg_vif  );
    uvm_config_db#(virtual rd_wr_if)::set(this, "env.wr_agt" , "vif"    , fifo_vif );
    uvm_config_db#(virtual rd_wr_if)::set(this, "env.rd_agt" , "vif"    , fifo_vif );
    uvm_config_db#(virtual rd_wr_if)::set(this, "env.sb"     , "vif"    , fifo_vif );
    uvm_config_db#(virtual rd_wr_if)::set(this, "env.driver"     , "vif"    , fifo_vif );
    uvm_config_db #(int)::set(this, "env.driver" , "driver_type", 1); // Type 1 = Write
    // Set default reset sequence to run in reset phase
    uvm_config_db #(uvm_object_wrapper)::set(this, "top_rst_sqr.reset_phase", "default_sequence", rst_top_seq::get_type());

    // Set the HDL path for RAL backdoor access
    uvm_config_db #(string)::set(this, "env", "hdl_path", "async_fifo_test_top");

  endfunction: build_phase

  //--------------------------------------------------------
  // Connect Phase
  //--------------------------------------------------------
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect sequencers from top sequencers to their corresponding agent sequencers
    top_rst_sqr.rst_sqr     = env.rst_agt.sqr;
    top_rst_sqr.wr_sqr      = env.wr_agt.sqr;
    top_rst_sqr.rd_sqr      = env.rd_agt.sqr;

    top_fifo_sqr.config_sqr = env.cfg_agt.sqr;
    top_fifo_sqr.wr_sqr     = env.wr_agt.sqr;
    top_fifo_sqr.rd_sqr     = env.rd_agt.sqr;

  endfunction: connect_phase

  //--------------------------------------------------------
  // End of Elaboration phase
  //--------------------------------------------------------
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Enable all functional coverage for the register model
    env.regmodel.set_coverage(UVM_CVR_ALL);

  endfunction: end_of_elaboration_phase


  //--------------------------------------------------------
  // Final Phase
  //--------------------------------------------------------
  virtual function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Display end of test banner
    $display("//-------------------------------------------//");
    $display("//               Test finished               //");
    $display("//-------------------------------------------//");

    // Optionally print UVM topology and factory content if debugging is enabled
    // UVM_DEBUG to avoid dumping too much data.
    if (uvm_report_enabled(UVM_DEBUG, UVM_INFO, "TOPOLOGY")) begin
      uvm_root::get().print_topology();
    end

    if (uvm_report_enabled(UVM_DEBUG, UVM_INFO, "FACTORY")) begin
      uvm_factory::get().print();
    end
  endfunction: final_phase

endclass: test_base