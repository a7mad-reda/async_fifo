// Define a transaction class for read/write operations
class rd_wr_tr extends uvm_sequence_item;

  rand bit[`DATA_WD -1:0] data[$];
  rand bit                wr_to_full;
  rand bit                rd_to_empty;
  rand bit                force_req;

  //--------------------------------------------------------
  // Utility and Field macros
  // - for factory registration
  //--------------------------------------------------------
  `uvm_object_utils_begin(rd_wr_tr)
    `uvm_field_queue_int(data, UVM_ALL_ON)
  `uvm_object_utils_end

  //--------------------------------------------------------
  // Constraints
  //--------------------------------------------------------
  constraint valid {
    data.size inside {[1: (1 << `ADDR_WD)]};
  }

  //--------------------------------------------------------
  // Constructor:
  // -  Initializes the transaction object
  //--------------------------------------------------------
  function new(string name = "rd_wr_tr");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new
endclass: rd_wr_tr