`ifndef CFG_IF__SV
`define CFG_IF__SV

interface cfg_if
   #(
     parameter     DSIZE      = `DATA_WD
    ,parameter     ASIZE      = `ADDR_WD
    ,parameter     SETUP_TIME = `TB_IF_DEFAULT_SETUP_TIME
    ,parameter     HOLD_TIME  = `TB_IF_DEFAULT_HOLD_TIME
   )
   (
     input         wclk
    ,input         wrst_n
   );

  // Signals declaration
  logic                cfg_wr;
  logic                cfg_rd;
  logic [2:0]          cfg_addr;
  wire  [15:0]         cfg_data;

  //---------------------------------------------
  // Clocking Blocks
  //---------------------------------------------
  clocking Drv_cb @(posedge wclk);
    default input #(SETUP_TIME) output #(HOLD_TIME) ;
    input                 wrst_n;
    output                cfg_wr;
    output                cfg_rd;
    output                cfg_addr;
    inout                 cfg_data;
  endclocking: Drv_cb

  clocking Mon_cb @(posedge wclk);
    default input #(SETUP_TIME) output #(HOLD_TIME) ;
    input                 wrst_n;
    input                 cfg_wr;
    input                 cfg_rd;
    input                 cfg_addr;
    input                 cfg_data;
  endclocking: Mon_cb

  //---------------------------------------------
  // Modports
  //---------------------------------------------
  modport reg_mp (
    input                 wclk            ,
    input                 wrst_n          ,
    input                 cfg_wr          ,
    input                 cfg_rd          ,
    input                 cfg_addr        ,
    inout                 cfg_data
  );

endinterface: cfg_if

`endif // !CFG_IF__SV