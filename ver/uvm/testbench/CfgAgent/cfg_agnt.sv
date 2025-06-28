class cfg_agnt extends uvm_agent;

  // Declare a virtual interface for the DUT connection
  virtual  cfg_if vif;

  // Declare an analysis port for broadcasting monitor output
  uvm_analysis_port #(cfg_tr) analysis_port;

  // Declare handles for components defined under the Agent
  cfg_sqr           sqr;
  cfg_drv           drv;
  cfg_mon           mon;

  // Declare handles for components defined under the Agent
  //--------------------------------------------------------
  // Utility and Field macros
  // - To register the component with UVM factory
  //--------------------------------------------------------
  `uvm_component_utils(cfg_agnt)

  //--------------------------------------------------------
  // Constructor function
  //--------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  //--------------------------------------------------------
  // Build Phase
  // - Constructs the required sub-components 
  // - sets up configuration parameters.
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // If the agent is active, create the sequencer and driver
    if (is_active == UVM_ACTIVE) begin
      sqr = cfg_sqr::type_id::create("sqr", this);
      drv = cfg_drv::type_id::create("drv", this);
    end

  // Always Construct the monitor
    mon  = cfg_mon::type_id::create("mon", this);

    // Contruct TLM analysis port.
    analysis_port = new("analysis_port", this);

    // Retrieve configuration properties
    uvm_config_db#(virtual cfg_if)::get(this, "", "vif", vif);
    // Set configuration parameters for sub-components
    uvm_config_db#(virtual cfg_if)::set(this, "*", "vif", vif);

  endfunction: build_phase

  //--------------------------------------------------------
  // Connect Phase
  // - Establishes TLM connections between components
  //--------------------------------------------------------
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Connect drv's seq_item_port to sqr's seq_item_export if the is_active flag is UVM_ACTIVE.
    if (is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
    end

    // Connect the monitor's analysis_port to the agent's pass-through analysis_port
    mon.analysis_port.connect(this.analysis_port);
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
     `uvm_fatal("CFGERR", "Interface for CFG Agent is not set");
    end
  endfunction: end_of_elaboration_phase

endclass: cfg_agnt