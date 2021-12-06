/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : O-2018.06-SP1
// Date      : Mon Dec  6 21:40:29 2021
/////////////////////////////////////////////////////////////


module sync_SIZE4_1 ( clk, rst_n, async_in, sync_out );
  input [4:0] async_in;
  output [4:0] sync_out;
  input clk, rst_n;

  wire   [4:0] temp;
  assign sync_out[4] = temp[4];
  assign sync_out[3] = temp[3];

  sdcrq1 \temp_reg[4]  ( .D(async_in[4]), .SD(1'b0), .SC(1'b0), .CP(clk), 
        .CDN(rst_n), .Q(temp[4]) );
  sdcrq1 \temp_reg[3]  ( .D(async_in[3]), .SD(1'b0), .SC(1'b0), .CP(clk), 
        .CDN(rst_n), .Q(temp[3]) );
  sdcrq1 \temp_reg[2]  ( .D(async_in[2]), .SD(1'b0), .SC(1'b0), .CP(clk), 
        .CDN(rst_n), .Q(temp[2]) );
  sdcrq1 \temp_reg[1]  ( .D(async_in[1]), .SD(1'b0), .SC(1'b0), .CP(clk), 
        .CDN(rst_n), .Q(temp[1]) );
  sdcrq1 \temp_reg[0]  ( .D(async_in[0]), .SD(1'b0), .SC(1'b0), .CP(clk), 
        .CDN(rst_n), .Q(temp[0]) );
  dfcrq1 \sync_out_reg[0]  ( .D(temp[0]), .CP(clk), .CDN(rst_n), .Q(
        sync_out[0]) );
  dfcrq1 \sync_out_reg[1]  ( .D(temp[1]), .CP(clk), .CDN(rst_n), .Q(
        sync_out[1]) );
  dfcrq1 \sync_out_reg[2]  ( .D(temp[2]), .CP(clk), .CDN(rst_n), .Q(
        sync_out[2]) );
endmodule


