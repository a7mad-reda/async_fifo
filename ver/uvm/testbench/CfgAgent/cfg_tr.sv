class cfg_tr extends uvm_sequence_item;

  rand uvm_access_e             access_type;
  rand uvm_status_e             status;
  rand logic [2:0]              cfg_addr;
  rand logic [15:0]             cfg_data;

  //--------------------------------------------------------
  // Utility and Field macros
  //--------------------------------------------------------
  `uvm_object_utils_begin(cfg_tr)
    `uvm_field_enum(uvm_access_e, access_type, UVM_ALL_ON)
    `uvm_field_enum(uvm_status_e, status, UVM_ALL_ON)
    `uvm_field_int(cfg_addr, UVM_ALL_ON)
    `uvm_field_int(cfg_data, UVM_ALL_ON)
  `uvm_object_utils_end

  //--------------------------------------------------------
  // Constraints
  //--------------------------------------------------------
  constraint valid_addr {
    cfg_addr inside {[0: 4]};
  }

  constraint valid_data {
    (cfg_addr == 0) ? ({cfg_data[15:9], cfg_data[7:0]} == '0) : (cfg_data[15:4] == '0);
  }

  //--------------------------------------------------------
  // Constructor
  //--------------------------------------------------------
  function new(string name = "cfg_tr");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

endclass: cfg_tr

//------------------------------------------------------------------------------
// Class: reg_adapter
// Description:
//   This class implements a UVM register adapter that translates between 
//   uvm_reg_bus_op transactions and the user-defined 'cfg_tr' transaction.
//------------------------------------------------------------------------------
class reg_adapter extends uvm_reg_adapter;
  `uvm_object_utils(reg_adapter)

  //--------------------------------------------------------
  // Constructor
  //--------------------------------------------------------
  function new(string name="reg_adapter");
    super.new(name);
    `uvm_info("Trace", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  //--------------------------------------------------------
  // Function: reg2bus
  //   Converts a uvm_reg_bus_op (register model transaction)
  //   to a cfg_tr bus transaction.
  //--------------------------------------------------------
  virtual function uvm_sequence_item reg2bus (const ref uvm_reg_bus_op rw);
    cfg_tr tr;
    `uvm_info("Trace", $sformatf("%m"), UVM_HIGH);

    // Create the transaction using the factory
    tr = cfg_tr::type_id::create("tr");

    tr.cfg_addr    = rw.addr;
    tr.cfg_data    = rw.data;
    tr.access_type = rw.kind;

    return tr;

  endfunction: reg2bus

  //--------------------------------------------------------
  // Function: bus2reg
  //   Converts a cfg_tr bus transaction back into 
  //   a uvm_reg_bus_op format, which the register model can understand
  //--------------------------------------------------------
  virtual function void bus2reg (uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    cfg_tr tr;
    `uvm_info("Trace", $sformatf("%m"), UVM_HIGH);

    // Create the transaction using the factory
    tr = cfg_tr::type_id::create("tr");

    // Cast the generic uvm_sequence_item to cfg_tr
    if (!$cast(tr, bus_item)) begin
      `uvm_fatal("NOT_HOST_REG_TYPE", "bus_item is not correct type");
    end

    rw.addr   = tr.cfg_addr;
    rw.data   = tr.cfg_data;
    rw.kind   = tr.access_type;
    rw.status = UVM_IS_OK;

  endfunction: bus2reg

endclass: reg_adapter