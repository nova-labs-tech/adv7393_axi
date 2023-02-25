`timescale 1ns / 1ns

module adc_write #(
	parameter integer DATA_WIDTH = 64,
	parameter integer ADDR_WIDTH = 32,
	parameter integer ID_WIDTH = 4,
	parameter integer BURST_LEN = 256,
  	parameter integer MEM_ADDR_BASE = 'h100000
) (
	input clk,
	input aresetn,
	//
	output [2:0]                  m_aw_prot,
	output [3:0]                  m_aw_qos,
	output [3:0]                  m_aw_cache,
	output                        m_aw_lock,
	output [1:0]                  m_aw_burst,
	output [2:0]                  m_aw_size,
	output [7:0]                  m_aw_len,
	output [3:0]                  m_aw_region,
	output [ID_WIDTH-1:0]         m_aw_id,
	output [ADDR_WIDTH-1:0]       m_aw_addr,
	input                         m_aw_ready,
	output                        m_aw_valid,
	//
	output                        m_w_last,
	output [DATA_WIDTH/8-1:0]     m_w_strb,
	output [DATA_WIDTH-1:0]       m_w_data,
	input                         m_w_ready,
	output                        m_w_valid,
	//
	input [1:0]                   m_b_resp,
	input [ID_WIDTH-1:0]          m_b_id,
	output                        m_b_ready,
	input                         m_b_valid,
	//
	output [2:0]                  m_ar_prot,
	output [3:0]                  m_ar_qos,
	output [3:0]                  m_ar_cache,
	output                        m_ar_lock,
	output [1:0]                  m_ar_burst,
	output [2:0]                  m_ar_size,
	output [7:0]                  m_ar_len,
	output [3:0]                  m_ar_region,
	output [ID_WIDTH-1:0]         m_ar_id,
	output [ADDR_WIDTH-1:0]       m_ar_addr,
	input                         m_ar_ready,
	output                        m_ar_valid,
	//
	input                         m_r_last,
	input [1:0]                   m_r_resp,
	input [ID_WIDTH-1:0]          m_r_id,
	input [DATA_WIDTH-1:0]        m_r_data,
	output                        m_r_ready,
	input                         m_r_valid,

	output [7:0]                  new_coeff_addr,
	input [79:0]                  new_coeff_data,
	input                         new_coeff_req
);

function integer clogb2 (input integer bd);
integer bit_depth;
begin
  bit_depth = bd;
  for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
    bit_depth = bit_depth >> 1;
  end
endfunction

localparam [1:0]
	FIXED = 2'b00,
	INCR  = 2'b01,
	WARP  = 2'b10;

localparam integer BEAT_NUM = clogb2(BURST_LEN-1);

reg [ADDR_WIDTH-1:0] write_addr;
reg [ADDR_WIDTH-1:0] mem_base;
reg write_addr_valid;
reg write_data_valid;
reg write_data_valid_delay;
reg write_last;

reg b_ready;

reg [7:0] write_idx;	// Index of word being written (send)

reg write_start;
reg write_run;

reg data_saved, data_saved_d;
reg [DATA_WIDTH-1:0] data_save;
wire [DATA_WIDTH-1:0] data_ram;

wire wnext;

// Write start signal
wire wr;

assign wr = new_coeff_req;
assign new_coeff_addr = write_idx;

assign m_aw_addr = MEM_ADDR_BASE + write_addr;
assign m_aw_len = BURST_LEN - 1;
assign m_aw_size = clogb2((DATA_WIDTH/8)-1);
//assign m_aw_size = 3'b011;
assign m_aw_valid = write_addr_valid;
assign m_aw_burst = INCR;
assign m_aw_id = 4'b0;
assign m_aw_qos = 0;
assign m_aw_region = 4'b0000;
assign m_aw_lock = 1'b0;
assign m_aw_cache = 4'b0011;

assign data_ram = { 
                    12'b000000000000, new_coeff_data[79:60],
                    12'b000000000000, new_coeff_data[59:40],
                    12'b000000000000, new_coeff_data[39:20],
                    12'b000000000000,new_coeff_data[19:0]
                  };

assign m_w_data = data_saved ? data_save : data_ram;

assign m_w_strb = {(DATA_WIDTH/8){1'b1}};

assign m_w_last = write_last;

assign m_b_ready = b_ready;

assign wnext = m_w_ready & write_data_valid;

assign  m_ar_valid = 0,
        m_ar_prot = 0,
        m_ar_qos = 0,
        m_ar_cache = 0,
        m_ar_lock = 0,
        m_ar_burst = 0,
        m_ar_size = 0,
        m_ar_len = 0,
        m_ar_region = 0,
        m_ar_id = 0,
        m_ar_addr = 0,
        m_ar_valid = 0,
        m_r_ready = 0;

wire data_accepted = m_w_ready && m_w_valid;
wire transfer_finished = write_idx == BURST_LEN-1;
reg w_valid;

assign m_b_ready = 1'b1;
assign m_w_valid = w_valid;
assign m_w_last = transfer_finished;

always @(posedge clk, negedge aresetn) begin
	if(!aresetn) begin
		write_run <= 0;
        write_addr_valid <= 0;
        write_addr <= 0;
        w_valid <= 0;
		write_idx <= 0;
	end
	else begin
		if(wr && ~write_run)
			write_run <= 1'b1;
		else if(transfer_finished)
            write_run <= 1'b0;
        
        if(wr && ~write_run)
            write_addr_valid <= 1'b1;
        else if(m_aw_ready && write_run) begin
            write_addr_valid <= '0;
            write_addr <= write_addr + (DATA_WIDTH/8)*BURST_LEN;
        end
		
		w_valid <= write_run;
        if(data_accepted) begin
            write_idx <= write_idx + 1'b1;
        end	
		
	end
end







endmodule
