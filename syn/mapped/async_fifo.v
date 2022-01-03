/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : O-2018.06-SP1
// Date      : Mon Jan  3 19:37:44 2022
/////////////////////////////////////////////////////////////


module sync_rst_1 ( clk, rst_n, atpg_mode, sync_rst_n );
  input clk, rst_n, atpg_mode;
  output sync_rst_n;
  wire   dff2, dff1;

  sdcrq1 dff1_reg ( .D(1'b1), .SD(1'b0), .SC(1'b0), .CP(clk), .CDN(rst_n), .Q(
        dff1) );
  sdcrq1 dff2_reg ( .D(dff1), .SD(1'b0), .SC(1'b0), .CP(clk), .CDN(rst_n), .Q(
        dff2) );
  mx02d1 U5 ( .I0(dff2), .I1(rst_n), .S(atpg_mode), .Z(sync_rst_n) );
endmodule


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


module dpram_ASIZE4_DSIZE8 ( wclk, rst_n, wen, waddr, raddr, wdata, rdata );
  input [3:0] waddr;
  input [3:0] raddr;
  input [7:0] wdata;
  output [7:0] rdata;
  input wclk, rst_n, wen;
  wire   \mem[0][7] , \mem[0][6] , \mem[0][5] , \mem[0][4] , \mem[0][3] ,
         \mem[0][2] , \mem[0][1] , \mem[0][0] , \mem[1][7] , \mem[1][6] ,
         \mem[1][5] , \mem[1][4] , \mem[1][3] , \mem[1][2] , \mem[1][1] ,
         \mem[1][0] , \mem[2][7] , \mem[2][6] , \mem[2][5] , \mem[2][4] ,
         \mem[2][3] , \mem[2][2] , \mem[2][1] , \mem[2][0] , \mem[3][7] ,
         \mem[3][6] , \mem[3][5] , \mem[3][4] , \mem[3][3] , \mem[3][2] ,
         \mem[3][1] , \mem[3][0] , \mem[4][7] , \mem[4][6] , \mem[4][5] ,
         \mem[4][4] , \mem[4][3] , \mem[4][2] , \mem[4][1] , \mem[4][0] ,
         \mem[5][7] , \mem[5][6] , \mem[5][5] , \mem[5][4] , \mem[5][3] ,
         \mem[5][2] , \mem[5][1] , \mem[5][0] , \mem[6][7] , \mem[6][6] ,
         \mem[6][5] , \mem[6][4] , \mem[6][3] , \mem[6][2] , \mem[6][1] ,
         \mem[6][0] , \mem[7][7] , \mem[7][6] , \mem[7][5] , \mem[7][4] ,
         \mem[7][3] , \mem[7][2] , \mem[7][1] , \mem[7][0] , \mem[8][7] ,
         \mem[8][6] , \mem[8][5] , \mem[8][4] , \mem[8][3] , \mem[8][2] ,
         \mem[8][1] , \mem[8][0] , \mem[9][7] , \mem[9][6] , \mem[9][5] ,
         \mem[9][4] , \mem[9][3] , \mem[9][2] , \mem[9][1] , \mem[9][0] ,
         \mem[10][7] , \mem[10][6] , \mem[10][5] , \mem[10][4] , \mem[10][3] ,
         \mem[10][2] , \mem[10][1] , \mem[10][0] , \mem[11][7] , \mem[11][6] ,
         \mem[11][5] , \mem[11][4] , \mem[11][3] , \mem[11][2] , \mem[11][1] ,
         \mem[11][0] , \mem[12][7] , \mem[12][6] , \mem[12][5] , \mem[12][4] ,
         \mem[12][3] , \mem[12][2] , \mem[12][1] , \mem[12][0] , \mem[13][7] ,
         \mem[13][6] , \mem[13][5] , \mem[13][4] , \mem[13][3] , \mem[13][2] ,
         \mem[13][1] , \mem[13][0] , \mem[14][7] , \mem[14][6] , \mem[14][5] ,
         \mem[14][4] , \mem[14][3] , \mem[14][2] , \mem[14][1] , \mem[14][0] ,
         \mem[15][7] , \mem[15][6] , \mem[15][5] , \mem[15][4] , \mem[15][3] ,
         \mem[15][2] , \mem[15][1] , \mem[15][0] , N48, N49, N50, N51, N52,
         N53, N54, N55, n129, n130, n131, n132, n133, n134, n135, n136, n137,
         n138, n139, n140, n141, n142, n143, n144, n145, n146, n147, n148,
         n150, n151, n152, n154, n155, n156, n160, n161, n162, n164, n165,
         n166, n170, n171, n172, n174, n175, n176, n180, n181, n182, n184,
         n185, n186, n190, n191, n192, n194, n195, n196, n200, n201, n202,
         n204, n205, n206, n210, n211, n212, n214, n215, n216, n220, n221,
         n222, n223, n224, n225, n226, n227, n228, n229, n230, n232, n233,
         n234, n237, n238, n239, n240, n241, n242, n243, n244, n245, n246,
         n247, n248, n249, n250, n251, n252, n253, n254, n255, n256, n257,
         n258, n259, n260, n261, n262, n263, n264, n265, n266, n267, n268,
         n269, n270, n271, n272, n273, n274, n275, n276, n277, n278, n279,
         n280, n281, n282, n283, n284, n285, n286, n287, n288, n289, n290,
         n291, n292, n293, n294, n295, n296, n297, n298, n299, n300, n301,
         n302, n303, n304, n305, n306, n307, n308, n309, n310, n311, n312,
         n313, n314, n315, n316, n317, n318, n319, n320, n321, n322, n323,
         n324, n325, n326, n327, n328, n329, n330, n331, n332, n333, n334,
         n335, n336, n337, n338, n339, n340, n341, n342, n343, n344, n345,
         n346, n347, n348, n349, n350, n351, n352, n353, n354, n355, n356,
         n357, n358, n359, n360, n361, n362, n363, n364, n365, n366, n367,
         n368, n168, n169, n173, n177, n178, n179, n183, n187, n188, n189,
         n193, n197, n198, n199, n203, n207, n208, n213, n217, n218, n219,
         n231, n236, n369, n370, n371, n372, n374, n375, n376, n377, n378,
         n380, n381, n382, n383, n384, n386, n387, n388, n389, n390, n392,
         n393, n394, n395, n396, n398, n399, n400, n401, n402, n404, n405,
         n406, n407;

  sdcrq1 \mem_reg[0][7]  ( .D(n364), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[0][7] ) );
  sdcrq1 \mem_reg[0][6]  ( .D(n363), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[0][6] ) );
  sdcrq1 \mem_reg[0][5]  ( .D(n362), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[0][5] ) );
  sdcrq1 \mem_reg[0][4]  ( .D(n361), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[0][4] ) );
  sdcrq1 \mem_reg[0][3]  ( .D(n360), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[0][3] ) );
  sdcrq1 \mem_reg[0][2]  ( .D(n359), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[0][2] ) );
  sdcrq1 \mem_reg[0][1]  ( .D(n358), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[0][1] ) );
  sdcrq1 \mem_reg[0][0]  ( .D(n357), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[0][0] ) );
  sdcrq1 \mem_reg[1][7]  ( .D(n356), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[1][7] ) );
  sdcrq1 \mem_reg[1][6]  ( .D(n355), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[1][6] ) );
  sdcrq1 \mem_reg[1][5]  ( .D(n354), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[1][5] ) );
  sdcrq1 \mem_reg[1][4]  ( .D(n353), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[1][4] ) );
  sdcrq1 \mem_reg[1][3]  ( .D(n352), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[1][3] ) );
  sdcrq1 \mem_reg[1][2]  ( .D(n351), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[1][2] ) );
  sdcrq1 \mem_reg[1][1]  ( .D(n350), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[1][1] ) );
  sdcrq1 \mem_reg[1][0]  ( .D(n349), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[1][0] ) );
  sdcrq1 \mem_reg[2][7]  ( .D(n348), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[2][7] ) );
  sdcrq1 \mem_reg[2][6]  ( .D(n347), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[2][6] ) );
  sdcrq1 \mem_reg[2][5]  ( .D(n346), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[2][5] ) );
  sdcrq1 \mem_reg[2][4]  ( .D(n345), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[2][4] ) );
  sdcrq1 \mem_reg[2][3]  ( .D(n344), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[2][3] ) );
  sdcrq1 \mem_reg[2][2]  ( .D(n343), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[2][2] ) );
  sdcrq1 \mem_reg[2][1]  ( .D(n342), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[2][1] ) );
  sdcrq1 \mem_reg[2][0]  ( .D(n341), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[2][0] ) );
  sdcrq1 \mem_reg[3][7]  ( .D(n340), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[3][7] ) );
  sdcrq1 \mem_reg[3][6]  ( .D(n339), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[3][6] ) );
  sdcrq1 \mem_reg[3][5]  ( .D(n338), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[3][5] ) );
  sdcrq1 \mem_reg[3][4]  ( .D(n337), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[3][4] ) );
  sdcrq1 \mem_reg[3][3]  ( .D(n336), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[3][3] ) );
  sdcrq1 \mem_reg[3][2]  ( .D(n335), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[3][2] ) );
  sdcrq1 \mem_reg[3][1]  ( .D(n334), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[3][1] ) );
  sdcrq1 \mem_reg[3][0]  ( .D(n333), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[3][0] ) );
  sdcrq1 \mem_reg[4][7]  ( .D(n332), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[4][7] ) );
  sdcrq1 \mem_reg[4][6]  ( .D(n331), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[4][6] ) );
  sdcrq1 \mem_reg[4][5]  ( .D(n330), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[4][5] ) );
  sdcrq1 \mem_reg[4][4]  ( .D(n329), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[4][4] ) );
  sdcrq1 \mem_reg[4][3]  ( .D(n328), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[4][3] ) );
  sdcrq1 \mem_reg[4][2]  ( .D(n327), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[4][2] ) );
  sdcrq1 \mem_reg[4][1]  ( .D(n326), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[4][1] ) );
  sdcrq1 \mem_reg[4][0]  ( .D(n325), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[4][0] ) );
  sdcrq1 \mem_reg[5][7]  ( .D(n324), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[5][7] ) );
  sdcrq1 \mem_reg[5][6]  ( .D(n323), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[5][6] ) );
  sdcrq1 \mem_reg[5][5]  ( .D(n322), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[5][5] ) );
  sdcrq1 \mem_reg[5][4]  ( .D(n321), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[5][4] ) );
  sdcrq1 \mem_reg[5][3]  ( .D(n320), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[5][3] ) );
  sdcrq1 \mem_reg[5][2]  ( .D(n319), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[5][2] ) );
  sdcrq1 \mem_reg[5][1]  ( .D(n318), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[5][1] ) );
  sdcrq1 \mem_reg[5][0]  ( .D(n317), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[5][0] ) );
  sdcrq1 \mem_reg[6][7]  ( .D(n316), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[6][7] ) );
  sdcrq1 \mem_reg[6][6]  ( .D(n315), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[6][6] ) );
  sdcrq1 \mem_reg[6][5]  ( .D(n314), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[6][5] ) );
  sdcrq1 \mem_reg[6][4]  ( .D(n313), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[6][4] ) );
  sdcrq1 \mem_reg[6][3]  ( .D(n312), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[6][3] ) );
  sdcrq1 \mem_reg[6][2]  ( .D(n311), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[6][2] ) );
  sdcrq1 \mem_reg[6][1]  ( .D(n310), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[6][1] ) );
  sdcrq1 \mem_reg[6][0]  ( .D(n309), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[6][0] ) );
  sdcrq1 \mem_reg[7][7]  ( .D(n308), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[7][7] ) );
  sdcrq1 \mem_reg[7][6]  ( .D(n307), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[7][6] ) );
  sdcrq1 \mem_reg[7][5]  ( .D(n306), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[7][5] ) );
  sdcrq1 \mem_reg[7][4]  ( .D(n305), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[7][4] ) );
  sdcrq1 \mem_reg[7][3]  ( .D(n304), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[7][3] ) );
  sdcrq1 \mem_reg[7][2]  ( .D(n303), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[7][2] ) );
  sdcrq1 \mem_reg[7][1]  ( .D(n302), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[7][1] ) );
  sdcrq1 \mem_reg[7][0]  ( .D(n301), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[7][0] ) );
  sdcrq1 \mem_reg[8][7]  ( .D(n300), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[8][7] ) );
  sdcrq1 \mem_reg[8][6]  ( .D(n299), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[8][6] ) );
  sdcrq1 \mem_reg[8][5]  ( .D(n298), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[8][5] ) );
  sdcrq1 \mem_reg[8][4]  ( .D(n297), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[8][4] ) );
  sdcrq1 \mem_reg[8][3]  ( .D(n296), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[8][3] ) );
  sdcrq1 \mem_reg[8][2]  ( .D(n295), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[8][2] ) );
  sdcrq1 \mem_reg[8][1]  ( .D(n294), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[8][1] ) );
  sdcrq1 \mem_reg[8][0]  ( .D(n293), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[8][0] ) );
  sdcrq1 \mem_reg[9][7]  ( .D(n292), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[9][7] ) );
  sdcrq1 \mem_reg[9][6]  ( .D(n291), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[9][6] ) );
  sdcrq1 \mem_reg[9][5]  ( .D(n290), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[9][5] ) );
  sdcrq1 \mem_reg[9][4]  ( .D(n289), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[9][4] ) );
  sdcrq1 \mem_reg[9][3]  ( .D(n288), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[9][3] ) );
  sdcrq1 \mem_reg[9][2]  ( .D(n287), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[9][2] ) );
  sdcrq1 \mem_reg[9][1]  ( .D(n286), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[9][1] ) );
  sdcrq1 \mem_reg[9][0]  ( .D(n285), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[9][0] ) );
  sdcrq1 \mem_reg[10][7]  ( .D(n284), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[10][7] ) );
  sdcrq1 \mem_reg[10][6]  ( .D(n283), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[10][6] ) );
  sdcrq1 \mem_reg[10][5]  ( .D(n282), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[10][5] ) );
  sdcrq1 \mem_reg[10][4]  ( .D(n281), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[10][4] ) );
  sdcrq1 \mem_reg[10][3]  ( .D(n280), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[10][3] ) );
  sdcrq1 \mem_reg[10][2]  ( .D(n279), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[10][2] ) );
  sdcrq1 \mem_reg[10][1]  ( .D(n278), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[10][1] ) );
  sdcrq1 \mem_reg[10][0]  ( .D(n277), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[10][0] ) );
  sdcrq1 \mem_reg[11][7]  ( .D(n276), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[11][7] ) );
  sdcrq1 \mem_reg[11][6]  ( .D(n275), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[11][6] ) );
  sdcrq1 \mem_reg[11][5]  ( .D(n274), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[11][5] ) );
  sdcrq1 \mem_reg[11][4]  ( .D(n273), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[11][4] ) );
  sdcrq1 \mem_reg[11][3]  ( .D(n272), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[11][3] ) );
  sdcrq1 \mem_reg[11][2]  ( .D(n271), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[11][2] ) );
  sdcrq1 \mem_reg[11][1]  ( .D(n270), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[11][1] ) );
  sdcrq1 \mem_reg[11][0]  ( .D(n269), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[11][0] ) );
  sdcrq1 \mem_reg[12][7]  ( .D(n268), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[12][7] ) );
  sdcrq1 \mem_reg[12][6]  ( .D(n267), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[12][6] ) );
  sdcrq1 \mem_reg[12][5]  ( .D(n266), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[12][5] ) );
  sdcrq1 \mem_reg[12][4]  ( .D(n265), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[12][4] ) );
  sdcrq1 \mem_reg[12][3]  ( .D(n264), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[12][3] ) );
  sdcrq1 \mem_reg[12][2]  ( .D(n263), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[12][2] ) );
  sdcrq1 \mem_reg[12][1]  ( .D(n262), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[12][1] ) );
  sdcrq1 \mem_reg[12][0]  ( .D(n261), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[12][0] ) );
  sdcrq1 \mem_reg[13][7]  ( .D(n260), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[13][7] ) );
  sdcrq1 \mem_reg[13][6]  ( .D(n259), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[13][6] ) );
  sdcrq1 \mem_reg[13][5]  ( .D(n258), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[13][5] ) );
  sdcrq1 \mem_reg[13][4]  ( .D(n257), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[13][4] ) );
  sdcrq1 \mem_reg[13][3]  ( .D(n256), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[13][3] ) );
  sdcrq1 \mem_reg[13][2]  ( .D(n255), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[13][2] ) );
  sdcrq1 \mem_reg[13][1]  ( .D(n254), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[13][1] ) );
  sdcrq1 \mem_reg[13][0]  ( .D(n253), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[13][0] ) );
  sdcrq1 \mem_reg[14][7]  ( .D(n252), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[14][7] ) );
  sdcrq1 \mem_reg[14][6]  ( .D(n251), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[14][6] ) );
  sdcrq1 \mem_reg[14][5]  ( .D(n250), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[14][5] ) );
  sdcrq1 \mem_reg[14][4]  ( .D(n249), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[14][4] ) );
  sdcrq1 \mem_reg[14][3]  ( .D(n248), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[14][3] ) );
  sdcrq1 \mem_reg[14][2]  ( .D(n247), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[14][2] ) );
  sdcrq1 \mem_reg[14][1]  ( .D(n246), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[14][1] ) );
  sdcrq1 \mem_reg[14][0]  ( .D(n245), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[14][0] ) );
  sdcrq1 \mem_reg[15][7]  ( .D(n244), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[15][7] ) );
  sdcrq1 \mem_reg[15][6]  ( .D(n243), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[15][6] ) );
  sdcrq1 \mem_reg[15][5]  ( .D(n242), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[15][5] ) );
  sdcrq1 \mem_reg[15][4]  ( .D(n241), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[15][4] ) );
  sdcrq1 \mem_reg[15][3]  ( .D(n240), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[15][3] ) );
  sdcrq1 \mem_reg[15][2]  ( .D(n239), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[15][2] ) );
  sdcrq1 \mem_reg[15][1]  ( .D(n238), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[15][1] ) );
  sdcrq1 \mem_reg[15][0]  ( .D(n237), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(
        rst_n), .Q(\mem[15][0] ) );
  aor22d1 U283 ( .A1(n224), .A2(\mem[7][0] ), .B1(n223), .B2(\mem[5][0] ), .Z(
        n152) );
  aor22d1 U287 ( .A1(n226), .A2(\mem[6][0] ), .B1(n225), .B2(\mem[4][0] ), .Z(
        n151) );
  aor22d1 U290 ( .A1(n228), .A2(\mem[3][0] ), .B1(n227), .B2(\mem[1][0] ), .Z(
        n150) );
  aor22d1 U295 ( .A1(n224), .A2(\mem[15][0] ), .B1(n223), .B2(\mem[13][0] ), 
        .Z(n156) );
  aor22d1 U296 ( .A1(n226), .A2(\mem[14][0] ), .B1(n225), .B2(\mem[12][0] ), 
        .Z(n155) );
  aor22d1 U297 ( .A1(n228), .A2(\mem[11][0] ), .B1(n227), .B2(\mem[9][0] ), 
        .Z(n154) );
  aor22d1 U301 ( .A1(n224), .A2(\mem[7][1] ), .B1(n223), .B2(\mem[5][1] ), .Z(
        n162) );
  aor22d1 U302 ( .A1(n226), .A2(\mem[6][1] ), .B1(n225), .B2(\mem[4][1] ), .Z(
        n161) );
  aor22d1 U303 ( .A1(n228), .A2(\mem[3][1] ), .B1(n227), .B2(\mem[1][1] ), .Z(
        n160) );
  aor22d1 U306 ( .A1(n224), .A2(\mem[15][1] ), .B1(n223), .B2(\mem[13][1] ), 
        .Z(n166) );
  aor22d1 U307 ( .A1(n226), .A2(\mem[14][1] ), .B1(n225), .B2(\mem[12][1] ), 
        .Z(n165) );
  aor22d1 U308 ( .A1(n228), .A2(\mem[11][1] ), .B1(n227), .B2(\mem[9][1] ), 
        .Z(n164) );
  aor22d1 U312 ( .A1(n224), .A2(\mem[7][2] ), .B1(n223), .B2(\mem[5][2] ), .Z(
        n172) );
  aor22d1 U313 ( .A1(n226), .A2(\mem[6][2] ), .B1(n225), .B2(\mem[4][2] ), .Z(
        n171) );
  aor22d1 U314 ( .A1(n228), .A2(\mem[3][2] ), .B1(n227), .B2(\mem[1][2] ), .Z(
        n170) );
  aor22d1 U317 ( .A1(n224), .A2(\mem[15][2] ), .B1(n223), .B2(\mem[13][2] ), 
        .Z(n176) );
  aor22d1 U318 ( .A1(n226), .A2(\mem[14][2] ), .B1(n225), .B2(\mem[12][2] ), 
        .Z(n175) );
  aor22d1 U319 ( .A1(n228), .A2(\mem[11][2] ), .B1(n227), .B2(\mem[9][2] ), 
        .Z(n174) );
  aor22d1 U323 ( .A1(n224), .A2(\mem[7][3] ), .B1(n223), .B2(\mem[5][3] ), .Z(
        n182) );
  aor22d1 U324 ( .A1(n226), .A2(\mem[6][3] ), .B1(n225), .B2(\mem[4][3] ), .Z(
        n181) );
  aor22d1 U325 ( .A1(n228), .A2(\mem[3][3] ), .B1(n227), .B2(\mem[1][3] ), .Z(
        n180) );
  aor22d1 U328 ( .A1(n224), .A2(\mem[15][3] ), .B1(n223), .B2(\mem[13][3] ), 
        .Z(n186) );
  aor22d1 U329 ( .A1(n226), .A2(\mem[14][3] ), .B1(n225), .B2(\mem[12][3] ), 
        .Z(n185) );
  aor22d1 U330 ( .A1(n228), .A2(\mem[11][3] ), .B1(n227), .B2(\mem[9][3] ), 
        .Z(n184) );
  aor22d1 U334 ( .A1(n224), .A2(\mem[7][4] ), .B1(n223), .B2(\mem[5][4] ), .Z(
        n192) );
  aor22d1 U335 ( .A1(n226), .A2(\mem[6][4] ), .B1(n225), .B2(\mem[4][4] ), .Z(
        n191) );
  aor22d1 U336 ( .A1(n228), .A2(\mem[3][4] ), .B1(n227), .B2(\mem[1][4] ), .Z(
        n190) );
  aor22d1 U339 ( .A1(n224), .A2(\mem[15][4] ), .B1(n223), .B2(\mem[13][4] ), 
        .Z(n196) );
  aor22d1 U340 ( .A1(n226), .A2(\mem[14][4] ), .B1(n225), .B2(\mem[12][4] ), 
        .Z(n195) );
  aor22d1 U341 ( .A1(n228), .A2(\mem[11][4] ), .B1(n227), .B2(\mem[9][4] ), 
        .Z(n194) );
  aor22d1 U345 ( .A1(n224), .A2(\mem[7][5] ), .B1(n223), .B2(\mem[5][5] ), .Z(
        n202) );
  aor22d1 U346 ( .A1(n226), .A2(\mem[6][5] ), .B1(n225), .B2(\mem[4][5] ), .Z(
        n201) );
  aor22d1 U347 ( .A1(n228), .A2(\mem[3][5] ), .B1(n227), .B2(\mem[1][5] ), .Z(
        n200) );
  aor22d1 U350 ( .A1(n224), .A2(\mem[15][5] ), .B1(n223), .B2(\mem[13][5] ), 
        .Z(n206) );
  aor22d1 U351 ( .A1(n226), .A2(\mem[14][5] ), .B1(n225), .B2(\mem[12][5] ), 
        .Z(n205) );
  aor22d1 U352 ( .A1(n228), .A2(\mem[11][5] ), .B1(n227), .B2(\mem[9][5] ), 
        .Z(n204) );
  aor22d1 U356 ( .A1(n224), .A2(\mem[7][6] ), .B1(n223), .B2(\mem[5][6] ), .Z(
        n212) );
  aor22d1 U357 ( .A1(n226), .A2(\mem[6][6] ), .B1(n225), .B2(\mem[4][6] ), .Z(
        n211) );
  aor22d1 U358 ( .A1(n228), .A2(\mem[3][6] ), .B1(n227), .B2(\mem[1][6] ), .Z(
        n210) );
  aor22d1 U361 ( .A1(n224), .A2(\mem[15][6] ), .B1(n223), .B2(\mem[13][6] ), 
        .Z(n216) );
  aor22d1 U362 ( .A1(n226), .A2(\mem[14][6] ), .B1(n225), .B2(\mem[12][6] ), 
        .Z(n215) );
  aor22d1 U363 ( .A1(n228), .A2(\mem[11][6] ), .B1(n227), .B2(\mem[9][6] ), 
        .Z(n214) );
  aor22d1 U367 ( .A1(n224), .A2(\mem[7][7] ), .B1(n223), .B2(\mem[5][7] ), .Z(
        n222) );
  aor22d1 U368 ( .A1(n226), .A2(\mem[6][7] ), .B1(n225), .B2(\mem[4][7] ), .Z(
        n221) );
  aor22d1 U369 ( .A1(n228), .A2(\mem[3][7] ), .B1(n227), .B2(\mem[1][7] ), .Z(
        n220) );
  aor22d1 U372 ( .A1(n224), .A2(\mem[15][7] ), .B1(n223), .B2(\mem[13][7] ), 
        .Z(n234) );
  aor22d1 U373 ( .A1(n226), .A2(\mem[14][7] ), .B1(n225), .B2(\mem[12][7] ), 
        .Z(n233) );
  aor22d1 U374 ( .A1(n228), .A2(\mem[11][7] ), .B1(n227), .B2(\mem[9][7] ), 
        .Z(n232) );
  nd02d0 U278 ( .A1(raddr[1]), .A2(raddr[0]), .ZN(n146) );
  inv0d1 U279 ( .I(raddr[2]), .ZN(n145) );
  nr03d0 U291 ( .A1(raddr[0]), .A2(raddr[2]), .A3(n148), .ZN(n230) );
  mx02d0 U233 ( .I0(wdata[3]), .I1(\mem[4][3] ), .S(n140), .Z(n328) );
  mx02d0 U221 ( .I0(wdata[0]), .I1(\mem[5][0] ), .S(n139), .Z(n317) );
  mx02d0 U225 ( .I0(wdata[4]), .I1(\mem[5][4] ), .S(n139), .Z(n321) );
  mx02d0 U234 ( .I0(wdata[4]), .I1(\mem[4][4] ), .S(n140), .Z(n329) );
  mx02d0 U231 ( .I0(wdata[1]), .I1(\mem[4][1] ), .S(n140), .Z(n326) );
  mx02d0 U235 ( .I0(wdata[5]), .I1(\mem[4][5] ), .S(n140), .Z(n330) );
  mx02d0 U215 ( .I0(wdata[3]), .I1(\mem[6][3] ), .S(n138), .Z(n312) );
  mx02d0 U214 ( .I0(wdata[2]), .I1(\mem[6][2] ), .S(n138), .Z(n311) );
  mx02d0 U232 ( .I0(wdata[2]), .I1(\mem[4][2] ), .S(n140), .Z(n327) );
  mx02d0 U212 ( .I0(wdata[0]), .I1(\mem[6][0] ), .S(n138), .Z(n309) );
  mx02d0 U210 ( .I0(wdata[7]), .I1(\mem[7][7] ), .S(n137), .Z(n308) );
  mx02d0 U224 ( .I0(wdata[3]), .I1(\mem[5][3] ), .S(n139), .Z(n320) );
  mx02d0 U208 ( .I0(wdata[5]), .I1(\mem[7][5] ), .S(n137), .Z(n306) );
  mx02d0 U207 ( .I0(wdata[4]), .I1(\mem[7][4] ), .S(n137), .Z(n305) );
  mx02d0 U206 ( .I0(wdata[3]), .I1(\mem[7][3] ), .S(n137), .Z(n304) );
  mx02d0 U205 ( .I0(wdata[2]), .I1(\mem[7][2] ), .S(n137), .Z(n303) );
  mx02d0 U204 ( .I0(wdata[1]), .I1(\mem[7][1] ), .S(n137), .Z(n302) );
  mx02d0 U203 ( .I0(wdata[0]), .I1(\mem[7][0] ), .S(n137), .Z(n301) );
  mx02d0 U217 ( .I0(wdata[5]), .I1(\mem[6][5] ), .S(n138), .Z(n314) );
  mx02d0 U200 ( .I0(wdata[6]), .I1(\mem[8][6] ), .S(n136), .Z(n299) );
  mx02d0 U199 ( .I0(wdata[5]), .I1(\mem[8][5] ), .S(n136), .Z(n298) );
  mx02d0 U198 ( .I0(wdata[4]), .I1(\mem[8][4] ), .S(n136), .Z(n297) );
  mx02d0 U213 ( .I0(wdata[1]), .I1(\mem[6][1] ), .S(n138), .Z(n310) );
  mx02d0 U230 ( .I0(wdata[0]), .I1(\mem[4][0] ), .S(n140), .Z(n325) );
  mx02d0 U228 ( .I0(wdata[7]), .I1(\mem[5][7] ), .S(n139), .Z(n324) );
  mx02d0 U227 ( .I0(wdata[6]), .I1(\mem[5][6] ), .S(n139), .Z(n323) );
  mx02d0 U226 ( .I0(wdata[5]), .I1(\mem[5][5] ), .S(n139), .Z(n322) );
  mx02d0 U197 ( .I0(wdata[3]), .I1(\mem[8][3] ), .S(n136), .Z(n296) );
  mx02d0 U196 ( .I0(wdata[2]), .I1(\mem[8][2] ), .S(n136), .Z(n295) );
  mx02d0 U223 ( .I0(wdata[2]), .I1(\mem[5][2] ), .S(n139), .Z(n319) );
  mx02d0 U222 ( .I0(wdata[1]), .I1(\mem[5][1] ), .S(n139), .Z(n318) );
  mx02d0 U195 ( .I0(wdata[1]), .I1(\mem[8][1] ), .S(n136), .Z(n294) );
  mx02d0 U201 ( .I0(wdata[7]), .I1(\mem[8][7] ), .S(n136), .Z(n300) );
  mx02d0 U219 ( .I0(wdata[7]), .I1(\mem[6][7] ), .S(n138), .Z(n316) );
  mx02d0 U218 ( .I0(wdata[6]), .I1(\mem[6][6] ), .S(n138), .Z(n315) );
  mx02d0 U194 ( .I0(wdata[0]), .I1(\mem[8][0] ), .S(n136), .Z(n293) );
  mx02d0 U216 ( .I0(wdata[4]), .I1(\mem[6][4] ), .S(n138), .Z(n313) );
  mx02d0 U192 ( .I0(wdata[7]), .I1(\mem[9][7] ), .S(n135), .Z(n292) );
  mx02d0 U191 ( .I0(wdata[6]), .I1(\mem[9][6] ), .S(n135), .Z(n291) );
  mx02d0 U190 ( .I0(wdata[5]), .I1(\mem[9][5] ), .S(n135), .Z(n290) );
  mx02d0 U189 ( .I0(wdata[4]), .I1(\mem[9][4] ), .S(n135), .Z(n289) );
  mx02d0 U188 ( .I0(wdata[3]), .I1(\mem[9][3] ), .S(n135), .Z(n288) );
  mx02d0 U209 ( .I0(wdata[6]), .I1(\mem[7][6] ), .S(n137), .Z(n307) );
  mx02d0 U187 ( .I0(wdata[2]), .I1(\mem[9][2] ), .S(n135), .Z(n287) );
  mx02d0 U186 ( .I0(wdata[1]), .I1(\mem[9][1] ), .S(n135), .Z(n286) );
  mx02d0 U132 ( .I0(wdata[1]), .I1(\mem[15][1] ), .S(n129), .Z(n238) );
  mx02d0 U185 ( .I0(wdata[0]), .I1(\mem[9][0] ), .S(n135), .Z(n285) );
  mx02d0 U183 ( .I0(wdata[7]), .I1(\mem[10][7] ), .S(n134), .Z(n284) );
  mx02d0 U182 ( .I0(wdata[6]), .I1(\mem[10][6] ), .S(n134), .Z(n283) );
  mx02d0 U181 ( .I0(wdata[5]), .I1(\mem[10][5] ), .S(n134), .Z(n282) );
  mx02d0 U179 ( .I0(wdata[3]), .I1(\mem[10][3] ), .S(n134), .Z(n280) );
  mx02d0 U178 ( .I0(wdata[2]), .I1(\mem[10][2] ), .S(n134), .Z(n279) );
  mx02d0 U177 ( .I0(wdata[1]), .I1(\mem[10][1] ), .S(n134), .Z(n278) );
  mx02d0 U176 ( .I0(wdata[0]), .I1(\mem[10][0] ), .S(n134), .Z(n277) );
  mx02d0 U174 ( .I0(wdata[7]), .I1(\mem[11][7] ), .S(n133), .Z(n276) );
  mx02d0 U173 ( .I0(wdata[6]), .I1(\mem[11][6] ), .S(n133), .Z(n275) );
  mx02d0 U172 ( .I0(wdata[5]), .I1(\mem[11][5] ), .S(n133), .Z(n274) );
  mx02d0 U171 ( .I0(wdata[4]), .I1(\mem[11][4] ), .S(n133), .Z(n273) );
  mx02d0 U170 ( .I0(wdata[3]), .I1(\mem[11][3] ), .S(n133), .Z(n272) );
  mx02d0 U169 ( .I0(wdata[2]), .I1(\mem[11][2] ), .S(n133), .Z(n271) );
  mx02d0 U168 ( .I0(wdata[1]), .I1(\mem[11][1] ), .S(n133), .Z(n270) );
  mx02d0 U167 ( .I0(wdata[0]), .I1(\mem[11][0] ), .S(n133), .Z(n269) );
  mx02d0 U165 ( .I0(wdata[7]), .I1(\mem[12][7] ), .S(n132), .Z(n268) );
  mx02d0 U164 ( .I0(wdata[6]), .I1(\mem[12][6] ), .S(n132), .Z(n267) );
  mx02d0 U163 ( .I0(wdata[5]), .I1(\mem[12][5] ), .S(n132), .Z(n266) );
  mx02d0 U162 ( .I0(wdata[4]), .I1(\mem[12][4] ), .S(n132), .Z(n265) );
  mx02d0 U161 ( .I0(wdata[3]), .I1(\mem[12][3] ), .S(n132), .Z(n264) );
  mx02d0 U160 ( .I0(wdata[2]), .I1(\mem[12][2] ), .S(n132), .Z(n263) );
  mx02d0 U159 ( .I0(wdata[1]), .I1(\mem[12][1] ), .S(n132), .Z(n262) );
  mx02d0 U158 ( .I0(wdata[0]), .I1(\mem[12][0] ), .S(n132), .Z(n261) );
  mx02d0 U156 ( .I0(wdata[7]), .I1(\mem[13][7] ), .S(n131), .Z(n260) );
  mx02d0 U155 ( .I0(wdata[6]), .I1(\mem[13][6] ), .S(n131), .Z(n259) );
  mx02d0 U154 ( .I0(wdata[5]), .I1(\mem[13][5] ), .S(n131), .Z(n258) );
  mx02d0 U153 ( .I0(wdata[4]), .I1(\mem[13][4] ), .S(n131), .Z(n257) );
  mx02d0 U152 ( .I0(wdata[3]), .I1(\mem[13][3] ), .S(n131), .Z(n256) );
  mx02d0 U151 ( .I0(wdata[2]), .I1(\mem[13][2] ), .S(n131), .Z(n255) );
  mx02d0 U150 ( .I0(wdata[1]), .I1(\mem[13][1] ), .S(n131), .Z(n254) );
  mx02d0 U149 ( .I0(wdata[0]), .I1(\mem[13][0] ), .S(n131), .Z(n253) );
  mx02d0 U147 ( .I0(wdata[7]), .I1(\mem[14][7] ), .S(n130), .Z(n252) );
  mx02d0 U146 ( .I0(wdata[6]), .I1(\mem[14][6] ), .S(n130), .Z(n251) );
  mx02d0 U145 ( .I0(wdata[5]), .I1(\mem[14][5] ), .S(n130), .Z(n250) );
  mx02d0 U144 ( .I0(wdata[4]), .I1(\mem[14][4] ), .S(n130), .Z(n249) );
  mx02d0 U143 ( .I0(wdata[3]), .I1(\mem[14][3] ), .S(n130), .Z(n248) );
  mx02d0 U142 ( .I0(wdata[2]), .I1(\mem[14][2] ), .S(n130), .Z(n247) );
  mx02d0 U141 ( .I0(wdata[1]), .I1(\mem[14][1] ), .S(n130), .Z(n246) );
  mx02d0 U140 ( .I0(wdata[0]), .I1(\mem[14][0] ), .S(n130), .Z(n245) );
  mx02d0 U138 ( .I0(wdata[7]), .I1(\mem[15][7] ), .S(n129), .Z(n244) );
  mx02d0 U137 ( .I0(wdata[6]), .I1(\mem[15][6] ), .S(n129), .Z(n243) );
  mx02d0 U136 ( .I0(wdata[5]), .I1(\mem[15][5] ), .S(n129), .Z(n242) );
  mx02d0 U135 ( .I0(wdata[4]), .I1(\mem[15][4] ), .S(n129), .Z(n241) );
  mx02d0 U134 ( .I0(wdata[3]), .I1(\mem[15][3] ), .S(n129), .Z(n240) );
  mx02d0 U133 ( .I0(wdata[2]), .I1(\mem[15][2] ), .S(n129), .Z(n239) );
  mx02d0 U180 ( .I0(wdata[4]), .I1(\mem[10][4] ), .S(n134), .Z(n281) );
  mx02d0 U236 ( .I0(wdata[6]), .I1(\mem[4][6] ), .S(n140), .Z(n331) );
  mx02d0 U237 ( .I0(wdata[7]), .I1(\mem[4][7] ), .S(n140), .Z(n332) );
  mx02d0 U239 ( .I0(wdata[0]), .I1(\mem[3][0] ), .S(n141), .Z(n333) );
  mx02d0 U240 ( .I0(wdata[1]), .I1(\mem[3][1] ), .S(n141), .Z(n334) );
  mx02d0 U241 ( .I0(wdata[2]), .I1(\mem[3][2] ), .S(n141), .Z(n335) );
  mx02d0 U242 ( .I0(wdata[3]), .I1(\mem[3][3] ), .S(n141), .Z(n336) );
  mx02d0 U243 ( .I0(wdata[4]), .I1(\mem[3][4] ), .S(n141), .Z(n337) );
  mx02d0 U244 ( .I0(wdata[5]), .I1(\mem[3][5] ), .S(n141), .Z(n338) );
  mx02d0 U245 ( .I0(wdata[6]), .I1(\mem[3][6] ), .S(n141), .Z(n339) );
  mx02d0 U246 ( .I0(wdata[7]), .I1(\mem[3][7] ), .S(n141), .Z(n340) );
  mx02d0 U248 ( .I0(wdata[0]), .I1(\mem[2][0] ), .S(n142), .Z(n341) );
  mx02d0 U249 ( .I0(wdata[1]), .I1(\mem[2][1] ), .S(n142), .Z(n342) );
  mx02d0 U250 ( .I0(wdata[2]), .I1(\mem[2][2] ), .S(n142), .Z(n343) );
  mx02d0 U251 ( .I0(wdata[3]), .I1(\mem[2][3] ), .S(n142), .Z(n344) );
  mx02d0 U252 ( .I0(wdata[4]), .I1(\mem[2][4] ), .S(n142), .Z(n345) );
  mx02d0 U253 ( .I0(wdata[5]), .I1(\mem[2][5] ), .S(n142), .Z(n346) );
  mx02d0 U254 ( .I0(wdata[6]), .I1(\mem[2][6] ), .S(n142), .Z(n347) );
  mx02d0 U255 ( .I0(wdata[7]), .I1(\mem[2][7] ), .S(n142), .Z(n348) );
  mx02d0 U257 ( .I0(wdata[0]), .I1(\mem[1][0] ), .S(n143), .Z(n349) );
  mx02d0 U258 ( .I0(wdata[1]), .I1(\mem[1][1] ), .S(n143), .Z(n350) );
  mx02d0 U259 ( .I0(wdata[2]), .I1(\mem[1][2] ), .S(n143), .Z(n351) );
  mx02d0 U260 ( .I0(wdata[3]), .I1(\mem[1][3] ), .S(n143), .Z(n352) );
  mx02d0 U261 ( .I0(wdata[4]), .I1(\mem[1][4] ), .S(n143), .Z(n353) );
  mx02d0 U262 ( .I0(wdata[5]), .I1(\mem[1][5] ), .S(n143), .Z(n354) );
  mx02d0 U263 ( .I0(wdata[6]), .I1(\mem[1][6] ), .S(n143), .Z(n355) );
  mx02d0 U264 ( .I0(wdata[7]), .I1(\mem[1][7] ), .S(n143), .Z(n356) );
  mx02d0 U266 ( .I0(wdata[0]), .I1(\mem[0][0] ), .S(n144), .Z(n357) );
  mx02d0 U267 ( .I0(wdata[1]), .I1(\mem[0][1] ), .S(n144), .Z(n358) );
  mx02d0 U268 ( .I0(wdata[2]), .I1(\mem[0][2] ), .S(n144), .Z(n359) );
  mx02d0 U269 ( .I0(wdata[3]), .I1(\mem[0][3] ), .S(n144), .Z(n360) );
  mx02d0 U270 ( .I0(wdata[4]), .I1(\mem[0][4] ), .S(n144), .Z(n361) );
  mx02d0 U271 ( .I0(wdata[5]), .I1(\mem[0][5] ), .S(n144), .Z(n362) );
  mx02d0 U272 ( .I0(wdata[6]), .I1(\mem[0][6] ), .S(n144), .Z(n363) );
  mx02d0 U273 ( .I0(wdata[7]), .I1(\mem[0][7] ), .S(n144), .Z(n364) );
  mx02d0 U131 ( .I0(wdata[0]), .I1(\mem[15][0] ), .S(n129), .Z(n237) );
  nr03d1 U286 ( .A1(raddr[1]), .A2(raddr[0]), .A3(n145), .ZN(n225) );
  nr03d1 U289 ( .A1(raddr[1]), .A2(raddr[2]), .A3(n147), .ZN(n227) );
  nr03d1 U282 ( .A1(raddr[1]), .A2(n147), .A3(n145), .ZN(n223) );
  nr03d1 U285 ( .A1(raddr[0]), .A2(n148), .A3(n145), .ZN(n226) );
  nr02d1 U280 ( .A1(n146), .A2(n145), .ZN(n224) );
  an02d1 C550 ( .A1(n368), .A2(waddr[1]), .Z(N53) );
  an02d1 C549 ( .A1(waddr[0]), .A2(waddr[1]), .Z(N52) );
  an02d0 C545 ( .A1(waddr[2]), .A2(waddr[3]), .Z(N48) );
  nr03d0 U292 ( .A1(raddr[1]), .A2(raddr[0]), .A3(raddr[2]), .ZN(n229) );
  inv0d0 U284 ( .I(raddr[1]), .ZN(n148) );
  inv0d0 U281 ( .I(raddr[0]), .ZN(n147) );
  nr02d1 U288 ( .A1(raddr[2]), .A2(n146), .ZN(n228) );
  an02d1 C546 ( .A1(n366), .A2(waddr[3]), .Z(N49) );
  an02d1 C547 ( .A1(waddr[2]), .A2(n365), .Z(N50) );
  an02d1 C551 ( .A1(waddr[0]), .A2(n367), .Z(N54) );
  nd02d0 U9 ( .A1(n188), .A2(n380), .ZN(n381) );
  nd02d0 U10 ( .A1(n177), .A2(n404), .ZN(n405) );
  nd02d1 U25 ( .A1(n387), .A2(raddr[3]), .ZN(n388) );
  nd02d1 U26 ( .A1(n369), .A2(raddr[3]), .ZN(n370) );
  nd02d1 U27 ( .A1(n381), .A2(raddr[3]), .ZN(n382) );
  nd02d1 U28 ( .A1(n393), .A2(raddr[3]), .ZN(n394) );
  nd02d1 U29 ( .A1(n375), .A2(raddr[3]), .ZN(n376) );
  nd02d1 U31 ( .A1(n405), .A2(raddr[3]), .ZN(n406) );
  nd02d1 U32 ( .A1(n399), .A2(raddr[3]), .ZN(n400) );
  nd02d1 U33 ( .A1(n187), .A2(n386), .ZN(n387) );
  nd02d1 U34 ( .A1(n179), .A2(n236), .ZN(n369) );
  nd02d1 U35 ( .A1(n183), .A2(n392), .ZN(n393) );
  nd02d1 U36 ( .A1(n189), .A2(n398), .ZN(n399) );
  nd02d1 U37 ( .A1(n173), .A2(n374), .ZN(n375) );
  nd02d0 U38 ( .A1(n178), .A2(n213), .ZN(n217) );
  aoi22d1 U39 ( .A1(n230), .A2(\mem[2][5] ), .B1(n229), .B2(\mem[0][5] ), .ZN(
        n168) );
  aoi22d1 U40 ( .A1(n230), .A2(\mem[2][3] ), .B1(n229), .B2(\mem[0][3] ), .ZN(
        n169) );
  aoi22d1 U41 ( .A1(n230), .A2(\mem[10][7] ), .B1(n229), .B2(\mem[8][7] ), 
        .ZN(n173) );
  aoi22d1 U42 ( .A1(n230), .A2(\mem[10][6] ), .B1(n229), .B2(\mem[8][6] ), 
        .ZN(n177) );
  aoi22d1 U43 ( .A1(n230), .A2(\mem[10][5] ), .B1(n229), .B2(\mem[8][5] ), 
        .ZN(n178) );
  aoi22d1 U44 ( .A1(n230), .A2(\mem[10][3] ), .B1(n229), .B2(\mem[8][3] ), 
        .ZN(n179) );
  aoi22d1 U45 ( .A1(n230), .A2(\mem[10][2] ), .B1(n229), .B2(\mem[8][2] ), 
        .ZN(n183) );
  aoi22d1 U46 ( .A1(n230), .A2(\mem[10][1] ), .B1(n229), .B2(\mem[8][1] ), 
        .ZN(n187) );
  aoi22d1 U47 ( .A1(n230), .A2(\mem[10][0] ), .B1(n229), .B2(\mem[8][0] ), 
        .ZN(n188) );
  aoi22d1 U48 ( .A1(n230), .A2(\mem[10][4] ), .B1(n229), .B2(\mem[8][4] ), 
        .ZN(n189) );
  aoi22d1 U49 ( .A1(n230), .A2(\mem[2][0] ), .B1(n229), .B2(\mem[0][0] ), .ZN(
        n193) );
  aoi22d1 U50 ( .A1(n230), .A2(\mem[2][1] ), .B1(n229), .B2(\mem[0][1] ), .ZN(
        n197) );
  aoi22d1 U51 ( .A1(n230), .A2(\mem[2][2] ), .B1(n229), .B2(\mem[0][2] ), .ZN(
        n198) );
  aoi22d1 U52 ( .A1(n230), .A2(\mem[2][4] ), .B1(n229), .B2(\mem[0][4] ), .ZN(
        n199) );
  aoi22d1 U53 ( .A1(n230), .A2(\mem[2][6] ), .B1(n229), .B2(\mem[0][6] ), .ZN(
        n203) );
  aoi22d1 U54 ( .A1(n230), .A2(\mem[2][7] ), .B1(n229), .B2(\mem[0][7] ), .ZN(
        n207) );
  nr03d0 U56 ( .A1(n200), .A2(n202), .A3(n201), .ZN(n208) );
  nr03d0 U57 ( .A1(n204), .A2(n206), .A3(n205), .ZN(n213) );
  nd02d1 U58 ( .A1(n217), .A2(raddr[3]), .ZN(n218) );
  nd02d1 U59 ( .A1(n219), .A2(n218), .ZN(rdata[5]) );
  nr03d0 U60 ( .A1(n180), .A2(n182), .A3(n181), .ZN(n231) );
  nr03d0 U61 ( .A1(n184), .A2(n186), .A3(n185), .ZN(n236) );
  nd02d1 U62 ( .A1(n371), .A2(n370), .ZN(rdata[3]) );
  nr03d0 U63 ( .A1(n220), .A2(n222), .A3(n221), .ZN(n372) );
  nr03d0 U64 ( .A1(n232), .A2(n234), .A3(n233), .ZN(n374) );
  nd02d1 U65 ( .A1(n377), .A2(n376), .ZN(rdata[7]) );
  nr03d0 U66 ( .A1(n150), .A2(n152), .A3(n151), .ZN(n378) );
  nr03d0 U67 ( .A1(n154), .A2(n156), .A3(n155), .ZN(n380) );
  nd02d1 U68 ( .A1(n383), .A2(n382), .ZN(rdata[0]) );
  nr03d0 U69 ( .A1(n160), .A2(n162), .A3(n161), .ZN(n384) );
  nr03d0 U70 ( .A1(n164), .A2(n166), .A3(n165), .ZN(n386) );
  nd02d1 U71 ( .A1(n389), .A2(n388), .ZN(rdata[1]) );
  nr03d0 U72 ( .A1(n170), .A2(n172), .A3(n171), .ZN(n390) );
  nr03d0 U73 ( .A1(n174), .A2(n176), .A3(n175), .ZN(n392) );
  nd02d1 U74 ( .A1(n395), .A2(n394), .ZN(rdata[2]) );
  nr03d0 U75 ( .A1(n190), .A2(n192), .A3(n191), .ZN(n396) );
  nr03d0 U76 ( .A1(n194), .A2(n196), .A3(n195), .ZN(n398) );
  nd02d1 U77 ( .A1(n401), .A2(n400), .ZN(rdata[4]) );
  nr03d0 U78 ( .A1(n210), .A2(n212), .A3(n211), .ZN(n402) );
  nr03d0 U79 ( .A1(n214), .A2(n216), .A3(n215), .ZN(n404) );
  nd02d1 U80 ( .A1(n407), .A2(n406), .ZN(rdata[6]) );
  nd03d0 U2 ( .A1(N49), .A2(N52), .A3(wen), .ZN(n133) );
  nd03d0 U3 ( .A1(N49), .A2(N53), .A3(wen), .ZN(n134) );
  nd03d0 U4 ( .A1(N49), .A2(N54), .A3(wen), .ZN(n135) );
  nd03d0 U5 ( .A1(N50), .A2(N52), .A3(wen), .ZN(n137) );
  nd03d0 U6 ( .A1(N50), .A2(N53), .A3(wen), .ZN(n138) );
  nd03d0 U7 ( .A1(N50), .A2(N54), .A3(wen), .ZN(n139) );
  nd03d0 U8 ( .A1(wen), .A2(N52), .A3(N48), .ZN(n129) );
  nd03d0 U11 ( .A1(wen), .A2(N53), .A3(N48), .ZN(n130) );
  nd03d0 U12 ( .A1(N54), .A2(wen), .A3(N48), .ZN(n131) );
  nd03d0 U13 ( .A1(wen), .A2(N52), .A3(N51), .ZN(n141) );
  nd03d0 U14 ( .A1(wen), .A2(N53), .A3(N51), .ZN(n142) );
  nd03d0 U15 ( .A1(N54), .A2(wen), .A3(N51), .ZN(n143) );
  nd03d0 U16 ( .A1(N49), .A2(N55), .A3(wen), .ZN(n136) );
  nd03d0 U17 ( .A1(N50), .A2(N55), .A3(wen), .ZN(n140) );
  nd03d0 U18 ( .A1(wen), .A2(N55), .A3(N48), .ZN(n132) );
  nd03d0 U19 ( .A1(wen), .A2(N55), .A3(N51), .ZN(n144) );
  aor21d1 U20 ( .B1(n168), .B2(n208), .A(raddr[3]), .Z(n219) );
  aor21d1 U21 ( .B1(n203), .B2(n402), .A(raddr[3]), .Z(n407) );
  aor21d1 U22 ( .B1(n199), .B2(n396), .A(raddr[3]), .Z(n401) );
  aor21d1 U23 ( .B1(n198), .B2(n390), .A(raddr[3]), .Z(n395) );
  aor21d1 U24 ( .B1(n197), .B2(n384), .A(raddr[3]), .Z(n389) );
  aor21d1 U30 ( .B1(n193), .B2(n378), .A(raddr[3]), .Z(n383) );
  aor21d1 U55 ( .B1(n207), .B2(n372), .A(raddr[3]), .Z(n377) );
  aor21d1 U130 ( .B1(n169), .B2(n231), .A(raddr[3]), .Z(n371) );
  inv0d0 U139 ( .I(waddr[3]), .ZN(n365) );
  inv0d0 U148 ( .I(waddr[2]), .ZN(n366) );
  nr02d0 U157 ( .A1(waddr[2]), .A2(waddr[3]), .ZN(N51) );
  inv0d0 U166 ( .I(waddr[1]), .ZN(n367) );
  inv0d0 U175 ( .I(waddr[0]), .ZN(n368) );
  nr02d0 U184 ( .A1(waddr[0]), .A2(waddr[1]), .ZN(N55) );
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


