// Explicitely execute the virtual reset sequence.
// Then explicitely execute buil-in RAL reg sequences.
class test_reg_ral_auto extends test_base;

  //--------------------------------------------------------
  // Utility and Field macros
  //--------------------------------------------------------
  `uvm_component_utils(test_reg_ral_auto)

  // Built-in sequences to be tested
  string                 seq_name[$] = {"uvm_reg_hw_reset_seq"       // Tests the hard reset values of registers. "LSB"
                                       ,"uvm_reg_single_access_seq"  // Verify accessibility through front and back door for a single register.
                                       ,"uvm_reg_access_seq"         // Verify accessibility through front and back door for all registers in reg model.
                                       ,"uvm_reg_bit_bash_seq"};     // Verifies the implementation of all registers by attempting to write 1’s and 0’s to every bit in it.

  string                     clp_seq = "null";                       // Reg sequence to be excuted from command line

  uvm_reg_sequence           selftest_seq [4];   // Reg sequence base
  uvm_reg_single_access_seq  single_access_seq;  // Single access sequence
  rst_top_seq                top_rst_seq;        // Reset virtual sequence
  bit                        single_flag;        // Single Flag
  bit                        cast_successful;    // Single Flag

  ral_reg_WPTR               WPTR;               // UVM Register for single register test

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

    // Turn off all sequences 
    uvm_config_db #(uvm_object_wrapper)::set(this,"*","default_sequence",null);
  endfunction: build_phase

  //--------------------------------------------------------
  // Reset Phase
  //--------------------------------------------------------
  virtual task reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    phase.raise_objection(this, "Starting reset tests");

    // Execute Global reset
    top_rst_seq = rst_top_seq::type_id::create("top_rst_seq", this);
    top_rst_seq.start(top_rst_sqr);

    phase.drop_objection(this, "Done with Global reset");

  endtask: reset_phase

  //--------------------------------------------------------
  // Run Phase
  // - Squences are implemented explicitly
  //--------------------------------------------------------
  virtual task main_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    phase.raise_objection(this, "Starting RAL Built-in Sequences tests");

    // Execute RAL Req sequences
    clp.get_arg_value("+seq=", clp_seq);

    //------------------------------------
    // Reg sequence from command-line
    //------------------------------------
    if (clp_seq != "null") begin
      single_flag = 1'b0;
      for (int i=0; i<clp_seq.len(); i++) begin
        if (clp_seq.substr(i,i+6-1) == "single") begin
          single_flag = 1'b1;
        end
      end
      // RAL sequence for single register
      if ( clp_seq == "uvm_reg_single_access_seq") begin
        single_access_seq = new("single_access_seq");
        single_access_seq.model = env.regmodel;
        single_access_seq.rg    = env.regmodel.WPTR;
        single_access_seq.start(env.cfg_agt.sqr);
      end
      else if (single_flag) begin
        `uvm_fatal("INVALID_SEQ", $sformatf("Uusupported RAL Single register sequence"));
      end
      // RAL sequence for all registers
      else begin
        cast_successful = $cast(selftest_seq[0], uvm_factory::get().create_object_by_name(clp_seq));
        if ( cast_successful ) begin
          $cast(selftest_seq[0], uvm_factory::get().create_object_by_name(clp_seq));
          selftest_seq[0].model = env.regmodel;
          selftest_seq[0].start(env.cfg_agt.sqr);
        end
        else begin
          `uvm_fatal("INVALID_SEQ", $sformatf("Unsupported RAL register sequence"));
        end
      end
    end
    else begin
    //------------------------------------
    // Default built-in Reg sequences
    //------------------------------------
      foreach (seq_name[i]) begin
        begin
          // RAL sequence for single register
          if ( seq_name[i] == "uvm_reg_single_access_seq") begin
            single_access_seq = new("single_access_seq");
            single_access_seq.model = env.regmodel;
            single_access_seq.rg    = env.regmodel.WPTR;
            single_access_seq.start(env.cfg_agt.sqr,.this_priority(100));
          end
          // RAL sequence for all registers
          else begin
            $cast(selftest_seq[0], uvm_factory::get().create_object_by_name(seq_name[i]));
            selftest_seq[0].model = env.regmodel;
            selftest_seq[0].start(env.cfg_agt.sqr,.this_priority(200));
          end
        end
      end

      // Sequence arbitration by weight
      // execute all sequences at the same time and the sequencer will arbitrate by weight
      // This doesn't work here because the sequencer doesn't grant the sequence untill it's finished
      // It can grant a single sequence item and move to another sequence which can cause error if read after write is interleaved with unpredicted write from another sequence.
      // to avoid this we can lock the sequencer to the granted sequence using lock() unlock(), but this needs to be implemeted inside the sequnce itself.
      // In this case, the sequence is a built-in sequence and in order to updated it, we need to inhert the built-in sequnece

      //env.cfg_agt.sqr.set_arbitration(UVM_SEQ_ARB_WEIGHTED);
      //foreach (seq_name[i]) begin
      //  automatic int tid = i;
      //  fork
      //  begin
      //    // RAL sequence for single register
      //    if ( seq_name[tid] == "uvm_reg_single_access_seq") begin
      //      single_access_seq = new("single_access_seq");
      //      single_access_seq.model = env.regmodel;
      //      single_access_seq.rg    = env.regmodel.WPTR;
      //      single_access_seq.start(env.cfg_agt.sqr,.this_priority(100));  // Lowest priority
      //    end
      //    // RAL sequence for all registers
      //    else if ( seq_name[tid] == "uvm_reg_hw_reset_seq") begin
      //      $cast(selftest_seq[tid], uvm_factory::get().create_object_by_name(seq_name[tid]));
      //      selftest_seq[tid].model = env.regmodel;
      //      selftest_seq[tid].start(env.cfg_agt.sqr,.this_priority(2000)); // Highest priority
      //    end
      //      $cast(selftest_seq[tid], uvm_factory::get().create_object_by_name(seq_name[tid]));
      //      selftest_seq[tid].model = env.regmodel;
      //      selftest_seq[tid].start(env.cfg_agt.sqr,.this_priority(200));
      //    end
      //  end
      //  join_none
      //end
    end

    phase.drop_objection(this, "Done with register tests");
  endtask: main_phase

endclass: test_reg_ral_auto