// synopsys translate_off
`timescale 1 ns / 1 ns
// synopsys translate_on

module adv7393_sync_gen
  import adv7393_pkg::*;
(
  input                          clk        ,
  input                          rst        ,
  //!
  output                         field      ,
  output                         active_line,
  output logic [LINES_CNT_W-1:0] line       ,
  output logic                   frame_ends ,
  //!
  output                         hsync      ,
  output                         field
);

endmodule : adv7393_sync_gen