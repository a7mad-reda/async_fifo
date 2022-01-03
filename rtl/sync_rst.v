`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Project Name			: Design of a Parametrizable, Configurable and Modular Asynchronous FIFO
// Engineer 			: Ahmad Reda
// Module  Name			: sync_rst
// Module  Description		: Double flip flop synchronization scheme for asynchronous reset
// Create  Date			: 2021/12/18
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module sync_rst
	// -------------------- Ports -----------------------
	(
	 input	wire		clk		,
	 input	wire		rst_n		,
	 input	wire		atpg_mode	,		// Test Mode
	 output	wire		sync_rst_n	
	);

	reg 	dff1, dff2		;

	// --------------------------------------------------
	// douple synchronization scheme
	// --------------------------------------------------
	always @(posedge clk, negedge rst_n)
	if (~rst_n)
	begin
		dff1	<=	1'b0	;
		dff2	<=	1'b0	;
	end
	else
	begin
		dff1	<=	1'b1	;
		dff2	<=	dff1	;
	end	
	
	// --------------------------------------------------
	// multiplexing output for DFT
	// --------------------------------------------------
	assign	sync_rst_n = atpg_mode ? rst_n : dff2 ;

endmodule
