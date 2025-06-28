module async_fifo_test_top;

  parameter      DSIZE = `DATA_WD;        // Data width
  parameter      ASIZE = `ADDR_WD;        // Address width
  parameter      DEPTH = 1 << ASIZE;      // FIFO depth
  parameter SRC_PERIOD = `SRC_CLK_PERIOD; // Write clock time period
  parameter DST_PERIOD = `DST_CLK_PERIOD; // Read clock time period

  logic wclk;
  logic rclk;

  logic                wptr_clr;
  logic [3:0]          near_full_mrgn;

  logic                rptr_clr;
  logic [3:0]          near_empty_mrgn;

  //--------------------------------------------------------------------
  // Interfaces instantiation
  //--------------------------------------------------------------------
  rst_if reset_if
   (
     .wclk    (wclk               )
    ,.rclk    (rclk               )
   );

  cfg_if reg_if 
   (
     .wclk    (wclk               )
    ,.wrst_n  (rst_if.wrst_n      )
   );

  rd_wr_if 
  #(
     .DSIZE   (DSIZE    )
    ,.ASIZE   (ASIZE    )
   ) async_fifo_if
   (
     .wclk    (wclk               )
    ,.rclk    (rclk               )
    ,.wrst_n  (rst_if.wrst_n      )
    ,.rrst_n  (rst_if.rrst_n      )
   );

  //--------------------------------------------------------------------
  // instantiation of Asynchronous FIFO top module
  //--------------------------------------------------------------------
  async_fifo
      //------------------------- PARAMETERS -------------------------------
      #(  
       .DSIZE             (DSIZE          ),
       .ASIZE             (ASIZE          )
      ) dut
      //--------------------------- PORTS ----------------------------------
      (
      //---------------------- Write Interface -----------------------------
       .wclk              (wclk                          ),
       .wrst_n            (rst_if.wrst_n                 ),
       .wptr_clr          (wptr_clr                      ),
       .near_full_mrgn    ((ASIZE+1)'(near_full_mrgn)    ),
       .wen               (async_fifo_if.wen             ),
       .wdata             (async_fifo_if.wdata           ),
       .full              (async_fifo_if.full            ),
       .near_full         (async_fifo_if.near_full       ),
       .over_flow         (async_fifo_if.over_flow       ),
      //----------------------- Read Interface -----------------------------
       .rclk              (rclk                          ),
       .rrst_n            (rst_if.rrst_n                 ),
       .rptr_clr          (rptr_clr                      ),
       .near_empty_mrgn   ((ASIZE+1)'(near_empty_mrgn)   ),
       .ren               (async_fifo_if.ren             ),
       .rdata             (async_fifo_if.rdata           ),
       .empty             (async_fifo_if.empty           ),
       .near_empty        (async_fifo_if.near_empty      ),
       .under_flow        (async_fifo_if.under_flow      ),
      //----------------------- DFT Interface -----------------------------
       .test_si           (async_fifo_if.test_si         ),
       .test_so           (async_fifo_if.test_so         ),
       .test_se           (async_fifo_if.test_se         ),
       .test_mode         (async_fifo_if.test_mode       ),
       .atpg_mode         (async_fifo_if.atpg_mode       )
      );

  //--------------------------------------------------------------------
  // instantiation of Configuration register
  //--------------------------------------------------------------------
  wire [15:0] data;

  reg_file u_reg
      //--------------------------- PORTS ----------------------------------
      (
      //------------------ Register file interface -------------------------
       .i_clk             (wclk                          ),
       .i_rst_n           (rst_if.wrst_n                 ),
       .i_wr_en           (reg_if.cfg_wr                 ),
       .i_rd_en           (reg_if.cfg_rd                 ),
       .i_addr            (reg_if.cfg_addr               ),
       .io_data           (reg_if.cfg_data               ),
      //-------------------- FIFO Status interface --------------------------
       .i_full            (async_fifo_if.full            ),
       .i_near_full       (async_fifo_if.near_full       ),
       .i_overflow        (async_fifo_if.over_flow       ),
       .i_empty           (async_fifo_if.empty           ),
       .i_near_empty      (async_fifo_if.near_empty      ),
       .i_underflow       (async_fifo_if.under_flow      ),
      //-------------------- FIFO Control interface -------------------------
       .o_wptr_clr        (wptr_clr                      ),
       .o_near_full_mrgn  (near_full_mrgn                ),
       .o_rptr_clr        (rptr_clr                      ),
       .o_near_empty_mrgn (near_empty_mrgn               )
      );

  assign async_fifo_if.near_full_mrgn  = near_full_mrgn;
  assign async_fifo_if.near_empty_mrgn = near_empty_mrgn;

  //--------------------------------------------------------------------
  // Clocks generation
  //--------------------------------------------------------------------
  initial begin

    $fsdbDumpvars;
    $fsdbDumpfile("novas.fsdb");
    $fsdbDumpSVA;

    wclk  = 1'b0;
    rclk  = 1'b0;

    fork
      forever #(SRC_PERIOD/2) wclk = ~wclk ;
      forever #(DST_PERIOD/2) rclk = ~rclk ;
    join

  end

  // Include assetion controll file
  `include "../sva/fifo_sva_control.sv"

	//---------------------------------------------------------------------
	// Cover SVA with embedded covergroup
  //    - Cover Empty to full sequence repeated over ranges from 2 to 10
	//---------------------------------------------------------------------
  genvar i;
  generate
    for (i=2; i<11; i++) begin : COV_GROUP_PROC
    
      realtime time_ptr = 0;

      // Non-consecutive transition
      covergroup fifo_cov;
        fifo_state_cov: coverpoint async_fifo_if.full {
          bins full_twic = (1'b1[->i]); // e .. => f .. => e .. => f
        }
      endgroup:fifo_cov

      // declare handle and initialize covergroup
      fifo_cov cov_inst = new();

      property empty_to_full;
        @(posedge rclk) async_fifo_if.empty 
        ##0 async_fifo_if.near_empty[=1] 
        ##1 @(posedge wclk) async_fifo_if.near_full[=1] 
        ##[1:$] async_fifo_if.full;
      endproperty

      // Cover empty to full sequence and enable covergroup sampling
      fv_cov_empty_to_full:
      cover property (empty_to_full) begin
        if (time_ptr != $realtime) begin
          cov_inst.sample();
          $display("[COV_Info]%t empty-to-full sequence successfully matched", $realtime);
        end
        time_ptr = $realtime;
      end

    end
  endgenerate

endmodule