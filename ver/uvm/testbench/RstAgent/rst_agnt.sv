typedef class rst_mon;
typedef uvm_sequencer #(rst_tr) rst_sqr;

// --------------------- Reset Agent class ---------------------
class rst_agnt extends uvm_agent;

  // Declare a virtual interface for the DUT connection
  virtual  rst_if vif;                // DUT virtual interface

  // Declare handles for components defined under the Agent
  rst_sqr    sqr;
  rst_drv    drv;
  rst_mon    mon;

  //--------------------------------------------------------
  // Register the component with UVM factory
  //--------------------------------------------------------
  `uvm_component_utils(rst_agnt)

  //--------------------------------------------------------
  // Constructor function
  //--------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  //--------------------------------------------------------
  // Build Phase:
  // - Constructs the required sub-components 
  // - sets up configuration parameters.
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // If the agent is active, create the sequencer and driver
    if (is_active == UVM_ACTIVE) begin
      sqr = rst_sqr::type_id::create("sqr", this);
      drv = rst_drv::type_id::create("drv", this);
    end

    // Always Construct the monitor
    mon = rst_mon::type_id::create("mon", this);

    // Retrieve configuration properties
    uvm_config_db#(virtual rst_if)::get(this, "", "rst_vif", vif);

    // Set configuration parameters for sub-components
    uvm_config_db#(virtual rst_if)::set(this, "*", "rst_vif", vif);
    
  endfunction: build_phase

  //--------------------------------------------------------
  // Connect Phase:
  // - Establishes TLM connections between components
  //--------------------------------------------------------
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Connect drv's seq_item_port to sqr's seq_item_export if the is_active flag is UVM_ACTIVE.
    if (is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
    end

  endfunction: connect_phase

  //--------------------------------------------------------
  // End of Elaboration Phase:
  // - Checking the correctness of 
  //   testbench structure & the configuration variables.
  //--------------------------------------------------------
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Check if the virtual interface has been properly set
    if (vif == null) begin
      `uvm_fatal("CFGERR", "Interface for Reset Agent is not set");
    end
  endfunction: end_of_elaboration_phase

endclass: rst_agnt

// --------------------- Monitor Agent class ---------------------
class rst_mon extends uvm_monitor;

  // Declare a virtual interface to interact with the DUT
  virtual  rst_if vif;

  // UVM analysis port for publishing reset transactions to the scoreboard
  uvm_analysis_port #(rst_tr) analysis_port;

  // Global UVM events to track write and read resets
  uvm_event wr_reset_event = uvm_event_pool::get_global("wr_reset");
  uvm_event rd_reset_event = uvm_event_pool::get_global("rd_reset");

  //--------------------------------------------------------
  // Register the component with UVM factory
  //--------------------------------------------------------
  `uvm_component_utils(rst_mon)

  //--------------------------------------------------------
  // Constructor function
  //--------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  //--------------------------------------------------------
  // Build Phase
  //--------------------------------------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Retrieve configuration properties
    uvm_config_db#(virtual rst_if)::get(this, "", "rst_vif", vif);

    // Contruct TLM analysis port. TLM ports do not have factory support to be constructed using create() method.
    analysis_port = new("analysis_port", this);
  endfunction: build_phase

  //--------------------------------------------------------
  // End-of-Elaboration Phase
  // - Checks if the monitor has been properly configured
  //--------------------------------------------------------
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Ensure that the virtual interface is correctly set
    if (vif == null) begin
      `uvm_fatal("CFGERR", "Interface for reset monitor not set");
    end
  endfunction: end_of_elaboration_phase

  //--------------------------------------------------------
  // Run Phase
  // - Continuously monitors and records transactions
  // - Sends observed transactions to subscribers
  //   via TLM analysis port
  //--------------------------------------------------------
  virtual task run_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    forever begin
      rst_tr tr = rst_tr::type_id::create("tr", this);
      fork
        detect_wrst(tr);
        detect_rrst(tr);
      join
      analysis_port.write(tr);
    end
  endtask: run_phase

  //--------------------------------------------------------
  // Packet Monitoring Tasks 
  //--------------------------------------------------------
  // Capture Write reset events from DUT
  virtual task detect_wrst(rst_tr tr);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    @(vif.wrst_n);
    assert(!$isunknown(vif.wrst_n)); ; // Imediate assetion
    if (vif.wrst_n == 1'b0) begin
      tr.kind = rst_tr::ASSERT;
      wr_reset_event.trigger();
    end else begin
      tr.kind = rst_tr::DEASSERT;
      wr_reset_event.reset();
    end
  endtask: detect_wrst

  // Capture Read reset events from DUT
  virtual task detect_rrst(rst_tr tr);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    @(vif.rrst_n);
    assert(!$isunknown(vif.rrst_n)); // Imediate assetion
    if (vif.rrst_n == 1'b0) begin
      tr.kind = rst_tr::ASSERT;
      rd_reset_event.trigger();
    end else begin
      tr.kind = rst_tr::DEASSERT;
      rd_reset_event.reset();
    end
  endtask: detect_rrst

endclass: rst_mon
