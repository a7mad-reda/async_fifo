class rst_seq extends uvm_sequence #(rst_tr);

  //--------------------------------------------------------
  // Utility and Field macros
  // - Register the sequence with the UVM factory
  //--------------------------------------------------------
  `uvm_object_utils(rst_seq)

  //--------------------------------------------------------
  // Constructor
  // - Initializes the sequence object
  //--------------------------------------------------------
  function new(string name = "rst_seq");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    
    `ifndef UVM_VERSION_1_1
      // Set automatic phase objection for newer UVM versions (not UVM 1.1)
      set_automatic_phase_objection(1);
    `endif // UVM_VERSION_1_1
  endfunction: new

  `ifdef UVM_VERSION_1_1
  //--------------------------------------------------------
  // Pre/Post body Callbacks
  //--------------------------------------------------------
  virtual task pre_start();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    // Raise an objection at the start of the sequence if no parent sequence exists
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.raise_objection(this);
    end
  endtask: pre_start

  virtual task post_start();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    // Drop the objection at the end of the sequence if no parent sequence exists
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.drop_objection(this);
    end
  endtask: post_start
  `endif // UVM_VERSION_1_1

  //--------------------------------------------------------
  // Sequence body
  // -  Defines the sequence behavior
  //--------------------------------------------------------
  virtual task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Create reset transaction sequence
    `ifndef UVM_VERSION
    // For UVM-1.1 & UVM-1.2
      `uvm_do_with(req, {kind == DEASSERT; cycles == 2;});
      `uvm_do_with(req, {kind == ASSERT; cycles == 1;});
      `uvm_do_with(req, {kind == DEASSERT; cycles == 15;});
    `else // UVM_VERSION
    // For IEEE UVM
      `uvm_do(req,,, {kind == DEASSERT; cycles == 2;});
      `uvm_do(req,,, {kind == ASSERT; cycles == 1;});
      `uvm_do(req,,, {kind == DEASSERT; cycles == 15;});
    `endif // UVM_VERSION

  endtask: body

endclass: rst_seq