module sync_rst_0 ( clk, rst_n, atpg_mode, sync_rst_n );
  input clk, rst_n, atpg_mode;
  output sync_rst_n;
  wire   dff2, dff1;

  sdcrq1 dff1_reg ( .D(1'b1), .SD(1'b0), .SC(1'b0), .CP(clk), .CDN(rst_n), .Q(
        dff1) );
  sdcrq1 dff2_reg ( .D(dff1), .SD(1'b0), .SC(1'b0), .CP(clk), .CDN(rst_n), .Q(
        dff2) );
  mx02d1 U5 ( .I0(dff2), .I1(rst_n), .S(atpg_mode), .Z(sync_rst_n) );
endmodule


module async_fifo ( wclk, wrst_n, wen, wptr_clr, wdata, rclk, rrst_n, ren, 
        rptr_clr, near_full_mrgn, near_empty_mrgn, rdata, full, empty, 
        near_full, near_empty, over_flow, under_flow, test_si, test_so, 
        test_se, atpg_mode, test_mode );
  input [7:0] wdata;
  input [4:0] near_full_mrgn;
  input [4:0] near_empty_mrgn;
  output [7:0] rdata;
  input wclk, wrst_n, wen, wptr_clr, rclk, rrst_n, ren, rptr_clr, test_si,
         test_se, atpg_mode, test_mode;
  output full, empty, near_full, near_empty, over_flow, under_flow, test_so;
  wire   sync_wrst_n, sync_rrst_n, \wptr_full/N33 , \wptr_full/N25 ,
         \wptr_full/N19 , \wptr_full/N12 , \wptr_full/N11 , \wptr_full/N10 ,
         \wptr_full/N9 , \wptr_full/N8 , \wptr_full/N7 , \wptr_full/N6 ,
         \wptr_full/N5 , \wptr_full/N4 , \wptr_full/wbin[4] , \rptr_empty/N25 ,
         \rptr_empty/N16 , \rptr_empty/N15 , \rptr_empty/N12 ,
         \rptr_empty/N11 , \rptr_empty/N10 , \rptr_empty/N9 , \rptr_empty/N8 ,
         \rptr_empty/N7 , \rptr_empty/N6 , \rptr_empty/N5 , \rptr_empty/N4 ,
         \rptr_empty/rbin[4] , \intadd_0/B[2] , \intadd_0/B[1] ,
         \intadd_0/B[0] , \intadd_2/A[2] , \intadd_2/A[1] , \intadd_2/A[0] ,
         \intadd_2/B[2] , \intadd_2/B[1] , \intadd_2/B[0] , \intadd_2/CI ,
         \intadd_2/n3 , \intadd_2/n2 , \intadd_2/n1 , n77, n78, n79, n80, n81,
         n82, n84, n86, n87, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98,
         n99, n100, n102, n103, n105, n106, n109, n110, n111, n112, n113, n114,
         n115, n118, n119, n121, n122, n127, n128, n129, n130, n131, n132,
         n134, n135, n136, n137, n139, n140, n141, n142, n143, n144, n145,
         n146, n147, n148, n151, n152, n153, n154, n155, n156, n157, n159,
         n160, n161, n162, n163, n164, n165, n166, n167, n168, n169, n170,
         n171, n172, n173, n174, n175, n176, n178, n180, n181, n182, n183,
         n184, n185, n186, n187, n188, n189, n190, n191, n192, n193, n194,
         n195, n196, n197, n198, n199, n200, n201, n202, n203, n204, n205,
         n206, n207, n208, n209, n210, n211, n212, n213, n214, n215, n217,
         n218, n219, n220, n221, n222, n223, n224;
  wire   [4:0] sync_rptr;
  wire   [3:0] waddr;
  wire   [4:0] wptr;
  wire   [4:0] sync_wptr;
  wire   [3:0] raddr;
  wire   [4:0] rptr;
  assign \wptr_full/N25  = near_full_mrgn[0];

  sync_rst_1 sync_rst_w ( .clk(wclk), .rst_n(wrst_n), .atpg_mode(atpg_mode), 
        .sync_rst_n(sync_wrst_n) );
  sync_rst_0 sync_rst_r ( .clk(rclk), .rst_n(rrst_n), .atpg_mode(atpg_mode), 
        .sync_rst_n(sync_rrst_n) );
  sync_SIZE4_1 sync_r2w ( .clk(wclk), .rst_n(sync_wrst_n), .async_in({
        \rptr_empty/rbin[4] , rptr[3:0]}), .sync_out({n215, n214, 
        sync_rptr[2:0]}) );
  sync_SIZE4_0 sync_w2r ( .clk(rclk), .rst_n(sync_rrst_n), .async_in({
        \wptr_full/wbin[4] , wptr[3:0]}), .sync_out(sync_wptr) );
  dpram_ASIZE4_DSIZE8 fifo_mem ( .wclk(wclk), .rst_n(wrst_n), .wen(n219), 
        .waddr(waddr), .raddr(raddr), .wdata(wdata), .rdata(rdata) );
  sdcrq1 \wptr_full/wptr_reg[0]  ( .D(\wptr_full/N9 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(sync_wrst_n), .Q(wptr[0]) );
  sdcrq1 \wptr_full/wptr_reg[1]  ( .D(\wptr_full/N10 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(sync_wrst_n), .Q(wptr[1]) );
  sdcrq1 \wptr_full/wptr_reg[2]  ( .D(\wptr_full/N11 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(sync_wrst_n), .Q(wptr[2]) );
  sdcrq1 \wptr_full/wptr_reg[3]  ( .D(\wptr_full/N12 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(sync_wrst_n), .Q(wptr[3]) );
  sdcrq1 \wptr_full/wbin_reg[0]  ( .D(\wptr_full/N4 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(sync_wrst_n), .Q(waddr[0]) );
  sdcrq1 \wptr_full/wbin_reg[1]  ( .D(\wptr_full/N5 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(sync_wrst_n), .Q(waddr[1]) );
  sdcrq1 \wptr_full/wbin_reg[2]  ( .D(\wptr_full/N6 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(sync_wrst_n), .Q(waddr[2]) );
  sdcrq1 \wptr_full/wbin_reg[3]  ( .D(\wptr_full/N7 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(sync_wrst_n), .Q(waddr[3]) );
  sdcrq1 \wptr_full/wbin_reg[4]  ( .D(\wptr_full/N8 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(sync_wrst_n), .Q(\wptr_full/wbin[4] ) );
  sdcrq1 \rptr_empty/rptr_reg[0]  ( .D(\rptr_empty/N9 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .CDN(sync_rrst_n), .Q(rptr[0]) );
  sdcrq1 \rptr_empty/rptr_reg[1]  ( .D(\rptr_empty/N10 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .CDN(sync_rrst_n), .Q(rptr[1]) );
  sdcrq1 \rptr_empty/rptr_reg[2]  ( .D(\rptr_empty/N11 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .CDN(sync_rrst_n), .Q(rptr[2]) );
  sdcrq1 \rptr_empty/rptr_reg[3]  ( .D(\rptr_empty/N12 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .CDN(sync_rrst_n), .Q(rptr[3]) );
  sdcrq1 \rptr_empty/rbin_reg[3]  ( .D(\rptr_empty/N7 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .CDN(sync_rrst_n), .Q(raddr[3]) );
  sdcrq1 \rptr_empty/rbin_reg[4]  ( .D(\rptr_empty/N8 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .CDN(sync_rrst_n), .Q(\rptr_empty/rbin[4] ) );
  sdprb1 \rptr_empty/empty_reg  ( .D(\rptr_empty/N16 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .SDN(sync_rrst_n), .Q(empty), .QN(n213) );
  sdcrq1 R_0 ( .D(n217), .SD(1'b0), .SC(1'b0), .CP(wclk), .CDN(sync_wrst_n), 
        .Q(n218) );
  dfcrq1 R_1 ( .D(n215), .CP(wclk), .CDN(sync_wrst_n), .Q(sync_rptr[4]) );
  dfcrq1 R_2 ( .D(n214), .CP(wclk), .CDN(sync_wrst_n), .Q(sync_rptr[3]) );
  sdcrq1 \rptr_empty/near_empty_reg  ( .D(\rptr_empty/N25 ), .SD(1'b0), .SC(
        1'b0), .CP(rclk), .CDN(sync_rrst_n), .Q(near_empty) );
  sdcrq1 \rptr_empty/under_flow_reg  ( .D(\rptr_empty/N15 ), .SD(1'b0), .SC(
        1'b0), .CP(rclk), .CDN(sync_rrst_n), .Q(under_flow) );
  sdcrq1 \wptr_full/near_full_reg  ( .D(\wptr_full/N33 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(sync_wrst_n), .Q(near_full) );
  sdcrq1 \wptr_full/over_flow_reg  ( .D(n212), .SD(1'b0), .SC(1'b0), .CP(wclk), 
        .CDN(sync_wrst_n), .Q(over_flow) );
  sdcrq1 \wptr_full/full_reg  ( .D(\wptr_full/N19 ), .SD(1'b0), .SC(1'b0), 
        .CP(wclk), .CDN(sync_wrst_n), .Q(full) );
  ad01d0 \intadd_2/U4  ( .A(\intadd_2/B[0] ), .B(\intadd_2/A[0] ), .CI(
        \intadd_2/CI ), .CO(\intadd_2/n3 ), .S(\intadd_0/B[0] ) );
  ad01d0 \intadd_2/U3  ( .A(\intadd_2/B[1] ), .B(\intadd_2/A[1] ), .CI(
        \intadd_2/n3 ), .CO(\intadd_2/n2 ), .S(\intadd_0/B[1] ) );
  ad01d0 \intadd_2/U2  ( .A(\intadd_2/B[2] ), .B(\intadd_2/A[2] ), .CI(
        \intadd_2/n2 ), .CO(\intadd_2/n1 ), .S(\intadd_0/B[2] ) );
  sdcrq2 \rptr_empty/rbin_reg[0]  ( .D(\rptr_empty/N4 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .CDN(sync_rrst_n), .Q(raddr[0]) );
  sdcrq1 \rptr_empty/rbin_reg[2]  ( .D(\rptr_empty/N6 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .CDN(sync_rrst_n), .Q(raddr[2]) );
  sdcrq1 \rptr_empty/rbin_reg[1]  ( .D(\rptr_empty/N5 ), .SD(1'b0), .SC(1'b0), 
        .CP(rclk), .CDN(sync_rrst_n), .Q(raddr[1]) );
  nd02d1 U105 ( .A1(n152), .A2(n151), .ZN(n156) );
  an02d0 U106 ( .A1(n154), .A2(n153), .Z(n155) );
  inv0d0 U108 ( .I(waddr[1]), .ZN(n112) );
  inv0d1 U109 ( .I(wen), .ZN(n82) );
  inv0d0 U110 ( .I(wptr_clr), .ZN(n172) );
  inv0d0 U112 ( .I(n114), .ZN(n115) );
  buffd1 U113 ( .I(n109), .Z(n137) );
  nd02d1 U121 ( .A1(n132), .A2(n130), .ZN(n152) );
  nr02d0 U122 ( .A1(n176), .A2(n80), .ZN(n81) );
  an02d0 U126 ( .A1(n178), .A2(raddr[3]), .Z(n186) );
  an02d0 U127 ( .A1(n81), .A2(raddr[2]), .Z(n178) );
  cg01d0 U129 ( .A(n145), .B(n144), .CI(n143), .CO(n146) );
  inv0d0 U132 ( .I(rptr_clr), .ZN(n210) );
  inv0d0 U135 ( .I(n90), .ZN(n91) );
  an02d0 U136 ( .A1(n168), .A2(n172), .Z(\wptr_full/N19 ) );
  cg01d0 U137 ( .A(n202), .B(near_empty_mrgn[4]), .CI(n201), .CO(n203) );
  cg01d0 U138 ( .A(\intadd_0/B[2] ), .B(near_empty_mrgn[3]), .CI(n200), .CO(
        n201) );
  nd02d0 U140 ( .A1(n106), .A2(n105), .ZN(n142) );
  nr02d2 U141 ( .A1(full), .A2(n82), .ZN(n219) );
  inv0d0 U142 ( .I(sync_wptr[3]), .ZN(n77) );
  mx02d0 U143 ( .I0(n77), .I1(sync_wptr[3]), .S(sync_wptr[4]), .Z(
        \intadd_2/B[2] ) );
  inv0d0 U144 ( .I(\intadd_2/B[2] ), .ZN(n78) );
  mx02d0 U145 ( .I0(\intadd_2/B[2] ), .I1(n78), .S(sync_wptr[2]), .Z(
        \intadd_2/B[1] ) );
  inv0d0 U146 ( .I(\intadd_2/B[1] ), .ZN(n79) );
  mx02d0 U147 ( .I0(\intadd_2/B[1] ), .I1(n79), .S(sync_wptr[1]), .Z(
        \intadd_2/B[0] ) );
  nd03d0 U148 ( .A1(ren), .A2(raddr[0]), .A3(n213), .ZN(n176) );
  inv0d0 U149 ( .I(raddr[1]), .ZN(n80) );
  an02d0 U150 ( .A1(n176), .A2(n80), .Z(n184) );
  nr02d0 U151 ( .A1(n81), .A2(n184), .ZN(\intadd_2/A[0] ) );
  nr02d0 U152 ( .A1(n81), .A2(raddr[2]), .ZN(n182) );
  nr02d0 U153 ( .A1(n178), .A2(n182), .ZN(\intadd_2/A[1] ) );
  nr02d0 U154 ( .A1(n178), .A2(raddr[3]), .ZN(n180) );
  nr02d0 U155 ( .A1(n186), .A2(n180), .ZN(\intadd_2/A[2] ) );
  xr02d1 U158 ( .A1(n215), .A2(n214), .Z(n217) );
  nr02d0 U160 ( .A1(n219), .A2(waddr[0]), .ZN(n103) );
  nr02d0 U161 ( .A1(n84), .A2(n103), .ZN(n136) );
  an02d0 U162 ( .A1(n136), .A2(n172), .Z(\wptr_full/N4 ) );
  an02d0 U163 ( .A1(n94), .A2(n172), .Z(\wptr_full/N5 ) );
  an02d0 U166 ( .A1(n92), .A2(n172), .Z(\wptr_full/N6 ) );
  xr02d1 U168 ( .A1(n87), .A2(waddr[3]), .Z(n90) );
  nr02d0 U169 ( .A1(n90), .A2(wptr_clr), .ZN(\wptr_full/N7 ) );
  xn02d1 U170 ( .A1(n89), .A2(\wptr_full/wbin[4] ), .ZN(n93) );
  an02d0 U171 ( .A1(n93), .A2(n172), .Z(\wptr_full/N8 ) );
  xn02d1 U172 ( .A1(n93), .A2(n90), .ZN(n173) );
  xn02d1 U173 ( .A1(n173), .A2(sync_rptr[3]), .ZN(n100) );
  xn02d1 U174 ( .A1(n91), .A2(n92), .ZN(n174) );
  xn02d1 U175 ( .A1(n174), .A2(sync_rptr[2]), .ZN(n99) );
  xn02d1 U176 ( .A1(n92), .A2(n94), .ZN(n170) );
  xr02d1 U177 ( .A1(n170), .A2(sync_rptr[1]), .Z(n97) );
  xr02d1 U178 ( .A1(n93), .A2(sync_rptr[4]), .Z(n96) );
  xn02d1 U179 ( .A1(n94), .A2(n136), .ZN(n171) );
  xr02d1 U180 ( .A1(n171), .A2(sync_rptr[0]), .Z(n95) );
  nd03d0 U181 ( .A1(n97), .A2(n96), .A3(n95), .ZN(n98) );
  nr03d0 U182 ( .A1(n100), .A2(n99), .A3(n98), .ZN(n168) );
  nr02d0 U185 ( .A1(n157), .A2(near_full_mrgn[3]), .ZN(n102) );
  xr02d1 U186 ( .A1(n102), .A2(near_full_mrgn[4]), .Z(n167) );
  xn02d1 U187 ( .A1(n218), .A2(sync_rptr[2]), .ZN(n114) );
  xn02d1 U188 ( .A1(n114), .A2(sync_rptr[1]), .ZN(n113) );
  xn02d1 U189 ( .A1(n113), .A2(sync_rptr[0]), .ZN(n109) );
  xn02d1 U191 ( .A1(n113), .A2(waddr[1]), .ZN(n110) );
  nd02d1 U193 ( .A1(n142), .A2(n140), .ZN(n111) );
  nd02d0 U194 ( .A1(n137), .A2(n110), .ZN(n139) );
  nd02d0 U195 ( .A1(n111), .A2(n139), .ZN(n132) );
  nr02d0 U196 ( .A1(n113), .A2(n112), .ZN(n119) );
  xn02d1 U197 ( .A1(n115), .A2(waddr[2]), .ZN(n118) );
  nd02d0 U200 ( .A1(n119), .A2(n118), .ZN(n151) );
  xn02d1 U202 ( .A1(n218), .A2(waddr[3]), .ZN(n121) );
  nd12d0 U204 ( .A1(n122), .A2(n121), .ZN(n154) );
  xr03d1 U208 ( .A1(sync_rptr[4]), .A2(n127), .A3(\wptr_full/wbin[4] ), .Z(
        n128) );
  xr02d1 U209 ( .A1(n129), .A2(n128), .Z(n166) );
  nd02d0 U210 ( .A1(n151), .A2(n130), .ZN(n131) );
  xn02d1 U211 ( .A1(n132), .A2(n131), .ZN(n147) );
  nd02d0 U214 ( .A1(n157), .A2(n134), .ZN(n148) );
  aor21d1 U215 ( .B1(near_full_mrgn[1]), .B2(\wptr_full/N25 ), .A(n135), .Z(
        n145) );
  nd02d0 U217 ( .A1(n140), .A2(n139), .ZN(n141) );
  xn02d1 U218 ( .A1(n142), .A2(n141), .ZN(n143) );
  ora21d1 U219 ( .B1(n147), .B2(n148), .A(n146), .Z(n164) );
  xn02d1 U222 ( .A1(n156), .A2(n155), .ZN(n160) );
  nd02d1 U225 ( .A1(n160), .A2(n159), .ZN(n162) );
  nr02d0 U226 ( .A1(n160), .A2(n159), .ZN(n161) );
  oan211d1 U227 ( .C1(n164), .C2(n163), .B(n162), .A(n161), .ZN(n165) );
  cg01d1 U228 ( .A(n167), .B(n166), .CI(n165), .CO(n169) );
  nr03d0 U229 ( .A1(n169), .A2(n168), .A3(wptr_clr), .ZN(\wptr_full/N33 ) );
  nr02d0 U230 ( .A1(n170), .A2(wptr_clr), .ZN(\wptr_full/N10 ) );
  nr02d0 U231 ( .A1(n171), .A2(wptr_clr), .ZN(\wptr_full/N9 ) );
  an02d0 U232 ( .A1(n173), .A2(n172), .Z(\wptr_full/N12 ) );
  nr02d0 U233 ( .A1(n174), .A2(wptr_clr), .ZN(\wptr_full/N11 ) );
  inv0d0 U234 ( .I(\intadd_2/B[0] ), .ZN(n175) );
  mx02d0 U235 ( .I0(n175), .I1(\intadd_2/B[0] ), .S(sync_wptr[0]), .Z(n196) );
  aon211d1 U236 ( .C1(ren), .C2(n213), .B(raddr[0]), .A(n176), .ZN(n209) );
  nr02d0 U237 ( .A1(n196), .A2(n209), .ZN(\intadd_2/CI ) );
  inv0d0 U240 ( .I(sync_wptr[2]), .ZN(n181) );
  mx02d0 U241 ( .I0(\intadd_2/A[2] ), .I1(n180), .S(\intadd_2/A[1] ), .Z(n207)
         );
  mx02d0 U242 ( .I0(n181), .I1(sync_wptr[2]), .S(n207), .Z(n191) );
  inv0d0 U243 ( .I(sync_wptr[1]), .ZN(n183) );
  mx02d0 U244 ( .I0(\intadd_2/A[1] ), .I1(n182), .S(\intadd_2/A[0] ), .Z(n206)
         );
  mx02d0 U245 ( .I0(n183), .I1(sync_wptr[1]), .S(n206), .Z(n190) );
  inv0d0 U246 ( .I(sync_wptr[0]), .ZN(n185) );
  mx02d0 U247 ( .I0(n184), .I1(\intadd_2/A[0] ), .S(n209), .Z(n205) );
  mx02d0 U248 ( .I0(n185), .I1(sync_wptr[0]), .S(n205), .Z(n189) );
  inv0d0 U249 ( .I(sync_wptr[4]), .ZN(n188) );
  inv0d0 U250 ( .I(\rptr_empty/rbin[4] ), .ZN(n187) );
  mx02d0 U251 ( .I0(\rptr_empty/rbin[4] ), .I1(n187), .S(n186), .Z(n211) );
  mx02d0 U252 ( .I0(n188), .I1(sync_wptr[4]), .S(n211), .Z(n194) );
  nd04d0 U253 ( .A1(n191), .A2(n190), .A3(n189), .A4(n194), .ZN(n193) );
  nr02d0 U254 ( .A1(n208), .A2(sync_wptr[3]), .ZN(n192) );
  aor211d1 U255 ( .C1(n208), .C2(sync_wptr[3]), .A(n193), .B(n192), .Z(n204)
         );
  xr02d1 U256 ( .A1(n194), .A2(\intadd_2/n1 ), .Z(n202) );
  inv0d0 U257 ( .I(n209), .ZN(n197) );
  inv0d0 U258 ( .I(n196), .ZN(n195) );
  aor221d1 U259 ( .B1(n197), .B2(n196), .C1(n209), .C2(n195), .A(
        near_empty_mrgn[0]), .Z(n198) );
  ad01d0 U260 ( .A(\intadd_0/B[0] ), .B(near_empty_mrgn[1]), .CI(n198), .CO(
        n199) );
  ad01d0 U261 ( .A(\intadd_0/B[1] ), .B(near_empty_mrgn[2]), .CI(n199), .CO(
        n200) );
  an03d0 U262 ( .A1(n210), .A2(n204), .A3(n203), .Z(\rptr_empty/N25 ) );
  nr02d0 U263 ( .A1(rptr_clr), .A2(n204), .ZN(\rptr_empty/N16 ) );
  an03d0 U264 ( .A1(n210), .A2(empty), .A3(ren), .Z(\rptr_empty/N15 ) );
  an02d0 U265 ( .A1(n210), .A2(n205), .Z(\rptr_empty/N9 ) );
  an02d0 U266 ( .A1(n210), .A2(n206), .Z(\rptr_empty/N10 ) );
  an02d0 U267 ( .A1(n210), .A2(n207), .Z(\rptr_empty/N11 ) );
  nr02d0 U268 ( .A1(rptr_clr), .A2(n208), .ZN(\rptr_empty/N12 ) );
  nr02d0 U269 ( .A1(rptr_clr), .A2(n209), .ZN(\rptr_empty/N4 ) );
  an02d0 U270 ( .A1(n210), .A2(\intadd_2/A[0] ), .Z(\rptr_empty/N5 ) );
  an02d0 U271 ( .A1(n210), .A2(\intadd_2/A[1] ), .Z(\rptr_empty/N6 ) );
  an02d0 U272 ( .A1(n210), .A2(\intadd_2/A[2] ), .Z(\rptr_empty/N7 ) );
  an02d0 U273 ( .A1(n211), .A2(n210), .Z(\rptr_empty/N8 ) );
  nr03d0 U107 ( .A1(n82), .A2(wptr_clr), .A3(n220), .ZN(n212) );
  inv0d0 U111 ( .I(full), .ZN(n220) );
  xr02d1 U114 ( .A1(\rptr_empty/rbin[4] ), .A2(n221), .Z(n208) );
  nr02d0 U115 ( .A1(n178), .A2(raddr[3]), .ZN(n221) );
  inv0d0 U116 ( .I(n222), .ZN(n129) );
  inv0d0 U117 ( .I(n153), .ZN(n223) );
  aon211d1 U118 ( .C1(n152), .C2(n151), .B(n223), .A(n154), .ZN(n222) );
  an02d1 U119 ( .A1(n147), .A2(n148), .Z(n163) );
  nd12d0 U120 ( .A1(n218), .A2(waddr[3]), .ZN(n127) );
  xr02d1 U123 ( .A1(near_full_mrgn[3]), .A2(n157), .Z(n159) );
  nd12d0 U124 ( .A1(near_full_mrgn[2]), .A2(n135), .ZN(n157) );
  xr02d1 U125 ( .A1(waddr[1]), .A2(n84), .Z(n94) );
  inv0d0 U128 ( .I(n105), .ZN(n84) );
  nd02d0 U130 ( .A1(waddr[0]), .A2(n219), .ZN(n105) );
  nd12d0 U131 ( .A1(n87), .A2(waddr[3]), .ZN(n89) );
  nd02d0 U133 ( .A1(n86), .A2(waddr[2]), .ZN(n87) );
  oai211d1 U134 ( .C1(n137), .C2(n136), .A(\wptr_full/N25 ), .B(n224), .ZN(
        n144) );
  nd02d0 U139 ( .A1(n137), .A2(n136), .ZN(n224) );
  xr02d1 U156 ( .A1(waddr[2]), .A2(n86), .Z(n92) );
  nr02d0 U157 ( .A1(n105), .A2(n112), .ZN(n86) );
  nr02d0 U164 ( .A1(near_full_mrgn[1]), .A2(\wptr_full/N25 ), .ZN(n135) );
  nd12d0 U165 ( .A1(n121), .A2(n122), .ZN(n153) );
  nd02d0 U167 ( .A1(waddr[2]), .A2(n114), .ZN(n122) );
  nd12d0 U183 ( .A1(n135), .A2(near_full_mrgn[2]), .ZN(n134) );
  or02d1 U184 ( .A1(n119), .A2(n118), .Z(n130) );
  or02d1 U190 ( .A1(n109), .A2(n110), .Z(n140) );
  or02d1 U192 ( .A1(n109), .A2(n103), .Z(n106) );
endmodule

