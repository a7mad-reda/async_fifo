//------------------------------------------------------------------------------
// Description : Drives the reset sequence and coordinates write/read sequences
//               based on reset-related events.
//------------------------------------------------------------------------------
class rst_top_seq extends uvm_sequence;

  //--------------------------------------------------------------------------
  // Sequence Handle Declarations
  //--------------------------------------------------------------------------
  // Base reset sequence (typically asserts and deasserts reset signals)
  rst_seq rst_sqn;

  // Write sequence that drives default vaules under reset
  rd_wr_rst_seq #(1, 0) wr_rst_sqn;

  // Read sequence that drives default vaules under reset
  rd_wr_rst_seq #(0, 1) rd_rst_sqn;

  // Reset Events
  // Global UVM event triggers used to synchronize reset behavior
  uvm_event wr_reset_event = uvm_event_pool::get_global("wr_reset");
  uvm_event rd_reset_event = uvm_event_pool::get_global("rd_reset");

  //--------------------------------------------------------
  // Utility and Field macros
  //--------------------------------------------------------
  // Register this sequence with the UVM factory for object creation
  `uvm_object_utils(rst_top_seq)

  // Create the p_sequencer handle
  // Declare pointer to parent sequencer of type rst_top_sqr
  `uvm_declare_p_sequencer(rst_top_sqr)

  //--------------------------------------------------------
  // Constructor
  //--------------------------------------------------------
  function new(string name = "rst_top_seq");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    
    `ifndef UVM_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif // UVM_VERSION_1_1
  endfunction: new

  `ifdef UVM_VERSION_1_1
  //--------------------------------------------------------
  // Pre/Post body Callbacks (Only for UVM 1.1)
  //--------------------------------------------------------
  // Raise phase objection if this is a top-level sequence
  virtual task pre_start();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.raise_objection(this);
    end
  endtask: pre_start

  // Drop objection after the sequence completes
  virtual task post_start();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.drop_objection(this);
    end
  endtask: post_start
  `endif // UVM_VERSION_1_1

  //--------------------------------------------------------
  // Sequence body
  //--------------------------------------------------------
  virtual task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Use different macros for IEEE-compliant UVM versions
    `ifndef UVM_VERSION

      // Parallel execution:
      // 1. Execute the base reset sequence.
      // 2. Wait for reset events before launching write/read sequences.
      fork
        // Start base reset logic
        `uvm_do_on(rst_sqn, p_sequencer.rst_sqr);

        fork
          // Wait for write-reset event and trigger write reset sequence
          begin
            wr_reset_event.wait_on();
            `uvm_do_on(wr_rst_sqn, p_sequencer.wr_sqr);
          end

          // Wait for read-reset event and trigger read reset sequence
          begin
            rd_reset_event.wait_on();
            `uvm_do_on(rd_rst_sqn, p_sequencer.rd_sqr);
          end
        join_none

      join

    `else  // UVM_VERSION (for IEEE UVM-compliant environments)

      // Similar logic using IEEE-compliant macros
      fork
        `uvm_do(rst_sqn, p_sequencer.rst_sqr);

        fork
          begin
            wr_reset_event.wait_on();
            `uvm_do(wr_rst_sqn, p_sequencer.wr_sqr);
          end
          begin
            rd_reset_event.wait_on();
            `uvm_do(rd_rst_sqn, p_sequencer.rd_sqr);
          end
        join_none

      join

    `endif // UVM_VERSION

  endtask: body

endclass: rst_top_seq
