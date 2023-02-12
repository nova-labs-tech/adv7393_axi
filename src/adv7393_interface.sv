// synopsys translate_off
`timescale 1 ns / 1 ns
// synopsys translate_on

// Using 10 bit DDR regime

module adv7393_interface
  import adv7393_pkg::*;
(
  input                                clk_pixel       ,
  input                                rst             ,
  //!
  input  ADV7393RegBlock_t             registers       ,
  //!
  input                                fb_read_rdy     ,
  //!
  output logic                         field           ,
  output logic                         frame_start     ,
  output logic                         frame_end       ,
  input                                blank_line      ,
  //!
  input        [PIXEL_STORED_SIZE-1:0] line_buf_dout   ,
  input                                line_buf_dval   ,
  output logic                         line_buf_read   ,
  input                                line_buf_empty  ,
  //!
  output logic                         ic_clkin        ,
  output                               ic_hsync        ,
  output                               ic_vsync        ,
  output logic [                 15:0] ic_data
);

logic         hsync_n   ;
logic         data_phase;
PixelStored_t pix       ;
PixelStored_t from_data ;

adv7393_sync_gen i_adv7393_sync_gen (
  .clk            (clk_pixel  ),
  .rst            (rst        ),
  .registers      (registers  ),
  .line_valid     (line_valid ),
  .line           (line       ),
  .frame_start    (frame_start),
  .frame_end      (frame_end  ),
  .hsync_n        (hsync_n    ),
  .field          (field      )
);

delayreg #(.WIDTH(2), .DELAY(4)) i_delayreg (
  .clk    (clk_pixel           ),
  .rst    (rst                 ),
  .ena    ('1                  ),
  .data   ({hsync_n, field}    ),
  .delay  ({ic_hsync, ic_vsync})
);

assign ic_clkin = clk_pixel;

always_comb begin
  from_data = line_buf_dout;
  if (blank_line || !line_valid) pix = blank_val;
  else pix = from_data;    

  line_buf_read = line_valid && !data_phase;
end

always_ff @(posedge clk_pixel or posedge rst) begin
  if(rst) begin
    ic_data    <= '0;
    data_phase <= '0;
  end else begin
    data_phase <= frame_start ? '0 : !data_phase;
    ic_data    <= pixel2out(pix, data_phase);
  end
end


endmodule