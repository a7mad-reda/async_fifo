// Define a parameterized Configuration driver class
class cfg_drv extends uvm_driver #(cfg_tr);

  // Declare a virtual interface to interact with the DUT
  virtual  cfg_if vif;

  //--------------------------------------------------------
  // Utility and Field macros
  // - Register the driver with the UVM factory
  //--------------------------------------------------------
  `uvm_component_utils(cfg_drv)

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
      `uvm_fatal("CFGERR", "Interface for Configuartion Driver is not set");
    end
  endfunction: end_of_elaboration_phase

  //--------------------------------------------------------
  // Run Phase
 // - Continuously fetches transactions and sends them to the DUT
  //--------------------------------------------------------
  virtual task run_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    fork
      forever begin
        @(negedge vif.wrst_n);
        req_init();
      end
      @(posedge vif.wclk);
      forever begin
        seq_item_port.get_next_item(req);
        `uvm_info("RUN", { "Before process\n", req.sprint() }, UVM_FULL);
        send(req);
        rsp = cfg_tr::type_id::create("rsp", this);
        //rsp.set_id_info(req);
        `uvm_info("RUN", { "After process\n", req.sprint() }, UVM_FULL);
        seq_item_port.item_done();
      end
    join
  endtask: run_phase

  //--------------------------------------------------------
  // Driver tasks 
  //--------------------------------------------------------
  virtual task send(cfg_tr req);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if (req.access_type == UVM_WRITE) begin
      wr_req(req);
    end
    else if (req.access_type == UVM_READ) begin
      rd_req(req);
    end
  endtask: send

  // Intiate configuration write request to DUT
  virtual task wr_req(cfg_tr req);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    vif.cfg_wr   <= 1'b1;
    vif.cfg_addr <= req.cfg_addr;
    vif.cfg_data <= req.cfg_data;
    @(vif.Drv_cb);
    vif.cfg_wr   <= 1'b0;
    vif.cfg_data <= 'z;
  endtask: wr_req

  // RAL read sequences are delayed by 1 step so we don't use clocking block in driving
  // Intiate configuration read request to DUT
  virtual task rd_req(cfg_tr req);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    vif.cfg_rd          <= 1'b1;
    vif.cfg_addr        <= req.cfg_addr;
    #1step
    req.cfg_data        = vif.cfg_data;
    @(vif.Drv_cb);
    vif.cfg_rd          <= 1'b0;
  endtask: rd_req

 // Tie configuration interface to zero's in reset phase
  virtual task req_init;
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    vif.cfg_wr   <= '0;
    vif.cfg_rd   <= '0;
    vif.cfg_addr <= '0;
  endtask: req_init

endclass: cfg_drv