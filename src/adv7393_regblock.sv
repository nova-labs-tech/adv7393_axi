// synopsys translate_off
`timescale 1 ns / 1 ns
// synopsys translate_on

import adv7393_pkg::*;

// Will be replaced with peekrdl regblock

module adv7393_regblock #(parameter CSR_ENABLE = 0) (
  input                       clk          ,
  input                       rst          ,
  //!
  output                      s_axi_awready,
  input                       s_axi_awvalid,
  input  [  S_AXI_AWIDTH-1:0] s_axi_awaddr ,
  input  [               2:0] s_axi_awprot ,
  //!
  output                      s_axi_wready ,
  input                       s_axi_wvalid ,
  input  [  S_AXI_DWIDTH-1:0] s_axi_wdata  ,
  input  [S_AXI_DWIDTH/8-1:0] s_axi_wstrb  ,
  //!
  input                       s_axi_bready ,
  output                      s_axi_bvalid ,
  output [               1:0] s_axi_bresp  ,
  //!
  output                      s_axi_arready,
  input                       s_axi_arvalid,
  input  [  S_AXI_AWIDTH-1:0] s_axi_araddr ,
  input  [               2:0] s_axi_arprot ,
  output                      s_axi_arvalid,
  //!
  input                       s_axi_rready ,
  output [  S_AXI_DWIDTH-1:0] s_axi_rdata  ,
  output [               1:0] s_axi_rresp  ,
  //!
  output ADV7393RegBlock_t    reg_block
);

initial if(CSR_ENABLE == 1) $error("Unsupported parameter %s", `__LINE__);

assign reg_block = adv7393_pkg::def_config;

endmodule : adv7393_regblock