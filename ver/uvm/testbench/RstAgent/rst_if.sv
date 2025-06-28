`ifndef RST_IF__SV
`define RST_IF__SV

interface rst_if
  #(
     parameter     RECOVERY_TIME = `TB_IF_DEFAULT_RECOVERY_TIME
    ,parameter     REMOVAL_TIME  = `TB_IF_DEFAULT_REMOVAL_TIME
   )
   (
     input         wclk
    ,input         rclk
   );

  logic        wrst_n;
  logic        rrst_n;

  //---------------------------------------------
  // Clocking Blocks
  //---------------------------------------------
  clocking srcDrv_cb @(posedge wclk);
    default input #(RECOVERY_TIME) output #(REMOVAL_TIME) ;
    output wrst_n;
  endclocking: srcDrv_cb

  clocking dstDrv_cb @(posedge rclk);
    default input #(RECOVERY_TIME) output #(REMOVAL_TIME) ;
    output rrst_n;
  endclocking: dstDrv_cb

  clocking iMon_cb @(posedge wclk);
    default input #(RECOVERY_TIME) output #(REMOVAL_TIME) ;
    input wrst_n;
  endclocking: iMon_cb

  clocking oMon_cb @(posedge rclk);
    default input #(RECOVERY_TIME) output #(REMOVAL_TIME) ;
    input rrst_n;
  endclocking: oMon_cb

  //---------------------------------------------
  // Modports
  //---------------------------------------------
  modport dut_mp (
     input  wrst_n
    ,input  rrst_n
  );

endinterface: rst_if
`endif // RST_IF__SV