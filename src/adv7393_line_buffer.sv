import adv7393_pkg::*;

module adv7393_line_buffer (
  input                    clk               ,
  input                    reset             ,
  //!
  input                    clk_pixel         ,
  //!
  output                   read_ready        ,
  output                   write_ready       ,
  // FIFO read interface (normal fifo)
  output [           15:0] line_fifo_dout    ,
  input                    line_fifo_read  ,
  output                   line_fifo_empty   ,
  //!
  input  [AXIS_DWIDTH-1:0] s_axis_fifo_tdata ,
  input  [AXIS_DWIDTH/8:0] s_axis_fifo_tkeep ,
  input                    s_axis_fifo_tlast ,
  input                    s_axis_fifo_tvalid,
  output                   s_axis_fifo_tready
);

logic [COMPRESSED_WIDTH-1:0] fifo_data;
logic [COMPRESSED_WIDTH-1:0] fifo_dout;

logic [$clog2(BUFFER_SIZE)-1:0] fifo_usedw;
logic [$clog2(BUFFER_SIZE)-1:0] fifo_usedr;
logic                           fifo_full ;
logic                           fifo_read ;
logic                           fifo_empty;

dcfifo #(
  .WIDTH(COMPRESSED_WIDTH),
  .SIZE (BUFFER_SIZE     )
) i_dcfifo (
  .rst    (reset     ),
  //!
  .clkw   (clk       ),
  .data   (fifo_data ),
  .write  (fifo_write),
  .full   (fifo_full ),
  .usedw  (fifo_usedw),
  //!
  .clkr   (clk_pixel ),
  .read   (fifo_read ),
  .empty  (fifo_empty),
  .usedr  (fifo_usedr),
  .q      (fifo_dout ),
  //!
  .clkhalt(clkhalt   )
);







endmodule : adv7393_line_buffer