`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Project Name			: Design of a Parametrizable, Configurable and Modular Asynchronous FIFO
// Engineer 			: Ahmad Reda
// Module  Name			: async_fifo
// Module  Description		: top level module of fifo
// Create  Date			: 2021/9/19
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module	async_fifo
	//------------------------- PARAMETERS -------------------------------
	#(
	 parameter				DSIZE 		= 8	,	// word width
	 parameter				ASIZE		= 4	 	// Number of address bits
	)
	//---------------------------- PORTS ---------------------------------
	(
	 input	wire				wclk			,
	 input	wire				wrst_n			,
	 input	wire				wen			,
	 input	wire				wptr_clr		,
	 input	wire	[DSIZE-1 : 0]		wdata			,
	 input	wire				rclk			,
	 input	wire				rrst_n			,
	 input	wire				ren			,
	 input	wire				rptr_clr		,
	 input	wire	[ASIZE	 : 0]		near_full_mrgn		,
	 input	wire	[ASIZE	 : 0]		near_empty_mrgn		,
	 output	wire	[DSIZE-1 : 0]		rdata			,
	 output wire				full			,
	 output wire				empty			,
	 output wire				near_full		,
	 output wire				near_empty		,
	 output wire				over_flow		,
	 output	wire				under_flow		,
	 input	wire				test_si			, 
	 output	wire				test_so			,
	 input	wire				test_se, atpg_mode	,
	 input	wire				test_mode				
	);

	//--------------------------- SIGNALS ---------------------------------
	wire		[ASIZE	 : 0]		rptr, wptr				;
	wire		[ASIZE	 : 0]		sync_wptr, sync_rptr			;
	wire		[ASIZE-1 : 0]		raddr, waddr				;
	wire					mem_wr, mem_rd				;
	wire					sync_wrst_n, sync_rrst_n		;

	//---------------------------------------------------------------------
	// instantiation of reset synchronization modules
	//---------------------------------------------------------------------
	sync_rst	sync_rst_w
		(
			.clk			(wclk			),
			.rst_n			(wrst_n			),
			.sync_rst_n		(sync_wrst_n		),
			.atpg_mode		(atpg_mode		)
		);

	sync_rst	sync_rst_r
		(
			.clk			(rclk			),
			.rst_n			(rrst_n			),
			.sync_rst_n		(sync_rrst_n		),
			.atpg_mode		(atpg_mode		)
		);

	//---------------------------------------------------------------------
	// instantiation of module generating write pointer and full flags
	//---------------------------------------------------------------------
	wptr_full
		#(
			ASIZE
		)
	wptr_full
		(
			.wclk			(wclk			),
			.wrst_n			(sync_wrst_n		),
			.winc			(wen			),
			.wptr_clr		(wptr_clr		),
			.near_full_mrgn		(near_full_mrgn		),
			.sync_rptr		(sync_rptr		),
			.full			(full			),
			.near_full		(near_full		),
			.over_flow		(over_flow		),
			.waddr			(waddr			),
			.wptr			(wptr			)		
		);

	//---------------------------------------------------------------------
	// instantiation of module generating read pointer and empty flags
	//---------------------------------------------------------------------
	rptr_empty
		#(
			ASIZE
		)
	rptr_empty
		(
			.rclk			(rclk			),
			.rrst_n			(sync_rrst_n		),
			.rinc			(ren			),
			.rptr_clr		(rptr_clr		),
			.near_empty_mrgn	(near_empty_mrgn	),
			.sync_wptr		(sync_wptr		),
			.empty			(empty			),
			.near_empty		(near_empty		),
			.under_flow		(under_flow		),
			.raddr			(raddr			),
			.rptr			(rptr			)	
		);
			
	//---------------------------------------------------------------------
	// instantiation of syncronizer
	// syncronize read data to write domain
	//---------------------------------------------------------------------
	sync
		#(
			ASIZE
		)
	sync_r2w
		(
			.clk			(wclk			),
			.rst_n			(sync_wrst_n			),
			.async_in		(rptr			),
			.sync_out		(sync_rptr		)	
		);
		

	//---------------------------------------------------------------------
	// instantiation of syncronizer
	// syncronize write data to read domain
	//---------------------------------------------------------------------
	sync
		#(
			ASIZE
		)
	sync_w2r
		(
			.clk			(rclk			),
			.rst_n			(sync_rrst_n			),
			.async_in		(wptr			),
			.sync_out		(sync_wptr		)	
		);
	
	assign	mem_wr		=		wen && ~full		;
	assign	mem_rd		=		ren && ~empty		;
	//---------------------------------------------------------------------
	// instaniation of fifo memory
	// dual port synchronous write asynchronous read
	//---------------------------------------------------------------------
	dpram
		#(
			.ASIZE 			(ASIZE			),				
			.DSIZE			(DSIZE			)										
		)
	fifo_mem
		(
			.wclk			(wclk			),
			.rst_n			(wrst_n			),
			.wen			(mem_wr			),
			.waddr			(waddr			),
			.raddr			(raddr			),
			.wdata			(wdata			),
			.rdata			(rdata			)
	);

endmodule
		
		
