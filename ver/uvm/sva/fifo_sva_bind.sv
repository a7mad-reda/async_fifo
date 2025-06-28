//--------------------------------//
//  Bind SVA to relative modules  //
//--------------------------------//
module fifo_sva_bind;

  // Bind Write pointer assertions
  bind async_fifo_test_top.dut.wptr_full 
    assert_wptr 
    #(
     .ASIZE           ( `ADDR_WD     )
    )
    u_wptr_ast
    (
     .clk             ( wclk         )
    ,.rst_n           ( wrst_n       )
    ,.winc            ( winc         )
    ,.near_full       ( near_full    )
    ,.full            ( full         )
    ,.overflow        ( over_flow    )
    );

  // Bind Read pointer assertions
  bind async_fifo_test_top.dut.rptr_empty
    assert_rptr 
    #(
     .ASIZE           ( `ADDR_WD     )
    )
    u_rptr_ast
    (
     .clk             ( rclk         )
    ,.rst_n           ( rrst_n       )
    ,.rinc            ( rinc         )
    ,.near_empty      ( near_empty   )
    ,.empty           ( empty        )
    ,.underflow       ( under_flow   )
    );

  // Bind top-level assertions
  bind async_fifo_test_top.dut
    assert_fifo_top 
    #(
     .ASIZE           ( `ADDR_WD     )
    )
    u_fifo_top_ast
    (
     .wclk            ( wclk         )
    ,.wrst_n          ( wrst_n       )
    ,.wen             ( wen          )
    ,.near_full       ( near_full    )
    ,.full            ( full         )
    ,.overflow        ( over_flow    )
    ,.rclk            ( rclk         )
    ,.rrst_n          ( rrst_n       )
    ,.ren             ( ren          )
    ,.near_empty      ( near_empty   )
    ,.empty           ( empty        )
    ,.underflow       ( under_flow   )
    );

  // Bind assertions from SVA Library
  bind async_fifo_test_top.dut
    assert_dual_clk_fifo
    #(
     .severity_level   (0                  )
    ,.depth            (`FIFO_DP           )
    ,.elem_sz          (`DATA_WD           )
    ,.hi_water_mark    (0                  )
    ,.enq_lat          (0                  )
    ,.deq_lat          (0                  )
    ,.oflow_chk        (1                  )
    ,.uflow_chk        (1                  )
    ,.value_chk        (1                  )
    ,.enq_edge_expr    (0                  )
    ,.deq_edge_expr    (0                  )
    ,.msg              ("SVA_LIB_VIOLATION")
    ,.category         (0                  )
    ,.coverage_level_1 (1                  )
    ,.coverage_level_2 (1                  )
    ,.coverage_level_3 (1                  )
    ,.property_type    (0                  )
    )
    u_fifo_sva_lib_ast
    (
     .reset_n          ( wrst_n            )
    ,.enq_clk          ( wclk              )
    ,.enq              ( wen               )
    ,.enq_data         ( wdata             )
    ,.deq_clk          ( rclk              )
    ,.deq              ( ren               )
    ,.deq_data         ( rdata             )
    );

endmodule