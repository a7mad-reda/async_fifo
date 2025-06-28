// Define a base sequence class
class rd_wr_base_seq extends uvm_sequence #(rd_wr_tr);

  rand bit       s_wr_to_full;
  rand bit       s_rd_to_empty;
  rand bit [3:0] s_data_size;
  rand bit       s_force_req;

  //--------------------------------------------------------
  // Utility and Field macros
  // - Register the sequence with the UVM factory
  //--------------------------------------------------------
  `uvm_object_param_utils(rd_wr_base_seq)

  //--------------------------------------------------------
  // Constructor
  // - Initializes the sequence object
  //--------------------------------------------------------
  function new(string name = "rd_wr_base_seq");
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

endclass: rd_wr_base_seq

// Define a read/write sequence
class rd_wr_seq #(bit wr_en=1, bit rd_en=1) extends rd_wr_base_seq;

  //--------------------------------------------------------
  // Utility and Field macros
  //--------------------------------------------------------
  `uvm_object_param_utils_begin(rd_wr_seq #(wr_en, rd_en))
  `uvm_object_utils_end

  //--------------------------------------------------------
  // Constructor:
  // - Initializes the sequence object
  //--------------------------------------------------------
  function new(string name = "rd_wr_seq");
    super.new(name);                               // Call parent class constructor
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH); // Print trace information
  endfunction: new

  //--------------------------------------------------------
  // Sequence body:
  // -  Defines the sequence behavior
  //--------------------------------------------------------
  virtual task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Create and randomize transactions
    `uvm_do_with(req,{wr_to_full  == s_wr_to_full;
                      rd_to_empty == s_rd_to_empty;
                      data.size   == (s_data_size+1); 
                      force_req   == s_force_req;  });

    if ( rd_en==1 ) begin
      get_response(rsp);
      `uvm_info("TOP_SEQ_RD_DATA", {"\n", rsp.sprint()}, UVM_MEDIUM);
    end

  endtask: body

endclass: rd_wr_seq