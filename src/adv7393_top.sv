// synopsys translate_off
`timescale 1 ns / 1 ns
// synopsys translate_on

import adv7393_pkg::*

module adv7393_top
(
	input                       clk,
	input                       reset,       
  
  input                       clk_pixel,

  input                       fb_sel,

  //! IC interface
  output                      ic_clkin,
  output                      ic_hsync,
  output                      ic_vsync,
  output [15:0]               ic_data,

  //! AXI Master
  output [31 : 0]             m_axi_araddr,
  output [7 : 0]              m_axi_arlen,
  output [2 : 0]              m_axi_arsize,
  output [1 : 0]              m_axi_arburst,
  output [0 : 0]              m_axi_arlock,
  output [3 : 0]              m_axi_arcache,
  output [2 : 0]              m_axi_arprot,
  output [3 : 0]              m_axi_arregion,
  output [3 : 0]              m_axi_arqos,
  output                      m_axi_arvalid,
  input                       m_axi_arready,

  input [M_AXI_DWIDTH-1 : 0]  m_axi_rdata,
  input [1 : 0]               m_axi_rresp,
  input                       m_axi_rlast,
  input                       m_axi_rvalid,
  output                      m_axi_rready

);

adv7393_pkg::def_config cfg;




endmodule


