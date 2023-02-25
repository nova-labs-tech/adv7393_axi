// synopsys translate_off
`timescale 1 ns / 1 ns
// synopsys translate_on

module adv7393_top_tb;

import tb_helper::*;
import axi_pkg::*;
import adv7393_pkg::*;

int CLOCK_PERIOD   = 5 ;
int RESET_DURATION = 10;

logic                    clk           ;
logic                    rst           ;
logic                    clk_pixel     ;
//!
logic                    fb_sel        ;
//!
logic                    ic_clkin      ;
logic                    ic_hsync      ;
logic                    ic_vsync      ;
//!
logic [            15:0] ic_data       ;
logic [            31:0] m_axi_araddr  ;
logic [             7:0] m_axi_arlen   ;
logic [             2:0] m_axi_arsize  ;
logic [             1:0] m_axi_arburst ;
logic [             0:0] m_axi_arlock  ;
logic [             3:0] m_axi_arcache ;
logic [             2:0] m_axi_arprot  ;
logic [             3:0] m_axi_arregion;
logic [             3:0] m_axi_arqos   ;
logic                    m_axi_arvalid ;
logic                    m_axi_arready ;
logic [M_AXI_DWIDTH-1:0] m_axi_rdata   ;
logic [             1:0] m_axi_rresp   ;
logic                    m_axi_rlast   ;
logic                    m_axi_rvalid  ;
logic                    m_axi_rready  ;

adv7393_top i_adv7393_top (
  .clk           (clk           ),
  .rst           (rst           ),
  .clk_pixel     (clk_pixel     ),
  .fb_sel        (fb_sel        ),
  .ic_clkin      (ic_clkin      ),
  .ic_hsync      (ic_hsync      ),
  .ic_vsync      (ic_vsync      ),
  .ic_data       (ic_data       ),
  .m_axi_araddr  (m_axi_araddr  ),
  .m_axi_arlen   (m_axi_arlen   ),
  .m_axi_arsize  (m_axi_arsize  ),
  .m_axi_arburst (m_axi_arburst ),
  .m_axi_arlock  (m_axi_arlock  ),
  .m_axi_arcache (m_axi_arcache ),
  .m_axi_arprot  (m_axi_arprot  ),
  .m_axi_arregion(m_axi_arregion),
  .m_axi_arqos   (m_axi_arqos   ),
  .m_axi_arvalid (m_axi_arvalid ),
  .m_axi_arready (m_axi_arready ),
  .m_axi_rdata   (m_axi_rdata   ),
  .m_axi_rresp   (m_axi_rresp   ),
  .m_axi_rlast   (m_axi_rlast   ),
  .m_axi_rvalid  (m_axi_rvalid  ),
  .m_axi_rready  (m_axi_rready  )
);

initial tb_helper::clk_gen(clk, CLOCK_PERIOD);
initial tb_helper::reset_gen(clk, rst, RESET_DURATION);


endmodule