//------------------------------------------------------------------------------
// Class: user_callback
// Description: This class extends the fifo_callback base class and implements
//              user-defined overrides for margin configuration, repeat count,
//              and packet data modification. These methods are automatically
//              called via the UVM callback mechanism to customize behavior.
//------------------------------------------------------------------------------
class user_callback extends fifo_callback;

  //--------------------------------------------------------
  // Utility and Field macros
  //--------------------------------------------------------
  `uvm_object_utils(user_callback)

  //--------------------------------------------------------
  // Constructor
  //--------------------------------------------------------
  function new(string name = "user_callback");
    super.new(name);
  endfunction

  //--------------------------------------------------------------------------
  // Task: pre_cfg_seq_wr
  // Description: Override full and empty margin values before
  //              the configuration sequence writes them.
  //--------------------------------------------------------------------------
  task pre_cfg_seq_wr(ref logic [15:0] cfg_full_mrgn, ref logic [15:0] cfg_empty_mrgn);
    cfg_empty_mrgn = 'd11;  // Set custom empty margin
    cfg_full_mrgn  = 'd13;  // Set custom full margin
    `uvm_info("CB_UPDATE", "User callback called.", UVM_MEDIUM);
  endtask

  //--------------------------------------------------------------------------
  // Task: rep_cnt_wr
  // Description: Override the repeat count for a sequence or operation.
  //--------------------------------------------------------------------------
  virtual task rep_cnt_wr(ref int rep_cnt);
    rep_cnt = 1;  // Custom repeat count
  endtask: rep_cnt_wr

  //--------------------------------------------------------------------------
  // Task: pkt_wr
  // Description: Modify the packet contents before write operation
  //--------------------------------------------------------------------------
  virtual task pkt_wr(ref rd_wr_tr req);
    for (int i = 0; i < `FIFO_DP; i++) begin
      req.data[i] = 8'd10;  // Set each data element to a fixed value
    end
  endtask: pkt_wr

endclass: user_callback
