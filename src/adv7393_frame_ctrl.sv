// synopsys translate_off
`timescale 1 ns / 1 ns
// synopsys translate_on

import adv7393_pkg::*;
import axi_pkg::*;

module adv7393_frame_ctrl (
  input                          clk                 ,
  input                          rst                 ,
  //!
  input  ADV7393RegBlock_t       registers           ,
  //!
  input                          fb_write_rdy        ,
  //!
  input                          field               ,
  input                          line_start          , 
  input                          frame_start         ,
  input                          frame_end           ,
  //!
  input                          s_axis_cmd_tvalid   ,
  output logic                   s_axis_cmd_tready   ,
  input  AxiMasterRdCtrl_t       s_axis_cmd_tdata    ,
  //!
  output logic                   m_axis_status_tvalid,
  input                          m_axis_status_tready,
  output AxiMasterRdStatus_t     m_axis_status_tdata
);

typedef enum int { ST_IDLE, ST_BLANK_LINE,  } fsm_t;





endmodule