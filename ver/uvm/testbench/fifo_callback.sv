//------------------------------------------------------------------------------
// Class: fifo_callback
// Description: Base callback class that defines virtual methods to allow
//              user-defined overrides during simulation phases such as
//              configuring margins, setting repeat counts, and modifying
//              packet data before it is driven.
//------------------------------------------------------------------------------
class fifo_callback extends uvm_callback;

  //--------------------------------------------------------
  // Utility and Field macros
  //--------------------------------------------------------
  `uvm_object_utils(fifo_callback)

  //--------------------------------------------------------
  // Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_callback");
    super.new(name);
  endfunction

  //--------------------------------------------------------------------------
  // Virtual Task: pre_cfg_seq_wr
  // Description: Called before configuration sequence writes.
  //              Allows user to override default full and empty margin values.
  //--------------------------------------------------------------------------
  virtual task pre_cfg_seq_wr(ref logic [15:0] cfg_full_mrgn, ref logic [15:0] cfg_empty_mrgn);
  endtask: pre_cfg_seq_wr

  //--------------------------------------------------------------------------
  // Virtual Task: rep_cnt_wr
  // Description: Called to override or modify repeat count for operations.
  //--------------------------------------------------------------------------
  virtual task rep_cnt_wr(ref int rep_cnt);
  endtask: rep_cnt_wr

  //--------------------------------------------------------------------------
  // Virtual Task: pkt_wr
  // Description: Called before a packet write is issued.
  //              Allows modification of the transaction data.
  //--------------------------------------------------------------------------
  virtual task pkt_wr(ref rd_wr_tr req);
  endtask: pkt_wr

endclass: fifo_callback