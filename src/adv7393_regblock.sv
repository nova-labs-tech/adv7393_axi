import adv7393_pkg::*;

module adv7393_regblock #(
  parameter CSR_ENABLE                  = 0,
  parameter ADV7393RegBlock_t REG_DEFAULT = adv7393_pkg::def_config
)(
	input clk,    // Clock
	input reset,  // Asynchronous reset active
	
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
  output [1:0]                s_axi_rresp     = '0,

  output ADV7393RegBlock_t    reg_block

);

initial if(CSR_ENABLE == 1) $error("Unsupported parameter %s", `__LINE__);

assign reg_block = REG_DEFAULT;


endmodule : adv7393_regblock