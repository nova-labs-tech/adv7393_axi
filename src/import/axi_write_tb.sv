`timescale 1ns / 1ps

module axi_write_tb;

parameter integer DATA_WIDTH = 128;
parameter integer ADDR_WIDTH = 32;
parameter integer ID_WIDTH = 4;
parameter integer BURST_LEN = 160;

parameter SLAVE_ADDRESS = 'h100000;
parameter SLAVE_MEM_SIZE = 'h200000;
parameter MAX_OUTSTANDING_TRANSACTIONS = 5;
parameter MEMORY_MODEL_MODE = 1;
parameter EXCLUSIVE_ACCESS_SUPPORTED = 1;

parameter RAM_DWIDTH = 80;
parameter RAM_DEPTH = BURST_LEN;
parameter RAM_AWIDTH = $clog2(RAM_DEPTH);
parameter RAM_COEFS = 4;
parameter RAM_COEF_WIDTH = RAM_DWIDTH/RAM_COEFS;

parameter integer DATA_WIDTH_PART = DATA_WIDTH/RAM_COEFS;
parameter USE_BFM = 0;


logic clk;
logic aresetn;

logic [2:0]             m_aw_prot;
logic [3:0]             m_aw_qos;
logic [3:0]             m_aw_cache;
logic                   m_aw_lock;
logic [1:0]             m_aw_burst;
logic [2:0]             m_aw_size;
logic [7:0]             m_aw_len;
logic [3:0]             m_aw_region;
logic [ID_WIDTH-1:0]    m_aw_id;
logic [ADDR_WIDTH-1:0]  m_aw_addr;
logic                   m_aw_ready;
logic                   m_aw_valid;
//
logic                     m_w_last;
logic [DATA_WIDTH/8-1:0]  m_w_strb;
logic [DATA_WIDTH-1:0]    m_w_data;
logic                     m_w_ready;
logic                     m_w_valid;

logic [1:0]           m_b_resp;
logic [ID_WIDTH-1:0]  m_b_id;
logic                 m_b_ready;
logic                 m_b_valid;

logic [2:0]             m_ar_prot;
logic [3:0]             m_ar_qos;
logic [3:0]             m_ar_cache;
logic                   m_ar_lock;
logic [1:0]             m_ar_burst;
logic [2:0]             m_ar_size;
logic [7:0]             m_ar_len;
logic [3:0]             m_ar_region;
logic [ID_WIDTH-1:0]    m_ar_id;
logic [ADDR_WIDTH-1:0]  m_ar_addr;
logic                   m_ar_ready;
logic                   m_ar_valid;


logic                   m_r_last;
logic [1:0]             m_r_resp;
logic [ID_WIDTH-1:0]    m_r_id;
logic [DATA_WIDTH-1:0]  m_r_data;
logic                   m_r_ready;
logic                   m_r_valid;

logic [7:0]             new_coeff_addr;
logic [79:0]            new_coeff_data;
logic                   new_coeff_req;

adc_write #(
  .DATA_WIDTH        (DATA_WIDTH),
  .ADDR_WIDTH        (ADDR_WIDTH),
  .ID_WIDTH          (ID_WIDTH),
  .BURST_LEN         (BURST_LEN),
  .MEM_ADDR_BASE     (SLAVE_ADDRESS)
) u_adc_write (
  .clk               (clk),
  .aresetn           (aresetn),
  //
  .m_aw_prot         (m_aw_prot),
  .m_aw_qos          (m_aw_qos),
  .m_aw_cache        (m_aw_cache),
  .m_aw_lock         (m_aw_lock),
  .m_aw_burst        (m_aw_burst),
  .m_aw_size         (m_aw_size),
  .m_aw_len          (m_aw_len),
  .m_aw_region       (m_aw_region),
  .m_aw_id           (m_aw_id),
  .m_aw_addr         (m_aw_addr),
  .m_aw_ready        (m_aw_ready),
  .m_aw_valid        (m_aw_valid),
  //
  .m_w_last          (m_w_last),
  .m_w_strb          (m_w_strb),
  .m_w_data          (m_w_data),
  .m_w_ready         (m_w_ready),
  .m_w_valid         (m_w_valid),
  //
  .m_b_resp          (m_b_resp),
  .m_b_id            (m_b_id),
  .m_b_ready         (m_b_ready),
  .m_b_valid         (m_b_valid),
  //
  .m_ar_prot         (m_ar_prot),
  .m_ar_qos          (m_ar_qos),
  .m_ar_cache        (m_ar_cache),
  .m_ar_lock         (m_ar_lock),
  .m_ar_burst        (m_ar_burst),
  .m_ar_size         (m_ar_size),
  .m_ar_len          (m_ar_len),
  .m_ar_region       (m_ar_region),
  .m_ar_id           (m_ar_id),
  .m_ar_addr         (m_ar_addr),
  .m_ar_ready        (m_ar_ready),
  .m_ar_valid        (m_ar_valid),
  //
  .m_r_last          (m_r_last),
  .m_r_resp          (m_r_resp),
  .m_r_id            (m_r_id),
  .m_r_data          (m_r_data),
  .m_r_ready         (m_r_ready),
  .m_r_valid         (m_r_valid),

  .new_coeff_addr    (new_coeff_addr),
  .new_coeff_data    (new_coeff_data),
  .new_coeff_req     (new_coeff_req)
);

  wire [31:0]m_axi_araddr;
  wire [1:0]m_axi_arburst;
  wire [3:0]m_axi_arcache;
  wire [7:0]m_axi_arlen;
  wire [0:0]m_axi_arlock;
  wire [2:0]m_axi_arprot;
  wire [3:0]m_axi_arqos;
  wire m_axi_arready;
  wire [3:0]m_axi_arregion;
  wire [2:0]m_axi_arsize;
  wire m_axi_arvalid;
  wire [31:0]m_axi_awaddr;
  wire [1:0]m_axi_awburst;
  wire [3:0]m_axi_awcache;
  wire [7:0]m_axi_awlen;
  wire [0:0]m_axi_awlock;
  wire [2:0]m_axi_awprot;
  wire [3:0]m_axi_awqos;
  wire m_axi_awready;
  wire [3:0]m_axi_awregion;
  wire [2:0]m_axi_awsize;
  wire m_axi_awvalid;
  wire m_axi_bready;
  wire [1:0]m_axi_bresp;
  wire m_axi_bvalid;
  wire [127:0]m_axi_rdata;
  wire m_axi_rlast;
  wire m_axi_rready;
  wire [1:0]m_axi_rresp;
  wire m_axi_rvalid;
  wire [127:0]m_axi_wdata;
  wire m_axi_wlast;
  wire m_axi_wready;
  wire [15:0]m_axi_wstrb;
  wire m_axi_wvalid;


axi_vip_0 axi_vip (
  .aclk             (aclk),           
  .aresetn          (aresetn),  

  .s_axi_awaddr     (m_aw_addr),   
  .s_axi_awlen      (m_aw_len),    
  .s_axi_awsize     (m_aw_size),   
  .s_axi_awburst    (m_aw_burst),  
  .s_axi_awlock     (m_aw_lock),   
  .s_axi_awcache    (m_aw_cache),  
  .s_axi_awprot     (m_aw_prot),   
  .s_axi_awregion   (m_aw_region), 
  .s_axi_awqos      (m_aw_qos),    
  .s_axi_awvalid    (m_aw_valid),  
  .s_axi_awready    (m_aw_ready),  
  
  .s_axi_wdata      (m_w_data),    
  .s_axi_wstrb      (m_w_strb),    
  .s_axi_wlast      (m_w_last),    
  .s_axi_wvalid     (m_w_valid),   
  .s_axi_wready     (m_w_ready),   
  
  .s_axi_bresp      (m_b_resp),    
  .s_axi_bvalid     (m_b_valid),   
  .s_axi_bready     (m_b_ready),   
  
  .s_axi_araddr     (m_ar_addr),   
  .s_axi_arlen      (m_ar_len),    
  .s_axi_arsize     (m_ar_size),   
  .s_axi_arburst    (m_ar_burst),  
  .s_axi_arlock     (m_ar_lock),   
  .s_axi_arcache    (m_ar_cache),  
  .s_axi_arprot     (m_ar_prot),   
  .s_axi_arregion   (m_ar_region), 
  .s_axi_arqos      (m_ar_qos),    
  .s_axi_arvalid    (m_ar_valid),  
  .s_axi_arready    (m_ar_ready),  
  
  .s_axi_rdata      (m_r_data),    
  .s_axi_rresp      (m_r_resp),    
  .s_axi_rlast      (m_r_last),    
  .s_axi_rvalid     (m_r_valid),   
  .s_axi_rready     (m_r_ready),   
  
  .m_axi_awaddr     (m_axi_awaddr),   
  .m_axi_awlen      (m_axi_awlen),    
  .m_axi_awsize     (m_axi_awsize),   
  .m_axi_awburst    (m_axi_awburst),  
  .m_axi_awlock     (m_axi_awlock),   
  .m_axi_awcache    (m_axi_awcache),  
  .m_axi_awprot     (m_axi_awprot),   
  .m_axi_awregion   (m_axi_awregion), 
  .m_axi_awqos      (m_axi_awqos),    
  .m_axi_awvalid    (m_axi_awvalid),  
  .m_axi_awready    (m_axi_awready),  
  
  .m_axi_wdata      (m_axi_wdata),    
  .m_axi_wstrb      (m_axi_wstrb),    
  .m_axi_wlast      (m_axi_wlast),    
  .m_axi_wvalid     (m_axi_wvalid),   
  .m_axi_wready     (m_axi_wready),   
  
  .m_axi_bresp      (m_axi_bresp),    
  .m_axi_bvalid     (m_axi_bvalid),   
  .m_axi_bready     (m_axi_bready),   
  
  .m_axi_araddr     (m_axi_araddr),   
  .m_axi_arlen      (m_axi_arlen),    
  .m_axi_arsize     (m_axi_arsize),   
  .m_axi_arburst    (m_axi_arburst),  
  .m_axi_arlock     (m_axi_arlock),   
  .m_axi_arcache    (m_axi_arcache),  
  .m_axi_arprot     (m_axi_arprot),   
  .m_axi_arregion   (m_axi_arregion), 
  .m_axi_arqos      (m_axi_arqos),    
  .m_axi_arvalid    (m_axi_arvalid),  
  .m_axi_arready    (m_axi_arready),  
  
  .m_axi_rdata      (m_axi_rdata),    
  .m_axi_rresp      (m_axi_rresp),    
  .m_axi_rlast      (m_axi_rlast),    
  .m_axi_rvalid     (m_axi_rvalid),   
  .m_axi_rready     (m_axi_rready)    
);

generate if (USE_BFM == 1) begin
  cdn_axi4_slave_bfm #(
  .DATA_BUS_WIDTH               (DATA_WIDTH),
  .ADDRESS_BUS_WIDTH            (ADDR_WIDTH),
  .SLAVE_ADDRESS                (SLAVE_ADDRESS),
  .SLAVE_MEM_SIZE               (SLAVE_MEM_SIZE),
  .MAX_OUTSTANDING_TRANSACTIONS (MAX_OUTSTANDING_TRANSACTIONS),
  .MEMORY_MODEL_MODE            (MEMORY_MODEL_MODE),
  .EXCLUSIVE_ACCESS_SUPPORTED   (EXCLUSIVE_ACCESS_SUPPORTED)
  ) u_cdn_axi4_slave_bfm (
    .ACLK        (clk),
    .ARESETn     (aresetn),

    .AWID        (m_aw_id),
    .AWADDR      (m_axi_awaddr),
    .AWLEN       (m_axi_awlen),
    .AWSIZE      (m_axi_awsize),
    .AWBURST     (m_axi_awburst),
    .AWLOCK      (m_axi_awlock),
    .AWCACHE     (m_axi_awcache),
    .AWPROT      ('0),
    .AWREGION    (m_axi_awregion),
    .AWQOS       (m_axi_awqos),
    .AWUSER      ('0),
    .AWVALID     (m_axi_awvalid),
    .AWREADY     (m_axi_awready),

    .WDATA       (m_axi_wdata),
    .WSTRB       (m_axi_wstrb),
    .WLAST       (m_axi_wlast),
    .WUSER       ('0),
    .WVALID      (m_axi_wvalid),
    .WREADY      (m_axi_wready),

    .BID         (),
    .BRESP       (m_axi_bresp),
    .BVALID      (m_axi_bvalid),
    .BUSER       (),
    .BREADY      (m_axi_bready),

    .ARID        (m_ar_id),
    .ARADDR      (m_axi_araddr),
    .ARLEN       (m_axi_arlen),
    .ARSIZE      (m_axi_arsize),
    .ARBURST     (m_axi_arburst),
    .ARLOCK      (m_axi_arlock),
    .ARCACHE     (m_axi_arcache),
    .ARPROT      (m_axi_arprot),
    .ARREGION    (m_axi_arregion),
    .ARQOS       (m_axi_arqos),
    .ARUSER      ('0),
    .ARVALID     (m_axi_arvalid),
    .ARREADY     (m_axi_arready),

    .RID         (),
    .RDATA       (m_axi_rdata),
    .RRESP       (m_axi_rresp),
    .RLAST       (m_axi_rlast),
    .RUSER       (),
    .RVALID      (m_axi_rvalid),
    .RREADY      (m_axi_rready)
  );
end 
else begin

  wire [31:0] m0_axi_araddr;
  wire [1:0]m0_axi_arburst;
  wire [3:0]m0_axi_arcache;
  wire [7:0]m0_axi_arlen;
  wire [0:0]m0_axi_arlock;
  wire [2:0]m0_axi_arprot;
  wire [3:0]m0_axi_arqos;
  wire m0_axi_arready;
  wire [3:0]m0_axi_arregion;
  wire [2:0]m0_axi_arsize;
  wire m0_axi_arvalid;
  wire [31:0]m0_axi_awaddr;
  wire [1:0]m0_axi_awburst;
  wire [3:0]m0_axi_awcache;
  wire [7:0]m0_axi_awlen;
  wire [0:0]m0_axi_awlock;
  wire [2:0]m0_axi_awprot;
  wire [3:0]m0_axi_awqos;
  wire m0_axi_awready;
  wire [3:0]m0_axi_awregion;
  wire [2:0]m0_axi_awsize;
  wire m0_axi_awvalid;
  wire m0_axi_bready;
  wire [1:0]m0_axi_bresp;
  wire m0_axi_bvalid;
  wire [31:0]m0_axi_rdata;
  wire m0_axi_rlast;
  wire m0_axi_rready;
  wire [1:0]m0_axi_rresp;
  wire m0_axi_rvalid;
  wire [31:0]m0_axi_wdata;
  wire m0_axi_wlast;
  wire m0_axi_wready;
  wire [3:0]m0_axi_wstrb;
  wire m0_axi_wvalid;

  axi_dwidth_converter_0 axi_dwidth_converter_0 (
  .s_axi_aclk       (clk),       
  .s_axi_aresetn    (aresetn),    
  .s_axi_awaddr     (m_axi_awaddr),     
  .s_axi_awlen      (m_axi_awlen),      
  .s_axi_awsize     (m_axi_awsize),     
  .s_axi_awburst    (m_axi_awburst),    
  .s_axi_awlock     (m_axi_awlock),    
  .s_axi_awcache    (m_axi_awcache),    
  .s_axi_awprot     (m_axi_awprot),     
  .s_axi_awregion   (m_axi_awregion),  
  .s_axi_awqos      (m_axi_awqos),      
  .s_axi_awvalid    (m_axi_awvalid),    
  .s_axi_awready    (m_axi_awready),    
  .s_axi_wdata      (m_axi_wdata),      
  .s_axi_wstrb      (m_axi_wstrb),      
  .s_axi_wlast      (m_axi_wlast),      
  .s_axi_wvalid     (m_axi_wvalid),     
  .s_axi_wready     (m_axi_wready),     
  .s_axi_bresp      (m_axi_bresp),      
  .s_axi_bvalid     (m_axi_bvalid),     
  .s_axi_bready     (m_axi_bready),     
  .s_axi_araddr     (m_axi_araddr),     
  .s_axi_arlen      (m_axi_arlen),      
  .s_axi_arsize     (m_axi_arsize),     
  .s_axi_arburst    (m_axi_arburst),    
  .s_axi_arlock     (m_axi_arlock),     
  .s_axi_arcache    (m_axi_arcache),    
  .s_axi_arprot     (m_axi_arprot),     
  .s_axi_arregion   (m_axi_arregion),  
  .s_axi_arqos      (m_axi_arqos),      
  .s_axi_arvalid    (m_axi_arvalid),    
  .s_axi_arready    (m_axi_arready),    
  .s_axi_rdata      (m_axi_rdata),      
  .s_axi_rresp      (m_axi_rresp),      
  .s_axi_rlast      (m_axi_rlast),      
  .s_axi_rvalid     (m_axi_rvalid),     
  .s_axi_rready     (m_axi_rready),     

  .m_axi_awaddr     (m0_axi_awaddr),  
  .m_axi_awlen      (m0_axi_awlen),   
  .m_axi_awsize     (m0_axi_awsize),  
  .m_axi_awburst    (m0_axi_awburst), 
  .m_axi_awlock     (m0_axi_awlock),  
  .m_axi_awcache    (m0_axi_awcache), 
  .m_axi_awprot     (m0_axi_awprot),  
  .m_axi_awregion   (m0_axi_awregion),
  .m_axi_awqos      (m0_axi_awqos),   
  .m_axi_awvalid    (m0_axi_awvalid), 
  .m_axi_awready    (m0_axi_awready), 
  .m_axi_wdata      (m0_axi_wdata),   
  .m_axi_wstrb      (m0_axi_wstrb),   
  .m_axi_wlast      (m0_axi_wlast),   
  .m_axi_wvalid     (m0_axi_wvalid),  
  .m_axi_wready     (m0_axi_wready),  
  .m_axi_bresp      (m0_axi_bresp),   
  .m_axi_bvalid     (m0_axi_bvalid),  
  .m_axi_bready     (m0_axi_bready),  
  .m_axi_araddr     (m0_axi_araddr),  
  .m_axi_arlen      (m0_axi_arlen),   
  .m_axi_arsize     (m0_axi_arsize),  
  .m_axi_arburst    (m0_axi_arburst), 
  .m_axi_arlock     (m0_axi_arlock),  
  .m_axi_arcache    (m0_axi_arcache), 
  .m_axi_arprot     (m0_axi_arprot),  
  .m_axi_arregion   (m0_axi_arregion),
  .m_axi_arqos      (m0_axi_arqos),   
  .m_axi_arvalid    (m0_axi_arvalid), 
  .m_axi_arready    (m0_axi_arready), 
  .m_axi_rdata      (m0_axi_rdata),   
  .m_axi_rresp      (m0_axi_rresp),   
  .m_axi_rlast      (m0_axi_rlast),   
  .m_axi_rvalid     (m0_axi_rvalid),  
  .m_axi_rready     (m0_axi_rready)   
);

  blk_mem_gen_0 memory (
    .rsta_busy        (),     
    .rstb_busy        (),     

    .s_aclk           (clk),        
    .s_aresetn        (aresetn), 

    .s_axi_awid       (m0_axi_awid),    
    .s_axi_awaddr     (m0_axi_awaddr),  
    .s_axi_awlen      (m0_axi_awlen),   
    .s_axi_awsize     (m0_axi_awsize),  
    .s_axi_awburst    (m0_axi_awburst), 
    .s_axi_awvalid    (m0_axi_awvalid), 
    .s_axi_awready    (m0_axi_awready), 

    .s_axi_wdata      (m0_axi_wdata),   
    .s_axi_wstrb      (m0_axi_wstrb),   
    .s_axi_wlast      (m0_axi_wlast),   
    .s_axi_wvalid     (m0_axi_wvalid),  
    .s_axi_wready     (m0_axi_wready),  
    
    .s_axi_bid        (),     
    .s_axi_bresp      (m0_axi_bresp),   
    .s_axi_bvalid     (m0_axi_bvalid),  
    .s_axi_bready     (m0_axi_bready),  
    
    .s_axi_arid       (m0_axi_arid),    
    .s_axi_araddr     (m0_axi_araddr),  
    .s_axi_arlen      (m0_axi_arlen),   
    .s_axi_arsize     (m0_axi_arsize),  
    .s_axi_arburst    (m0_axi_arburst), 
    .s_axi_arvalid    (m0_axi_arvalid), 
    .s_axi_arready    (m0_axi_arready), 
    .s_axi_rid        (m0_axi_rid),   

    .s_axi_rdata      (m0_axi_rdata),   
    .s_axi_rresp      (m0_axi_rresp),   
    .s_axi_rlast      (m0_axi_rlast),   
    .s_axi_rvalid     (m0_axi_rvalid),  
    .s_axi_rready     (m0_axi_rready)   
  ); 

end
endgenerate

logic [RAM_AWIDTH-1:0]   ram_waddr;
logic [RAM_DWIDTH-1:0]   ram_wdata;
logic         					 ram_we;

ram_infer #(
  .DATA_WIDTH    (RAM_DWIDTH),
  .DATA_DEPTH    (RAM_DEPTH)
) u_ram_infer (
  .wclk          (clk),
  .waddr         (ram_waddr),
  .wdata         (ram_wdata),
  .we            (ram_we),
  .rclk          (clk),
  .raddr         (new_coeff_addr),
  .rdata         (new_coeff_data),
  .re            ('1)
);

localparam PERIOD = 5;

initial begin
  clk <= '0;
  #PERIOD;
  forever #PERIOD clk = ~clk;
end

task automatic wait_ticks_r(ref clk_src, int ticks);
  repeat(ticks) begin
    @ (posedge clk_src);
  end
endtask

task automatic rst_gen(ref rst_sig, ref clk_sig, int ticks);
  automatic int pre_tick = 1;
  wait_ticks_r(clk_sig, pre_tick);
  rst_sig = '0;
  wait_ticks_r(clk_sig, ticks);
  rst_sig = '1;
  wait_ticks_r(clk_sig, ticks);
endtask

logic [RAM_COEF_WIDTH-1:0] ram_coef;

function logic[RAM_DWIDTH-1:0] set_ram_data (logic [RAM_COEF_WIDTH-1:0] ram_coef);
  automatic logic[RAM_DWIDTH-1:0] val = 0;
  val [0 +: RAM_COEF_WIDTH] = ram_coef;
  for (int i=1; i<RAM_COEFS; i++)begin
    val[i*RAM_COEF_WIDTH +: RAM_COEF_WIDTH] = val[(i-1)*RAM_COEF_WIDTH +: RAM_COEF_WIDTH] + 1'b1;
  end
  return val;
endfunction

task ram_clear_write_port;
  ram_waddr <= '0;
  ram_wdata <= '0;
  ram_we <= '0;
endtask

task wait_ticks(int ticks);
  wait_ticks_r(clk, ticks);
endtask

task automatic write_ram_cnt(ref logic [RAM_COEF_WIDTH-1:0] ram_coef);
  ram_clear_write_port;
  wait_ticks(1);
  ram_we = '1;
  repeat(RAM_DEPTH) begin
    ram_wdata = set_ram_data(ram_coef);
    wait_ticks(1);
    ram_coef = ram_coef + RAM_COEFS;
    ram_waddr = ram_waddr + 1'b1;
  end
  ram_we = '0;
endtask

task axi_start;
  wait_ticks(1);
  new_coeff_req <= '1;
  wait_ticks(1);
  new_coeff_req <= '0;
endtask

task axi_wait_ready;
  while(!(m_b_valid && m_b_ready)) wait_ticks(1);
endtask

task wait_forever;
  forever begin
    wait_ticks(1);
  end
endtask

logic [10:0] transfer_cnt;

initial begin
  int ticks = 10;
  ram_clear_write_port;
  ram_coef = '0;
  rst_gen(aresetn, clk, ticks);

  forever begin
    write_ram_cnt(ram_coef);
    axi_start;
    axi_wait_ready;
    if(transfer_cnt != RAM_DEPTH)
      $error("Transfer depth invalid %d", transfer_cnt);
  end

end

function bit cnt_is_up(logic [DATA_WIDTH-1:0] data, logic [DATA_WIDTH-1:0] data_prev);
  logic [DATA_WIDTH_PART-1:0] data_part;
  logic [DATA_WIDTH_PART-1:0] data_prev_part;
  if(data [DATA_WIDTH_PART-1:0] == '0)
    return '1;
  else begin
    for (int i=0; i<RAM_COEFS; ++i) begin
      data_part = data[i*DATA_WIDTH_PART +: DATA_WIDTH_PART];
      data_prev_part = data_prev[i*DATA_WIDTH_PART +: DATA_WIDTH_PART];
      if(data_part != (data_prev_part + RAM_COEFS))
        return '0;
    end
  end
  return '1;
endfunction

task data_integrity_checker_up(logic [DATA_WIDTH-1:0] data);
  logic [DATA_WIDTH-1:0] data_prev;

  wait_ticks(1);
  if(m_w_ready && m_w_ready) begin
    data_prev <= data;
    if(!cnt_is_up(data, data_prev))
      $error("Counter isn't up");
  end

endtask

logic [DATA_WIDTH-1:0] data_prev;

always_ff @ (posedge clk) begin
  if(m_w_ready && m_w_valid) begin
    if(!cnt_is_up(m_w_data, data_prev)) begin
      $error("Counter isn't up");
      // $stop();
    end
    data_prev <= m_w_data;
  end
end

always_ff @ (posedge clk) begin
  if(new_coeff_req)
    transfer_cnt <= '0;
  else if(m_w_ready && m_w_valid) 
    transfer_cnt <= transfer_cnt + 1'b1;
end



endmodule