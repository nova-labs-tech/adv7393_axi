// synopsys translate_off
`timescale 1 ns / 1 ns
// synopsys translate_on

module adv7393_top_tb;

import tb_helper::*;
import axi_pkg::*;
import adv7393_pkg::*;

int            CLOCK_PERIOD       = 5    ;
int            CLOCK_PIXEL_PERIOD = 16   ;
int            RESET_DURATION     = 10   ;
localparam int SLAVE_MEM_SIZE     = 65536;
localparam int ID_WIDTH           = 1    ;


logic clk      ;
logic rst      ;
logic clk_pixel;
//!
logic fb_sel;
//!
logic        ic_clkin;
logic        ic_hsync;
logic        ic_vsync;
logic [15:0] ic_data ;
//!
logic [31:0] m_axi_araddr  ;
logic [ 7:0] m_axi_arlen   ;
logic [ 2:0] m_axi_arsize  ;
logic [ 1:0] m_axi_arburst ;
logic [ 0:0] m_axi_arlock  ;
logic [ 3:0] m_axi_arcache ;
logic [ 2:0] m_axi_arprot  ;
logic [ 3:0] m_axi_arregion;
logic [ 3:0] m_axi_arqos   ;
logic        m_axi_arvalid ;
logic        m_axi_arready ;
//!
logic [M_AXI_DWIDTH-1:0] m_axi_rdata ;
logic [             1:0] m_axi_rresp ;
logic                    m_axi_rlast ;
logic                    m_axi_rvalid;
logic                    m_axi_rready;

logic [         2:0] m_axi_awprot  ;
logic [         3:0] m_axi_awqos   ;
logic [         3:0] m_axi_awcache ;
logic                m_axi_awlock  ;
logic [         1:0] m_axi_awburst ;
logic [         2:0] m_axi_awsize  ;
logic [         7:0] m_axi_awlen   ;
logic [         3:0] m_axi_awregion;
logic [ID_WIDTH-1:0] m_axi_awid    ;
logic [        31:0] m_axi_awaddr  ;
logic                m_axi_awready ;
logic                m_axi_awvalid ;
//
logic                      m_wlast ;
logic [M_AXI_DWIDTH/8-1:0] m_wstrb ;
logic [  M_AXI_DWIDTH-1:0] m_wdata ;
logic                      m_wready;
logic                      m_wvalid;

logic [         1:0] m_axi_bresp ;
logic [ID_WIDTH-1:0] m_axi_bid   ;
logic                m_axi_bready;
logic                m_axi_bvalid;

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
initial tb_helper::clk_gen(clk_pixel, CLOCK_PERIOD);
initial tb_helper::rst_gen(rst, clk, RESET_DURATION);

cdn_axi4_slave_bfm #(
  .DATA_BUS_WIDTH              (M_AXI_DWIDTH  ),
  .SLAVE_ADDRESS               (0             ),
  .SLAVE_MEM_SIZE              (SLAVE_MEM_SIZE),
  .MAX_OUTSTANDING_TRANSACTIONS(8             )
) i_cdn_axi4_slave_bfm (
  .ACLK    (clk           ),
  .ARESETn (!rst          ),
  //!
  .AWID    ('0            ),
  .AWADDR  (m_axi_awaddr  ),
  .AWLEN   (m_axi_awlen   ),
  .AWSIZE  (m_axi_awsize  ),
  .AWBURST (m_axi_awburst ),
  .AWLOCK  (m_axi_awlock  ),
  .AWCACHE (m_axi_awcache ),
  .AWPROT  (m_axi_awprot  ),
  .AWREGION(m_axi_awregion),
  .AWQOS   (m_axi_awqos   ),
  .AWUSER  (              ),
  .AWVALID (m_axi_awvalid ),
  .AWREADY (m_axi_awready ),
  //!
  .WDATA   (m_wdata       ),
  .WSTRB   (m_wstrb       ),
  .WLAST   (m_axi_wlast   ),
  .WUSER   (              ),
  .WVALID  (m_wvalid      ),
  .WREADY  (m_wready      ),
  //!
  .BID     (m_axi_bid     ),
  .BRESP   (m_axi_bresp   ),
  .BVALID  (m_axi_bvalid  ),
  .BUSER   (              ),
  .BREADY  (m_axi_bready  ),
  //!
  .ARID    ('0            ),
  .ARADDR  (m_axi_araddr  ),
  .ARLEN   (m_axi_arlen   ),
  .ARSIZE  (m_axi_arsize  ),
  .ARBURST (m_axi_arburst ),
  .ARLOCK  (m_axi_arlock  ),
  .ARCACHE (m_axi_arcache ),
  .ARPROT  (m_axi_arprot  ),
  .ARREGION(m_axi_arregion),
  .ARQOS   (m_axi_arqos   ),
  .ARUSER  (              ),
  .ARVALID (m_axi_arvalid ),
  .ARREADY (m_axi_arready ),
  //!
  .RID     (              ),
  .RDATA   (m_axi_rdata   ),
  .RRESP   (m_axi_rresp   ),
  .RLAST   (m_axi_rlast   ),
  .RUSER   (              ),
  .RVALID  (m_axi_rvalid  ),
  .RREADY  (m_axi_rready  )
);

task reset();
  m_axi_awprot  <= '0;
  m_axi_awqos   <= '0;
  m_axi_awcache <= '0;
  m_axi_awlock  <= '0;
  m_axi_awburst <= '0;
  m_axi_awsize  <= '0;
  m_axi_awlen   <= '0;
  m_axi_awregion<= '0;
  m_axi_awid    <= '0;
  m_axi_awaddr  <= '0;
  m_axi_awvalid <= '0;
//
  m_wlast  <= '0;
  m_wstrb  <= '0;
  m_wdata  <= '0;
  m_wvalid <= '0;

  m_axi_bready <= '0;

endtask : reset

initial begin
  reset();  
  wait_clk(clk, CLOCK_PERIOD);
end


endmodule