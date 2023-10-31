module asy_FIFO 
#(	parameter WIDTH = 16,
	parameter DEPTH = 32
	)
(
	rst_n,
//read
	rd_clk,
	rd_en,
	rd_data,
	fifo_empty,
//write
	wr_clk,
	wr_en,
	wr_data,
	fifo_full
);

input  rst_n;
//read
input rd_clk;
input rd_en;
output reg[WIDTH - 1 : 0]rd_data;
output reg fifo_empty;
//write
input wr_clk;
input wr_en;
input [WIDTH - 1 : 0]wr_data;
output reg fifo_full;


reg [$clog2(DEPTH) : 0] wr_ptr, rd_ptr;
reg [WIDTH - 1 : 0] MEM[DEPTH - 1 : 0];


//gray code
reg [$clog2(DEPTH) : 0] wr_ptr_gr0, rd_ptr_gr0; //same clk domain
//2FF delay CDC
reg [$clog2(DEPTH) : 0] wr_ptr_gr1, wr_ptr_gr2, rd_ptr_gr1, rd_ptr_gr2; //To another clk domain

integer i;

//ptr
always @(posedge wr_clk, negedge rst_n)begin
	if(~rst_n)
		wr_ptr <= 0;
	else begin
		if(wr_en && ~fifo_full)
			wr_ptr <= wr_ptr + 1;
		else
			wr_ptr <= wr_ptr;
	end
end

always @(posedge rd_clk, negedge rst_n)begin
	if(~rst_n)
		rd_ptr <= 0;
	else begin
		if(rd_en && ~fifo_empty)
			rd_ptr <= rd_ptr + 1;
		else
			rd_ptr <= rd_ptr;
	end
end

//write data
always @(posedge wr_clk, negedge rst_n)begin
	if(~rst_n)begin
		for(i = 0 ;i<DEPTH;i=i+1 )begin
			MEM[i] <= 0;
		end
	end
	else begin
		if(wr_en && ~fifo_full)
			MEM[wr_ptr] <= wr_data;
		else 
			MEM[wr_ptr] <= MEM[wr_ptr];
	end
end

//read data
always @(posedge rd_clk, negedge rst_n)begin
	if(~rst_n)begin
		rd_data <= 0;
	end
	else begin
		if(rd_en && ~fifo_empty)
			rd_data <= MEM[rd_ptr];
		else 
			rd_data <= rd_data;
	end
end


//gray code 
always @(posedge wr_clk, negedge rst_n)begin
	if(~rst_n)begin
		wr_ptr_gr0 <= 0;
	end
	else begin
		wr_ptr_gr0 <= wr_ptr ^ (wr_ptr >> 1);
	end
end

always @(posedge rd_clk, negedge rst_n)begin
	if(~rst_n)begin
		rd_ptr_gr0 <= 0;
	end
	else begin
		rd_ptr_gr0 <= rd_ptr ^ (rd_ptr >> 1);
	end
end


//2FF delay CDC
always @(posedge rd_clk, negedge rst_n)begin
	if(~rst_n)begin
		wr_ptr_gr2 <= 0;
		wr_ptr_gr1 <= 0;
	end
	else begin
		wr_ptr_gr2 <= wr_ptr_gr1;
		wr_ptr_gr1 <= wr_ptr_gr0;
	end
end

always @(posedge wr_clk, negedge rst_n)begin
	if(~rst_n)begin
		rd_ptr_gr2 <= 0;
		rd_ptr_gr1 <= 0;
	end
	else begin
		rd_ptr_gr2 <= rd_ptr_gr1;
		rd_ptr_gr1 <= rd_ptr_gr0;
	end
end


//empty and full
always @(posedge rd_clk, negedge rst_n)begin
	if(~rst_n)begin
		fifo_empty <= 0;
	end
	else begin
		if(rd_ptr_gr0 == wr_ptr_gr2)
			fifo_empty <= 1;
		else 
			fifo_empty <= 0;
	end
end

always @(posedge wr_clk, negedge rst_n)begin
	if(~rst_n)begin
		fifo_full <= 0;
	end
	else begin
		if(wr_ptr_gr0[$clog2(DEPTH)] != rd_ptr_gr2[$clog2(DEPTH)] && wr_ptr_gr0[$clog2(DEPTH)-1] != rd_ptr_gr2[$clog2(DEPTH)-1] &&
			wr_ptr_gr0[$clog2(DEPTH) - 2 : 0] == rd_ptr_gr2[$clog2(DEPTH) - 2 : 0])
			fifo_full <= 1;
		else 
			fifo_full <= 0;
	end
end

endmodule 
