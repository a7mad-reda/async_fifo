`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Project Name                 : Design of a Parametrizable, Configurable and Modular Asynchronous FIFO
// Engineer                     : Ahmad Reda
// Module  Name                 : fifo_mem
// Module  Description          : FIFO dual port memory
// Create  Date                 : 2021/9/18
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module fifo_mem
        //--------------------- PARAMETERS ---------------------------------
        #(
         parameter                              ASIZE = 4               ,               // Number of address bits
         parameter                              DSIZE = 8               ,               // word width
         parameter                              FALLTHROUGH = "TRUE"                    // TRUE => first word fall-through "async_read" else => sync_read
        )
        //----------------------- PORTS ------------------------------------
        (
         input  wire                            wclk            ,
         input  wire                            wen             ,
         input  wire    [ASIZE - 1 : 0]         waddr           ,
         input  wire                            rclk            ,
         input  wire                            ren             ,
         input  wire    [ASIZE - 1 : 0]         raddr           ,
         input  wire    [DSIZE - 1 : 0]         wdata           ,
         output reg     [DSIZE - 1 : 0]         rdata           
        );

        //---------------------- SIGNALS -----------------------------------
        localparam      DEPTH = 1 << ASIZE                                      ;       // 2^ASIZE
        reg             [DSIZE - 1 : 0]         mem             [0 : DEPTH - 1] ;
        wire                                    wdata_next                      ;


        //------------------------------------------------------------------
        // write data in FIFO memory synchronously
        //------------------------------------------------------------------
        always @(posedge wclk)
                if      (wen)
                        mem[waddr]      <=      wdata                           ;

        //------------------------------------------------------------------
        // read data from FIFO
        //------------------------------------------------------------------
        generate
                if      (FALLTHROUGH == "TRUE")
                        begin : asyncronous_read
                        always @*
                                if      (ren)
                                        rdata           =       mem[raddr]	;
				else
					rdata		=	{DSIZE{1'bz}}	;
                        end
                else
                        begin : synchronous_read        
                        always @(posedge rclk)
                                if      (ren)
                                        rdata           <=      mem[raddr]      ;
                        end
        endgenerate
                
endmodule
