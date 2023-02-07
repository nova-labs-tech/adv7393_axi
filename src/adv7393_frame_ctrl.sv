// synopsys translate_off
`timescale 1 ns / 1 ns
// synopsys translate_on

module adv7393_frame_ctrl
  import adv7393_pkg::*; import axi_pkg::*;
(
  input                          clk                 ,
  input                          rst                 ,
  //!
  input  ADV7393RegBlock_t       registers           ,
  input                          fb_sel              ,
  //!
  input                          lb_write_rdy        ,
  //!
  input                          field               ,
  input                          line_start          ,
  input                          frame_start         ,
  input                          frame_end           ,
  output                         blank_line          ,
  //!
  output logic                   s_axis_cmd_tvalid   ,
  input                          s_axis_cmd_tready   ,
  output  AxiMasterRdCtrl_t      s_axis_cmd_tdata    ,
  //!
  input logic                    m_axis_status_tvalid,
  output                         m_axis_status_tready,
  input AxiMasterRdStatus_t      m_axis_status_tdata
);

typedef enum int { 
  ST_IDLE = 0, 
  ST_CMD_SEND, 
  ST_CMD_WAIT,
  ST_CHECK_LINE_BUFFER, 
  ST_WAIT_LINE_END 
} fsm_t;

fsm_t             fsm;
AxiMasterRdCtrl_t cmd;

logic [LINES_CNT_W-1:0] line2read_wo_field;
logic [LINES_CNT_W-1:0] line_wo_field     ;
logic [  LINES_CNT_W:0] line2read         ;
logic [  LINES_CNT_W:0] line              ;

logic [15:0] req_size    ;
logic [31:0] line_offset ;
logic [31:0] frame_base  ;
logic        next_line_in;
logic        next_line;

LineActInterval_t center_align;

bcnts #(.MAX(LINES-1)) 
i0_bcnts (.clk(clk), .aclr(frame_start), .ena(next_line), .dir('1), .q(line_per_field));
bcnts #(.MAX(LINES-1)) 
i1_bcnts (.clk(clk), .aclr(frame_start), .ena(line_ends), .dir('1), .q(line_per_field));

pdet i_pdet (.clk(clk), .in(next_line_in), .out(out));

always_comb begin
  line2read = { line2read_wo_field, field };

  req_size     = registers.frame.LineLength*PIXEL_SIZE;
  line_offset  = axi_pkg::line_offset(frame_base, line2read);
  frame_base   = axi_pkg::frame_base(registers, fb_sel);
  center_align = axi_pkg::frame_align_center(registers);
  blank_line   = axi_pkg::blank_line(line, center_align);

  s_axis_cmd_tdata = cmd;
  next_line_in     = (fsm == ST_CHECK_LINE_BUFFER) && lb_write_rdy;
end   

always_ff @(posedge clk or posedge rst) begin
  if(rst) begin
    fsm                   <= ST_IDLE;
    cmd                   <= '0;
    s_axis_cmd_tvalid     <= '0;
    m_axis_status_tready  <= '0;
  end else begin
    case(fsm)
      ST_IDLE : begin
        if(frame_start) 
          fsm <= ST_CMD_SEND;
      end
      ST_CMD_SEND : begin
        cmd.address       <= line_offset;
        cmd.bytes         <= req_size;
        s_axis_cmd_tvalid <= '1;
        if(axiAccepted(s_axis_cmd_tvalid, s_axis_cmd_tready))
          fsm <= ST_CMD_WAIT;
      end
      ST_CMD_WAIT : begin
        s_axis_cmd_tvalid    <= '0;
        m_axis_status_tready <= '1;
        if(axiAccepted(m_axis_status_tvalid, m_axis_status_tready))
          fsm <= ST_CHECK_LINE_BUFFER;
      end
      ST_CHECK_LINE_BUFFER : begin
        m_axis_status_tready <= '0;
        if(lb_write_rdy)
          fsm <= ST_WAIT_LINE_END;
      end
      ST_WAIT_LINE_END     : begin
        if(frame_end)
          fsm <= ST_IDLE;
      default : begin
        fsm <= ST_IDLE;
      end
      endcase
    end
  end



endmodule