module fifo_mem_4_4_54525545 ( wclk, wen, waddr, rclk, ren, raddr, wdata, 
        rdata );
  input [3:0] waddr;
  input [3:0] raddr;
  input [3:0] wdata;
  output [3:0] rdata;
  input wclk, wen, rclk, ren;
  wire   \mem[0][3] , \mem[0][2] , \mem[0][1] , \mem[0][0] , \mem[1][3] ,
         \mem[1][2] , \mem[1][1] , \mem[1][0] , \mem[2][3] , \mem[2][2] ,
         \mem[2][1] , \mem[2][0] , \mem[3][3] , \mem[3][2] , \mem[3][1] ,
         \mem[3][0] , \mem[4][3] , \mem[4][2] , \mem[4][1] , \mem[4][0] ,
         \mem[5][3] , \mem[5][2] , \mem[5][1] , \mem[5][0] , \mem[6][3] ,
         \mem[6][2] , \mem[6][1] , \mem[6][0] , \mem[7][3] , \mem[7][2] ,
         \mem[7][1] , \mem[7][0] , \mem[8][3] , \mem[8][2] , \mem[8][1] ,
         \mem[8][0] , \mem[9][3] , \mem[9][2] , \mem[9][1] , \mem[9][0] ,
         \mem[10][3] , \mem[10][2] , \mem[10][1] , \mem[10][0] , \mem[11][3] ,
         \mem[11][2] , \mem[11][1] , \mem[11][0] , \mem[12][3] , \mem[12][2] ,
         \mem[12][1] , \mem[12][0] , \mem[13][3] , \mem[13][2] , \mem[13][1] ,
         \mem[13][0] , \mem[14][3] , \mem[14][2] , \mem[14][1] , \mem[14][0] ,
         \mem[15][3] , \mem[15][2] , \mem[15][1] , \mem[15][0] , N55, N56, N57,
         N58, N59, N60, N61, N62, n1, n2, n3, n5, n6, n7, n8, n10, n11, n12,
         n13, n15, n16, n17, n18, n19, n21, n22, n23, n24, n26, n27, n28, n29,
         n30, n31, n32, n34, n36, n102, n103, n104, n105, n106, n107, n108,
         n109, n110, n111, n112, n113, n114, n115, n116, n117, n118, n119,
         n120, n121, n122, n123, n124, n125, n126, n127, n128, n129, n130,
         n131, n132, n133, n134, n135, n136, n137, n138, n139, n140, n141,
         n142, n143, n144, n145, n146, n147, n148, n149, n150, n151, n152,
         n153, n154, n155, n156, n157, n158, n159, n160, n161, n162, n163,
         n164, n165, n166, n167, n168, n169, n170, n171, n172, n173, n174,
         n175, n176, n177, n178, n179, n180, n181, n182, n183, n184, n185, n4,
         n9, n14, n25, n33, n35, n37, n186, n187, n188, n189, n190, n191, n192,
         n193, n194, n195;
  tri   [3:0] rdata;

  sdnrq1 \mem_reg[0][3]  ( .D(n181), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[0][3] ) );
  sdnrq1 \mem_reg[0][2]  ( .D(n180), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[0][2] ) );
  sdnrq1 \mem_reg[0][1]  ( .D(n179), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[0][1] ) );
  sdnrq1 \mem_reg[0][0]  ( .D(n178), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[0][0] ) );
  sdnrq1 \mem_reg[1][3]  ( .D(n177), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[1][3] ) );
  sdnrq1 \mem_reg[1][2]  ( .D(n176), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[1][2] ) );
  sdnrq1 \mem_reg[1][1]  ( .D(n175), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[1][1] ) );
  sdnrq1 \mem_reg[1][0]  ( .D(n174), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[1][0] ) );
  sdnrq1 \mem_reg[2][3]  ( .D(n173), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[2][3] ) );
  sdnrq1 \mem_reg[2][2]  ( .D(n172), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[2][2] ) );
  sdnrq1 \mem_reg[2][1]  ( .D(n171), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[2][1] ) );
  sdnrq1 \mem_reg[2][0]  ( .D(n170), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[2][0] ) );
  sdnrq1 \mem_reg[3][3]  ( .D(n169), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[3][3] ) );
  sdnrq1 \mem_reg[3][2]  ( .D(n168), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[3][2] ) );
  sdnrq1 \mem_reg[3][1]  ( .D(n167), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[3][1] ) );
  sdnrq1 \mem_reg[3][0]  ( .D(n166), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[3][0] ) );
  sdnrq1 \mem_reg[4][3]  ( .D(n165), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[4][3] ) );
  sdnrq1 \mem_reg[4][2]  ( .D(n164), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[4][2] ) );
  sdnrq1 \mem_reg[4][1]  ( .D(n163), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[4][1] ) );
  sdnrq1 \mem_reg[4][0]  ( .D(n162), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[4][0] ) );
  sdnrq1 \mem_reg[5][3]  ( .D(n161), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[5][3] ) );
  sdnrq1 \mem_reg[5][2]  ( .D(n160), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[5][2] ) );
  sdnrq1 \mem_reg[5][1]  ( .D(n159), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[5][1] ) );
  sdnrq1 \mem_reg[5][0]  ( .D(n158), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[5][0] ) );
  sdnrq1 \mem_reg[6][3]  ( .D(n157), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[6][3] ) );
  sdnrq1 \mem_reg[6][2]  ( .D(n156), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[6][2] ) );
  sdnrq1 \mem_reg[6][1]  ( .D(n155), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[6][1] ) );
  sdnrq1 \mem_reg[6][0]  ( .D(n154), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[6][0] ) );
  sdnrq1 \mem_reg[7][3]  ( .D(n153), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[7][3] ) );
  sdnrq1 \mem_reg[7][2]  ( .D(n152), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[7][2] ) );
  sdnrq1 \mem_reg[7][1]  ( .D(n151), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[7][1] ) );
  sdnrq1 \mem_reg[7][0]  ( .D(n150), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[7][0] ) );
  sdnrq1 \mem_reg[8][3]  ( .D(n149), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[8][3] ) );
  sdnrq1 \mem_reg[8][2]  ( .D(n148), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[8][2] ) );
  sdnrq1 \mem_reg[8][1]  ( .D(n147), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[8][1] ) );
  sdnrq1 \mem_reg[8][0]  ( .D(n146), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[8][0] ) );
  sdnrq1 \mem_reg[9][3]  ( .D(n145), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[9][3] ) );
  sdnrq1 \mem_reg[9][2]  ( .D(n144), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[9][2] ) );
  sdnrq1 \mem_reg[9][1]  ( .D(n143), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[9][1] ) );
  sdnrq1 \mem_reg[9][0]  ( .D(n142), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[9][0] ) );
  sdnrq1 \mem_reg[10][3]  ( .D(n141), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[10][3] ) );
  sdnrq1 \mem_reg[10][2]  ( .D(n140), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[10][2] ) );
  sdnrq1 \mem_reg[10][1]  ( .D(n139), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[10][1] ) );
  sdnrq1 \mem_reg[10][0]  ( .D(n138), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[10][0] ) );
  sdnrq1 \mem_reg[11][3]  ( .D(n137), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[11][3] ) );
  sdnrq1 \mem_reg[11][2]  ( .D(n136), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[11][2] ) );
  sdnrq1 \mem_reg[11][1]  ( .D(n135), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[11][1] ) );
  sdnrq1 \mem_reg[11][0]  ( .D(n134), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[11][0] ) );
  sdnrq1 \mem_reg[12][3]  ( .D(n133), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[12][3] ) );
  sdnrq1 \mem_reg[12][2]  ( .D(n132), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[12][2] ) );
  sdnrq1 \mem_reg[12][1]  ( .D(n131), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[12][1] ) );
  sdnrq1 \mem_reg[12][0]  ( .D(n130), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[12][0] ) );
  sdnrq1 \mem_reg[13][3]  ( .D(n129), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[13][3] ) );
  sdnrq1 \mem_reg[13][2]  ( .D(n128), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[13][2] ) );
  sdnrq1 \mem_reg[13][1]  ( .D(n127), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[13][1] ) );
  sdnrq1 \mem_reg[13][0]  ( .D(n126), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[13][0] ) );
  sdnrq1 \mem_reg[14][3]  ( .D(n125), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[14][3] ) );
  sdnrq1 \mem_reg[14][2]  ( .D(n124), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[14][2] ) );
  sdnrq1 \mem_reg[14][1]  ( .D(n123), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[14][1] ) );
  sdnrq1 \mem_reg[14][0]  ( .D(n122), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[14][0] ) );
  sdnrq1 \mem_reg[15][3]  ( .D(n121), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[15][3] ) );
  sdnrq1 \mem_reg[15][2]  ( .D(n120), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[15][2] ) );
  sdnrq1 \mem_reg[15][1]  ( .D(n119), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[15][1] ) );
  sdnrq1 \mem_reg[15][0]  ( .D(n118), .SD(1'b0), .SC(1'b0), .CP(wclk), .Q(
        \mem[15][0] ) );
  invtd1 \rdata_tri[0]  ( .I(n36), .EN(n31), .ZN(rdata[0]) );
  invtd1 \rdata_tri[1]  ( .I(n34), .EN(n31), .ZN(rdata[1]) );
  invtd1 \rdata_tri[2]  ( .I(n32), .EN(n31), .ZN(rdata[2]) );
  invtd1 \rdata_tri[3]  ( .I(n30), .EN(n31), .ZN(rdata[3]) );
  oai2222d1 U6 ( .A1(n195), .A2(\mem[5][3] ), .B1(n19), .B2(\mem[6][3] ), .C1(
        n18), .C2(\mem[7][3] ), .D1(n17), .D2(\mem[4][3] ), .ZN(n6) );
  nr02d0 U8 ( .A1(raddr[3]), .A2(n1), .ZN(n23) );
  oai2222d1 U10 ( .A1(n195), .A2(\mem[13][3] ), .B1(n19), .B2(\mem[14][3] ), 
        .C1(n18), .C2(\mem[15][3] ), .D1(n17), .D2(\mem[12][3] ), .ZN(n5) );
  oai2222d1 U11 ( .A1(n195), .A2(\mem[9][3] ), .B1(n19), .B2(\mem[10][3] ), 
        .C1(n18), .C2(\mem[11][3] ), .D1(n17), .D2(\mem[8][3] ), .ZN(n3) );
  nr02d0 U13 ( .A1(raddr[3]), .A2(raddr[2]), .ZN(n22) );
  oai2222d1 U14 ( .A1(n19), .A2(\mem[2][3] ), .B1(n195), .B2(\mem[1][3] ), 
        .C1(n18), .C2(\mem[3][3] ), .D1(n17), .D2(\mem[0][3] ), .ZN(n2) );
  oai2222d1 U18 ( .A1(n195), .A2(\mem[9][2] ), .B1(n19), .B2(\mem[10][2] ), 
        .C1(n18), .C2(\mem[11][2] ), .D1(n17), .D2(\mem[8][2] ), .ZN(n11) );
  oai2222d1 U19 ( .A1(n195), .A2(\mem[13][2] ), .B1(n19), .B2(\mem[14][2] ), 
        .C1(n18), .C2(\mem[15][2] ), .D1(n17), .D2(\mem[12][2] ), .ZN(n10) );
  oai2222d1 U20 ( .A1(n195), .A2(\mem[5][2] ), .B1(n19), .B2(\mem[6][2] ), 
        .C1(n18), .C2(\mem[7][2] ), .D1(n17), .D2(\mem[4][2] ), .ZN(n8) );
  oai2222d1 U21 ( .A1(n195), .A2(\mem[1][2] ), .B1(n19), .B2(\mem[2][2] ), 
        .C1(n18), .C2(\mem[3][2] ), .D1(n17), .D2(\mem[0][2] ), .ZN(n7) );
  oai2222d1 U24 ( .A1(n195), .A2(\mem[9][1] ), .B1(n19), .B2(\mem[10][1] ), 
        .C1(n18), .C2(\mem[11][1] ), .D1(n17), .D2(\mem[8][1] ), .ZN(n16) );
  oai2222d1 U25 ( .A1(n195), .A2(\mem[13][1] ), .B1(n19), .B2(\mem[14][1] ), 
        .C1(n18), .C2(\mem[15][1] ), .D1(n17), .D2(\mem[12][1] ), .ZN(n15) );
  oai2222d1 U26 ( .A1(n195), .A2(\mem[5][1] ), .B1(n19), .B2(\mem[6][1] ), 
        .C1(n18), .C2(\mem[7][1] ), .D1(n17), .D2(\mem[4][1] ), .ZN(n13) );
  oai2222d1 U27 ( .A1(n195), .A2(\mem[1][1] ), .B1(n19), .B2(\mem[2][1] ), 
        .C1(n18), .C2(\mem[3][1] ), .D1(n17), .D2(\mem[0][1] ), .ZN(n12) );
  oai2222d1 U30 ( .A1(n195), .A2(\mem[9][0] ), .B1(n19), .B2(\mem[10][0] ), 
        .C1(n18), .C2(\mem[11][0] ), .D1(n17), .D2(\mem[8][0] ), .ZN(n29) );
  oai2222d1 U31 ( .A1(n195), .A2(\mem[13][0] ), .B1(n19), .B2(\mem[14][0] ), 
        .C1(n18), .C2(\mem[15][0] ), .D1(n17), .D2(\mem[12][0] ), .ZN(n26) );
  oai2222d1 U32 ( .A1(n195), .A2(\mem[5][0] ), .B1(n19), .B2(\mem[6][0] ), 
        .C1(n18), .C2(\mem[7][0] ), .D1(n17), .D2(\mem[4][0] ), .ZN(n24) );
  oai2222d1 U33 ( .A1(n195), .A2(\mem[1][0] ), .B1(n19), .B2(\mem[2][0] ), 
        .C1(n18), .C2(\mem[3][0] ), .D1(n17), .D2(\mem[0][0] ), .ZN(n21) );
  mx02d0 U102 ( .I0(wdata[1]), .I1(\mem[15][1] ), .S(n102), .Z(n119) );
  mx02d0 U104 ( .I0(wdata[3]), .I1(\mem[15][3] ), .S(n102), .Z(n121) );
  mx02d0 U103 ( .I0(wdata[2]), .I1(\mem[15][2] ), .S(n102), .Z(n120) );
  mx02d0 U106 ( .I0(wdata[0]), .I1(\mem[14][0] ), .S(n103), .Z(n122) );
  mx02d0 U101 ( .I0(wdata[0]), .I1(\mem[15][0] ), .S(n102), .Z(n118) );
  mx02d0 U108 ( .I0(wdata[2]), .I1(\mem[14][2] ), .S(n103), .Z(n124) );
  mx02d0 U109 ( .I0(wdata[3]), .I1(\mem[14][3] ), .S(n103), .Z(n125) );
  mx02d0 U111 ( .I0(wdata[0]), .I1(\mem[13][0] ), .S(n104), .Z(n126) );
  mx02d0 U112 ( .I0(wdata[1]), .I1(\mem[13][1] ), .S(n104), .Z(n127) );
  mx02d0 U113 ( .I0(wdata[2]), .I1(\mem[13][2] ), .S(n104), .Z(n128) );
  mx02d0 U114 ( .I0(wdata[3]), .I1(\mem[13][3] ), .S(n104), .Z(n129) );
  mx02d0 U116 ( .I0(wdata[0]), .I1(\mem[12][0] ), .S(n105), .Z(n130) );
  mx02d0 U117 ( .I0(wdata[1]), .I1(\mem[12][1] ), .S(n105), .Z(n131) );
  mx02d0 U118 ( .I0(wdata[2]), .I1(\mem[12][2] ), .S(n105), .Z(n132) );
  mx02d0 U119 ( .I0(wdata[3]), .I1(\mem[12][3] ), .S(n105), .Z(n133) );
  mx02d0 U107 ( .I0(wdata[1]), .I1(\mem[14][1] ), .S(n103), .Z(n123) );
  mx02d0 U122 ( .I0(wdata[1]), .I1(\mem[11][1] ), .S(n106), .Z(n135) );
  mx02d0 U123 ( .I0(wdata[2]), .I1(\mem[11][2] ), .S(n106), .Z(n136) );
  mx02d0 U124 ( .I0(wdata[3]), .I1(\mem[11][3] ), .S(n106), .Z(n137) );
  mx02d0 U126 ( .I0(wdata[0]), .I1(\mem[10][0] ), .S(n107), .Z(n138) );
  mx02d0 U127 ( .I0(wdata[1]), .I1(\mem[10][1] ), .S(n107), .Z(n139) );
  mx02d0 U128 ( .I0(wdata[2]), .I1(\mem[10][2] ), .S(n107), .Z(n140) );
  mx02d0 U129 ( .I0(wdata[3]), .I1(\mem[10][3] ), .S(n107), .Z(n141) );
  mx02d0 U131 ( .I0(wdata[0]), .I1(\mem[9][0] ), .S(n108), .Z(n142) );
  mx02d0 U132 ( .I0(wdata[1]), .I1(\mem[9][1] ), .S(n108), .Z(n143) );
  mx02d0 U133 ( .I0(wdata[2]), .I1(\mem[9][2] ), .S(n108), .Z(n144) );
  mx02d0 U134 ( .I0(wdata[3]), .I1(\mem[9][3] ), .S(n108), .Z(n145) );
  mx02d0 U136 ( .I0(wdata[0]), .I1(\mem[8][0] ), .S(n109), .Z(n146) );
  mx02d0 U137 ( .I0(wdata[1]), .I1(\mem[8][1] ), .S(n109), .Z(n147) );
  mx02d0 U138 ( .I0(wdata[2]), .I1(\mem[8][2] ), .S(n109), .Z(n148) );
  mx02d0 U139 ( .I0(wdata[3]), .I1(\mem[8][3] ), .S(n109), .Z(n149) );
  mx02d0 U141 ( .I0(wdata[0]), .I1(\mem[7][0] ), .S(n110), .Z(n150) );
  mx02d0 U142 ( .I0(wdata[1]), .I1(\mem[7][1] ), .S(n110), .Z(n151) );
  mx02d0 U143 ( .I0(wdata[2]), .I1(\mem[7][2] ), .S(n110), .Z(n152) );
  mx02d0 U144 ( .I0(wdata[3]), .I1(\mem[7][3] ), .S(n110), .Z(n153) );
  mx02d0 U121 ( .I0(wdata[0]), .I1(\mem[11][0] ), .S(n106), .Z(n134) );
  mx02d0 U146 ( .I0(wdata[0]), .I1(\mem[6][0] ), .S(n111), .Z(n154) );
  mx02d0 U147 ( .I0(wdata[1]), .I1(\mem[6][1] ), .S(n111), .Z(n155) );
  mx02d0 U148 ( .I0(wdata[2]), .I1(\mem[6][2] ), .S(n111), .Z(n156) );
  mx02d0 U149 ( .I0(wdata[3]), .I1(\mem[6][3] ), .S(n111), .Z(n157) );
  mx02d0 U151 ( .I0(wdata[0]), .I1(\mem[5][0] ), .S(n112), .Z(n158) );
  mx02d0 U152 ( .I0(wdata[1]), .I1(\mem[5][1] ), .S(n112), .Z(n159) );
  mx02d0 U153 ( .I0(wdata[2]), .I1(\mem[5][2] ), .S(n112), .Z(n160) );
  mx02d0 U154 ( .I0(wdata[3]), .I1(\mem[5][3] ), .S(n112), .Z(n161) );
  mx02d0 U156 ( .I0(wdata[0]), .I1(\mem[4][0] ), .S(n113), .Z(n162) );
  mx02d0 U157 ( .I0(wdata[1]), .I1(\mem[4][1] ), .S(n113), .Z(n163) );
  mx02d0 U158 ( .I0(wdata[2]), .I1(\mem[4][2] ), .S(n113), .Z(n164) );
  mx02d0 U159 ( .I0(wdata[3]), .I1(\mem[4][3] ), .S(n113), .Z(n165) );
  mx02d0 U161 ( .I0(wdata[0]), .I1(\mem[3][0] ), .S(n114), .Z(n166) );
  mx02d0 U162 ( .I0(wdata[1]), .I1(\mem[3][1] ), .S(n114), .Z(n167) );
  mx02d0 U163 ( .I0(wdata[2]), .I1(\mem[3][2] ), .S(n114), .Z(n168) );
  mx02d0 U164 ( .I0(wdata[3]), .I1(\mem[3][3] ), .S(n114), .Z(n169) );
  mx02d0 U166 ( .I0(wdata[0]), .I1(\mem[2][0] ), .S(n115), .Z(n170) );
  mx02d0 U167 ( .I0(wdata[1]), .I1(\mem[2][1] ), .S(n115), .Z(n171) );
  mx02d0 U168 ( .I0(wdata[2]), .I1(\mem[2][2] ), .S(n115), .Z(n172) );
  mx02d0 U169 ( .I0(wdata[3]), .I1(\mem[2][3] ), .S(n115), .Z(n173) );
  mx02d0 U171 ( .I0(wdata[0]), .I1(\mem[1][0] ), .S(n116), .Z(n174) );
  mx02d0 U172 ( .I0(wdata[1]), .I1(\mem[1][1] ), .S(n116), .Z(n175) );
  mx02d0 U173 ( .I0(wdata[2]), .I1(\mem[1][2] ), .S(n116), .Z(n176) );
  mx02d0 U174 ( .I0(wdata[3]), .I1(\mem[1][3] ), .S(n116), .Z(n177) );
  mx02d0 U176 ( .I0(wdata[0]), .I1(\mem[0][0] ), .S(n117), .Z(n178) );
  mx02d0 U177 ( .I0(wdata[1]), .I1(\mem[0][1] ), .S(n117), .Z(n179) );
  mx02d0 U178 ( .I0(wdata[2]), .I1(\mem[0][2] ), .S(n117), .Z(n180) );
  mx02d0 U179 ( .I0(wdata[3]), .I1(\mem[0][3] ), .S(n117), .Z(n181) );
  or02d1 U5 ( .A1(raddr[1]), .A2(raddr[0]), .Z(n17) );
  an02d0 C171 ( .A1(waddr[0]), .A2(n184), .Z(N61) );
  an02d0 C170 ( .A1(n185), .A2(waddr[1]), .Z(N60) );
  an02d0 C169 ( .A1(waddr[0]), .A2(waddr[1]), .Z(N59) );
  an02d0 C167 ( .A1(waddr[2]), .A2(n182), .Z(N57) );
  an02d0 C166 ( .A1(n183), .A2(waddr[3]), .Z(N56) );
  an02d0 U9 ( .A1(raddr[3]), .A2(raddr[2]), .Z(n27) );
  an02d0 U12 ( .A1(n1), .A2(raddr[3]), .Z(n28) );
  an02d0 C165 ( .A1(waddr[2]), .A2(waddr[3]), .Z(N55) );
  nd02d1 U4 ( .A1(raddr[1]), .A2(raddr[0]), .ZN(n18) );
  nd12d1 U3 ( .A1(raddr[0]), .A2(raddr[1]), .ZN(n19) );
  inv0d0 U7 ( .I(raddr[2]), .ZN(n1) );
  inv0d1 U17 ( .I(ren), .ZN(n31) );
  nd02d0 U15 ( .A1(n6), .A2(n23), .ZN(n191) );
  nd02d0 U16 ( .A1(n7), .A2(n22), .ZN(n190) );
  nd02d0 U22 ( .A1(n12), .A2(n22), .ZN(n186) );
  nd02d0 U23 ( .A1(n2), .A2(n22), .ZN(n193) );
  nd02d0 U28 ( .A1(n5), .A2(n27), .ZN(n192) );
  nd02d0 U29 ( .A1(n3), .A2(n28), .ZN(n194) );
  nd02d0 U34 ( .A1(n8), .A2(n23), .ZN(n189) );
  nd02d0 U35 ( .A1(n10), .A2(n27), .ZN(n188) );
  nd02d0 U36 ( .A1(n11), .A2(n28), .ZN(n187) );
  nd02d0 U37 ( .A1(n13), .A2(n23), .ZN(n37) );
  nd02d0 U38 ( .A1(n16), .A2(n28), .ZN(n33) );
  nd02d0 U39 ( .A1(n24), .A2(n23), .ZN(n14) );
  nd02d0 U40 ( .A1(n26), .A2(n27), .ZN(n9) );
  nd02d0 U41 ( .A1(n21), .A2(n22), .ZN(n25) );
  nd02d0 U42 ( .A1(n29), .A2(n28), .ZN(n4) );
  nd02d0 U43 ( .A1(n15), .A2(n27), .ZN(n35) );
  nd04d0 U44 ( .A1(n25), .A2(n14), .A3(n9), .A4(n4), .ZN(n36) );
  nd04d0 U45 ( .A1(n186), .A2(n37), .A3(n35), .A4(n33), .ZN(n34) );
  nd04d0 U46 ( .A1(n190), .A2(n189), .A3(n188), .A4(n187), .ZN(n32) );
  nd04d0 U47 ( .A1(n194), .A2(n193), .A3(n192), .A4(n191), .ZN(n30) );
  nd03d0 U2 ( .A1(wen), .A2(N59), .A3(N55), .ZN(n102) );
  nd03d0 U100 ( .A1(wen), .A2(N60), .A3(N55), .ZN(n103) );
  nd03d0 U105 ( .A1(N61), .A2(wen), .A3(N55), .ZN(n104) );
  nd03d0 U110 ( .A1(N56), .A2(N59), .A3(wen), .ZN(n106) );
  nd03d0 U115 ( .A1(N56), .A2(N60), .A3(wen), .ZN(n107) );
  nd03d0 U120 ( .A1(N61), .A2(wen), .A3(N56), .ZN(n108) );
  nd03d0 U125 ( .A1(N57), .A2(N59), .A3(wen), .ZN(n110) );
  nd03d0 U130 ( .A1(N57), .A2(N60), .A3(wen), .ZN(n111) );
  nd03d0 U135 ( .A1(N57), .A2(N61), .A3(wen), .ZN(n112) );
  nd03d0 U140 ( .A1(N56), .A2(N62), .A3(wen), .ZN(n109) );
  nd03d0 U145 ( .A1(N57), .A2(N62), .A3(wen), .ZN(n113) );
  nd03d0 U150 ( .A1(wen), .A2(N62), .A3(N55), .ZN(n105) );
  nd03d0 U155 ( .A1(wen), .A2(N59), .A3(N58), .ZN(n114) );
  nd03d0 U160 ( .A1(wen), .A2(N60), .A3(N58), .ZN(n115) );
  nd03d0 U165 ( .A1(N61), .A2(wen), .A3(N58), .ZN(n116) );
  nd03d0 U170 ( .A1(wen), .A2(N62), .A3(N58), .ZN(n117) );
  inv0d0 U175 ( .I(waddr[3]), .ZN(n182) );
  inv0d0 U180 ( .I(waddr[2]), .ZN(n183) );
  nr02d0 U181 ( .A1(waddr[2]), .A2(waddr[3]), .ZN(N58) );
  inv0d0 U182 ( .I(waddr[1]), .ZN(n184) );
  inv0d0 U183 ( .I(waddr[0]), .ZN(n185) );
  nr02d0 U196 ( .A1(waddr[0]), .A2(waddr[1]), .ZN(N62) );
  nd12d1 U197 ( .A1(raddr[1]), .A2(raddr[0]), .ZN(n195) );
