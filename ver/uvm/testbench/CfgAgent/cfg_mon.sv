// Define a parameterized configuration Monitor class
class cfg_mon extends uvm_monitor;

  // Declare a virtual interface for DUT interaction
  virtual  cfg_if vif;                // DUT virtual interface

  // UVM Analysis Port for sending collected transactions to subscribers
  uvm_analysis_port #(cfg_tr) analysis_port;

  //--------------------------------------------------------
  // Utility and Field macros
  // - Register the Monitor with the UVM factory
  //--------------------------------------------------------
  `uvm_component_utils(cfg_mon)

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
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Retrieve configuration properties
    uvm_config_db#(virtual cfg_if)::get(this, "", "vif", vif);

    // Contruct TLM analysis port. TLM ports do not have factory support to be constructed using create() method.
    analysis_port = new("analysis_port", this);
  endfunction: build_phase

  //--------------------------------------------------------
  // End-of-Elaboration Phase
  // - Checks if the monitor has been properly configured
  //--------------------------------------------------------
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Ensure that the virtual interface is correctly set
    if (vif == null) begin
      `uvm_fatal("CFGERR", "Interface for Driver is not set");
    end
  endfunction: end_of_elaboration_phase

  //--------------------------------------------------------
  // Run Phase
  // - Continuously monitors and records transactions
  // - Sends observed transactions to subscribers
  //   via TLM analysis port
  //--------------------------------------------------------
  virtual task run_phase(uvm_phase phase);
    cfg_tr tr;
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    forever begin
      tr = cfg_tr::type_id::create("tr", this);
      get_packet(tr);
      `uvm_info("CFG_REC", {"\n", tr.sprint()}, UVM_MEDIUM);
      analysis_port.write(tr);
    end
  endtask: run_phase

  //--------------------------------------------------------
  // Packet Monitoring Tasks 
  //--------------------------------------------------------
  virtual task get_packet(cfg_tr req);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    @(vif.Mon_cb iff (vif.cfg_wr | vif.cfg_rd));
    if (vif.cfg_wr) begin
      req.access_type = UVM_WRITE;
    end
    else if (vif.cfg_rd) begin
      req.access_type = UVM_READ;
    end
      req.cfg_addr        = vif.cfg_addr;
      req.cfg_data        = vif.cfg_data;
  endtask: get_packet

endclass: cfg_mon