`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Project Name                 : Design of a Parametrizable, Configurable and Modular Asynchronous FIFO
// Engineer                     : Ahmad Reda
// Module  Name                 : rptr_empty
// Module  Description          : FIFO read pointer and empty flags generation
// Create  Date                 : 2021/9/16
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module rptr_empty
        //--------------------- PARAMETERS -----------------------------
        #(
         parameter                              ASIZE = 4
        )
        //----------------------- PORTS --------------------------------
        (
         input  wire                            rclk            ,
         input  wire                            rrst_n          ,
         input  wire                            rinc            ,
         input  wire                            rptr_clr        ,
         input  wire    [ASIZE  :0]             near_empty_mrgn ,
         input  wire    [ASIZE  :0]             sync_wptr       ,
         output reg                             empty           ,
         output reg                             near_empty      ,
         output reg                             under_flow      ,
         output wire    [ASIZE-1:0]             raddr           ,
         output reg     [ASIZE  :0]             rptr            
        );

        //----------------------- SIGNALS ------------------------------
        wire            [ASIZE:0]          	rbin_next, rgray_next           ;
        reg             [ASIZE:0]             	rbin                            ;
        reg             [ASIZE:0]             	bin_sync_wptr                   ;
        reg                                     near_empty_val                  ;
        wire                                    empty_val, under_flow_val       ;
        integer                                 i                               ;

        //------------------------------------------------------------------
        // generation of gray and binary read pointers
        // binary read pointer to address memory "raddr"
        // gray read pointer to be compare with write pointer "rptr"
        //------------------------------------------------------------------
        always @(posedge rclk or negedge rrst_n)
                if      (!rrst_n)
                        {rptr, rbin}    <=      {ASIZE+1{1'b0}}                 ;
                else if (rptr_clr)
                        {rptr, rbin}    <=      {ASIZE+1{1'b0}}                 ;
                else 
                        {rptr, rbin}    <=      {rgray_next, rbin_next}         ;

        assign rbin_next        =       rbin + (rinc && ~empty)                 ;
        assign rgray_next       =       (rbin_next >> 1) ^ rbin_next            ;       // bin2gray
        assign raddr            =       rbin[ASIZE-1:0]                         ;

        
        //------------------------------------------------------------------
        // gray to binary conversion
        // input : synchronized write pointer in gray "sync_ptr"
        //------------------------------------------------------------------
        generate
                always @*
                        for (i = 0; i <= ASIZE; i = i + 1)
                                begin : gray_bin
                                        bin_sync_wptr[i]        = ^(sync_wptr >> i)     ;
                                end
        endgenerate

        //------------------------------------------------------------------
        // generation of flags (under_flow, empty, near_empty)
        //------------------------------------------------------------------
        //------------------------------------------------------------------
        // underflow flag asserted when fifo empty and read pointer icreament asserted
        //------------------------------------------------------------------
        assign  under_flow_val = empty && rinc                                  ;

        always @(posedge rclk or negedge rrst_n)
                if      (!rrst_n)
                        under_flow      <=      1'b0                            ;
                else if (rptr_clr)
                        under_flow      <=      1'b0                            ;
                else
                        under_flow      <=      under_flow_val                  ;

        //------------------------------------------------------------------
        // empty flag asserted when read address = syncronized write address
        //------------------------------------------------------------------
        assign  empty_val = (rgray_next == sync_wptr)                           ;

        always @(posedge rclk or negedge rrst_n)
                if      (!rrst_n)
                        empty           <=      1'b1                            ;
                else if (rptr_clr)
                        empty           <=      1'b0                            ;
                else
                        empty           <=      empty_val                       ;

        //------------------------------------------------------------------
        // near_empty flag asserted when 
        //(syncronized write pointer - read pointer) <= near empty margin 
        //------------------------------------------------------------------
        always @*
                begin
                        near_empty_val = ~empty_val                                 	// prevent assertion of empty and near_empty at the same time
                        &&((bin_sync_wptr - rbin_next) <= (near_empty_mrgn))    ;       // term because check is done cycle before assertion
                end

        always @(posedge rclk or negedge rrst_n)
                if      (!rrst_n)
                        near_empty      <=      1'b0                            ;
                else if (rptr_clr)
                        near_empty      <=      1'b0                            ;
                else if (near_empty_val)
                        near_empty      <=      1'b1                            ;
                else
                        near_empty      <=      1'b0                            ;

endmodule


        
