// Define a transaction class for reset operations
class rst_tr extends uvm_sequence_item;

  typedef enum {ASSERT, DEASSERT} kind_e;
  rand kind_e kind;
  rand int unsigned cycles = 1;

  //--------------------------------------------------------
  // Utility and Field macros
  // - for factory registration
  //--------------------------------------------------------
  `uvm_object_utils_begin(rst_tr)
    `uvm_field_enum(kind_e, kind, UVM_ALL_ON)
    `uvm_field_int(cycles, UVM_ALL_ON)
  `uvm_object_utils_end

  //--------------------------------------------------------
  // Constructor
  //--------------------------------------------------------
  function new(string name = "rst_tr");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new
endclass: rst_tr