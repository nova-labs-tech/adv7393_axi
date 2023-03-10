module adv7393_top #(
  parameter M_AXI_DWIDTH = 128,
  parameter S_AXI_DWIDTH = 32,
  parameter S_AXI_AWIDTH = 4, 
  paraemter CSR_ENABLE   = 0
)(
	input                       clk,
	input                       reset,       
  
  input                       clk_pixel,

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
  output                      m_axi_rready,

  //! AXI Lite Slave
  output                      s_axi_awready = '0,    
  input                       s_axi_awvalid,
  input  [S_AXI_AWIDTH-1:0]   s_axi_awaddr,
  input  [2:0]                s_axi_awprot,

  output                      s_axi_wready = '0,
  input                       s_axi_wvalid,
  input  [S_AXI_DWIDTH-1:0]   s_axi_wdata,
  input  [S_AXI_DWIDTH/8-1:0] s_axi_wstrb,

  input                       s_axi_bready,
  output                      s_axi_bvalid    = '0,
  output [1:0]                s_axi_bresp     = '0,

  output                      s_axi_arready   = '0,
  input                       s_axi_arvalid,
  input  [S_AXI_AWIDTH-1:0]   s_axi_araddr,
  input  [2:0]                s_axi_arprot,

  input                       s_axi_rready,
  output                      s_axi_arvalid   = '0,
  output [S_AXI_DWIDTH-1:0]   s_axi_rdata     = '0,
  output [1:0]                s_axi_rresp     = '0

);








endmodule : adv7393_top


