class test_reg_ral_directed extends test_base;

  //--------------------------------------------------------
  // Utility and Field macros
  //--------------------------------------------------------
  `uvm_component_utils(test_reg_ral_directed)

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

    // Turn off all sequence execution at the configure and main phase.
    uvm_config_db #(uvm_object_wrapper)::set(this, "env.*.configure_phase", "default_sequence", null);
    uvm_config_db #(uvm_object_wrapper)::set(this, "env.*.main_phase", "default_sequence", null);

    // Global reset is already added in reset phase by test base

    // Excute cfg_ral_direct_seq on Config sqr in main phase
    uvm_config_db #(uvm_object_wrapper)::set(this, "env.cfg_agt.sqr.main_phase", "default_sequence", cfg_ral_direct_seq::get_type());

  endfunction: build_phase

endclass: test_reg_ral_directed