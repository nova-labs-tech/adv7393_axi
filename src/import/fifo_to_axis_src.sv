module fifo_to_axis_mstr
#(
  parameter AXIS_DWIDTH = 64,
  parameter FIFO_DWIDTH = 64,
  parameter FIFO_UWIDTH = 10,
  parameter CHANNEL     = 0
) 
(
  input                       clk,
  input                       rst,

  input [FIFO_UWIDTH-1:0]     ctrl_psize,   // Packet size
  output logic                busy,

  input                       fifo_empty,
  input [FIFO_UWIDTH-1:0]     fifo_used,
  input [FIFO_DWIDTH-1:0]     fifo_q,
  output                      fifo_read,

  output logic                axis_tvalid,
  input                       axis_tready,
  output [AXIS_DWIDTH-1:0]    axis_tdata,
  output [AXIS_DWIDTH/8-1:0]  axis_tkeep,
  output logic                axis_tlast
);

localparam CHANNEL_WIDTH = 4;

initial begin
  if(AXIS_DWIDTH % 8 != 0) $error("AXIS_DWIDTH must be multiple of 8");
  if(AXIS_DWIDTH != FIFO_DWIDTH) $error("AXIS_DWIDTH must be equal of FIFO_DWIDTH");
  if(AXIS_DWIDTH % FIFO_DWIDTH != 0) $error("AXIS_DWIDTH must be multiple of FIFO_DWIDTH");
end    

logic [FIFO_UWIDTH-1:0] cnt_transfer;
logic data_ready;
logic transfer; 
logic transfer_d; 
logic transfer_pedge;
logic [AXIS_DWIDTH-1:0] channel_info;

assign channel_info[AXIS_DWIDTH-1:AXIS_DWIDTH-CHANNEL_WIDTH] = CHANNEL_WIDTH'(CHANNEL);
assign channel_info[AXIS_DWIDTH-CHANNEL_WIDTH-1:0] = '0;

assign data_ready = fifo_used >= ctrl_psize;
assign axis_tkeep = '1;
assign axis_tdata = transfer_pedge ? channel_info : fifo_q;
assign fifo_read  = transfer && axis_tready;

always_ff @ (posedge clk, posedge rst) 
  if (rst) transfer <= '0;
  else if (!transfer && data_ready) transfer <= '1;
  else if (cnt_transfer >= ctrl_psize) transfer <= '0;

always_ff @(posedge clk or posedge rst)
  if (rst) cnt_transfer <= '0;
  else if (!transfer) cnt_transfer <= '0;
  else if (fifo_read) cnt_transfer <= cnt_transfer + 1'b1; 

always_ff @(posedge clk) transfer_d <= transfer;

assign axis_tvalid = transfer || transfer_d;
assign axis_tlast = !transfer && transfer_d;     
assign transfer_pedge = transfer && !transfer_d;
assign busy = transfer;

endmodule

// COMPONENT fifo_to_axis_mstr
//   Generic (
//     AXIS_DWIDTH  : positive range 64 to 64 := 64;
//     FIFO_DWIDTH  : positive range 64 to 64 := 64;
//     FIFO_UWIDTH  : positive range 1 to 32 := 8 
//   );
//   Port (
//     clk          : in std_logic;   
//     rst          : in std_logic;   
//     ctrl_psize   : in std_logic_vector(FIFO_UWIDTH-1 downto 0);
//     fifo_empty   : in std_logic; 
//     fifo_used    : in std_logic_vector(FIFO_UWIDTH-1 downto 0);
//     fifo_q       : in std_logic_vector(FIFO_DWIDTH-1 downto 0);
//     fifo_read    : out std_logic;
//     axis_tvalid  : out std_logic;
//     axis_tready  : in std_logic; 
//     axis_tdata   : out std_logic_vector(AXIS_DWIDTH-1 downto 0);
//     axis_tkeep   : out std_logic_vector(AXIS_DWIDTH/8-1 downto 0);
//     axis_tlast   : out std_logic
//   );
// END COMPONENT;

