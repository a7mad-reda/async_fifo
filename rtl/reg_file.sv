`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Project Name        : Design of a Parametrizable, Configurable and Modular Asynchronous FIFO
// Engineer            : Ahmad Reda
// Module  Name        : reg_file
// Module  Description : Register File
// Create  Date        : 2021/9/17
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module reg_file
  //----------------------- PORTS --------------------------------
  (
   // Register file interface
   input  logic        i_clk             ,
   input  logic        i_rst_n           ,
   input  logic        i_wr_en           ,
   input  logic        i_rd_en           ,
   input  logic [2 :0] i_addr            ,
   inout  wire  [15:0] io_data           ,
   // FIFO status interface
   input  logic        i_full            ,
   input  logic        i_near_full       ,
   input  logic        i_overflow        ,
   input  logic        i_empty           ,
   input  logic        i_near_empty      ,
   input  logic        i_underflow       ,
   // FIFO Control interface
   output logic        o_wptr_clr        ,
   output logic [3:0]  o_near_full_mrgn  ,
   output logic        o_rptr_clr        ,
   output logic [3:0]  o_near_empty_mrgn
  );

  //----------------------- SIGNALS ------------------------------
  // Register Array
  logic [15:0] r_data [5];

  //-------------------------------------------------------------
  // Register file WR logic
  //-------------------------------------------------------------
  always @(posedge i_clk or negedge i_rst_n)
    if (!i_rst_n) begin
      r_data[0]        <= '0;
      r_data[1]        <= {12'b0, 4'b0100};
      r_data[2]        <= {12'b0, 4'b0100};
    end
    else begin
      if (i_wr_en) begin
        case (i_addr)
          0: {r_data[0][0], r_data[0][8]} <= {io_data[0], io_data[8]};
          1:  r_data[1][3:0]              <=  io_data[3:0];
          2:  r_data[2][3:0]              <=  io_data[3:0];
        endcase
      end
    end

  assign r_data[3]  = {13'b0, i_full , i_near_full , i_overflow };
  assign r_data[4]  = {13'b0, i_empty, i_near_empty, i_underflow};

  //---------------------------------------------------------------
  // Register file RD logic
  //---------------------------------------------------------------
  assign io_data           = i_rd_en ? r_data[i_addr] : 'z;

  assign o_wptr_clr        = r_data[0][0];
  assign o_near_full_mrgn  = r_data[1][3:0];
  assign o_rptr_clr        = r_data[0][8];
  assign o_near_empty_mrgn = r_data[2][3:0];

endmodule
