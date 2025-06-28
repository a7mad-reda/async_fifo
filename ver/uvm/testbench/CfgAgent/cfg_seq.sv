// --------------------- base sequence class ---------------------
class cfg_base_seq extends uvm_sequence #(cfg_tr);

  // Virtual interface for accessing DUT configuration signals
  virtual cfg_if    vif;

  // Sequencer handle for interaction with the sequencer
  uvm_sequencer_base config_sqr;

  //--------------------------------------------------------
  // Utility and Field macros
  // - Register the sequence with the UVM factory
  //-------------------------------------------------------
  `uvm_object_utils(cfg_base_seq)

  //--------------------------------------------------------
  // Constructor
  // - Calls the parent constructor
  // - Enables automatic phase objection if UVM version is not 1.1
  //--------------------------------------------------------
  function new(string name = "cfg_base_seq");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    
    `ifndef UVM_VERSION_1_1
      // Set automatic phase objection for newer UVM versions (not UVM 1.1)
      set_automatic_phase_objection(1);
    `endif // UVM_VERSION_1_1
  endfunction: new


  //--------------------------------------------------------
  // Pre-Start Callback
  // - Raises phase objection in UVM 1.1
  // - Retrieves the virtual interface from the sequencer's parent component
  //--------------------------------------------------------
  virtual task pre_start();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

  `ifdef UVM_VERSION_1_1
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.raise_objection(this);
    end
  `endif // UVM_VERSION_1_1

    // get cfg interface from sequencer for upstream translation
    config_sqr = get_sequencer();
    if (uvm_config_db#(virtual cfg_if)::get(config_sqr.get_parent(), "", "vif", vif)) begin
      `uvm_info("HOST_SEQ_CFG", "Has access to host interface", UVM_HIGH);
    end

  endtask: pre_start

  `ifdef UVM_VERSION_1_1
  //--------------------------------------------------------
  // Post-Start Callback (Only for UVM 1.1)
  // - Drops phase objection when the sequence completes
  //--------------------------------------------------------
  virtual task post_start();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.drop_objection(this);
    end
  endtask: post_start
  `endif // UVM_VERSION_1_1

endclass: cfg_base_seq

// ----------------- Derived Configuration Sequence -----------------
// -------------- Bus Functional model Config Sequence --------------
class cfg_bfm_seq extends cfg_base_seq;

   logic [2:0]         cfg_reg_addr;
   logic [15:0]        cfg_reg_data_expected;
   logic [15:0]        cfg_reg_data_actual;

  //--------------------------------------------------------
  // Utility and Field macros
  //--------------------------------------------------------
  `uvm_object_utils_begin(cfg_bfm_seq)
  `uvm_object_utils_end

  //--------------------------------------------------------
  // Constructor
  //--------------------------------------------------------
  function new(string name = "cfg_bfm_seq");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  //--------------------------------------------------------
  // Sequence body
  //--------------------------------------------------------
  virtual task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

   // Send random write requests followed by the read request to the same address
     for (int i=0; i<10; i++) begin
       std::randomize(cfg_reg_addr) with {  cfg_reg_addr inside {[0: 2]}; };
       std::randomize(cfg_reg_data_expected) with { (cfg_reg_addr == 0) ? ({cfg_reg_data_expected[15:9], cfg_reg_data_expected[7:0]} == '0) : (cfg_reg_data_expected[15:4] == '0); };
  `ifndef UVM_VERSION
   // For UVM-1.1 & UVM-1.2
      `uvm_do_with(req, {access_type == UVM_WRITE; cfg_addr == cfg_reg_addr; cfg_data == cfg_reg_data_expected;});
      `uvm_do_with(req, {access_type == UVM_READ;  cfg_addr == cfg_reg_addr;});
  `else // UVM_VERSION
   // For IEEE UVM
      `uvm_do(req,,, {access_type == UVM_WRITE; cfg_addr == cfg_reg_addr; cfg_data == cfg_reg_data_expected;});
      `uvm_do(req,,, {access_type == UVM_READ;  cfg_addr == cfg_reg_addr;});
  `endif // UVM_VERSION
      cfg_reg_data_actual = req.cfg_data;
      if (cfg_reg_data_expected != cfg_reg_data_actual) begin
        `uvm_fatal("RAL_ERR", $sformatf("RAL_INCORRECT, Expected = %d, Actual = %d.", cfg_reg_data_expected, cfg_reg_data_actual));
      end
    end

  endtask: body

endclass: cfg_bfm_seq

