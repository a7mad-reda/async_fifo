//------------------------------------------------------------------------------
// FIFO Environment Class
// This UVM environment encapsulates all the components needed for the testbench,
// including agents, scoreboard, register model, and register predictor.
//------------------------------------------------------------------------------
class fifo_env extends uvm_env;

  // Environment components
  rst_agnt         rst_agt;       // Reset agent
  cfg_agnt         cfg_agt;       // Configuration agent
  rd_wr_agnt       wr_agt;        // Write agent
  rd_wr_agnt       rd_agt;        // Read agent
  fifo_scoreboard  sb;            // Scoreboard

  // UVM Register model and related components
  ral_block_dut_regmodel regmodel;  // DUT register model
  reg_adapter            adapter;   // Register adapter for UVM reg access

  // RAL Predictor
  typedef uvm_reg_predictor #(cfg_tr) reg_predictor; // RAL predictor definition
  reg_predictor reg_predict;                         // RAL predictor instance

  //--------------------------------------------------------
  // Utility and Field macros
  //--------------------------------------------------------
  // Registers this component with the UVM factory
  `uvm_component_utils(fifo_env)

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
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH); // Trace build_phase call

    //--------------- Environment components ---------------//
    // Create and configure Reset Agent
    rst_agt = rst_agnt::type_id::create("rst_agt", this);
    uvm_config_db #(uvm_object_wrapper)::set(this, "rst_agt.sqr.reset_phase", "default_sequence", rst_seq::get_type());

    // Create Configuration Agent and Register Adapter
    cfg_agt = cfg_agnt::type_id::create("cfg_agt", this);

    // Create and configure Write Agent
    wr_agt = rd_wr_agnt::type_id::create("wr_agt", this);
    uvm_config_db #(int)::set(this, wr_agt.get_name(), "driver_type", 1); // Type 1 = Write
    uvm_config_db #(uvm_object_wrapper)::set(this, {wr_agt.get_name(), ".", "sqr.reset_phase"}, "default_sequence", rd_wr_rst_seq#(1, 0)::get_type());
    uvm_config_db #(uvm_object_wrapper)::set(this, {wr_agt.get_name(), ".", "sqr.main_phase"}, "default_sequence", rd_wr_seq#(1, 0)::get_type());

    // Create and configure Read Agent
    rd_agt = rd_wr_agnt::type_id::create("rd_agt", this);
    uvm_config_db #(int)::set(this, rd_agt.get_name(), "driver_type", 0); // Type 0 = Read
    uvm_config_db #(uvm_object_wrapper)::set(this, {rd_agt.get_name(), ".", "sqr.reset_phase"}, "default_sequence", rd_wr_rst_seq#(0, 1)::get_type());
    uvm_config_db #(uvm_object_wrapper)::set(this, {rd_agt.get_name(), ".", "sqr.main_phase"}, "default_sequence", rd_wr_seq#(0, 1)::get_type());

    // Create the FIFO scoreboard
    sb = fifo_scoreboard::type_id::create("sb", this);

    //--------------- RAL components ---------------//
    // Retrieve RAL register model from config DB if available
    uvm_config_db #(ral_block_dut_regmodel)::get(this, "", "regmodel", regmodel);

    // If register model is not found, create it
    if (regmodel == null) begin
      string hdl_path;
      `uvm_info("HOST_CFG", "Self constructing regmodel", UVM_MEDIUM);

      // Get the HDL path for DPI backdoor access
      if (!uvm_config_db #(string)::get(this, "", "hdl_path", hdl_path)) begin
        `uvm_warning("HOST_CFG", "HDL path for DPI backdoor not set!");
      end

      // Build and lock the register model
      regmodel = ral_block_dut_regmodel::type_id::create("regmodel", this);
      regmodel.build();
      regmodel.lock_model();                // Once locked, the model cannot be modified no more fields, registers, blocks, or address maps can be added or removed
      regmodel.set_hdl_path_root(hdl_path); // Set HDL root path for DPI backdoor access
    end

    // Create the RAL register adapter
    adapter = reg_adapter::type_id::create("adapter", this);

    // Create the RAL register predictor
    reg_predict = reg_predictor::type_id::create("reg_predict", this);

    // Share regmodel with the config agent
    uvm_config_db #(ral_block_dut_regmodel)::set(this, cfg_agt.get_name(), "regmodel", regmodel);

    // Set the default config sequence to access the regmodel
    uvm_config_db #(uvm_object_wrapper)::set(this, {cfg_agt.get_name(), ".", "sqr.configure_phase"}, "default_sequence", cfg_ral_direct_seq::get_type());

  endfunction: build_phase

  //--------------------------------------------------------
  // Connect Phase
  //--------------------------------------------------------
  virtual function void connect_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Connect write and read agent analysis ports to scoreboard
    wr_agt.analysis_port.connect(sb.before_imp);  // Write events
    rd_agt.analysis_port.connect(sb.after_imp);   // Read events

    // Connect register model to config sequencer and adapter
    regmodel.default_map.set_sequencer(cfg_agt.sqr, adapter);

    // Disable automatic prediction, enable explicit predictor
    regmodel.default_map.set_auto_predict(0);
    reg_predict.map     = regmodel.get_default_map();  // Tells predictor where the registers are in Regmodel
    reg_predict.adapter = adapter;                     // Tells predictor how to interpret bus data

    // Connect config agent's analysis port to the register predictor
    cfg_agt.analysis_port.connect(reg_predict.bus_in);

  endfunction: connect_phase

endclass: fifo_env