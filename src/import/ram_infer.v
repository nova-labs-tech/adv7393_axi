`timescale 1ns / 1ns

module ram_infer #(
	parameter INIT_FILE = "NONE",
	parameter DATA_WIDTH = 14,
	parameter DATA_DEPTH = 256
) (
	input	      					wclk,
	input [$clog2(DATA_DEPTH)-1:0]  waddr,
	input [DATA_WIDTH-1:0]  		wdata,
	input         					we,
	input         					rclk,
	input [$clog2(DATA_DEPTH)-1:0]  raddr,
	output reg [DATA_WIDTH-1:0] 	rdata,
	input         					re
);

reg [DATA_WIDTH-1:0] mem [0:DATA_DEPTH-1];

always @(posedge wclk) begin
    if(we)
        mem[waddr] = wdata;	
end

always @(posedge rclk) begin
	if(re)
	    rdata = mem[raddr];
end

endmodule
