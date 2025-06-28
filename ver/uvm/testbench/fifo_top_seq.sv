//------------------------------------------------------------------------------
// Description : This UVM sequence drives various scenarios to stimulate and
//               verify FIFO functionality including normal operation, overflow,
//               and underflow.
//------------------------------------------------------------------------------
class fifo_top_seq extends uvm_sequence;

  // Declare events for Overflow Aand Underflow
  uvm_event overflow_event  = uvm_event_pool::get_global("wr_overflow");
  uvm_event underflow_event = uvm_event_pool::get_global("rd_underflow");

  int rep_cnt = 10;

  //--------------------------------------------------------------------------
  // Sequence Handle Declarations
  //--------------------------------------------------------------------------
  // Configuration sequence to update margin settings
  cfg_mrgn_seq      cfg_seq;

  // Write sequence for write transactions to FIFO
  rd_wr_seq #(1, 0) wr_seq;

  // Read sequence for read transactions from FIFO
  rd_wr_seq #(0, 1) rd_seq;

  //--------------------------------------------------------
  // Utility and Field macros
  //--------------------------------------------------------
  `uvm_object_utils(fifo_top_seq)

  // Create the p_sequencer handle
  // for accessing the content of the top fifo sequencer.
  `uvm_declare_p_sequencer(fifo_top_sqr)

  //--------------------------------------------------------
  // Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_top_seq");
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
  // Raise phase objection if top-level sequence
  virtual task pre_start();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.raise_objection(this);
    end
  endtask: pre_start

  // Drop phase objection after sequence finishes
  virtual task post_start();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.drop_objection(this);
    end
  endtask: post_start
  `endif // UVM_VERSION_1_1

  //--------------------------------------------------------
  // Sequence body: Main stimulus logic
  //--------------------------------------------------------
  virtual task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Place callback hook to method defined in user-defined callback class
    `uvm_do_obj_callbacks(fifo_top_sqr,fifo_callback,p_sequencer,rep_cnt_wr(rep_cnt));

    // Repeat the following stimulus pattern rep_cnt times
    repeat (rep_cnt) begin

      // Apply random margin configuration
      `uvm_info("TRAFFIC", "Write random values from Margins", UVM_MEDIUM);
      `uvm_do_on(cfg_seq, p_sequencer.config_sqr);

      // Perform concurrent writes and reads with full depth condition
      fork
        `uvm_info("TRAFFIC", "Simultaneous reads and writes", UVM_MEDIUM);
        `uvm_do_on_with(wr_seq , p_sequencer.wr_sqr, {
          (s_data_size + 1) == `FIFO_DP;
          s_force_req == 0;
          s_wr_to_full == 0;
        });

        `uvm_do_on_with(rd_seq , p_sequencer.rd_sqr, {
          (s_data_size + 1) == `FIFO_DP;
          s_force_req == 0;
          s_rd_to_empty == 0;
        });
      join

      // Fill FIFO until it is full
      `uvm_info("TRAFFIC", "Write FIFO to full", UVM_MEDIUM);
      `uvm_do_on_with(wr_seq , p_sequencer.wr_sqr, {
        s_force_req == 0;
        s_wr_to_full == 1;
      });

      // Test overflow condition
      overflow_event.trigger();
      `uvm_info("TRAFFIC", "Inject overflow scenario", UVM_MEDIUM);
      `uvm_do_on_with(wr_seq , p_sequencer.wr_sqr, {
        (s_data_size + 1) == 1;
        s_force_req == 1;
        s_wr_to_full == 0;
      });
      overflow_event.reset();

      // Empty the FIFO completely
      `uvm_info("TRAFFIC", "Read FIFO to empty", UVM_MEDIUM);
      `uvm_do_on_with(rd_seq , p_sequencer.rd_sqr, {
        s_force_req == 0;
        s_rd_to_empty == 1;
      });

      // Test underflow condition
      underflow_event.trigger();
      `uvm_info("TRAFFIC", "Inject underflow scenario", UVM_MEDIUM);
      `uvm_do_on_with(rd_seq , p_sequencer.rd_sqr, {
        (s_data_size + 1) == 1;
        s_force_req == 1;
        s_rd_to_empty == 0;
      });
      underflow_event.reset();

    end

  endtask: body

endclass: fifo_top_seq
