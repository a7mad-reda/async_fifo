// Top-level sequencer managing reset and default values for write and read interfaces during reset.
class rst_top_sqr extends uvm_sequencer;

  typedef uvm_sequencer #(rst_tr)   reset_sequencer;   // Sequencer for reset transactions
  typedef uvm_sequencer #(rd_wr_tr) packet_sequencer;  // Sequencer for read/write transactions

  // Sub-sequencer handles
  reset_sequencer  rst_sqr;   // Sub-sequencer for reset
  packet_sequencer wr_sqr;    // Sub-sequencer for write operations
  packet_sequencer rd_sqr;    // Sub-sequencer for read operations

  //--------------------------------------------------------
  // Utility and Field macros
  //--------------------------------------------------------
  // Register the component with the UVM factory
  `uvm_component_utils(rst_top_sqr)

  //--------------------------------------------------------
  // Constructor
  //--------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH); // Debug trace for constructor
  endfunction: new

endclass: rst_top_sqr
