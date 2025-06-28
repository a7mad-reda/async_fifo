// Define a parameterized reset sequence class
// - wr_en: Reset write inerface signals
// - rd_en: Reset read inerface signals
class rd_wr_rst_seq #(bit wr_en=1, bit rd_en=1) extends rd_wr_base_seq;

  virtual rd_wr_if vif;

  //--------------------------------------------------------
  // Utility and Field macros
  //--------------------------------------------------------
  `uvm_object_param_utils_begin(rd_wr_rst_seq #(wr_en, rd_en)) // Parameterized registration
  `uvm_object_utils_end

  //--------------------------------------------------------
  // Constructor
  //--------------------------------------------------------
  function new(string name = "rd_wr_rst_seq");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  //--------------------------------------------------------
  // Pre-start task:
  // Ensures that the virtual interface is retrieved
  //--------------------------------------------------------
  virtual task pre_start();
    // Get the virtual interface defined in associagted squencer
    uvm_config_db#(virtual rd_wr_if)::get(get_sequencer(), "", "vif", vif);
    if (vif == null) begin
      `uvm_fatal("CFGERR", "Interface for the Read/Write reset Driver Sequence not set");
    end
  endtask: pre_start

  //--------------------------------------------------------
  // Sequence body:
  // -  Defines the sequence behavior
  //--------------------------------------------------------
  virtual task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Tie dut signals to zero
    if ( wr_en) begin
      vif.wen              <= '0;
      vif.wptr_clr         <= '0;
      vif.wdata            <= '0;
      vif.near_full_mrgn   <= '0;
    end
    if ( rd_en ) begin
      vif.ren              <= '0;
      vif.rptr_clr         <= '0;
      vif.rdata            <= '0;
      vif.near_empty_mrgn  <= '0;
    end
  endtask

endclass: rd_wr_rst_seq