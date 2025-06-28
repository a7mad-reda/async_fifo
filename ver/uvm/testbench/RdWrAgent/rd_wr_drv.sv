// Define a parameterized Rd/Wr driver class
class rd_wr_drv extends uvm_driver #(rd_wr_tr);

  // Declare a virtual interface to interact with the DUT
  virtual  rd_wr_if vif;

  // Integer to specify driver type:
  // 0 = Write Driver, 1 = Read Driver
  int      driver_type = -1;

  //--------------------------------------------------------
  // Utility and Field macros
  // - Register the driver with the UVM factory
  //--------------------------------------------------------
  `uvm_component_utils_begin(rd_wr_drv)
    `uvm_field_int(driver_type, UVM_ALL_ON | UVM_DEC)
  `uvm_component_utils_end

  // Register Callback class with the object/component where callbacks are going to be used.
  // This macro is used to register the Callback (CB) with the Object(T).
  `uvm_register_cb(rd_wr_drv,fifo_callback)

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
      `uvm_fatal("CFGERR", "Interface for Driver is not set");
    end
    if (!(driver_type inside {0, 1})) begin
      `uvm_fatal("driver_type", "Driver type for Driver is not set");
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
    `uvm_info("DRV_CFG", $sformatf("driver_type == %0d, 0: Wr Driver, 1: Rd Driver", driver_type), UVM_MEDIUM);
  endfunction: start_of_simulation_phase

  //--------------------------------------------------------
  // Run Phase
  // - Continuously fetches transactions and sends them to the DUT
  //--------------------------------------------------------
  virtual task run_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    
    forever begin
      seq_item_port.get_next_item(req);
    // Place callback hook to method defined in user-defined callback class
      `uvm_do_callbacks(rd_wr_drv,fifo_callback,pkt_wr(req));
      send(req);
      `uvm_info("DRV_RUN", {"\n", req.sprint()}, UVM_MEDIUM);
    end
  endtask: run_phase

  //--------------------------------------------------------
  // Driver tasks
  //--------------------------------------------------------
  virtual task send(rd_wr_tr req);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if (driver_type == 1) begin
      if (req.wr_to_full == 1) begin
        wr_to_full_req(req);
      end
      else begin
        wr_req(req);
      end
      seq_item_port.item_done();
    end
    else begin
      if (req.rd_to_empty == 1) begin
        rd_to_empty_req(req);
      end
      else begin
        rd_req(req);
      end
      rsp = rd_wr_tr::type_id::create("rsp", this);
      // Copying Reques ID to response ID
      // to ensure that any response items have the same sequence id as their originating request.
      // As Multiple sequences can interact concurrently with a driver
      rsp.set_id_info(req);
      rsp.data = req.data;
      seq_item_port.item_done(rsp);
    end
  endtask: send

  // Intiate Write request to DUT
  virtual task wr_req(rd_wr_tr req);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    for (int i=0; i < $size(req.data, 1); i++) begin
      do begin
        @(posedge vif.wclk);
        vif.srcDrv_cb.wdata <= req.data[i];
        if (!vif.srcDrv_cb.full | req.force_req) begin
          vif.srcDrv_cb.wen   <= 1;
        end
        else begin
          vif.srcDrv_cb.wen   <= 0;
        end
      end while (vif.srcDrv_cb.full & ~req.force_req);
    end
    @(posedge vif.wclk);
    vif.srcDrv_cb.wen   <= 0;
  endtask: wr_req

  // Intiate Write to full request to DUT
  logic [`ADDR_WD-1:0] idx;
  virtual task wr_to_full_req(rd_wr_tr req);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    idx = 0;
    while (!vif.full) begin
      idx++;
      @(negedge vif.wclk);
      vif.wen   = 1;
      vif.wdata = req.data[idx];
    end
    vif.wen   = '0;
    vif.wdata = '0;
  endtask: wr_to_full_req

  // Intiate Read request to DUT
  virtual task rd_req(rd_wr_tr req);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    for (int i=0; i < $size(req.data, 1); i++) begin
      do begin
        @(negedge vif.rclk);
        if (!vif.empty | req.force_req) begin
          vif.ren     = 1;
          req.data[i] = vif.rdata;
        end
        else begin
          vif.ren   = 0;
        end
      end while (vif.empty & !req.force_req);
    end
    @(negedge vif.rclk);
    vif.ren   = 0;
  endtask: rd_req

  // Intiate Read request to DUT
  int k = 0;
  virtual task rd_to_empty_req(rd_wr_tr req);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    k = 0;
    while (!vif.empty) begin
      @(negedge vif.rclk);
      vif.ren   = 1;
      req.data[k] = vif.rdata;
      k++;
    end
    vif.ren   = 0;
  endtask: rd_to_empty_req

endclass: rd_wr_drv