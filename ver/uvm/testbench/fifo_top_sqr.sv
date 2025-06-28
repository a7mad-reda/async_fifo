// Top-level sequencer managing sub-sequencers for config, write and read.
class fifo_top_sqr extends uvm_sequencer;


  typedef uvm_sequencer #(rd_wr_tr) packet_sequencer;

  // Register Callback class with the object/component where callbacks are going to be used.
  `uvm_register_cb(fifo_top_sqr,fifo_callback)

  // Sub-sequencer handles
  cfg_sqr          config_sqr;   // Sub-sequencer for configurations
  packet_sequencer wr_sqr;    // Sub-sequencer for write operations
  packet_sequencer rd_sqr;    // Sub-sequencer for read operations

  //--------------------------------------------------------
  // Utility and Field macros
  //--------------------------------------------------------
  // Register the component with the UVM factory
  `uvm_component_utils(fifo_top_sqr)

  //--------------------------------------------------------
  // Constructor
  //--------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

endclass: fifo_top_sqr