endmodule


module sync_SIZE4_0 ( clk, rst_n, async_in, sync_out );
  input [4:0] async_in;
  output [4:0] sync_out;
  input clk, rst_n;

  wire   [4:0] temp;

  sdcrq1 \temp_reg[4]  ( .D(async_in[4]), .SD(1'b0), .SC(1'b0), .CP(clk), 
        .CDN(rst_n), .Q(temp[4]) );
  sdcrq1 \temp_reg[3]  ( .D(async_in[3]), .SD(1'b0), .SC(1'b0), .CP(clk), 
        .CDN(rst_n), .Q(temp[3]) );
  sdcrq1 \temp_reg[2]  ( .D(async_in[2]), .SD(1'b0), .SC(1'b0), .CP(clk), 
        .CDN(rst_n), .Q(temp[2]) );
  sdcrq1 \temp_reg[1]  ( .D(async_in[1]), .SD(1'b0), .SC(1'b0), .CP(clk), 
        .CDN(rst_n), .Q(temp[1]) );
  sdcrq1 \temp_reg[0]  ( .D(async_in[0]), .SD(1'b0), .SC(1'b0), .CP(clk), 
        .CDN(rst_n), .Q(temp[0]) );
  dfcrq1 \sync_out_reg[0]  ( .D(temp[0]), .CP(clk), .CDN(rst_n), .Q(
        sync_out[0]) );
  dfcrq1 \sync_out_reg[1]  ( .D(temp[1]), .CP(clk), .CDN(rst_n), .Q(
        sync_out[1]) );
  dfcrq1 \sync_out_reg[2]  ( .D(temp[2]), .CP(clk), .CDN(rst_n), .Q(
        sync_out[2]) );
  dfcrq1 \sync_out_reg[3]  ( .D(temp[3]), .CP(clk), .CDN(rst_n), .Q(
        sync_out[3]) );
  dfcrq1 \sync_out_reg[4]  ( .D(temp[4]), .CP(clk), .CDN(rst_n), .Q(
        sync_out[4]) );
