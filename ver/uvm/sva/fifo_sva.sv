//-------------------------------//
// FIFO Write Pointer assertions //
//-------------------------------//
module assert_wptr
  #(
   parameter        ASIZE = 4
  )
  (
   input logic      clk
  ,input logic      rst_n
  ,input logic      winc
  ,input logic      near_full
  ,input logic      full
  ,input logic      overflow
  );

`ifndef SYNTHESIS
	//---------------------------------------------------------------------
	// Concurrent Assetions
	//---------------------------------------------------------------------
  fv_asm_no_write_when_full:
  assume property ( 
    @(posedge clk) disable iff (!rst_n)
    ( full |-> !winc )
  ) else begin
    $error("FATAL: FIFO can not have write request while being full.");
  end

  fv_ast_overflow:
  assert property (
    @(posedge clk) disable iff (!rst_n)
    (full & winc |=> overflow)
  )else begin
    $error("FATAL: Overflow went undetected.");
  end

  fv_ast_full_near_full_mutex:
  assert property ( 
    @(posedge clk) disable iff (!rst_n)
    ( $onehot0({near_full,full}))
  ) else begin
    $fatal("FATAL: FIFO can not be full and near full at the same time.");
  end

	//---------------------------------------------------------------------
	// Cover Properities
	//---------------------------------------------------------------------
  fv_cov_full:
  cover property ( 
    @(posedge clk) disable iff (!rst_n)
    ( full )
  );
`endif // !SYNTHESIS

endmodule: assert_wptr

//-------------------------------//
// FIFO Read Pointer assertions  //
//-------------------------------//
module assert_rptr
  #(
   parameter        ASIZE = 4
  )
  (
   input logic      clk
  ,input logic      rst_n
  ,input logic      rinc
  ,input logic      near_empty
  ,input logic      empty
  ,input logic      underflow
  );

`ifndef SYNTHESIS
	//---------------------------------------------------------------------
	// Concurrent Assetions
	//---------------------------------------------------------------------
  fv_asm_no_read_when_empty:
  assume property ( 
    @(posedge clk) disable iff (!rst_n)
    ( empty |-> !rinc )
  ) else begin
    $error("FATAL: FIFO can not have read request while being empty.");
  end

  fv_ast_underflow:
  assert property (
    @(posedge clk) disable iff (!rst_n)
    ( empty & rinc |=> underflow )
  )else begin
    $error("FATAL: Overflow went undetected.");
  end

  fv_ast_empty_near_empty_mutex:
  assert property ( 
    @(posedge clk) disable iff (!rst_n)
    ( $onehot0({near_empty & empty}) )
  ) else begin
    $fatal("FATAL: FIFO can not be empty and near empty at the same time.");
  end

	//---------------------------------------------------------------------
	// Cover Properities
	//---------------------------------------------------------------------
  fv_cov_empty:
  cover property ( 
    @(posedge clk) disable iff (!rst_n)
    ( empty )
  );

`endif // !SYNTHESIS

endmodule: assert_rptr

//-------------------------------//
//      FIFO top assertions      //
//-------------------------------//
module assert_fifo_top
  #(
   parameter        ASIZE = 4
  )
  (
   input logic      wclk
  ,input logic      wrst_n
  ,input logic      wen
  ,input logic      near_full
  ,input logic      full
  ,input logic      overflow
  ,input logic      rclk
  ,input logic      rrst_n
  ,input logic      ren
  ,input logic      near_empty
  ,input logic      empty
  ,input logic      underflow
  );

`ifndef SYNTHESIS
	//---------------------------------------------------------------------
	// Concurrent Assetions
	//---------------------------------------------------------------------
  fv_ast_full_empty_mutex:
  assert property ( 
    @(posedge wclk) disable iff (!wrst_n)
    ( $onehot0({full & empty}) )
  ) else begin
    $error("FATAL: FIFO can not be full and empty at the same time.");
  end

	//---------------------------------------------------------------------
	// Cover Properities
	//---------------------------------------------------------------------
  fv_cov_simultaneous_wr_rd:
  cover property (
    @(posedge wclk) disable iff (!wrst_n)
    (wen & ren)
  );

  sequence nf_f_trans;
    @(posedge wclk) near_full ##[1:$] full;
  endsequence

  sequence f_nf_trans;
    @(posedge wclk) full ##0 near_full[->1];
  endsequence

  sequence ne_e_trans;
    @(posedge rclk) near_empty ##[1:$] empty;
  endsequence

  sequence e_ne_trans;
    @(posedge rclk) empty ##0 near_empty[=1];
  endsequence

  fv_cov_nearfull_to_full:
  cover property ( 
    @(posedge wclk) disable iff (!wrst_n)
    ( nf_f_trans )
  );

  fv_cov_full_to_nearfull:
  cover property ( 
    @(posedge wclk) disable iff (!wrst_n)
    ( f_nf_trans )
  );

  fv_cov_nearempty_to_empty:
  cover property ( 
    @(posedge rclk) disable iff (!rrst_n)
    ( ne_e_trans )
  );

  fv_cov_empty_to_nearempty:
  cover property ( 
    @(posedge rclk) disable iff (!rrst_n)
    ( e_ne_trans )
  );

  sequence empty_to_full;
    @(posedge rclk) e_ne_trans ##1 @(posedge wclk) ##[1:$] nf_f_trans;
  endsequence

  property full_to_empty;
    @(posedge wclk) f_nf_trans ##1 @(posedge rclk) ##[1:$] ne_e_trans;
  endproperty

  fv_cov_empty_to_full:
  cover property
    (empty_to_full);

  fv_cov_full_to_empty:
  cover property
    (full_to_empty);

  fv_cov_full_empty_full:
  cover property ( 
        @(posedge rclk)         e_ne_trans 
    ##1 @(posedge wclk) ##[1:$] nf_f_trans 
    ##[0:$]                     f_nf_trans
    ##1 @(posedge rclk) ##[1:$] ne_e_trans
  );

`endif // !SYNTHESIS

endmodule: assert_fifo_top