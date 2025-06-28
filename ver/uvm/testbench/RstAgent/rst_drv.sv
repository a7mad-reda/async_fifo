// Define a parameterized Reset driver class
class rst_drv extends uvm_driver #(rst_tr);

  // Declare a virtual interface to interact with the DUT
  virtual  rst_if vif;

  //--------------------------------------------------------
  // Utility and Field macros
  // - Register the driver with the UVM factory
  //--------------------------------------------------------
  `uvm_component_utils(rst_drv)

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
    uvm_config_db#(virtual rst_if)::get(this, "", "rst_vif", vif);
  endfunction: build_phase

  //--------------------------------------------------------
  // End-of-Elaboration Phase
  // - Checking the correctness of 
  //   testbench structure & the configuration variables.
  //--------------------------------------------------------
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if (vif == null) begin
      `uvm_fatal("CFGERR", "Interface for Reset Driver is not set");
    end
  endfunction: end_of_elaboration_phase

  //--------------------------------------------------------
  // Start-of-Simulation Phase
  // - Displaying the testbench configuration 
  //   before any active verification operation starts.
  //--------------------------------------------------------
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: start_of_simulation_phase

  //--------------------------------------------------------
  // Run Phase
  // - Continuously fetches transactions and sends them to the DUT
  //--------------------------------------------------------
  virtual task run_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    
    forever begin
      seq_item_port.get_next_item(req);
      fork
        drive_wr_rst(req);
        drive_rd_rst(req);
      join
      `uvm_info("DRV_RUN", {"\n", req.sprint()}, UVM_MEDIUM);
      seq_item_port.item_done();
    end
  endtask: run_phase

  //--------------------------------------------------------
  // Driver tasks 
  //--------------------------------------------------------
  // Intiate Write reset to DUT
  virtual task drive_wr_rst(rst_tr tr);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if (tr.kind == rst_tr::ASSERT) begin
      vif.wrst_n = 1'b0;
      repeat(tr.cycles) @(vif.srcDrv_cb);
    end else begin
      vif.wrst_n <= '1;
      repeat(tr.cycles) @(vif.srcDrv_cb);
    end
  endtask: drive_wr_rst

  // Intiate Read reset to DUT
  virtual task drive_rd_rst(rst_tr tr);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if (tr.kind == rst_tr::ASSERT) begin
      vif.rrst_n = 1'b0;
      repeat(tr.cycles) @(vif.dstDrv_cb);
    end else begin
      vif.rrst_n <= '1;
      repeat(tr.cycles) @(vif.dstDrv_cb);
    end
  endtask: drive_rd_rst

endclass: rst_drv