endmodule


module async_fifo ( wclk, wrst_n, wen, wptr_clr, wdata, rclk, rrst_n, ren, 
        rptr_clr, near_full_mrgn, near_empty_mrgn, rdata, full, empty, 
        near_full, near_empty, over_flow, under_flow );
  input [3:0] wdata;
  input [4:0] near_full_mrgn;
  input [4:0] near_empty_mrgn;
  output [3:0] rdata;
  input wclk, wrst_n, wen, wptr_clr, rclk, rrst_n, ren, rptr_clr;
  output full, empty, near_full, near_empty, over_flow, under_flow;
  wire   \wptr_full/N33 , \wptr_full/N25 , \wptr_full/N19 , \wptr_full/N12 ,
         \wptr_full/N11 , \wptr_full/N10 , \wptr_full/N9 , \wptr_full/N8 ,
         \wptr_full/N7 , \wptr_full/N6 , \wptr_full/N5 , \wptr_full/N4 ,
         \wptr_full/wbin[4] , \rptr_empty/N25 , \rptr_empty/N16 ,
         \rptr_empty/N15 , \rptr_empty/N14 , \rptr_empty/N12 ,
         \rptr_empty/N11 , \rptr_empty/N10 , \rptr_empty/N9 , \rptr_empty/N8 ,
         \rptr_empty/N7 , \rptr_empty/N6 , \rptr_empty/N5 , \rptr_empty/N4 ,
         \rptr_empty/rbin[4] , \intadd_0/B[2] , \intadd_0/B[1] ,
         \intadd_0/B[0] , \intadd_2/A[2] , \intadd_2/A[1] , \intadd_2/A[0] ,
         \intadd_2/B[2] , \intadd_2/B[1] , \intadd_2/B[0] , \intadd_2/CI ,
         \intadd_2/n3 , \intadd_2/n2 , \intadd_2/n1 , n77, n78, n79, n80, n81,
         n82, n83, n85, n87, n88, n90, n91, n92, n93, n94, n95, n96, n97, n98,
         n99, n100, n101, n103, n104, n105, n106, n109, n110, n111, n112, n116,
         n117, n118, n120, n121, n126, n127, n128, n130, n131, n132, n133,
         n134, n135, n136, n138, n139, n140, n141, n142, n143, n144, n145,
         n146, n147, n150, n151, n152, n153, n154, n155, n157, n158, n159,
         n160, n161, n162, n163, n164, n165, n166, n167, n168, n169, n170,
         n171, n172, n173, n174, n175, n177, n178, n179, n180, n181, n182,
         n183, n184, n185, n186, n187, n188, n189, n190, n191, n192, n193,
         n194, n195, n196, n197, n198, n199, n200, n201, n202, n203, n204,
         n205, n206, n207, n208, n209, n210, n212, n213, n214, n215, n216,
         n217, n218, n219, n220;
  wire   [4:0] sync_rptr;
  wire   [3:0] waddr;
  wire   [4:0] wptr;
  wire   [4:0] sync_wptr;
  wire   [3:0] raddr;
  wire   [4:0] rptr;
  tri   [3:0] rdata;
  assign \wptr_full/N25  = near_full_mrgn[0];

  sync_SIZE4_1 sync_r2w ( .clk(wclk), .rst_n(wrst_n), .async_in({
        \rptr_empty/rbin[4] , rptr[3:0]}), .sync_out({n210, sync_rptr[3:0]})
         );
  sync_SIZE4_0 sync_w2r ( .clk(rclk), .rst_n(rrst_n), .async_in({
        \wptr_full/wbin[4] , wptr[3:0]}), .sync_out(sync_wptr) );
  fifo_mem_4_4_54525545 fifo_mem ( .wclk(wclk), .wen(n215), .waddr(waddr), 
        .rclk(rclk), .ren(\rptr_empty/N14 ), .raddr(raddr), .wdata(wdata), 
        .rdata(rdata) );
  sdcrq1 \wptr_full/wptr_reg[0]  ( .D(\wptr_full/N9 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(wrst_n), .Q(wptr[0]) );
  sdcrq1 \wptr_full/wptr_reg[1]  ( .D(\wptr_full/N10 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(wrst_n), .Q(wptr[1]) );
  sdcrq1 \wptr_full/wptr_reg[2]  ( .D(\wptr_full/N11 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(wrst_n), .Q(wptr[2]) );
  sdcrq1 \wptr_full/wptr_reg[3]  ( .D(\wptr_full/N12 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(wrst_n), .Q(wptr[3]) );
  sdcrq1 \wptr_full/wbin_reg[0]  ( .D(\wptr_full/N4 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(wrst_n), .Q(waddr[0]) );
  sdcrq1 \wptr_full/wbin_reg[1]  ( .D(\wptr_full/N5 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(wrst_n), .Q(waddr[1]) );
  sdcrq1 \wptr_full/wbin_reg[2]  ( .D(\wptr_full/N6 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(wrst_n), .Q(waddr[2]) );
  sdcrq1 \wptr_full/wbin_reg[3]  ( .D(\wptr_full/N7 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(wrst_n), .Q(waddr[3]) );
  sdcrq1 \wptr_full/wbin_reg[4]  ( .D(\wptr_full/N8 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(wrst_n), .Q(\wptr_full/wbin[4] ) );
  sdcrq1 \rptr_empty/rptr_reg[0]  ( .D(\rptr_empty/N9 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .CDN(rrst_n), .Q(rptr[0]) );
  sdcrq1 \rptr_empty/rptr_reg[1]  ( .D(\rptr_empty/N10 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .CDN(rrst_n), .Q(rptr[1]) );
  sdcrq1 \rptr_empty/rptr_reg[2]  ( .D(\rptr_empty/N11 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .CDN(rrst_n), .Q(rptr[2]) );
  sdcrq1 \rptr_empty/rptr_reg[3]  ( .D(\rptr_empty/N12 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .CDN(rrst_n), .Q(rptr[3]) );
  sdcrq1 \rptr_empty/rbin_reg[1]  ( .D(\rptr_empty/N5 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .CDN(rrst_n), .Q(raddr[1]) );
  sdcrq1 \rptr_empty/rbin_reg[2]  ( .D(\rptr_empty/N6 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .CDN(rrst_n), .Q(raddr[2]) );
  sdcrq1 \rptr_empty/rbin_reg[3]  ( .D(\rptr_empty/N7 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .CDN(rrst_n), .Q(raddr[3]) );
  sdcrq1 \rptr_empty/rbin_reg[4]  ( .D(\rptr_empty/N8 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .CDN(rrst_n), .Q(\rptr_empty/rbin[4] ) );
  sdprb1 \rptr_empty/empty_reg  ( .D(\rptr_empty/N16 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .SDN(rrst_n), .Q(empty) );
  sdcrq1 R_2 ( .D(n212), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(wrst_n), .Q(
        n214) );
  dfcrq1 R_3 ( .D(n210), .CP(wclk), .CDN(wrst_n), .Q(sync_rptr[4]) );
  dfcrq1 R_1 ( .D(sync_rptr[3]), .CP(wclk), .CDN(wrst_n), .Q(n213) );
  sdcrq1 \rptr_empty/near_empty_reg  ( .D(\rptr_empty/N25 ), .SD(1'b0), .SC(
        1'b0), .CP(rclk), .CDN(rrst_n), .Q(near_empty) );
  sdcrq1 \rptr_empty/under_flow_reg  ( .D(\rptr_empty/N15 ), .SD(1'b0), .SC(
        1'b0), .CP(rclk), .CDN(rrst_n), .Q(under_flow) );
  sdcrq1 \wptr_full/over_flow_reg  ( .D(n209), .SD(1'b0), .SC(1'b0), .CP(wclk), 
        .CDN(wrst_n), .Q(over_flow) );
  sdcrq1 \rptr_empty/rbin_reg[0]  ( .D(\rptr_empty/N4 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .CDN(rrst_n), .Q(raddr[0]) );
  ad01d0 \intadd_2/U4  ( .A(\intadd_2/B[0] ), .B(\intadd_2/A[0] ), .CI(
        \intadd_2/CI ), .CO(\intadd_2/n3 ), .S(\intadd_0/B[0] ) );
  ad01d0 \intadd_2/U3  ( .A(\intadd_2/B[1] ), .B(\intadd_2/A[1] ), .CI(
        \intadd_2/n3 ), .CO(\intadd_2/n2 ), .S(\intadd_0/B[1] ) );
  ad01d0 \intadd_2/U2  ( .A(\intadd_2/B[2] ), .B(\intadd_2/A[2] ), .CI(
        \intadd_2/n2 ), .CO(\intadd_2/n1 ), .S(\intadd_0/B[2] ) );
  sdcrq1 \wptr_full/near_full_reg  ( .D(\wptr_full/N33 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(wrst_n), .Q(near_full) );
  sdcrq1 \wptr_full/full_reg  ( .D(\wptr_full/N19 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(wrst_n), .Q(full) );
  cg01d0 U105 ( .A(\intadd_0/B[2] ), .B(near_empty_mrgn[3]), .CI(n197), .CO(
        n198) );
  nd02d1 U106 ( .A1(n133), .A2(n131), .ZN(n151) );
  cg01d0 U107 ( .A(n144), .B(n143), .CI(n142), .CO(n145) );
  inv0d0 U109 ( .I(wptr_clr), .ZN(n170) );
  or02d1 U110 ( .A1(n106), .A2(n105), .Z(n141) );
  nd02d1 U111 ( .A1(n141), .A2(n138), .ZN(n110) );
  an02d0 U116 ( .A1(n153), .A2(n152), .Z(n77) );
  an02d0 U120 ( .A1(n82), .A2(raddr[2]), .Z(n175) );
  inv0d0 U123 ( .I(raddr[1]), .ZN(n81) );
  inv0d0 U124 ( .I(waddr[1]), .ZN(n111) );
  an02d0 U126 ( .A1(n175), .A2(raddr[3]), .Z(n183) );
  nr02d0 U127 ( .A1(n174), .A2(n81), .ZN(n82) );
  an02d0 U128 ( .A1(n174), .A2(n81), .Z(n181) );
  nd02d0 U135 ( .A1(n158), .A2(n157), .ZN(n160) );
  inv0d0 U136 ( .I(wen), .ZN(n83) );
  inv0d0 U138 ( .I(rptr_clr), .ZN(n207) );
  inv0d0 U139 ( .I(n91), .ZN(n92) );
  cg01d0 U140 ( .A(n199), .B(near_empty_mrgn[4]), .CI(n198), .CO(n200) );
  nd02d1 U141 ( .A1(n110), .A2(n139), .ZN(n133) );
  nr02d4 U142 ( .A1(full), .A2(n83), .ZN(n215) );
  inv0d0 U143 ( .I(sync_wptr[3]), .ZN(n78) );
  mx02d0 U144 ( .I0(n78), .I1(sync_wptr[3]), .S(sync_wptr[4]), .Z(
        \intadd_2/B[2] ) );
  inv0d0 U145 ( .I(\intadd_2/B[2] ), .ZN(n79) );
  mx02d0 U146 ( .I0(\intadd_2/B[2] ), .I1(n79), .S(sync_wptr[2]), .Z(
        \intadd_2/B[1] ) );
  inv0d0 U147 ( .I(\intadd_2/B[1] ), .ZN(n80) );
  mx02d0 U148 ( .I0(\intadd_2/B[1] ), .I1(n80), .S(sync_wptr[1]), .Z(
        \intadd_2/B[0] ) );
  an12d1 U149 ( .A2(ren), .A1(empty), .Z(\rptr_empty/N14 ) );
  nd02d0 U150 ( .A1(\rptr_empty/N14 ), .A2(raddr[0]), .ZN(n174) );
  nr02d0 U151 ( .A1(n82), .A2(n181), .ZN(\intadd_2/A[0] ) );
  nr02d0 U152 ( .A1(n82), .A2(raddr[2]), .ZN(n179) );
  nr02d0 U153 ( .A1(n175), .A2(n179), .ZN(\intadd_2/A[1] ) );
  nr02d0 U154 ( .A1(n175), .A2(raddr[3]), .ZN(n177) );
  nr02d0 U155 ( .A1(n183), .A2(n177), .ZN(\intadd_2/A[2] ) );
  xr02d1 U158 ( .A1(n210), .A2(sync_rptr[3]), .Z(n212) );
  nr02d0 U160 ( .A1(n215), .A2(waddr[0]), .ZN(n104) );
  nr02d0 U161 ( .A1(n105), .A2(n104), .ZN(n136) );
  an02d0 U162 ( .A1(n136), .A2(n170), .Z(\wptr_full/N4 ) );
  xn02d1 U163 ( .A1(n85), .A2(waddr[1]), .ZN(n95) );
  an02d0 U164 ( .A1(n95), .A2(n170), .Z(\wptr_full/N5 ) );
  an02d0 U167 ( .A1(n93), .A2(n170), .Z(\wptr_full/N6 ) );
  xr02d1 U168 ( .A1(n88), .A2(waddr[3]), .Z(n91) );
  nr02d0 U169 ( .A1(n91), .A2(wptr_clr), .ZN(\wptr_full/N7 ) );
  xn02d1 U171 ( .A1(n90), .A2(\wptr_full/wbin[4] ), .ZN(n94) );
  an02d0 U172 ( .A1(n94), .A2(n170), .Z(\wptr_full/N8 ) );
  xn02d1 U173 ( .A1(n94), .A2(n91), .ZN(n171) );
  xn02d1 U174 ( .A1(n171), .A2(n213), .ZN(n101) );
  xn02d1 U175 ( .A1(n92), .A2(n93), .ZN(n172) );
  xn02d1 U176 ( .A1(n172), .A2(sync_rptr[2]), .ZN(n100) );
  xn02d1 U177 ( .A1(n93), .A2(n95), .ZN(n168) );
  xr02d1 U178 ( .A1(n168), .A2(sync_rptr[1]), .Z(n98) );
  xr02d1 U179 ( .A1(n94), .A2(sync_rptr[4]), .Z(n97) );
  xn02d1 U180 ( .A1(n95), .A2(n136), .ZN(n169) );
  xr02d1 U181 ( .A1(n169), .A2(sync_rptr[0]), .Z(n96) );
  nd03d0 U182 ( .A1(n98), .A2(n97), .A3(n96), .ZN(n99) );
  nr03d0 U183 ( .A1(n101), .A2(n100), .A3(n99), .ZN(n166) );
  an02d0 U184 ( .A1(n166), .A2(n170), .Z(\wptr_full/N19 ) );
  nr02d0 U187 ( .A1(n155), .A2(near_full_mrgn[3]), .ZN(n103) );
  xr02d1 U188 ( .A1(n103), .A2(near_full_mrgn[4]), .Z(n165) );
  xn02d1 U190 ( .A1(n118), .A2(sync_rptr[1]), .ZN(n112) );
  xn02d1 U191 ( .A1(n112), .A2(sync_rptr[0]), .ZN(n135) );
  nr02d0 U192 ( .A1(n135), .A2(n104), .ZN(n106) );
  xn02d1 U194 ( .A1(n112), .A2(waddr[1]), .ZN(n109) );
  nd02d0 U196 ( .A1(n135), .A2(n109), .ZN(n139) );
  nr02d0 U197 ( .A1(n112), .A2(n111), .ZN(n117) );
  nd02d0 U200 ( .A1(n117), .A2(n116), .ZN(n150) );
  xn02d1 U202 ( .A1(n214), .A2(waddr[3]), .ZN(n120) );
  nd12d0 U204 ( .A1(n121), .A2(n120), .ZN(n153) );
  xr03d1 U208 ( .A1(n126), .A2(sync_rptr[4]), .A3(\wptr_full/wbin[4] ), .Z(
        n127) );
  xr02d1 U209 ( .A1(n128), .A2(n127), .Z(n164) );
  nd02d0 U212 ( .A1(n155), .A2(n130), .ZN(n147) );
  nd02d0 U213 ( .A1(n150), .A2(n131), .ZN(n132) );
  xn02d1 U214 ( .A1(n133), .A2(n132), .ZN(n146) );
  aor21d1 U215 ( .B1(near_full_mrgn[1]), .B2(\wptr_full/N25 ), .A(n134), .Z(
        n144) );
  nd02d0 U218 ( .A1(n139), .A2(n138), .ZN(n140) );
  xn02d1 U219 ( .A1(n141), .A2(n140), .ZN(n142) );
  ora21d1 U220 ( .B1(n147), .B2(n146), .A(n145), .Z(n162) );
  nd02d0 U222 ( .A1(n151), .A2(n150), .ZN(n154) );
  xn02d1 U223 ( .A1(n154), .A2(n77), .ZN(n158) );
  nr02d0 U225 ( .A1(n158), .A2(n157), .ZN(n159) );
  oan211d1 U226 ( .C1(n162), .C2(n161), .B(n160), .A(n159), .ZN(n163) );
  cg01d1 U227 ( .A(n165), .B(n164), .CI(n163), .CO(n167) );
  nr03d0 U228 ( .A1(n167), .A2(n166), .A3(wptr_clr), .ZN(\wptr_full/N33 ) );
  nr02d0 U229 ( .A1(n168), .A2(wptr_clr), .ZN(\wptr_full/N10 ) );
  nr02d0 U230 ( .A1(n169), .A2(wptr_clr), .ZN(\wptr_full/N9 ) );
  an02d0 U231 ( .A1(n171), .A2(n170), .Z(\wptr_full/N12 ) );
  nr02d0 U232 ( .A1(n172), .A2(wptr_clr), .ZN(\wptr_full/N11 ) );
  inv0d0 U233 ( .I(\intadd_2/B[0] ), .ZN(n173) );
  mx02d0 U234 ( .I0(n173), .I1(\intadd_2/B[0] ), .S(sync_wptr[0]), .Z(n193) );
  ora21d1 U235 ( .B1(\rptr_empty/N14 ), .B2(raddr[0]), .A(n174), .Z(n194) );
  inv0d0 U236 ( .I(n194), .ZN(n206) );
  nr02d0 U237 ( .A1(n193), .A2(n206), .ZN(\intadd_2/CI ) );
  inv0d0 U239 ( .I(sync_wptr[2]), .ZN(n178) );
  mx02d0 U240 ( .I0(\intadd_2/A[2] ), .I1(n177), .S(\intadd_2/A[1] ), .Z(n204)
         );
  mx02d0 U241 ( .I0(n178), .I1(sync_wptr[2]), .S(n204), .Z(n188) );
  inv0d0 U242 ( .I(sync_wptr[1]), .ZN(n180) );
  mx02d0 U243 ( .I0(\intadd_2/A[1] ), .I1(n179), .S(\intadd_2/A[0] ), .Z(n203)
         );
  mx02d0 U244 ( .I0(n180), .I1(sync_wptr[1]), .S(n203), .Z(n187) );
  inv0d0 U245 ( .I(sync_wptr[0]), .ZN(n182) );
  mx02d0 U246 ( .I0(\intadd_2/A[0] ), .I1(n181), .S(n194), .Z(n202) );
  mx02d0 U247 ( .I0(n182), .I1(sync_wptr[0]), .S(n202), .Z(n186) );
  inv0d0 U248 ( .I(sync_wptr[4]), .ZN(n185) );
  inv0d0 U249 ( .I(\rptr_empty/rbin[4] ), .ZN(n184) );
  mx02d0 U250 ( .I0(\rptr_empty/rbin[4] ), .I1(n184), .S(n183), .Z(n208) );
  mx02d0 U251 ( .I0(n185), .I1(sync_wptr[4]), .S(n208), .Z(n191) );
  nd04d0 U252 ( .A1(n188), .A2(n187), .A3(n186), .A4(n191), .ZN(n190) );
  nr02d0 U253 ( .A1(n205), .A2(sync_wptr[3]), .ZN(n189) );
  aor211d1 U254 ( .C1(n205), .C2(sync_wptr[3]), .A(n190), .B(n189), .Z(n201)
         );
  xr02d1 U255 ( .A1(n191), .A2(\intadd_2/n1 ), .Z(n199) );
  inv0d0 U256 ( .I(n193), .ZN(n192) );
  aor221d1 U257 ( .B1(n194), .B2(n193), .C1(n206), .C2(n192), .A(
        near_empty_mrgn[0]), .Z(n195) );
  ad01d0 U258 ( .A(\intadd_0/B[0] ), .B(near_empty_mrgn[1]), .CI(n195), .CO(
        n196) );
  ad01d0 U259 ( .A(\intadd_0/B[1] ), .B(near_empty_mrgn[2]), .CI(n196), .CO(
        n197) );
  an03d0 U260 ( .A1(n207), .A2(n201), .A3(n200), .Z(\rptr_empty/N25 ) );
  nr02d0 U261 ( .A1(rptr_clr), .A2(n201), .ZN(\rptr_empty/N16 ) );
  an03d0 U262 ( .A1(n207), .A2(empty), .A3(ren), .Z(\rptr_empty/N15 ) );
  an02d0 U263 ( .A1(n207), .A2(n202), .Z(\rptr_empty/N9 ) );
  an02d0 U264 ( .A1(n207), .A2(n203), .Z(\rptr_empty/N10 ) );
  an02d0 U265 ( .A1(n207), .A2(n204), .Z(\rptr_empty/N11 ) );
  nr02d0 U266 ( .A1(rptr_clr), .A2(n205), .ZN(\rptr_empty/N12 ) );
  nr02d0 U267 ( .A1(rptr_clr), .A2(n206), .ZN(\rptr_empty/N4 ) );
  an02d0 U268 ( .A1(n207), .A2(\intadd_2/A[0] ), .Z(\rptr_empty/N5 ) );
  an02d0 U269 ( .A1(n207), .A2(\intadd_2/A[1] ), .Z(\rptr_empty/N6 ) );
  an02d0 U270 ( .A1(n207), .A2(\intadd_2/A[2] ), .Z(\rptr_empty/N7 ) );
  an02d0 U271 ( .A1(n208), .A2(n207), .Z(\rptr_empty/N8 ) );
  nr03d0 U108 ( .A1(n83), .A2(wptr_clr), .A3(n216), .ZN(n209) );
  inv0d0 U112 ( .I(full), .ZN(n216) );
  xr02d1 U113 ( .A1(\rptr_empty/rbin[4] ), .A2(n217), .Z(n205) );
  nr02d0 U114 ( .A1(n175), .A2(raddr[3]), .ZN(n217) );
  inv0d0 U115 ( .I(n218), .ZN(n128) );
  inv0d0 U117 ( .I(n152), .ZN(n219) );
  aon211d1 U118 ( .C1(n151), .C2(n150), .B(n219), .A(n153), .ZN(n218) );
  an02d1 U119 ( .A1(n146), .A2(n147), .Z(n161) );
  nd12d0 U121 ( .A1(n214), .A2(waddr[3]), .ZN(n126) );
  xr02d1 U122 ( .A1(near_full_mrgn[3]), .A2(n155), .Z(n157) );
  nd12d0 U125 ( .A1(near_full_mrgn[2]), .A2(n134), .ZN(n155) );
  nd12d0 U129 ( .A1(n88), .A2(waddr[3]), .ZN(n90) );
  nd02d0 U130 ( .A1(n87), .A2(waddr[2]), .ZN(n88) );
  oai211d1 U131 ( .C1(n135), .C2(n136), .A(\wptr_full/N25 ), .B(n220), .ZN(
        n143) );
  nd02d0 U132 ( .A1(n135), .A2(n136), .ZN(n220) );
  xr02d1 U133 ( .A1(waddr[2]), .A2(n87), .Z(n93) );
  nr02d0 U134 ( .A1(n85), .A2(n111), .ZN(n87) );
  nr02d0 U137 ( .A1(near_full_mrgn[1]), .A2(\wptr_full/N25 ), .ZN(n134) );
  nd12d0 U156 ( .A1(n120), .A2(n121), .ZN(n152) );
  nd02d0 U157 ( .A1(waddr[2]), .A2(n118), .ZN(n121) );
  nd12d0 U165 ( .A1(n134), .A2(near_full_mrgn[2]), .ZN(n130) );
  or02d1 U166 ( .A1(n117), .A2(n116), .Z(n131) );
  inv0d0 U170 ( .I(n85), .ZN(n105) );
  nd02d0 U185 ( .A1(waddr[0]), .A2(n215), .ZN(n85) );
  xr02d1 U186 ( .A1(waddr[2]), .A2(n118), .Z(n116) );
  xn02d1 U189 ( .A1(n214), .A2(sync_rptr[2]), .ZN(n118) );
  or02d1 U193 ( .A1(n135), .A2(n109), .Z(n138) );
endmodule

