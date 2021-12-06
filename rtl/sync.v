`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Project Name			: Design of a Parametrizable, Configurable and Modular Asynchronous FIFO
// Engineer 			: Ahmad Reda
// Module  Name			: sync
// Module  Description		: Double flip flop synchronization scheme
// Create  Date			: 2021/9/18
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module sync
	//--------------------- PARAMETERS -----------------------------
	#(
	 parameter				SIZE = 4
	)
	//----------------------- PORTS --------------------------------
	(
	 input	wire 				clk		,
	 input	wire				rst_n		,
	 input	wire	[SIZE:0]		async_in	,
	 output	reg	[SIZE:0]		sync_out	
	);



	//----------------------- SIGNALS ------------------------------
	reg		[SIZE:0] 		temp		;

	//--------------------------------------------------------------
	// Douple flip flop synchronoziation scheme
	//--------------------------------------------------------------
	always @(posedge clk or negedge rst_n)
		if (!rst_n)
			{sync_out, temp} <= {SIZE{1'b0}}	;
		else
			{sync_out, temp} <= {temp, async_in}	;

endmodule