// ----------------- Derived Configuration Sequence -----------------
// ----------------- RAL Model base Config Sequence -----------------
class cfg_ral_seq_base extends uvm_reg_sequence #(cfg_base_seq);
  
  // Create instance of register model
  ral_block_dut_regmodel regmodel;

  //--------------------------------------------------------
  // Utility and Field Macros
  // - Registers the sequence with the UVM factory
  //--------------------------------------------------------
  `uvm_object_utils(cfg_ral_seq_base)

  //--------------------------------------------------------
  // Constructor
  // - Calls the parent constructor
  //--------------------------------------------------------
  function new(string name = "cfg_ral_seq_base");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  //--------------------------------------------------------
  // Pre-Start Callback
  // - Raises phase objection in UVM 1.1
  // - Retrieves the virtual interface from the sequencer's parent component
  //--------------------------------------------------------
  virtual task pre_start();
    super.pre_start();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Retrieve register model by sequencer config database
    if (!uvm_config_db#(ral_block_dut_regmodel)::get(config_sqr.get_parent(), "", "regmodel", regmodel)) begin
      `uvm_info("RAL_CFG", "regmodel not set through configuration.  Make sure it is set by other mechanisms", UVM_MEDIUM);
    end
    // If register model is not set, report a fatal error
    if (regmodel == null) begin
      `uvm_fatal("RAL_CFG", "regmodel not set");
    end

  endtask: pre_start

endclass: cfg_ral_seq_base

// ----------------- Derived Configuration Sequence -----------------
// ----------------- RAL Model Config self Sequence -----------------
class cfg_ral_direct_seq extends cfg_ral_seq_base;

   logic [15:0]        cfg_reg_data;
   string              cfg_reg_list[3] = { "CLEAR"
                                         , "WPTR"
                                         , "RPTR" };

  //--------------------------------------------------------
  // Utility and Field Macros
  //--------------------------------------------------------
  `uvm_object_utils(cfg_ral_direct_seq)
  
  //--------------------------------------------------------
  // Constructor
  //--------------------------------------------------------
  function new(string name = "cfg_ral_direct_seq");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  //--------------------------------------------------------
  // Sequence Body
  // - Performs register write/read operations
  // - Verifies mirror register values
  //--------------------------------------------------------
  virtual task body();
    uvm_status_e status;
    uvm_reg_data_t data_actual;
    uvm_reg_data_t data_expected;
    
    foreach (cfg_reg_list[i]) begin

      std::randomize(cfg_reg_data); // Set Random Data
      
      //---------------------
      // Front door access
      //---------------------
      // Write to Register
      regmodel.get_reg_by_name(cfg_reg_list[i]).write(.status(status), .value(cfg_reg_data) , .path(UVM_FRONTDOOR), .parent(this));
      // Get expected Read value from the mirrored vaule in the register model
      data_expected = regmodel.get_reg_by_name(cfg_reg_list[i]).get_mirrored_value();
      // Read the actual value from Register
      regmodel.get_reg_by_name(cfg_reg_list[i]).read(.status(status) , .value(data_actual)  , .path(UVM_FRONTDOOR), .parent(this));
      // Compare actual and expected values
      if (data_actual != data_expected) begin
        `uvm_fatal("RAL_ERR", $sformatf("RAL violation in Register %s, Expected = %d, Actual = %d.", cfg_reg_list[i], data_expected, data_actual));
      end
      
      //---------------------
      // Back door access
      //---------------------
      // Write to Register
      regmodel.get_reg_by_name(cfg_reg_list[i]).write(.status(status), .value(cfg_reg_data) , .path(UVM_BACKDOOR), .parent(this));
      // Get expected Read value from the mirrored vaule in the register model
      data_expected = regmodel.get_reg_by_name(cfg_reg_list[i]).get_mirrored_value();
      // Read the actual value from Register
      regmodel.get_reg_by_name(cfg_reg_list[i]).read(.status(status) , .value(data_actual)  , .path(UVM_BACKDOOR), .parent(this));
      // Compare actual and expected values
      if (data_actual != data_expected) begin
        `uvm_fatal("RAL_ERR", $sformatf("RAL violation in Register %s, Expected = %d, Actual = %d.", cfg_reg_list[i], data_expected, data_actual));
      end

    end

    // Note that backdoor reads update the mirrored value but frontdoor don't

    // Write to register field
    regmodel.WPTR.FULL_MRGN.write(.status(status), .value('d7), .path(UVM_FRONTDOOR), .parent(this));

  endtask: body

endclass: cfg_ral_direct_seq

// ----------------- Derived Configuration Sequence -----------------
// ------------------ RAL Config write fifo Margins -----------------
class cfg_mrgn_seq extends cfg_ral_seq_base;

   logic [15:0]        cfg_full_mrgn;
   logic [15:0]        cfg_empty_mrgn;

   // Declare handle for config sequencer
   cfg_sqr config_sqr;

  //--------------------------------------------------------
  // Utility and Field Macros
  //--------------------------------------------------------
  `uvm_object_utils(cfg_mrgn_seq)

  //--------------------------------------------------------
  // Constructor
  //--------------------------------------------------------
  function new(string name = "cfg_mrgn_seq");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  //--------------------------------------------------------
  // Sequence Body
  // - Performs register write operations
  //--------------------------------------------------------
  virtual task body();
    uvm_status_e status;

    std::randomize(cfg_full_mrgn)  with {cfg_full_mrgn  inside {[0:15]}; }; // Set Random value for empty margin
    std::randomize(cfg_empty_mrgn) with {cfg_empty_mrgn inside {[0:15]}; }; // Set Random value for full margin

    // Place callback hook to method defined in user-defined callback class
    `uvm_do_obj_callbacks(cfg_sqr,fifo_callback,config_sqr,pre_cfg_seq_wr(cfg_full_mrgn, cfg_empty_mrgn));

    // Write for full margin Register
    regmodel.WPTR.write(.status(status), .value(cfg_full_mrgn) , .path(UVM_FRONTDOOR), .parent(this));
    // Write for empty margin Register
    regmodel.RPTR.write(.status(status), .value(cfg_empty_mrgn), .path(UVM_FRONTDOOR), .parent(this));


  endtask: body

endclass: cfg_mrgn_seq