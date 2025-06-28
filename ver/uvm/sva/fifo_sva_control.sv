import uvm_pkg::*;

// Control SVA assertion
// Disable assertion for specific events

// Disable Overflow assertion to test the consequences of the Overflow
uvm_event overflow_event = uvm_event_pool::get_global("wr_overflow");

initial begin
  @(posedge rst_if.wrst_n) 
  forever begin
    overflow_event.wait_on();
    $assertoff(0,async_fifo_test_top.dut.wptr_full.u_wptr_ast.fv_asm_no_write_when_full);
    $assertoff(0,async_fifo_test_top.async_fifo_if.fv_asm_no_write_when_full);
    $assertoff(0,async_fifo_test_top.dut.u_fifo_sva_lib_ast.overflow_check.genblk1.A_ASSERT_FIFO_DCQ_OVERFLOW);
    overflow_event.wait_off();
    $asserton(0,async_fifo_test_top.dut.wptr_full.u_wptr_ast.fv_asm_no_write_when_full);
    $asserton(0,async_fifo_test_top.async_fifo_if.fv_asm_no_write_when_full);
    $asserton(0,async_fifo_test_top.dut.u_fifo_sva_lib_ast.overflow_check.genblk1.A_ASSERT_FIFO_DCQ_OVERFLOW);
  end
end

// Disable Underflow assertion to test the consequences of the Underflow
uvm_event underflow_event = uvm_event_pool::get_global("rd_underflow");

initial begin
  @(posedge rst_if.wrst_n) 
  forever begin
    underflow_event.wait_on();
    $assertoff(0,async_fifo_test_top.dut.rptr_empty.u_rptr_ast.fv_asm_no_read_when_empty);
    $assertoff(0,async_fifo_test_top.async_fifo_if.fv_asm_no_read_when_empty);
    $assertoff(0,async_fifo_test_top.dut.u_fifo_sva_lib_ast.underflow_check.genblk1.A_ASSERT_FIFO_DCQ_UNDERFLOW);
    underflow_event.wait_off();
    $asserton(0,async_fifo_test_top.dut.rptr_empty.u_rptr_ast.fv_asm_no_read_when_empty);
    $asserton(0,async_fifo_test_top.async_fifo_if.fv_asm_no_read_when_empty);
    $asserton(0,async_fifo_test_top.dut.u_fifo_sva_lib_ast.underflow_check.genblk1.A_ASSERT_FIFO_DCQ_UNDERFLOW);
  end
end