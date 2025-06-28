// Define a parameterized Rd/Wr Monitor class
class rd_wr_mon extends uvm_monitor;

  // Declare a virtual interface for DUT interaction
  virtual  rd_wr_if vif;

  // Integer to store driver type: 
  // 0 = Write Monitor, 1 = Read Monitor
  int      driver_type = -1;

  // UVM Analysis Port for sending collected transactions to subscribers
  uvm_analysis_port #(pkt_mon_pkt_s) analysis_port;

  //--------------------------------------------------------
  // Utility and Field macros
  // - Register the Monitor with the UVM factory
  //--------------------------------------------------------
  `uvm_component_utils_begin(rd_wr_mon)
    `uvm_field_int(driver_type, UVM_ALL_ON | UVM_DEC)
  `uvm_component_utils_end

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
    uvm_config_db#(int)::get(this, "", "driver_type", driver_type);
    uvm_config_db#(virtual rd_wr_if)::get(this, "", "vif", vif);

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
      `uvm_fatal("CFGERR", "Interface for Rd/Wr Monitor is not set");
    end

    // Ensure the driver type is correctly set
    if (!(driver_type inside {0, 1})) begin
      `uvm_fatal("driver_type", "Driver type for the Rd/Wr Monitor is not set");
    end
  endfunction: end_of_elaboration_phase

  //--------------------------------------------------------
  // Run Phase
  // - Continuously monitors and records transactions
  // - Sends observed transactions to subscribers
  //   via TLM analysis port
  //--------------------------------------------------------
  virtual task run_phase(uvm_phase phase);
    pkt_mon_pkt_s req;
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    
    forever begin
      // Capture a packet from the DUT
      get_packet(req);
      if (driver_type == 1) begin
      `uvm_info("MON_REC", $sformatf("Write_packet_received Data = %d", req.data), UVM_MEDIUM);
      end
      else begin
      `uvm_info("MON_REC", $sformatf("Read_packet_received Data = %d", req.data), UVM_MEDIUM);
      end
      analysis_port.write(req);
    end
  endtask: run_phase

  //--------------------------------------------------------
  // Packet Monitoring Tasks 
  //--------------------------------------------------------
  virtual task get_packet(output logic [`DATA_WD -1:0] req);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if (driver_type == 1) begin
      wr_req(req);
    end
    else begin
      rd_req(req);
    end
  endtask: get_packet

  // Capture Write Transactions from DUT
  virtual task wr_req(output pkt_mon_pkt_s req);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    @(vif.iMon_cb iff (vif.iMon_cb.wen));
    req.data      = vif.iMon_cb.wdata;
    req.overflow  = vif.iMon_cb.full;
    req.underflow = 0;
  endtask: wr_req

  // Capture Read Transactions from DUT
  virtual task rd_req(output pkt_mon_pkt_s req);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    @(vif.oMon_cb iff (vif.oMon_cb.ren));
    req.data      = vif.oMon_cb.rdata;
    req.overflow  = 0;
    req.underflow = vif.oMon_cb.empty;
  endtask: rd_req

endclass: rd_wr_mon