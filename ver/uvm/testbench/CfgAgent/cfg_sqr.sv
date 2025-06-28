class cfg_sqr extends uvm_sequencer #(cfg_tr);

  //--------------------------------------------------------
  // Utility and Field macros
  //--------------------------------------------------------
  `uvm_component_utils(cfg_sqr)

  // Register Callback class with the object/component where callbacks are going to be used.
  `uvm_register_cb(cfg_sqr,fifo_callback)
  
  function new(string name = "cfg_sqr", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //--------------------------------------------------------
  // Constructor function
  //--------------------------------------------------------

endclass: cfg_sqr