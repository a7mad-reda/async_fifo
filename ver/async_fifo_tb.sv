`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Project Name			: Design of a Parametrizable, Configurable and Modular Asynchronous FIFO
// Engineer 			: Ahmad Reda
// Module  Name			: async_fifo
// Module  Description		: testbench of FIFO top level module
// Create  Date			: 2021/9/20
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module	async_fifo_tb
	(
	);

	//------------------------- PARAMETERS -------------------------------
	parameter				DSIZE 		= 8		;	// word width
	parameter				ASIZE		= 4		;	// Number of address bits
	parameter				DEPTH		= 1<<ASIZE	;	// memory depth
	parameter				FALLTHROUGH 	= "TRUE"	;	// TRUE => first word fall-through "async_read" else => sync_read
	parameter				WCLK_PERIOD	= 5		;
	parameter				RCLK_PERIOD	= 7		;
	parameter				clk_phase_shift	= 1		;
	parameter				hold		= 1		;	// min duration after clk active edge
	parameter 				max_latency	= 2*RCLK_PERIOD	;
											
	//-------------------------- SIGNALS ---------------------------------
	reg					wclk				;
	reg					wrst_n				;
	reg					wen				;
	reg					wptr_clr			;
	reg	[DSIZE-1 : 0]			wdata				;
	reg					rclk				;
	reg					rrst_n				;
	reg					ren				;
	reg					rptr_clr			;
	reg	[ASIZE	 : 0]			near_full_mrgn			;
	reg	[ASIZE	 : 0]			near_empty_mrgn			;
	wire	[DSIZE-1 : 0]			rdata				;
	wire					full				;
	wire					empty				;
	wire					near_full			;
	wire					near_empty			;
	wire					over_flow			;
	wire					under_flow			;

	//------------------- generated random data ---------------------------
	reg	[DSIZE-1 : 0]			randwr_data			;


	//----------------- for read and write files ---------------------------
	parameter	write_file = "../ver/ver_data/write_file.txt"	;
	parameter	read_file  = "../ver/ver_data/read_file.txt"	;
	integer		write_file_id, 	read_file_id				;
	reg	[DSIZE-1 : 0]			wr_file_array	[DEPTH-1 : 0]	;
	reg	[DSIZE-1 : 0]			rd_file_array	[DEPTH-1 : 0]	;
	
	//--------------------- test end flags ---------------------------------
	reg					test1, test2, test3,tm		;	

	//--------------------- disabel scan mode ------------------------------
	reg					tm				;				

	//--------------------------------------------------------------------
	// instantiation of Asynchronous FIFO top module
	//--------------------------------------------------------------------
	async_fifo
		//------------------------- PARAMETERS -------------------------------
		#(	
		 .DSIZE 			(DSIZE			),
		 .ASIZE 			(ASIZE			)
		) DUT
		//--------------------------- PORTS ----------------------------------
		(
		 .wclk 				(wclk			),
		 .wrst_n 			(wrst_n			),
		 .wen	 			(wen			),
		 .wptr_clr 			(wptr_clr		),
		 .wdata	 			(wdata			),
		 .rclk	 			(rclk			),
		 .rrst_n 			(rrst_n 		),
		 .ren	 			(ren			),
		 .rptr_clr 			(rptr_clr		),
		 .near_full_mrgn 		(near_full_mrgn		),
		 .near_empty_mrgn 		(near_empty_mrgn	),
		 .rdata	 			(rdata			),
		 .full	 			(full			),
		 .empty	 			(empty			),
		 .near_full 			(near_full		),
		 .near_empty 			(near_empty		),
		 .over_flow 			(over_flow		),
		 .under_flow 			(under_flow		),
		 .test_si 			(			),
		 .test_so	 		(			),
		 .test_se	 		(			),
		 .test_mode	 		(			),
		 .atpg_mode	 		(1'b0			)
		);


	//-------------------------------------------------------------------------------------
	// TEST 1 => SIMPLE TEST MODE " write then read "
	//-------------------------------------------------------------------------------------
	initial
		begin
			$display("//----------------------------------------------------------");
			$display("		TEST 1 => SIMPLE TEST MODE	  	      ");
			$display("//----------------------------------------------------------");

			$display("*** FIFO BLOCK INITIALIZATION ***")				;
			fifo_initialization							;	// fifo initialized at empty state
			write_data(DEPTH/2)							;	// but both pointer are in the midlle of count range
			read_data(DEPTH/2)							;	// error prone :o
			$display("*** TEST SIGNALS WHILE FIFO IS EMPTY ***")			;
			@(posedge rclk)			
			#hold
			check("full"	   , full		, 0)				;
			check("empty"	   , empty		, 1)				;
			check("over_flow"  , over_flow		, 0)				;
			check("under_flow" , under_flow		, 0)				;

			$display("*** apply read to fifo ***")					;
			@(posedge rclk)	#hold	ren	 =	 1				;
			$display("*** TEST UNDERFLOW CORNER ***")				;
			@(posedge rclk)	
			#hold	
			ren	 =	 0							;	
			check("full"	   , full		, 0)				;
			check("empty"	   , empty		, 1)				;
			check("over_flow"  , over_flow		, 0)				;
			check("under_flow" , under_flow		, 1)				;
			check("near_full"  , near_full		, 0)				;
			check("near_empty" , near_empty		, 0)				;
			
			$display("*** WRITING ALL MEMORRY LOCATIONS ***")			;
			write_data(DEPTH)							;
			$display("*** TEST SIGNALS WHILE FIFO IS FULL ***")			;			
			#(max_latency)
			check("full"	   , full		, 1)				;
			check("empty"	   , empty		, 0)				;
			check("over_flow"  , over_flow		, 0)				;
			check("under_flow" , under_flow		, 0)				;

			$display("*** apply write to fifo ***")					;
			@(posedge wclk)	#hold	wen	 =	 1				;
			$display("*** TEST OVERFLOW CORNER ***")				;
			@(posedge wclk)		
			#hold	
			wen	 =	 0							;
			check("full"	   , full		, 1)				;
			check("empty"	   , empty		, 0)				;
			check("over_flow"  , over_flow		, 1)				;
			check("under_flow" , under_flow		, 0)				;
			check("near_full"  , near_full		, 0)				;
			check("near_empty" , near_empty		, 0)				;

			$display("*** READING ALL MEMORRY LOCATIONS ***")			;
			read_data(DEPTH)							;
			$display("*** TEST SIGNALS WHILE FIFO IS EMPTY ***")			;
			@(posedge rclk)			
			#(max_latency)
			check("full"	   , full		, 0)				;
			check("empty"	   , empty		, 1)				;
			check("over_flow"  , over_flow		, 0)				;
			check("under_flow" , under_flow		, 0)				;
			
			$display("*** COMPARING READ AND WRITE DATA ***")			;
			match_data								;

			test1	=	1							;
		end

	//-------------------------------------------------------------------------------------
	// TEST 2 => TYPICAL TEST MODE " write and read simuLtaneously " in parallel
	//-------------------------------------------------------------------------------------
	initial
		begin
			wait(test1 == 1)
			$display("//----------------------------------------------------------");
			$display("		TEST 2 => TYPICAL TEST MODE	  	      ");
			$display("//----------------------------------------------------------");
			
			$display("*** write and read simuLtaneously ***")			;

			fork
				write_data(DEPTH)						;
				read_data(DEPTH)						;
			join
			
			$display("*** COMPARING READ AND WRITE DATA ***")			;
			#hold
			match_data								;
			$display("*** TEST SIGNALS WHILE FIFO IS EMPTY ***")			;			
			#(max_latency)
			check("full"	   , full		, 0)				;
			check("empty"	   , empty		, 1)				;
			check("over_flow"  , over_flow		, 0)				;
			check("under_flow" , under_flow		, 0)				;
			check("near_full"  , near_full		, 0)				;
			check("near_empty" , near_empty		, 0)				;

			test2	=	1							;
		end

	//-------------------------------------------------------------------------------------
	// TEST 3 => TEST OF RE-COUFIGURABILITY AT RUN TIME " changing flags margin at run time "
	//-------------------------------------------------------------------------------------
	initial
		begin
			wait(test2 == 1)
			$display("//----------------------------------------------------------");
			$display("	    TEST OF RE-COUFIGURABILITY AT RUN TIME	      ");
			$display("//----------------------------------------------------------");
			
			$display("*** write 1 memory location ***")				;
			write_data(1)								;
			$display("*** check first corner for near_empty flag ***")		;
			@(posedge rclk)
			#(max_latency)
			#hold
			check("near_full"  , near_full		, 0)				;
			check("near_empty" , near_empty		, 1)				;

			$display("*** default empty margin is 4 ***")				;
			$display("*** write 3 memory locations ***")				;
			write_data(3)								;
			$display("*** check last corner for near_empty flag ***")		;
			@(posedge rclk)
			#(max_latency)
			check("near_full"  , near_full		, 0)				;
			check("near_empty" , near_empty		, 1)				;

			$display("*** change empty margin to 6 'change corner posistion' ***")	;
			near_empty_mrgn = 6							;
			#(max_latency)
			#hold
			check("near_full"  , near_full		, 0)				;
			check("near_empty" , near_empty		, 1)				;
			
			$display("*** write 2 memory locations ***")				;
			write_data(2)								;
			$display("*** check the new corner of near empty flag ***")		;
			@(posedge rclk)
			#(max_latency)
			#hold
			check("near_full"  , near_full		, 0)				;
			check("near_empty" , near_empty		, 1)				;

			$display("*** write 1 memory location ***")				;
			write_data(1)								;
			$display("*** check deassertion of near_empty flag ***")		;
			@(posedge rclk)
			#(max_latency)
			#hold
			check("near_full"  , near_full		, 0)				;
			check("near_empty" , near_empty		, 0)				;
		
			$display("*** write (Depth -ful_margin -7) memory location ***")	;
			write_data(DEPTH-11)							;
			$display("*** check first corner for near_full flag ***")		;
			@(posedge wclk)
			#(max_latency)
			#hold
			check("near_full"  , near_full		, 1)				;
			check("near_empty" , near_empty		, 0)				;

			$display("*** change full margin to 3'change corner posistion' ***")	;
			near_full_mrgn = 3							;
			#(max_latency)
			$display("*** check deassertion of near_full flag ***")		;
			#hold
			check("near_full"  , near_full		, 0)				;
			check("near_empty" , near_empty		, 0)				;
			
			$display("*** write 3 memory locations ***")				;
			write_data(3)								;
			$display("*** check the last corner of near full flag ***")		;
			@(posedge wclk)
			#(max_latency)
			#hold
			check("near_full"  , near_full		, 1)				;
			check("near_empty" , near_empty		, 0)				;

			$display("*** write 1 memory location ***")				;
			write_data(1)								;
			$display("*** check deassertion of near_full flag ***")			;
			@(posedge wclk)
			#(max_latency)
			#hold
			check("near_full"  , near_full		, 0)				;
			check("near_empty" , near_empty		, 0)				;
		
			test3	=	1							;
			$display("*** FUNCTIONAL VERIFICATION DONE SUCCESSFULLY ***")		;
			$finish									;
		end



	//-------------------------------------------------------------------------------------
	// write clock generation
	//-------------------------------------------------------------------------------------
	initial
		begin
			wclk	=	1'b1							;
			forever	#(WCLK_PERIOD / 2)
			wclk	=	~wclk							;
		end

	//-------------------------------------------------------------------------------------
	// read clock generation
	//-------------------------------------------------------------------------------------
	initial
		begin
			rclk	=	1'b1							;
			#clk_phase_shift
			forever	#(RCLK_PERIOD / 2)
			rclk	=	~rclk							;
		end

	//-------------------------------------------------------------------------------------
	// task to intialize asyncronous fifo for verification
	//-------------------------------------------------------------------------------------
	task fifo_initialization								;
		begin
			open_wr_file								;
			open_rd_file								;
			{test1, test2, test3}	=	1'b0					;
			
			wrst_n		=	1						;
			rrst_n		=	1						;

			wptr_clr	=	0						;
			rptr_clr	=	0						;
			
			wen		=	0						;
			ren		=	0						;
	
			near_full_mrgn	=	4						;
			near_empty_mrgn	=	4						;
			
			wrst_n		=	0						;
			rrst_n		=	0						;
		
			#500
			wrst_n		=	1						;
			rrst_n		=	1						;
	
			#500									;			
		end

	endtask

	//--------------------------------------------------------------------------------------
	// task to write random data into FIFO memory and random write file
	//--------------------------------------------------------------------------------------
	task 	write_data;
		input	integer			wlength						;
		integer				i						;
		begin
			for	(i = 0; i < wlength; i = i + 1)	
				@(posedge wclk)
					begin
						#hold
						wait(!full)					;
						wen		= 	1'b1			;
						randwr_data	=	$random()		;
						wdata		=	randwr_data		;
						$fwrite(write_file_id, "%d\n", randwr_data)	;
					end

			@(posedge wclk) 
				#hold  								
				begin
					wen	= 	1'b0					;
					wdata	=	0					;
				end								;
		end
	endtask

	//---------------------------------------------------------------------------------------
	// task to read data from FIFO memory and write it to read file "asynchronously"
	//---------------------------------------------------------------------------------------
	task	read_data;
		input	integer			rlength						;
		integer				i						;
		begin
			for	(i = 0; i < rlength; i = i + 1)
				begin
					@(posedge rclk)
					#hold
					ren	=	1'b0			 		;
					wait(!empty)						;
					ren	=	1'b1					;
					@(negedge rclk)							 //read at half of the cycle #safe shold & safe setup
					$fwrite(read_file_id, "%d\n", rdata)			;
				end
	
			@(negedge rclk)									//disable reading before next active edge
				ren	=	1'b0						;
		end
	endtask

	//---------------------------------------------------------------------------------------
	// task to compare read data with random written data
	//---------------------------------------------------------------------------------------
	task	match_data;
		$readmemb("../ver/ver_data/write_file.txt", wr_file_array)			;
		$readmemb("../ver/ver_data/read_file.txt", rd_file_array)			;

		if (wr_file_array === rd_file_array)
			$display(" ---> correct data matching")					;
		else
			begin
				$display("DATA MATCHING VIOLATION at time = %0d", $time)	;
				$finish								;
			end
	endtask

	//---------------------------------------------------------------------------------------
	// task to check correctness of current state of specific flag
	//---------------------------------------------------------------------------------------
	task	check										;
		input	string			flag_name					;
		input				flag_value					;
		input				expected_value					;	
		begin
			if (flag_value == expected_value) 
			$display(" ---> ", flag_name," flag works as expected")			; 
		else
			begin
			$display(flag_name," FLAG WORKS IN A WRONG WAY at time = %0d", $time)	; 
			$finish									; 
			end
		end
	endtask


	//---------------------------------------------------------------------------------------
	// task open read file
	//---------------------------------------------------------------------------------------
	task	open_rd_file									;
		begin
			read_file_id = $fopen(read_file)					;
			if (!read_file_id)
				$display("ERROR: can't open %s file", read_file)		;
		end
	endtask


	//---------------------------------------------------------------------------------------
	// task open write file
	//---------------------------------------------------------------------------------------
	task	open_wr_file									;
		begin
			write_file_id = $fopen(write_file)					;
			if (!write_file_id)
				$display("ERROR: can't open %s file", write_file)		;
		end
	endtask



endmodule
