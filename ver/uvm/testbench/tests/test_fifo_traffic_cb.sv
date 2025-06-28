//------------------------------------------------------------------------------
// Class: test_fifo_traffic_cb
// Description: A UVM test class that extends 'test_fifo_traffic' and registers
//              user-defined callback objects to override default behavior.
//------------------------------------------------------------------------------
class test_fifo_traffic_cb extends test_fifo_traffic;

  //--------------------------------------------------------------------------
  // Callback object declarations
  //--------------------------------------------------------------------------
  // Object to override configuration sequencer behavior
  user_callback cfg_sqr_cb;

  // Object to override top-level sequencer behavior
  user_callback top_sqr_cb;

  // Object to override write driver behavior
  user_callback wr_drv_cb;

  //--------------------------------------------------------
  // Utility and Field macros
  //--------------------------------------------------------
  // Register this test class with the UVM factory
  `uvm_component_utils(test_fifo_traffic_cb)

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

    // Create callback objects for configuration and top-level sequencer
    cfg_sqr_cb = user_callback::type_id::create("cfg_sqr_cb", this);
    top_sqr_cb = user_callback::type_id::create("top_sqr_cb", this);

    // Register the callback objects with the respective sequencers using "add" method
    // These callbacks modify behavior such as margin values and loop iterations.
    uvm_callbacks#(cfg_sqr,fifo_callback)::add(top_fifo_sqr.config_sqr,cfg_sqr_cb); // Override margins values
    uvm_callbacks#(fifo_top_sqr,fifo_callback)::add(top_fifo_sqr,top_sqr_cb);       // Override number of iteration of main sequence.

  endfunction: build_phase

  //--------------------------------------------------------
  // End of Elaboration Phase:
  //--------------------------------------------------------
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Create callback object for the write driver
    wr_drv_cb = user_callback::type_id::create("wr_drv_cb", this);

    // Register the callback to override write driver behavior
    uvm_callbacks#(rd_wr_drv,fifo_callback)::add(env.wr_agt.drv,wr_drv_cb);        // Override FIFO write data

  endfunction: end_of_elaboration_phase

endclass: test_fifo_traffic_cb