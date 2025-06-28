// Bus functional model for registers
class test_fifo_traffic extends test_base;

  //--------------------------------------------------------
  // Utility and Field macros
  //--------------------------------------------------------
  // Register this test class with the UVM factory
  `uvm_component_utils(test_fifo_traffic)

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

    // Disable automatic sequence execution on all sequencers in the env
    // for both configure_phase and main_phase
    uvm_config_db #(uvm_object_wrapper)::set(this, "env.*.configure_phase", "default_sequence", null);
    uvm_config_db #(uvm_object_wrapper)::set(this, "env.*.main_phase", "default_sequence", null);

    // Excute cfg_ral_direct_seq on Config sqr in main phase
    //uvm_config_db #(uvm_object_wrapper)::set(this, "env.cfg_agt.sqr.configure_phase", "default_sequence", cfg_ral_direct_seq::get_type());

    // Set fifo_top_seq as the default sequence for the FIFO top-level sequencer during main_phase
    uvm_config_db #(uvm_object_wrapper)::set(this, "top_fifo_sqr.main_phase", "default_sequence", fifo_top_seq::get_type());


  endfunction: build_phase

  //--------------------------------------------------------
  // Shutdown Phase
  //--------------------------------------------------------
  virtual task shutdown_phase(uvm_phase phase);
    super.shutdown_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Set timeout for the scoreboard completion
    env.sb.set_timeout(100us);

    // Raise objection to prevent phase from ending until the scoreboard completes
    phase.raise_objection(this);

    // Wait for scoreboard to signal completion
    env.sb.wait_for_done();

    // Drop objection once done
    phase.drop_objection(this);
  endtask: shutdown_phase

  //--------------------------------------------------------
  // Report phase
  //--------------------------------------------------------
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  
    // Display the scoreboard results.
    `uvm_info("SB_REPORT", {"\n", env.sb.print_results()}, UVM_MEDIUM);
  endfunction: report_phase

endclass: test_fifo_traffic