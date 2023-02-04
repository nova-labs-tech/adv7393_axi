// synopsys translate_off
`timescale 1 ns / 1 ns
// synopsys translate_on

// Should be rewritten

module fifo_rd_dconv #(
  parameter FIFO_DWIDTH = 64,
  parameter OUT_DWIDTH  = 16,
  parameter PIPELINE    = 1
) (
  input                          clk       ,
  input                          rst       ,
  //! FIFO read interface (normal fifo)
  input        [FIFO_DWIDTH-1:0] fifo_dout ,
  output                         fifo_read ,
  input                          fifo_empty,
  //! Converted DWIDTH
  output logic [ OUT_DWIDTH-1:0] conv_dout ,
  output logic                   conv_dval ,
  input                          conv_read ,
  output logic                   conv_empty
);

`include "macro.svh"

localparam MULTIPLE  = `MAX(FIFO_DWIDTH, OUT_DWIDTH)/`MIN(FIFO_DWIDTH, OUT_DWIDTH);
localparam PIPE_CNTW = $clog2(PIPELINE)                                           ;
localparam MULT_CNTW = $clog2(MULTIPLE)                                           ;

initial begin
  if(`MAX(FIFO_DWIDTH, OUT_DWIDTH) % `MIN(FIFO_DWIDTH, OUT_DWIDTH))
    $error("DWIDTH'S aren't multiple");  
  if (PIPELINE > 2) 
    $error("PIPELINE can't be greater than 2"); 
end

logic                   fifo_dval, fifo_dval_d;
logic                   delay_ena      ;
logic [  MULT_CNTW-1:0] cnt            ;
logic [FIFO_DWIDTH-1:0] fifo_dout_delay;

generate if (FIFO_DWIDTH > OUT_DWIDTH) begin

delayreg #(.WIDTH(1), .DELAY(PIPELINE+1)) i_delayreg (
  .clk  (clk      ),
  .ena  ('1),
  .data (fifo_read),
  .delay(fifo_dval)
);

always_ff @(posedge clk) fifo_dout_d <= fifo_dval ? fifo_dout : fifo_dout_d;
always_ff @(posedge clk) fifo_dval_d <= fifo_dval;

mux #(.DWIDTH(OUT_DWIDTH), .INPUTS(MULTIPLE)) 
i_mux (.data(fifo_dout_d), .sel(cnt), .q(conv_dout));

always_comb begin
  conv_empty = fifo_empty && ;
  fifo_read  = conv_read && fifo_read_en;
  conv_dval  = ;
end

always_ff @(posedge clk or posedge rst) begin
  if(rst) begin
    cnt <= '0;
  end else begin

  end
end
end 
else if (FIFO_DWIDTH < OUT_DWIDTH) begin
  $error("Unsupported parameter %s", `__LINE__);
end
else begin
  $error("Block is useless with this parameters");
end
endgenerate


endmodule