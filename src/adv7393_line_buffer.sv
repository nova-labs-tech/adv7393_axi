// synopsys translate_off
`timescale 1 ns / 1 ns
// synopsys translate_on

import adv7393_pkg::*;

// It can be line buffer for everything after modification
module adv7393_line_buffer (
  input                                clk            ,
  input                                rst            ,
  //!
  output logic                         lb_read_rdy    ,
  output logic                         lb_write_rdy   ,
  //!
  input        [      AXIS_DWIDTH-1:0] s_axis_tdata   ,
  input        [      AXIS_DWIDTH/8:0] s_axis_tkeep   ,
  input                                s_axis_tlast   ,
  input                                s_axis_tvalid  ,
  output logic                         s_axis_tready  ,
  //!
  output logic                         lb_exception   ,
  //! New Clock domain
  input                                clk_pix        ,
  //!
  output       [PIXEL_STORED_SIZE-1:0] line_buf_dout  ,
  output                               line_buf_dval  ,
  input                                line_buf_read  ,
  output                               line_buf_empty ,
  //!
  output logic                         lb_read_rdy_pix
);

localparam DCFIFO_PIPELINE = 1;

logic [COMPRESSED_WIDTH-1:0] fifo_data;
logic [COMPRESSED_WIDTH-1:0] fifo_dout;

logic [$clog2(BUFFER_SIZE)-1:0] fifo_usedw;
logic [$clog2(BUFFER_SIZE)-1:0] fifo_usedr;
logic                           fifo_full ;
logic                           fifo_read ;
logic                           fifo_empty;

always_comb begin
  fifo_data       = compress_data(s_axis_tdata);
  lb_exception    = !lb_write_rdy && s_axis_tvalid;
  lb_write_rdy    = (fifo_usedw <= BUFFER_DEPTH-1);
  lb_read_rdy_pix = (fifo_usedr >= BUFFER_DEPTH);
  s_axis_tready   = !fifo_full;
end     

rsync i_rsync (.clk(clk), .in(lb_read_rdy_pix), .out(lb_read_rdy));

dcfifo #(
  .WIDTH(COMPRESSED_WIDTH),
  .SIZE (BUFFER_SIZE     )
) i_dcfifo (
  .rst    (rst          ),
  //!
  .clkw   (clk          ),
  .data   (fifo_data    ),
  .write  (s_axis_tvalid),
  .usedw  (fifo_usedw   ),
  .full   (fifo_full    ),
  //!
  .clkr   (clk_pix      ),
  .read   (fifo_read    ),
  .usedr  (fifo_usedr   ),
  .empty  (fifo_empty   ),
  .q      (fifo_dout    ),
  //!
  .clkhalt(clkhalt      )
);

fifo_rd_dconv #(
  .FIFO_DWIDTH(COMPRESSED_WIDTH ),
  .OUT_DWIDTH (PIXEL_STORED_SIZE),
  .PIPELINE   (DCFIFO_PIPELINE  )
) i_fifo_rd_dwidth_conv (
  .clk       (clk_pix        ),
  .rst       (rst            ),
  //!
  .fifo_dout (fifo_dout      ),
  .fifo_read (fifo_read      ),
  .fifo_empty(fifo_empty     ),
  //!
  .conv_dout (line_buf_dout ),
  .conv_dval (line_buf_dval ),
  .conv_read (line_buf_read ),
  .conv_empty(line_buf_empty)
);

endmodule