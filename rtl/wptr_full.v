`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Project Name			: Design of a Parametrizable, Configurable and Modular Asynchronous FIFO
// Engineer 			: Ahmad Reda
// Module  Name			: wptr_full
// Module  Description		: FIFO write pointer and full flage generation
// Create  Date			: 2021/9/17
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module wptr_full
	//--------------------- PARAMETERS -----------------------------
	#(
	 parameter				ASIZE = 4
	)
	//----------------------- PORTS --------------------------------
	(
	 input	wire				wclk		,
	 input	wire				wrst_n		,
	 input	wire				winc		,
	 input	wire				wptr_clr	,
	 input	wire	[ASIZE :0]		near_full_mrgn	,
	 input	wire	[ASIZE :0]		sync_rptr	,
	 output	reg				full		,
	 output	reg				near_full	,
	 output reg				over_flow	,
	 output	wire	[ASIZE-1:0]		waddr		,
	 output	reg	[ASIZE  :0]		wptr		
	);

	//----------------------- SIGNALS ------------------------------
	wire		[ASIZE:0]		wbin_next, wgray_next		;
	reg		[ASIZE:0]		wbin				;
	reg		[ASIZE:0]		bin_sync_rptr			;
	wire					full_val, near_full_val		;
	wire					over_flow_val			;
	integer					i				;

	//-------------------------------------------------------------
	// generation of binary read memory address and gray pointer
	// binary to address memory "raddr"
	// gray to get syncrozied i read domin "rptr"
	//-------------------------------------------------------------
	always @(posedge wclk or negedge wrst_n)
		if	(!wrst_n)
			{wptr, wbin}	<=	{ASIZE+1{1'b0}}			;
		else if	(wptr_clr)
			{wptr, wbin}	<=	{ASIZE+1{1'b0}}			;
		else
			{wptr, wbin}	<=	{wgray_next, wbin_next}		;

	assign wbin_next	=	wbin + (winc && ~full)				;
	assign wgray_next	=	(wbin_next >> 1) ^ wbin_next		;	// bin2gray
	assign waddr		=	wbin[ASIZE-1 :  0]			;

	//---------------------------------------------------------------
	// BINARY TO GRAY CONVERSION
	// INPUT: synchronized read pointer in gray
	// OUTPUT: synchronized read address in binary
	//---------------------------------------------------------------
	generate
		always @*
			for (i = 0; i <= ASIZE; i = i + 1)
				begin : gray_bin
					bin_sync_rptr[i] = ^(sync_rptr >> i)	;
				end
	endgenerate

	//---------------------------------------------------------------
	// FULL FLAGS GENERATION (over_flow, full, near_full)
	//---------------------------------------------------------------
	//---------------------------------------------------------------
	// overflow if FIFO full and write increment signal asserted
	//---------------------------------------------------------------
	assign over_flow_val	=	full && winc				;
	always @(posedge wclk or negedge wrst_n)
		if	(!wrst_n)
			over_flow		<=	1'b0			;
		else if	(wptr_clr)
			over_flow		<=	1'b0			;
		else
			over_flow		<=	over_flow_val		;

	//---------------------------------------------------------------
	// full if read and write pointer pass three necessary conditions "IN GRAY"
	// write pointer [MSB]       != read pointer [MSB]
	// write pointer [MSB-1]     != read pointer [MSB-1]
	// write pointer [MSB-2 : 0] == read pointer [MSB-2 : 0]
	//---------------------------------------------------------------
	assign full_val	= (wgray_next[ASIZE] != sync_rptr[ASIZE]) &&
			  (wgray_next[ASIZE-1] != sync_rptr[ASIZE-1]) &&
			  (wgray_next[ASIZE-2 : 0] == sync_rptr[ASIZE-2 : 0])	;

	always @(posedge wclk or negedge wrst_n)
		if	(!wrst_n)
			full	<=	1'b0					;
		else if	(wptr_clr)
			full	<=	1'b0					;
		else
			full	<=	full_val				;

	//---------------------------------------------------------------
	// near_full under certain condition " IN BINARY "
	// wirte address - read address = total address size - near full margin
	//---------------------------------------------------------------
	assign near_full_val =	~full_val &&						// prevent assertion of empty and near_empty at the same time
				((wbin_next - bin_sync_rptr) >=
				(({(ASIZE){1'b1}} + 1'b1) - (near_full_mrgn))) 	;	// 1'b1 term because {(ASIZE){1'b1}} = no. locations - 1

				
	always @(posedge wclk or negedge wrst_n)
		if	(!wrst_n)
			near_full	<=	1'b0				;
		else if	(wptr_clr)
			near_full	<=	1'b0				;
		else if	(near_full_val)
			near_full	<=	1'b1				;
		else
			near_full	<=	1'b0				;

endmodule

