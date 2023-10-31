`timescale 1ns/10ps
`define CYCLE_TIME 10.0

module asy_FIFO_tb();
	reg rst_n;
	
	reg wr_clk;
	reg rd_clk;
   reg wr_en, rd_en;

   wire fifo_full, fifo_empty;

	reg [15 : 0] wr_data;
   wire[15 : 0] rd_data;
	wire wr_clk_skew;
	
	   //reset
   initial begin
      wr_clk  = 0 ;
      rd_clk  = 0 ;
      rst_n      = 0 ;
      #50 rst_n  = 1 ;
   end


   parameter CYCLE_WR = 40 ;
   always #(CYCLE_WR/4) rd_clk = ~rd_clk ;//rd quick than wr
	//always #(CYCLE_WR) rd_clk = ~rd_clk ;//rd slower than wd
   always #(CYCLE_WR/2) wr_clk = ~wr_clk ;
	
	assign #5 wr_clk_skew = wr_clk;
	
   //data generate
   initial begin
      wr_data       = 16'd1000 ;
      wr_en    = 0 ;
      wait (rst_n) ;
      
		//wr * 3 and rd * 2
      repeat(3) begin
         @(negedge wr_clk_skew) ;
         wr_en = 1'b1 ;
         wr_data    = {$random()} % 16;
      end
      @(negedge wr_clk_skew) wr_en = 1'b0 ;

     
	   repeat(2) begin
         @(negedge rd_clk) ;
         rd_en = 1'b1 ;
      end
		@(negedge rd_clk) rd_en = 1'b0 ;
	
      #80;
      rst_n = 0 ;
      #10 rst_n = 1 ;
	
      repeat(100) begin
         @(negedge wr_clk_skew) ;
         wr_en = 1'b1 ;
         wr_data    = {$random()} % 16;
			rd_en = 1'b1;
      end

   end
   
	
	asy_FIFO 
	#( .WIDTH	(16),
		.DEPTH	(32))
	FIFO_inst
	(
		.rst_n(rst_n),
	//read
		.rd_clk(rd_clk),
		.rd_en(rd_en),
		.rd_data(rd_data),
		.fifo_empty(fifo_empty),
	//write
		.wr_clk(wr_clk_skew),
		.wr_en(wr_en),
		.wr_data(wr_data),
		.fifo_full(fifo_full)
	);


endmodule 

