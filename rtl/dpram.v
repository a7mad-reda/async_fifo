`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Project Name                 : Design of a Parametrizable, Configurable and Modular Asynchronous FIFO
// Engineer                     : Ahmad Reda
// Module  Name                 : dpram
// Module  Description          : FIFO dual port memory synchronous write asynchronous read
// Create  Date                 : 2021/9/18
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module dpram
        //--------------------- PARAMETERS ---------------------------------
        #(
         parameter                              ASIZE = 4               ,               // Number of address bits
         parameter                              DSIZE = 8                               // word width
        )
        //----------------------- PORTS ------------------------------------
        (
         input  wire                            wclk            ,
	 input  wire                            rst_n           ,
         input  wire                            wen             ,
         input  wire    [ASIZE - 1 : 0]         waddr           ,
         input  wire    [ASIZE - 1 : 0]         raddr           ,
         input  wire    [DSIZE - 1 : 0]         wdata           ,
         output wire     [DSIZE - 1 : 0]         rdata           
        );

        //---------------------- SIGNALS -----------------------------------
        localparam      DEPTH = 1 << ASIZE                                      ;       // 2^ASIZE
        reg             [DSIZE - 1 : 0]         mem             [0 : DEPTH - 1] ;
        wire                                    wdata_next                      ;
	integer					i				;


        //------------------------------------------------------------------
        // write data in FIFO memory synchronously
        //------------------------------------------------------------------
        always @(posedge wclk, negedge rst_n)

                if      (~rst_n)
			for (i=0; i < DEPTH; i=i+1)
				mem[i]  <= {DSIZE{1'b0}}				;

		else if	(wen)
                        mem[waddr]      <=      wdata                           ;

        //------------------------------------------------------------------
        // read data from FIFO memory asynchronously
        //------------------------------------------------------------------
	assign rdata = mem[raddr]						;

                
endmodule
