// synopsys translate_off
`timescale 1 ns / 1 ns
// synopsys translate_on

module adv7393_frame_ctrl
  import adv7393_pkg::*; import axi_pkg::*;
(
  input                      clk                 ,
  input                      rst                 ,
  //!
  input  ADV7393RegBlock_t   registers           ,
  //!
  input                      fb_write_rdy        ,
  //!
  input                      field               ,
  input                      line_start          ,
  input                      frame_start         ,
  input                      frame_end           ,
  output                     blank_line          ,
  //!
  input                      s_axis_cmd_tvalid   ,
  output logic               s_axis_cmd_tready   ,
  input  AxiMasterRdCtrl_t   s_axis_cmd_tdata    ,
  //!
  output logic               m_axis_status_tvalid,
  input                      m_axis_status_tready,
  output AxiMasterRdStatus_t m_axis_status_tdata
);

typedef enum int { 
  ST_IDLE = 0, 
  ST_CMD_SEND, 
  ST_CMD_WAIT 
} fsm_t;

fsm_t fsm;
AxiMasterRdCtrl_t cmd;

logic [LINES_CNT_W-1:0] line_cnt_in_field             ;
logic [  LINES_CNT_W:0] line_number_to_;

logic [31:0] req_address;
logic 



bcnts #(.MAX(LINES-1)) 
i_bcnts (.clk(clk), .aclr(frame_start), .ena(line_start), .dir('1), .q(line_cnt_in_field));

always_comb begin
  line_number_field = { line, field };

  blank_line = 
end



always_ff @(posedge clk or posedge rst) begin
  if(rst) begin
    fsm <= ST_IDLE;
  end else begin
    
  end
end



endmodule