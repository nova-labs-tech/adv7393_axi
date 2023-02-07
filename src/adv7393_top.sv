// synopsys translate_off
`timescale 1 ns / 1 ns
// synopsys translate_on

import adv7393_pkg::*

module adv7393_top (
  input                     clk           ,
  input                     rst           ,
  //!
  input                     clk_pixel     ,
  //!
  input                     fb_sel        ,
  //! IC interface
  output                    ic_clkin      ,
  output                    ic_hsync      ,
  output                    ic_vsync      ,
  output [            15:0] ic_data       ,
  //! AXI Master
  output [            31:0] m_axi_araddr  ,
  output [             7:0] m_axi_arlen   ,
  output [             2:0] m_axi_arsize  ,
  output [             1:0] m_axi_arburst ,
  output [             0:0] m_axi_arlock  ,
  output [             3:0] m_axi_arcache ,
  output [             2:0] m_axi_arprot  ,
  output [             3:0] m_axi_arregion,
  output [             3:0] m_axi_arqos   ,
  output                    m_axi_arvalid ,
  input                     m_axi_arready ,
  //!
  input  [M_AXI_DWIDTH-1:0] m_axi_rdata   ,
  input  [             1:0] m_axi_rresp   ,
  input                     m_axi_rlast   ,
  input                     m_axi_rvalid  ,
  output                    m_axi_rready
);

adv7393_pkg::def_config regs;

logic                   lb_write_rdy        ;
logic                   field               ;
logic [LINES_CNT_W-1:0] line_progressive    ;
logic                   line_start          ;
logic                   frame_start         ;
logic                   frame_end           ;
logic                   blank_line          ;
logic                   s_axis_cmd_tvalid   ;
logic                   s_axis_cmd_tready   ;
AxiMasterRdCtrl_t       s_axis_cmd_tdata    ;
logic                   m_axis_status_tvalid;
logic                   m_axis_status_tready;
AxiMasterRdStatus_t     m_axis_status_tdata ;

adv7393_frame_ctrl i_adv7393_frame_ctrl (
  .clk                 (clk                 ),
  .rst                 (rst                 ),
  .registers           (regs                ),
  .fb_sel              (fb_sel              ),
  .lb_write_rdy        (lb_write_rdy        ),
  .field               (field               ),
  .line_start          (line_start          ),
  .frame_start         (frame_start         ),
  .frame_end           (frame_end           ),
  .blank_line          (blank_line          ),
  .s_axis_cmd_tvalid   (s_axis_cmd_tvalid   ),
  .s_axis_cmd_tready   (s_axis_cmd_tready   ),
  .s_axis_cmd_tdata    (s_axis_cmd_tdata    ),
  .m_axis_status_tvalid(m_axis_status_tvalid),
  .m_axis_status_tready(m_axis_status_tready),
  .m_axis_status_tdata (m_axis_status_tdata )
);

logic fb_read_rdy;
logic [PIXEL_STORED_SIZE-1:0] line_buf_dout;
logic line_buf_dval;
logic line_buf_read;
logic line_buf_empty;

adv7393_interface i_adv7393_interface (
  .clk_pixel       (clk_pixel       ),
  .rst             (rst             ),
  .registers       (regs            ),
  .fb_read_rdy     (fb_read_rdy     ),
  .field           (field           ),
  .frame_start     (frame_start     ),
  .frame_end       (frame_end       ),
  .line_start      (line_start      ),
  .blank_line      (blank_line      ),
  .line_buf_dout   (line_buf_dout   ),
  .line_buf_dval   (line_buf_dval   ),
  .line_buf_read   (line_buf_read   ),
  .line_buf_empty  (line_buf_empty  ),
  .ic_clkin        (ic_clkin        ),
  .ic_hsync        (ic_hsync        ),
  .ic_vsync        (ic_vsync        ),
  .ic_data         (ic_data         )
);

logic                   lb_read_rdy    ;
logic [AXIS_DWIDTH-1:0] s_axis_tdata   ;
logic [AXIS_DWIDTH/8:0] s_axis_tkeep   ;
logic                   s_axis_tlast   ;
logic                   s_axis_tvalid  ;
logic                   s_axis_tready  ;

adv7393_line_buffer i_adv7393_line_buffer (
  .clk            (clk            ),
  .rst            (rst            ),
  .lb_read_rdy    (lb_read_rdy    ),
  .lb_write_rdy   (lb_write_rdy   ),
  .s_axis_tdata   (s_axis_tdata   ),
  .s_axis_tkeep   (s_axis_tkeep   ),
  .s_axis_tlast   (s_axis_tlast   ),
  .s_axis_tvalid  (s_axis_tvalid  ),
  .s_axis_tready  (s_axis_tready  ),
  .clk_pix        (clk_pixel      ),
  .line_buf_dout  (line_buf_dout  ),
  .line_buf_dval  (line_buf_dval  ),
  .line_buf_read  (line_buf_read  ),
  .line_buf_empty (line_buf_empty ),
  .lb_read_rdy_pix(lb_read_rdy_pix)
);


  logic aclk;
  logic areset_n;

axi_master_rd #(
  .AXI_DWIDTH (M_AXI_DWIDTH),
  .AXI_AWIDTH (32          ),
  .AXI_IDWIDTH(1           )
) i_axi_master_rd (
  .aclk                (clk                 ),
  .areset_n            (!rst                ),
  .m_axi_arid          (m_axi_arid          ),
  .m_axi_araddr        (m_axi_araddr        ),
  .m_axi_arlen         (m_axi_arlen         ),
  .m_axi_arsize        (m_axi_arsize        ),
  .m_axi_arburst       (m_axi_arburst       ),
  .m_axi_arlock        (m_axi_arlock        ), 
  .m_axi_arcache       (m_axi_arcache       ),
  .m_axi_arprot        (m_axi_arprot        ),
  .m_axi_arregion      (m_axi_arregion      ),
  .m_axi_arqos         (m_axi_arqos         ),
  .m_axi_arvalid       (m_axi_arvalid       ),
  .m_axi_arready       (m_axi_arready       ),
  .m_axi_rid           (m_axi_rid           ),
  .m_axi_rdata         (m_axi_rdata         ), 
  .m_axi_rresp         (m_axi_rresp         ),
  .m_axi_rlast         (m_axi_rlast         ),
  .m_axi_rvalid        (m_axi_rvalid        ),
  .s_axis_cmd_tvalid   (s_axis_cmd_tvalid   ), 
  .s_axis_cmd_tready   (s_axis_cmd_tready   ),
  .s_axis_cmd_tdata    (s_axis_cmd_tdata    ),
  .m_axis_status_tvalid(m_axis_status_tvalid),
  .m_axis_status_tready(m_axis_status_tready),
  .m_axis_status_tdata (m_axis_status_tdata ),
  .m_axis_tdata        (s_axis_tdata        ),
  .m_axis_tkeep        (s_axis_tkeep        ),
  .m_axis_tlast        (s_axis_tlast        ),
  .m_axis_tvalid       (s_axis_tvalid       ),
  .m_axis_tready       (s_axis_tready       )
);

logic [AXIS_DWIDTH-1:0] s_axis_tdata   ;
logic [AXIS_DWIDTH/8:0] s_axis_tkeep   ;
logic                   s_axis_tlast   ;
logic                   s_axis_tvalid  ;
logic                   s_axis_tready  ;




endmodule


