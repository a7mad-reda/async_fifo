//------------------------------------------------------------------------------
// Title       : FIFO Scoreboard
// Project     : UVM Testbench for FIFO Verification
// Description : This class implements a scoreboard for verifying the correctness
//               of a FIFO design. It compares the data received at the output
//               with the expected data collected at the input to detect mismatches.
//               It also collects coverage information for validation metrics.
//------------------------------------------------------------------------------
class fifo_scoreboard extends uvm_scoreboard;

  // Virtual interface handle to communicate with the DUT signals
  virtual  rd_wr_if vif;

  // Fifo state
  fifo_state_t fifo_state;

  // Declare separate analysis ports for ingress and egress monitoring
  `uvm_analysis_imp_decl(_ingress)
  `uvm_analysis_imp_decl(_egress)
  uvm_analysis_imp_ingress #(pkt_mon_pkt_s, fifo_scoreboard) before_imp; // input monitor port
  uvm_analysis_imp_egress  #(pkt_mon_pkt_s, fifo_scoreboard) after_imp;  // output monitor port

  // Queues to store input and output transactions
  logic [`DATA_WD -1:0] in_queue  [$];
  logic [`DATA_WD -1:0] out_queue [$];

  // Transaction counters
  int wr_trans_cnt = 0;       // Number of write transactions recieved
  int rd_trans_cnt = 0;       // Number of read transactions recieved
  int matched = 0;            // Number of matched read/write pairs
  int unmatched = 0;          // Number of mismatches between read/write
  realtime timeout = 100ms;   // Maximum time before timeout error
  realtime start_time = 10us; // Initial time reference for timeout check

  // Reset Events
  // Global UVM event triggers used to synchronize reset behavior
  uvm_event wr_reset_event = uvm_event_pool::get_global("wr_reset");

  //--------------------------------------------------------
  // Utility and Field macros
  //--------------------------------------------------------
  `uvm_component_utils(fifo_scoreboard)

  //--------------------------------------------------------
  // Constructor function
  //--------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Retrieve virtual interface from configuration database
    uvm_config_db#(virtual rd_wr_if)::get(this, "", "vif", vif);

    // Instantiate coverage group
    fifo_wr_cov = new();
    fifo_rd_cov = new();

    // Disable coverage collection
    fifo_wr_cov.stop();
    fifo_rd_cov.stop();

  endfunction: new

  //--------------------------------------------------------
  // Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Create analysis port objects
    before_imp = new("before_imp", this);
    after_imp  = new("after_imp", this);

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
  endfunction: end_of_elaboration_phase

  //--------------------------------------------------------
  // Run Phase
  //--------------------------------------------------------
  // Protect test against unexpected large run-time.
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    // enable coverage after reset
    wr_reset_event.wait_on();
    // Start coverage collection
    fifo_wr_cov.start();
    fifo_rd_cov.start();

    fork
      // Start timeout checker
      check_timeout();

      // Moitor FIFO state
      forever begin
        @(posedge vif.wclk);
        unique case (1'b1)
          vif.full:       fifo_state = FULL;
          vif.near_full:  fifo_state = NEAR_FULL;
          vif.near_empty: fifo_state = NEAR_EMPTY;
          vif.empty:      fifo_state = EMPTY;
          default:        fifo_state = EMPTY;
        endcase
      end
    join

  endtask: run_phase

  //--------------------------------------------------------
  // TLM analysis port write method
  //--------------------------------------------------------
   virtual function void write_ingress(pkt_mon_pkt_s packet);
    `uvm_info (get_full_name(), "FIFO got input transaction", UVM_MEDIUM)

    if (!packet.overflow) begin
      // Store valid input data into input queue
      in_queue.push_front(packet.data);
      wr_trans_cnt++;
      `uvm_info("SB_WRITE", $sformatf("Scoreboard has %0d write transactions", wr_trans_cnt), UVM_MEDIUM);
    end
   endfunction

   virtual function void write_egress (pkt_mon_pkt_s packet);
    `uvm_info (get_full_name(), "FIFO got output transaction", UVM_MEDIUM)

    if (!packet.underflow) begin
      // Store valid output data into output queue
      out_queue.push_front(packet.data);
      rd_trans_cnt++;
      fifo_cmp();
      `uvm_info("SB_READ", $sformatf("Scoreboard recieved read transaction, %0d transactions pending", (wr_trans_cnt-rd_trans_cnt)), UVM_MEDIUM);
    end
   endfunction

  //--------------------------------------------------------
  // Scoreboard tasks and functions 
  //--------------------------------------------------------
  // Compare input and output queues element by element
  virtual function void fifo_cmp();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    while ((in_queue.size() > 0) & (out_queue.size() > 0)) begin
      if (in_queue.pop_back() == out_queue.pop_back()) begin
        matched++;
      end
      else begin
        unmatched++;
        `uvm_warning("Mismatch", "Scoreboard has unexpected read data");
      end
    end
  endfunction: fifo_cmp

  // Wait until all expected reads are recieved or timeout occurs
  virtual task wait_for_done();
    `uvm_info("SCOREBOARD", "Scoreboard processing completed", UVM_LOW);
    fork
      begin
        fork
          wait(wr_trans_cnt == rd_trans_cnt);
          begin
            #timeout;
            `uvm_warning("TIMEOUT", $sformatf("Scoreboard has %0d unprocessed expected objects", (wr_trans_cnt-rd_trans_cnt)));
            `uvm_error("TIMEOUT", "//------------ Timeout occurred during shutdown phase ------------//");
          end
        join_any
        disable fork;
      end
    join
  endtask: wait_for_done

  // Set a new timeout value for simulation
  virtual function void set_timeout(realtime timeout);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    this.timeout=timeout;
    `uvm_info("SCOREBOARD", $sformatf("Timeout set to %0t", timeout), UVM_LOW);
  endfunction: set_timeout

  // Return current timeout value
  virtual function realtime get_timeout();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    return timeout;
  endfunction: get_timeout

  // Monitor and enforce simulation timeout
  task check_timeout();
    this.start_time = $time;
    while (1) begin
      if (($time - start_time) > timeout) begin
        `uvm_error("TIMEOUT", "//------------ Timeout occurred during run_phase ------------//");
         // Display the scoreboard results.
         `uvm_info("SB_REPORT", {"\n", $sformatf("Scoreboard has %0d remaining requests. \n", (wr_trans_cnt-rd_trans_cnt)),
                                       $sformatf("Comparator Matches = %0d, Mismatches = %0d\n", matched, unmatched)}, UVM_MEDIUM);
         $finish; // End the simulation
      end
      #10ns; // Polling interval
    end
  endtask: check_timeout

  // Generate scoreboard result summary message
  virtual function string print_results();
    if (unmatched > 0) begin
      print_results = {"<<<-------------- TEST Failled -------------->>> \n",
                        $sformatf("Scoreboard has %0d remaining requests. \n", (wr_trans_cnt-rd_trans_cnt)),
                        $sformatf("Comparator Matches = %0d, Mismatches = %0d\n", matched, unmatched)};
    end
    else begin
      print_results = "<<<-------------- TEST PASSED -------------->>>\n";
    end
  endfunction: print_results

  //--------------------------------------------------------
  // Coverage Collection for FIFO
  //--------------------------------------------------------
  covergroup fifo_wr_cov @(posedge vif.wclk);

    // State Coverage
    //----------------------
    coverpoint vif.wrst_n;
    coverpoint vif.full      iff (vif.wrst_n); // State coverage for full flag
    coverpoint vif.near_full iff (vif.wrst_n); // State coverage for near_full flag
    coverpoint vif.over_flow iff (vif.wrst_n); // State coverage for overflow flag

    // Margin value ranges and boundary checks
    cov_empty_mrgn_bounds: coverpoint vif.near_empty_mrgn iff (vif.wrst_n){
      bins bin_min_mrgn = {'0};
      bins bin_max_mrgn = {'1};
      bins bin_any[]    = default;
    }

    cov_full_mrgn_bounds: coverpoint vif.near_full_mrgn iff (vif.wrst_n){
      bins bin_boundaries[] = {'0,'1};
    }

    cov_full_mrgn_range: coverpoint vif.near_full_mrgn iff (vif.wrst_n){
      bins bin_hot_range = {[1:3]};
    }

    // Cross Coverage
    //----------------------
    // Illegal cross-coverage conditions
    cross vif.full, vif.empty {
      illegal_bins bin_ignr_f_e = '{'{1,1}};
    }

    // Ignored cross-coverage conditions
    cross vif.near_full, vif.near_empty {
      ignore_bins bin_ignr_nf_ne = '{'{1,1}};
    }

    // Cross between margin bounds
    cross_mrgn: cross cov_empty_mrgn_bounds, cov_full_mrgn_bounds;

    // Different combinations of read and write operations
    cross vif.ren, vif.wen;

    // Transition Coverage
    //----------------------
    // Consecutive repetition
    // Transition coverage for fifo full states
    coverpoint {vif.near_full, vif.full} iff (vif.wrst_n){
      bins nf_to_f = ('b10 => 'b01); // nf => f
      bins f_to_nf = ('b01 => 'b10); // f  => nf
    }

    // Transition coverage for repetitive near full state
    nf_rep_cov: coverpoint vif.near_full iff (vif.wrst_n){
      bins nf_rep = (1'b1[*3]); // nf => nf => nf => nf
    }

    // Non-consecutive repetition
    coverpoint fifo_state iff (vif.wrst_n){
      bins f_to_nf_to_ne_to_e = (FULL  => NEAR_FULL  [=1] => NEAR_EMPTY => EMPTY [=1]); // f .. => nf .. => ne .. => e .. => 
      bins e_to_ne_to_nf_to_f = (EMPTY => NEAR_EMPTY [=1] => NEAR_FULL  => FULL  [=1]); // e .. => ne .. => nf .. => f .. => 
    }

  endgroup:fifo_wr_cov


  covergroup fifo_rd_cov @(posedge vif.rclk);

    // State Coverage
    //----------------------
    coverpoint vif.rrst_n;
    coverpoint vif.empty      iff (vif.rrst_n); // State coverage for empty flag
    coverpoint vif.near_empty iff (vif.rrst_n); // State coverage for near_empty flag
    coverpoint vif.under_flow iff (vif.wrst_n); // State coverage for underflow flag

    // Transition Coverage
    //----------------------
    // Consecutive repetition
    // Transition coverage for fifo empty states
    coverpoint {vif.near_empty, vif.empty} iff (vif.rrst_n){
      bins ne_to_e = ('b10 => 'b01);         //       ne => e
      bins e_to_ne = ('b01 [-> 1] => 'b10);  // .. => e  => ne
    }

    // Transition coverage for repetitive near full state
    ne_rep_cov: coverpoint vif.near_empty iff (vif.rrst_n){
      bins ne_rep = (1'b1[*3]); // ne => ne => ne => ne
    }

  endgroup:fifo_rd_cov

endclass: fifo_scoreboard