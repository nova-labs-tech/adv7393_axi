
`timescale 1ns/1ns

import axi_pkg::*;

module axi_master_rd #(
	parameter AXI_DWIDTH      = 128,
  parameter AXI_AWIDTH      = 32,
  parameter AXI_IDWIDTH     = 1,
  parameter AXIS_DWIDTH     = AXI_DWIDTH,
  parameter CTRL_WIDTH      = $size(AxiMasterRdCtrl_t),
  parameter STATUS_WIDTH    = $size(AxiMasterRdStatus_t)
) (
	input                               clk, 
	input                               rst, 
	
  //! AXI Master  
  output logic  [AXI_IDWIDTH-1:0]     m_axi_arid,     
  output logic  [AXI_AWIDTH-1:0]      m_axi_araddr,
  output logic  [7:0]                 m_axi_arlen,
  output logic  [2:0]                 m_axi_arsize,
  output logic  [1:0]                 m_axi_arburst,
  output logic                        m_axi_arlock,
  output logic  [3:0]                 m_axi_arcache,
  output logic  [2:0]                 m_axi_arprot,
  output logic  [3:0]                 m_axi_arregion,
  output logic  [3:0]                 m_axi_arqos,
  output logic                        m_axi_arvalid,
  input                               m_axi_arready = '0,

  input         [AXI_IDWIDTH-1:0]     m_axi_rid = '0,
  input         [AXI_DWIDTH-1:0]      m_axi_rdata = '0,
  input         [1:0]                 m_axi_rresp = '0,
  input                               m_axi_rlast = '0,
  input                               m_axi_rvalid = '0,
  output logic                        m_axi_rready

  input                               s_axis_cmd_tvalid = '0,
  output logic                        s_axis_cmd_tready,
  input AxiMasterRdCtrl_t             s_axis_cmd_tdata = '0,

  output logic                        m_axis_status_tvalid,
  input                               m_axis_status_tready = '0,
  output AxiMasterRdStatus_t          m_axis_status_tdata,
  output                              m_axis_status_tlast,


  output [AXIS_DWIDTH-1:0]            s_axis_fifo_tdata,
  output [AXIS_DWIDTH/8:0]            s_axis_fifo_tkeep,
  output                              s_axis_fifo_tlast,
  output                              s_axis_fifo_tvalid,
  input                               s_axis_fifo_tready = '0

);

localparam VERSION = 0;

initial begin
  if(AXI_DWIDTH != 128) $error("Invalid parameter");
  if(AXI_AWIDTH != 32)  $error("Invalid parameter");
  if(AXI_DWIDTH != AXIS_DWIDTH) $error("Invalid parameter");
end

logic transaction_complete;
logic transaction_go;
AxiMasterRdCtrl_t ctrl;

typedef enum int {  ST_IDLE = 0, 
                    ST_GEN_ADDR,
                    ST_TRANSACTION
                  } fsm_t;

always_comb begin
  transaction_go <= s_axis_cmd_tready && s_axis_cmd_tvalid;
  transaction_complete <= 
end

always_ff @(posedge clk or posedge rst) begin
  if(rst) begin
      AxiMasterRdCtrl_t ctrl <= '0;
      s_axis_cmd_tready <= '1;
      fsm_t fsm;
  end 
  else begin
      
      if(transaction_complete) 
        s_axis_cmd_tready <= '1;
      else if(s_axis_cmd_tvalid) 
        s_axis_cmd_tready <= '0;

      case (fsm)
        ST_IDLE: begin
          if(transaction_go) begin
            ctrl <= s_axis_cmd_tdata;
            fsm <= ST_GEN_ADDR;
          end
        end
        ST_GEN_ADDR: begin
          s_axis_cmd_tready <= '1;
        end
        ST_TRANSACTION: begin

        end
        default : fsm <= ST_IDLE;
      endcase

  end
end




endmodule : axi_master_rd