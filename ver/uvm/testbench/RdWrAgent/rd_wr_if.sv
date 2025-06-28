`ifndef RD_WR_IF__SV
`define RD_WR_IF__SV

interface rd_wr_if
   #(
     parameter     DSIZE      = `DATA_WD
    ,parameter     ASIZE      = `ADDR_WD
    ,parameter     SETUP_TIME = `TB_IF_DEFAULT_SETUP_TIME
    ,parameter     HOLD_TIME  = `TB_IF_DEFAULT_HOLD_TIME
   )
   (
     input         wclk
    ,input         wrst_n
    ,input         rclk
    ,input         rrst_n
   );

  // Write domain signals
  logic                wen             ;
  logic                wptr_clr        ;
  logic [DSIZE-1 : 0]  wdata           ;
  logic [ASIZE-1 : 0]  near_full_mrgn  ;
  logic                full            ;
  logic                near_full       ;
  logic                over_flow       ;
  // Read domain signals
  logic                ren             ;
  logic                rptr_clr        ;
  logic [DSIZE-1 : 0]  rdata           ;
  logic [ASIZE-1 : 0]  near_empty_mrgn ;
  logic                empty           ;
  logic                near_empty      ;
  logic                under_flow      ;
  // DFT signals
  logic                test_si         ; 
  logic                test_so         ;
  logic                test_se         ; 
  logic                atpg_mode       ;
  logic                test_mode       ;

  //---------------------------------------------
  // Clocking Blocks
  //---------------------------------------------
  // Write driver clocking block
  clocking srcDrv_cb @(posedge wclk);
    default input #(SETUP_TIME) output #(HOLD_TIME) ;
    input                 wrst_n          ;
    output                wen             ;
    output                wptr_clr        ;
    output                wdata           ;
    input                 near_full_mrgn  ;
    input                 full            ;
    input                 near_full       ;
    input                 over_flow       ;
  endclocking: srcDrv_cb

  // Read driver clocking block
  clocking dstDrv_cb @(posedge rclk);
    default input negedge output #(HOLD_TIME) ;
    input                 rrst_n          ;
    output                ren             ;
    output                rptr_clr        ;
    output                rdata           ;
    input                 near_empty_mrgn ;
    input                 empty           ;
    input                 near_empty      ;
    input                 under_flow      ;
  endclocking: dstDrv_cb

  // Write Monitor clocking block
  clocking iMon_cb @(posedge wclk);
    default input #(SETUP_TIME) output #(HOLD_TIME) ;
    input                 wclk            ;
    input                 wrst_n          ;
    input                 wen             ;
    input                 wptr_clr        ;
    input                 wdata           ;
    input                 near_full_mrgn  ;
    input                 full            ;
    input                 near_full       ;
    input                 over_flow       ;
  endclocking: iMon_cb

  // Read Monitor clocking block
  clocking oMon_cb @(posedge rclk);
    default input #(SETUP_TIME) output #(HOLD_TIME) ;
    input                 rclk            ;
    input                 rrst_n          ;
    input                 ren             ;
    input                 rptr_clr        ;
    input                 rdata           ;
    input                 near_empty_mrgn ;
    input                 empty           ;
    input                 near_empty      ;
    input                 under_flow      ;
  endclocking: oMon_cb

  //---------------------------------------------
  // Modports
  //---------------------------------------------
  // Write modport
  modport src_mp (
    input                 wclk            ,
    input                 wrst_n          ,
    input                 wen             ,
    input                 wptr_clr        ,
    input                 wdata           ,
    input                 near_full_mrgn  ,
    output                full            ,
    output                near_full       ,
    output                over_flow
  );

  // Read modport
  modport dst_mp (
    input                 rclk            ,
    input                 rrst_n          ,
    input                 ren             ,
    input                 rptr_clr        ,
    input                 rdata           ,
    input                 near_empty_mrgn ,
    output                empty           ,
    output                near_empty      ,
    output                under_flow
  );

  // DFT modport
  modport dft_mp (
    input                 test_si         , 
    output                test_so         ,
    input                 test_se         , 
    input                 atpg_mode       ,
    input                 test_mode
  );

  // Intialize DFT signals
  initial
  begin
    test_si   = 1'b0; 
    test_se   = 1'b0; 
    atpg_mode = 1'b0;
    test_mode = 1'b0;
  end

  //---------------------------------------------
  // Concurrent Assertions
  //---------------------------------------------
  fv_asm_no_write_when_full:
  assume property ( 
    @(posedge wclk) disable iff (!wrst_n)
    ( full |-> !wen )
  ) else begin
    $error("FATAL: FIFO can not have write request while being full.");
  end

  fv_asm_no_read_when_empty:
  assume property ( 
    @(posedge rclk) disable iff (!rrst_n)
    ( empty |-> !ren )
  ) else begin
    $error("FATAL: FIFO can not have read request while being empty.");
  end

endinterface: rd_wr_if

`endif // !RD_WR_IF__SV