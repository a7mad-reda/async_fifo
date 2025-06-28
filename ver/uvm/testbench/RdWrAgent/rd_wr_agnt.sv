// Define a sequencer for read/write transactions
typedef uvm_sequencer #(rd_wr_tr) rd_wr_sqr;

class rd_wr_agnt extends uvm_agent;

  // Declare a virtual interface for the DUT connection
  virtual  rd_wr_if vif;

  // Define an integer variable to store the driver type
  // (0: Write Driver, 1: Read Driver)
  int      driver_type = -1;

  // Declare an analysis port for broadcasting monitor output
  uvm_analysis_port #(pkt_mon_pkt_s) analysis_port;

  // Declare handles for components defined under the Agent
  rd_wr_sqr    sqr;
  rd_wr_drv    drv;
  rd_wr_mon    mon;

  //--------------------------------------------------------
  // Register the component with UVM factory
  //--------------------------------------------------------
  `uvm_component_utils(rd_wr_agnt)

  //--------------------------------------------------------
  // Constructor function: Initializes the agent
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
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH); // Print trace information

    // If the agent is active, create the sequencer and driver
    if (is_active == UVM_ACTIVE) begin
      sqr = rd_wr_sqr::type_id::create("sqr", this);
      drv = rd_wr_drv::type_id::create("drv", this);
    end

    // Always Construct the monitor
    mon = rd_wr_mon::type_id::create("mon", this);

    // Contruct TLM analysis port.
    analysis_port = new("analysis_port", this);

    // Retrieve configuration properties from upper components
    uvm_config_db#(int)::get(this, "", "driver_type", driver_type);
    uvm_config_db#(virtual rd_wr_if)::get(this, "", "vif", vif);

    // Set configuration parameters for sub-components
    uvm_config_db#(int)::set(this, "*", "driver_type", driver_type);
    uvm_config_db#(virtual rd_wr_if)::set(this, "*", "vif", vif);

  endfunction: build_phase

  //--------------------------------------------------------
  // Connect Phase:
  // - Establishes TLM connections between components
  //--------------------------------------------------------
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // If the agent is active, connect drv's seq_item_port to sqr's seq_item_export.
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
     `uvm_fatal("CFGERR", "Interface for Rd/Wr Agent is not set");
    end

    // Check if the driver type is correctly assigned
    if (!(driver_type inside {0, 1})) begin
      `uvm_fatal("driver_type", "Driver type for Agent is not set");
    end
  endfunction: end_of_elaboration_phase

endclass: rd_wr_agnt