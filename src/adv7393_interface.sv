// synopsys translate_off
`timescale 1 ns / 1 ns
// synopsys translate_on

import adv7393_pkg::*;

module adv7393_interface (
  input                                clk_pixel     ,
  input                                rst           ,
  //!
  input                                ena           ,
  //!
  input                                fb_read_rdy   ,
  //!
  output logic [         PHASES_W-1:0] phase         ,
  output logic [      LINES_CNT_W-1:0] line          ,
  output logic                         frame_ends    ,
  output logic                         blanking      ,
  //! 
  input        [PIXEL_STORED_SIZE-1:0] line_buf_dout ,
  input                                line_buf_dval ,
  output logic                         line_buf_read ,
  input                                line_buf_empty,
  //! 
  output                               ic_clkin      ,
  output                               ic_hsync      ,
  output                               ic_vsync      ,
  output       [                 15:0] ic_data
);


always_comb begin
  ic_clkin = clk_pixel;
end












endmodule