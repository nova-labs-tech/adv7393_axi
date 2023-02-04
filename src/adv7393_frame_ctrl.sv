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
  input        [    PHASE_W-1:0] phase               ,
  input        [LINES_CNT_W-1:0] line                ,
  input                          frame_ends          ,
  //!
  input                          s_axis_cmd_tvalid   ,
  output logic                   s_axis_cmd_tready   ,
  input  AxiMasterRdCtrl_t       s_axis_cmd_tdata    ,
  //!
  output logic                   m_axis_status_tvalid,
  input                          m_axis_status_tready,
  output AxiMasterRdStatus_t     m_axis_status_tdata ,
  output                         m_axis_status_tlast
);






endmodule