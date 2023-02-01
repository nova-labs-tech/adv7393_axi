module adv7393_interface #(
  parameter 
)(
	input               clk, 
  input               reset,

  input               clk_pixel = '0,

  input               line_ready = '0,

  // Mask fifo read interface (normal fifo)
  input [15:0]        line_fifo_dout = '0,
  output logic        line_fifo_rd_req,
  input               line_fifo_empty = '0,

  //! IC interface
  output              ic_clkin,
  output              ic_hsync,
  output              ic_vsync,
  output [15:0]       ic_data

	
);

endmodule : adv7393_interface