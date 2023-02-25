//----------------------------------------------------------------------------
// Project    : Pheidippides
// Company    : Cadence Design Systems
//----------------------------------------------------------------------------
// Description: 
// This file contains the AXI 4 Slave BFM.
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
// Required defines.
//----------------------------------------------------------------------------



//----------------------------------------------------------------------------
// Project    : Pheidippides
// Company    : Cadence Design Systems
//----------------------------------------------------------------------------
// Description: 
// This file contains the defines required for the Cadence AXI 4 BFMs.
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
// Required timescale.
//----------------------------------------------------------------------------
`timescale 1ns / 1ps

//----------------------------------------------------------------------------
// Defines.
//----------------------------------------------------------------------------
`define CDN_AXI4_BFM_VIP_VERSION_NUMBER "1.9"
`define AXI4_MODEL_NAME "Xilinx_AXI_BFM"
`define AXI4_MODEL_VERSION 2010.10

// Response timeout value is used for tasks that wait for some action or 
// response. If the timeout value is reached (measured in clock cycles) then 
// a timeout error message should be initiated.
`define AXI4_RESPONSE_TIMEOUT 500

// Burst Type Defines
`define AXI4_BURST_TYPE_FIXED 2'b00
`define AXI4_BURST_TYPE_INCR  2'b01
`define AXI4_BURST_TYPE_WRAP  2'b10

// Burst Size Defines
`define AXI4_BURST_SIZE_1_BYTE    3'b000
`define AXI4_BURST_SIZE_2_BYTES   3'b001
`define AXI4_BURST_SIZE_4_BYTES   3'b010
`define AXI4_BURST_SIZE_8_BYTES   3'b011
`define AXI4_BURST_SIZE_16_BYTES  3'b100
`define AXI4_BURST_SIZE_32_BYTES  3'b101
`define AXI4_BURST_SIZE_64_BYTES  3'b110
`define AXI4_BURST_SIZE_128_BYTES 3'b111

// Lock Type Defines
`define AXI4_LOCK_TYPE_NORMAL    1'b0
`define AXI4_LOCK_TYPE_EXCLUSIVE 1'b1

// Response Type Defines
`define AXI4_RESPONSE_OKAY 2'b00
`define AXI4_RESPONSE_EXOKAY 2'b01
`define AXI4_RESPONSE_SLVERR 2'b10
`define AXI4_RESPONSE_DECERR 2'b11

// AMBA AXI 4 Bus Size Constants
`define AXI4_LENGTH_BUS_WIDTH 8
`define AXI4_SIZE_BUS_WIDTH 3
`define AXI4_BURST_BUS_WIDTH 2
`define AXI4_LOCK_BUS_WIDTH 1
`define AXI4_CACHE_BUS_WIDTH 4
`define AXI4_PROT_BUS_WIDTH 3
`define AXI4_RESP_BUS_WIDTH 2
`define AXI4_QOS_BUS_WIDTH 4
`define AXI4_REGION_BUS_WIDTH 4
  
// AMBA AXI 4 Range Constants
`define AXI4_AXI3_MAX_BURST_LENGTH 8'b0000_1111
`define AXI4_MAX_BURST_LENGTH 8'b1111_1111
`define AXI4_MAX_DATA_SIZE (DATA_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))/8

// Message defines
`define AXI4_MSG_WARNING WARNING
`define AXI4_MSG_INFO    INFO
`define AXI4_MSG_ERROR   ERROR

// Define for intenal control value
`define AXI4_ANY_ID_NEXT 100
`define AXI4_IDVALID_TRUE  1'b1
`define AXI4_IDVALID_FALSE 1'b0
  
//----------------------------------------------------------------------------
// END OF FILE
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
// The AXI 4 Slave BFM Module.
//----------------------------------------------------------------------------

module cdn_axi4_slave_bfm (ACLK, ARESETn, 
                           AWID, AWADDR, AWLEN, AWSIZE, AWBURST, AWLOCK, 
                           AWCACHE, AWPROT, AWREGION, AWQOS, AWUSER, 
                           AWVALID, AWREADY,
                           WDATA, WSTRB, WLAST, WUSER, WVALID, WREADY,
                           BID, BRESP, BVALID, BUSER, BREADY,
                           ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARLOCK, 
                           ARCACHE, ARPROT, ARREGION, ARQOS, ARUSER, 
                           ARVALID, ARREADY,
                           RID, RDATA, RRESP, RLAST, RUSER, RVALID, RREADY);

   //------------------------------------------------------------------------
   // Configuration Parameters
   //------------------------------------------------------------------------
   parameter NAME = "SLAVE_0";
   parameter DATA_BUS_WIDTH = 32;
   parameter ADDRESS_BUS_WIDTH = 32;
   parameter ID_BUS_WIDTH = 4;
   parameter AWUSER_BUS_WIDTH = 1;
   parameter ARUSER_BUS_WIDTH = 1;
   parameter RUSER_BUS_WIDTH  = 1;
   parameter WUSER_BUS_WIDTH  = 1;
   parameter BUSER_BUS_WIDTH  = 1;
   parameter SLAVE_ADDRESS = 0;
   parameter SLAVE_MEM_SIZE = 4;
   parameter MAX_OUTSTANDING_TRANSACTIONS = 8;
   parameter MEMORY_MODEL_MODE = 0;
   parameter EXCLUSIVE_ACCESS_SUPPORTED = 1;
        
   integer READ_BURST_DATA_TRANSFER_GAP = 0;
   integer WRITE_RESPONSE_GAP = 0;
   integer READ_RESPONSE_GAP = 0;
   integer RESPONSE_TIMEOUT = `AXI4_RESPONSE_TIMEOUT;
   reg     STOP_ON_ERROR = 1'b1;
   reg     CHANNEL_LEVEL_INFO = 1'b0;
   reg     FUNCTION_LEVEL_INFO = 1'b1;
   
   //------------------------------------------------------------------------
   // Signal Definitions
   //------------------------------------------------------------------------

   // Global Clock Input. All signals are sampled on the rising edge.
   input wire ACLK;    
   // Global Reset Input. Active Low.
   input wire ARESETn;
   
   // Write Address Channel Signals.
   input wire [ID_BUS_WIDTH-1:0]      AWID;    // Master Write address ID. 
   input wire [ADDRESS_BUS_WIDTH-1:0] AWADDR;  // Master Write address. 
   input wire [`AXI4_LENGTH_BUS_WIDTH-1:0] AWLEN;   // Master Burst length.
   input wire [`AXI4_SIZE_BUS_WIDTH-1:0]   AWSIZE;  // Master Burst size.
   input wire [`AXI4_BURST_BUS_WIDTH-1:0]  AWBURST; // Master Burst type.
   input wire [`AXI4_LOCK_BUS_WIDTH-1:0]   AWLOCK;  // Master Lock type.
   input wire [`AXI4_CACHE_BUS_WIDTH-1:0]  AWCACHE; // Master Cache type.
   input wire [`AXI4_PROT_BUS_WIDTH-1:0]   AWPROT;  // Master Protection type.
   input wire [`AXI4_REGION_BUS_WIDTH-1:0] AWREGION;// Master Region signals.
   input wire [`AXI4_QOS_BUS_WIDTH-1:0]    AWQOS;   // Master QoS signals.
   input wire [AWUSER_BUS_WIDTH-1:0]  AWUSER;  // Master User defined signals.
   input wire                         AWVALID; // Master Write address valid.
   output reg                         AWREADY; // Slave Write address ready.

   // Write Data Channel Signals.
   input wire [DATA_BUS_WIDTH-1:0]     WDATA;  // Master Write data.
   input wire [(DATA_BUS_WIDTH/8)-1:0] WSTRB;  // Master Write strobes.
   input wire                          WLAST;  // Master Write last.
   input wire [WUSER_BUS_WIDTH-1:0]    WUSER;  // Master Write User defined signals.
   input wire                          WVALID; // Master Write valid.
   output reg                          WREADY; // Slave Write ready.
   
   // Write Response Channel Signals.
   output reg [ID_BUS_WIDTH-1:0]      BID;    // Slave Response ID.
   output reg [`AXI4_RESP_BUS_WIDTH-1:0]   BRESP;  // Slave Write response.
   output reg                         BVALID; // Slave Write response valid. 
   output reg [BUSER_BUS_WIDTH-1:0]   BUSER;  // Slave Write user defined signals.
   input wire                         BREADY; // Master Response ready.
   
   // Read Address Channel Signals.
   input wire [ID_BUS_WIDTH-1:0]       ARID;    // Master Read address ID.
   input wire [ADDRESS_BUS_WIDTH-1:0]  ARADDR;  // Master Read address.
   input wire [`AXI4_LENGTH_BUS_WIDTH-1:0]  ARLEN;   // Master Burst length.
   input wire [`AXI4_SIZE_BUS_WIDTH-1:0]    ARSIZE;  // Master Burst size.
   input wire [`AXI4_BURST_BUS_WIDTH-1:0]   ARBURST; // Master Burst type.
   input wire [`AXI4_LOCK_BUS_WIDTH-1:0]    ARLOCK;  // Master Lock type.
   input wire [`AXI4_CACHE_BUS_WIDTH-1:0]   ARCACHE; // Master Cache type.
   input wire [`AXI4_PROT_BUS_WIDTH-1:0]    ARPROT;  // Master Protection type.
   input wire [`AXI4_REGION_BUS_WIDTH-1:0]  ARREGION;// Master Region signals.
   input wire [`AXI4_QOS_BUS_WIDTH-1:0]     ARQOS;   // Master QoS signals.
   input wire [ARUSER_BUS_WIDTH-1:0]   ARUSER;  // Master User defined signals.
   input wire                          ARVALID; // Master Read address valid.
   output reg                          ARREADY; // Slave Read address ready.
   
   // Read Data Channel Signals.
   output  reg [ID_BUS_WIDTH-1:0]    RID;    // Slave Read ID tag. 
   output  reg [DATA_BUS_WIDTH-1:0]  RDATA;  // Slave Read data.
   output  reg [`AXI4_RESP_BUS_WIDTH-1:0] RRESP;  // Slave Read response.
   output  reg                       RLAST;  // Slave Read last.
   output  reg [RUSER_BUS_WIDTH-1:0] RUSER;  // Slave Read user defined signals.
   output  reg                       RVALID; // Slave Read valid.
   input wire                        RREADY; // Master Read ready.

   //------------------------------------------------------------------------
   // Local Variables
   //------------------------------------------------------------------------
   reg                               write_response_bus_locked;
   reg                               read_data_bus_locked;
   integer                           error_count;
   integer                           warning_count;
   integer                           pending_transactions_count;

   //------------------------------------------------------------------------
   // Local Events
   //------------------------------------------------------------------------
   event                             read_address_transfer_complete;
   event                             write_address_transfer_complete;
   event                             read_data_transfer_complete;
   event                             write_data_transfer_complete;
   event                             read_data_burst_complete;
   event                             write_data_burst_complete;
   event                             write_response_transfer_complete;
         
   //------------------------------------------------------------------------
   // Initialize Local Variables
   //------------------------------------------------------------------------
   initial begin
      write_response_bus_locked = 1'b0;
      read_data_bus_locked = 1'b0;
      error_count = 0;
      warning_count = 0;
      pending_transactions_count = 0;
   end

   //------------------------------------------------------------------------
   // Display BFM Header
   //------------------------------------------------------------------------
   initial begin
      $display("BFM Xilinx: License succeeded for %s, version %f",`AXI4_MODEL_NAME, `AXI4_MODEL_VERSION);
      $display("*********************************************************");
      $display("* Cadence AXI 4 SLAVE BFM                               *");
      $display("*********************************************************");
      $display("* VERSION NUMBER : ",`CDN_AXI4_BFM_VIP_VERSION_NUMBER);
      report_config;
   end

   //------------------------------------------------------------------------
   // UTILITY TASK: report_config
   //------------------------------------------------------------------------
   // Description:
   // This task prints out the current config of the slave BFM.
   //------------------------------------------------------------------------
   task report_config;
      begin
         $display("*********************************************************");
         $display("* CONFIGURATION: ");
         $display("* NAME = %s",NAME);
         $display("* DATA_BUS_WIDTH = %0d",DATA_BUS_WIDTH);
         $display("* ADDRESS_BUS_WIDTH = %0d",ADDRESS_BUS_WIDTH);
         $display("* ID_BUS_WIDTH = %0d",ID_BUS_WIDTH);
         $display("* AWUSER_BUS_WIDTH = %0d",AWUSER_BUS_WIDTH);
         $display("* ARUSER_BUS_WIDTH = %0d",ARUSER_BUS_WIDTH);
         $display("* RUSER_BUS_WIDTH = %0d",RUSER_BUS_WIDTH);
         $display("* WUSER_BUS_WIDTH = %0d",WUSER_BUS_WIDTH);
         $display("* BUSER_BUS_WIDTH = %0d",BUSER_BUS_WIDTH);
         $display("* SLAVE_ADDRESS = 0x%0h",SLAVE_ADDRESS);
         $display("* SLAVE_MEM_SIZE = 0x%0h",SLAVE_MEM_SIZE);
         $display("* MAX_OUTSTANDING_TRANSACTIONS = %0d",
                  MAX_OUTSTANDING_TRANSACTIONS);
         $display("* MEMORY_MODEL_MODE = %0d",MEMORY_MODEL_MODE);
         $display("* EXCLUSIVE_ACCESS_SUPPORTED = %0d",
                  EXCLUSIVE_ACCESS_SUPPORTED);
         $display("* READ_BURST_DATA_TRANSFER_GAP = %0d",
                  READ_BURST_DATA_TRANSFER_GAP);
         $display("* WRITE_RESPONSE_GAP = %0d",WRITE_RESPONSE_GAP);
         $display("* READ_RESPONSE_GAP = %0d",READ_RESPONSE_GAP);
         $display("* RESPONSE_TIMEOUT = %0d",RESPONSE_TIMEOUT);
         $display("* STOP_ON_ERROR = %0d",STOP_ON_ERROR);
         $display("* CHANNEL_LEVEL_INFO = %0d",CHANNEL_LEVEL_INFO);
         $display("* FUNCTION_LEVEL_INFO = %0d",FUNCTION_LEVEL_INFO);
         $display("*********************************************************");
        
      end
   endtask

   //------------------------------------------------------------------------
   // Include Common Checker Tasks
   //------------------------------------------------------------------------


//----------------------------------------------------------------------------
// Project    : Pheidippides
// Company    : Cadence Design Systems
//----------------------------------------------------------------------------
// Description: 
// This file contains the common checkers required for the Cadence AXI 4 BFMs.
// The reason for putting them here is so that the Master and Slave BFMs can
// leverage from common checks. This also makes maintenance easier.
//----------------------------------------------------------------------------

//------------------------------------------------------------------------
// CHECKING TASKS
//------------------------------------------------------------------------

//------------------------------------------------------------------------
// CHECKING TASK: check_burst_type
//------------------------------------------------------------------------
// Description:
// AXI 3 Spec (section 4.4) says the following types of burst are valid:
// b00 - FIXED
// b01 - INCR
// b10 - WRAP
// b11 - Reserved - This will be marked as an error.
//------------------------------------------------------------------------
task automatic check_burst_type;
   input [`AXI4_BURST_BUS_WIDTH-1:0]  burst_type;
   begin
      if (burst_type === 2'b11) begin
         $display("[%0d] : %s : ERROR : Burst type cannot be equal to 2'b11 as this is RESERVED - AMBA AXI SPEC V2 - Section 4.4 Burst type",$time,NAME);
         if(STOP_ON_ERROR == 1) begin
           $display("*** TEST FAILED");
           $stop;
         end
         error_count = error_count+1;
      end
   end
endtask

//------------------------------------------------------------------------
// CHECKING TASK: check_burst_length
//------------------------------------------------------------------------
// Description:
// check_burst_length(burst_type,length,lock_type)
// AXI 3 say the following types of burst length are valid:
// - if the burst type = WRAP then length must be either 2,4,8 or 16
// NOTE: The length value is encoded as 4'b0000 = 1, 4'b0001 = 2 etc.
// AXI 4 Allows burst of up to 256 beats but only for INCR burst.
// Exclusive accessares are not permitted to use a burst length of more
// than 16 beats.
//------------------------------------------------------------------------
task automatic check_burst_length;
   input [`AXI4_BURST_BUS_WIDTH-1:0]  burst_type;
   input [`AXI4_LENGTH_BUS_WIDTH-1:0] length;
   input [`AXI4_LOCK_BUS_WIDTH-1:0]   lock_type;
   reg                           ok;
   begin
      if (burst_type === `AXI4_BURST_TYPE_WRAP) begin
         case (length)
           4'b0001 : ok = 1'b1; // 4'b0001 = length 2
           4'b0011 : ok = 1'b1; // 4'b0011 = length 4
           4'b0111 : ok = 1'b1; // 4'b0111 = length 8
           4'b1111 : ok = 1'b1; // 4'b1111 = length 16
           default : begin
              $display("[%0d] : %s : *ERROR : Burst length cannot be equal to %0d when the burst type is WRAP. It must be either 2,4,8 or 16 - AMBA AXI SPEC V2 - Section 4.2 Burst length",$time,NAME,decode_burst_length(length));
              if(STOP_ON_ERROR == 1) begin
                $display("*** TEST FAILED");
                $stop;
              end
              error_count = error_count+1;
           end
         endcase            
      end
      // AXI 4 - Only Non exclusive bursts of type INCR are allowed to be
      // longer than 16 beats.
      if (decode_burst_length(length) > 16) begin
         if (burst_type !== `AXI4_BURST_TYPE_INCR) begin
              $display("[%0d] : %s : *ERROR : Burst length cannot be greater than 16 when the burst type is not INCR. - AMBA AXI SPEC V2 - AXI 4 Section 13.1.3 Burst Support - Limitations of use",$time,NAME);
              if(STOP_ON_ERROR == 1) begin
                $display("*** TEST FAILED");
                $stop;
              end
              error_count = error_count+1;
         end
         if (lock_type === `AXI4_LOCK_TYPE_EXCLUSIVE) begin
              $display("[%0d] : %s : *ERROR : Burst length cannot be greater than 16 when the burst is an exclusive accesses. - AMBA AXI SPEC V2 - AXI 4 Section 13.1.3 Burst Support - Limitations of use",$time,NAME);
              if(STOP_ON_ERROR == 1) begin
                $display("*** TEST FAILED");
                $stop;
              end
              error_count = error_count+1;
         end
         
      end
      
   end
endtask

//------------------------------------------------------------------------
// CHECKING TASK: check_burst_size
//------------------------------------------------------------------------
// Description:
// check_burst_size(size)
// AXI 3 Spec (section 4.3) says the size of a burst cannot be greater
// than the size of the data bus width.
//------------------------------------------------------------------------
task automatic check_burst_size;
   input [`AXI4_SIZE_BUS_WIDTH-1:0]  size;
   begin
      if (transfer_size_in_bytes(size) > (DATA_BUS_WIDTH/8)) begin
         $display("[%0d] : %s : *ERROR : Burst size cannot be greater than the data bus width - AMBA AXI SPEC V2 - Section 4.3 Burst size",$time,NAME);
         if(STOP_ON_ERROR == 1) begin
           $display("*** TEST FAILED");
           $stop;
         end
         error_count = error_count+1;
      end
   end
endtask

//------------------------------------------------------------------------
// CHECKING TASK: check_lock_type
//------------------------------------------------------------------------
// Description:
// check_lock_type(lock_type)
// AXI 4 Spec (section 13.15.1) says the following types of lock are valid:
// b0 - Normal Access
// b1 - Exclusive Access
//------------------------------------------------------------------------
task automatic check_lock_type;
   input [`AXI4_LOCK_BUS_WIDTH-1:0]  lock_type;
   begin
      if (lock_type > 1 ) begin
         $display("[%0d] : %s : *ERROR : Lock type cannot be greater than 1 as this should be implemented as a single bit in AXI 4. - AMBA AXI SPEC V2 - Section 13.15.1 AWLOCK and ARLOCK changes",$time,NAME);
         if(STOP_ON_ERROR == 1) begin
           $display("*** TEST FAILED");
           $stop;
         end
         error_count = error_count+1;
      end
   end
endtask

//------------------------------------------------------------------------
// CHECKING TASK: check_cache_type
//------------------------------------------------------------------------
// Description:
// check_cache_type(cache_type)
// AXI 4 Spec (section 13.8) says the following types of cache bit 
// combinations are reserved and will be marked as an error.
// b0100 - Reserved
// b0101 - Reserved
// b1000 - Reserved
// b1001 - Reserved
// b1100 - Reserved 
// b1101 - Reserved 
//------------------------------------------------------------------------
task automatic check_cache_type;
   input [`AXI4_CACHE_BUS_WIDTH-1:0]  cache_type;
   reg                           ok;
   begin
      case (cache_type)
        4'b0100 : ok = 1'b0;
        4'b0101 : ok = 1'b0;
        4'b1000 : ok = 1'b0;
        4'b1001 : ok = 1'b0;
        4'b1100 : ok = 1'b0;
        4'b1101 : ok = 1'b0;
        default : ok = 1'b1;
      endcase
      
      if (ok ==1'b0) begin
         $display("[%0d] : %s : *ERROR : CACHE type cannot be equal to %4b as this is RESERVED - AMBA AXI SPEC V2 - AXI 4 Section 13.8 Cache support",$time,NAME,cache_type);
         if(STOP_ON_ERROR == 1) begin
           $display("*** TEST FAILED");
           $stop;
         end
         error_count = error_count+1;
      end
   end
endtask

//------------------------------------------------------------------------
// CHECKING TASK: check_address
//------------------------------------------------------------------------
// Description:
// check_address(address,burst_type,size)
// If the burst type = WRAP then address must be aligned relative to the 
// burst size.
//------------------------------------------------------------------------
task automatic check_address;
   input [ADDRESS_BUS_WIDTH-1:0] address;
   input [`AXI4_BURST_BUS_WIDTH-1:0]  burst_type;
   input [`AXI4_SIZE_BUS_WIDTH-1:0]   size;
   integer                       address_offset;
   integer                       trans_size_in_bytes;
   begin
      trans_size_in_bytes = transfer_size_in_bytes(size);
      address_offset = address-((address/trans_size_in_bytes)*(trans_size_in_bytes));
      if (burst_type === `AXI4_BURST_TYPE_WRAP && address_offset !== 0) begin
         $display("[%0d] : %s : *ERROR : When the burst type is equal to WRAP the start address must be aligned to the size of the transfer - AMBA AXI SPEC V2 - Section 4.4.3 Burst length",$time,NAME);
         if(STOP_ON_ERROR == 1) begin
           $display("*** TEST FAILED");
           $stop;
         end
         error_count = error_count+1;
      end
   end
endtask

//------------------------------------------------------------------------
// COMMON FUNCTION: transfer_size_in_bytes
//------------------------------------------------------------------------
// Description:
// transfer_size_in_bytes(size)
// This function takes the transfer size input and decodes it into the
// integer number of bytes in the transfer.
//------------------------------------------------------------------------
function automatic integer transfer_size_in_bytes;
   input [`AXI4_SIZE_BUS_WIDTH-1:0]   size;
   begin
      case (size)
        `AXI4_BURST_SIZE_1_BYTE    : transfer_size_in_bytes = 1;
        `AXI4_BURST_SIZE_2_BYTES   : transfer_size_in_bytes = 2;
        `AXI4_BURST_SIZE_4_BYTES   : transfer_size_in_bytes = 4;
        `AXI4_BURST_SIZE_8_BYTES   : transfer_size_in_bytes = 8;
        `AXI4_BURST_SIZE_16_BYTES  : transfer_size_in_bytes = 16;
        `AXI4_BURST_SIZE_32_BYTES  : transfer_size_in_bytes = 32;
        `AXI4_BURST_SIZE_64_BYTES  : transfer_size_in_bytes = 64;
        `AXI4_BURST_SIZE_128_BYTES : transfer_size_in_bytes = 128;
      endcase
   end
endfunction

//------------------------------------------------------------------------
// COMMON FUNCTION: decode_burst_length
//------------------------------------------------------------------------
// Description:
// decode_burst_length(length)
// This function takes the burst length and decodes it into an integer
// number.
//------------------------------------------------------------------------
function automatic integer decode_burst_length;
   input [`AXI4_LENGTH_BUS_WIDTH-1:0] length;
   begin
      // Take the length and increment it in a second step
      decode_burst_length = length;
      decode_burst_length = decode_burst_length+1;
   end
endfunction

//------------------------------------------------------------------------
// FUNCTION: calculate_strobe
//------------------------------------------------------------------------
// Description:
// calculate_strobe(transfer_number,address,length,size,burst_type)
// This function calculates the strobe signals based on the transfer 
// number, burst type, burst size and data bus size.
// NOTE: From the AXI spec, section 9.3  narrorw transfers "In a fixed
// burst the address remains constant and the byte lanes used are also
// constant."
// NOTE: The formulas used here are from the AMBA AXI spec, section 4.5 
// burst address.
//------------------------------------------------------------------------
function automatic [(DATA_BUS_WIDTH/8)-1:0] calculate_strobe;
   input integer transfer_number;
   input [ADDRESS_BUS_WIDTH-1:0] address;
   input [`AXI4_LENGTH_BUS_WIDTH-1:0] length;
   input [`AXI4_SIZE_BUS_WIDTH-1:0]   size;
   input [`AXI4_BURST_BUS_WIDTH-1:0]  burst_type;

   integer                       Start_Address;
   integer                       Number_Bytes;
   integer                       Data_Bus_Bytes;
   integer                       Aligned_Address;
   integer                       Burst_Length;
   integer                       Address_N;
   integer                       Wrap_Boundary;
   integer                       Lower_Byte_Lane;
   integer                       Upper_Byte_Lane;
   integer                       strobe_index;
   
   begin
      // Initialize local variables
      transfer_number = transfer_number+1;
      
      Start_Address = address;
      Number_Bytes = transfer_size_in_bytes(size);
      Burst_Length = decode_burst_length(length);
      Aligned_Address = (Start_Address/Number_Bytes)*Number_Bytes;
      Data_Bus_Bytes = (DATA_BUS_WIDTH/8);
      
                        
      if (transfer_number == 1 || burst_type == `AXI4_BURST_TYPE_FIXED) begin
         // First transfer
         Address_N = Start_Address;

         // Calculate Byte Enable Ranges for generating the first strobe.
         Lower_Byte_Lane = Start_Address - ((Start_Address/Data_Bus_Bytes)*Data_Bus_Bytes);
         Upper_Byte_Lane = Aligned_Address + (Number_Bytes-1) - ((Start_Address/Data_Bus_Bytes)*Data_Bus_Bytes);
         
      end
      else begin
         // Subsequent transfers
         Address_N = Aligned_Address+((transfer_number-1)*Number_Bytes);

         // For Wrapped transfers work out the wrap boundary.
         if (burst_type == `AXI4_BURST_TYPE_WRAP) begin
            Wrap_Boundary = (Start_Address/(Number_Bytes*Burst_Length))*(Number_Bytes*Burst_Length);
            if (Address_N == (Wrap_Boundary+(Number_Bytes*Burst_Length))) begin
               Address_N = Wrap_Boundary;
            end
            else begin
               // If the current address is over the wrap boundary then recalculate the address.
               if(Address_N > (Wrap_Boundary+(Number_Bytes*Burst_Length))) begin
                  Address_N = Start_Address + ((transfer_number-1)*Number_Bytes) - (Number_Bytes*Burst_Length);
               end
            end
         end
         // Calculate Byte Enable Ranges for generating the subsequent strobes.
         Lower_Byte_Lane = Address_N - ((Address_N/Data_Bus_Bytes)*Data_Bus_Bytes);
         Upper_Byte_Lane = Lower_Byte_Lane + Number_Bytes - 1;
         
      end
      
      // Using the Upper and Lower Byte Lane ranges, generate the strobe signal.
      calculate_strobe = 0;
      
      for (strobe_index = Lower_Byte_Lane; strobe_index <= Upper_Byte_Lane; strobe_index = strobe_index+1) begin
         calculate_strobe[strobe_index] = 1;
      end
      
//      $display("STROBE : %s : t = %0d : calculate_strobe = 4'b%4b : address = 0x%h : burst_type = %0d : transfer size = %0d",NAME,transfer_number,calculate_strobe, address, burst_type,Number_Bytes);
//      $display("STROBE : %s : t = %0d : Lower_Byte_Lane = %0d : Upper_Byte_Lane = %0d",NAME,transfer_number,Lower_Byte_Lane,Upper_Byte_Lane);
      
   end
endfunction

//------------------------------------------------------------------------
// FUNCTION: calculate_response
//------------------------------------------------------------------------
// Description:
// calculate_response(lock_type)
// This function calculates the correct response based on the lock_type. 
// i.e. OKAY or EXOKAY
//------------------------------------------------------------------------
function automatic [`AXI4_RESP_BUS_WIDTH-1:0] calculate_response;
   input [`AXI4_LOCK_BUS_WIDTH-1:0]  lock_type;
   begin
      case (lock_type) 
        `AXI4_LOCK_TYPE_NORMAL : calculate_response = `AXI4_RESPONSE_OKAY;
        `AXI4_LOCK_TYPE_EXCLUSIVE : begin
           if (EXCLUSIVE_ACCESS_SUPPORTED == 1) begin
             calculate_response = `AXI4_RESPONSE_EXOKAY;
           end
           else begin
             calculate_response = `AXI4_RESPONSE_OKAY;
           end
        end
        default: calculate_response = `AXI4_RESPONSE_SLVERR;
      endcase
   end
endfunction

//------------------------------------------------------------------------
// API TASKS/FUNCTIONS
//------------------------------------------------------------------------

//------------------------------------------------------------------------
// API TASK: set_channel_level_info
//------------------------------------------------------------------------
// set_channel_level_info(level)
// Description:
// This function sets the CHANNEL_LEVEL_INFO internal variable to the 
// specified input value.
//------------------------------------------------------------------------
task automatic set_channel_level_info;
   input level;
   begin
      $display("[%0d] : %s : *INFO : Setting CHANNEL_LEVEL_INFO to %0d",$time,NAME,level);
      CHANNEL_LEVEL_INFO = level;
   end
endtask

//------------------------------------------------------------------------
// API TASK: set_function_level_info
//------------------------------------------------------------------------
// set_function_level_info(level)
// Description:
// This function sets the FUNCTION_LEVEL_INFO internal variable to the 
// specified input value.
//------------------------------------------------------------------------
task automatic set_function_level_info;
   input level;
   begin
      $display("[%0d] : %s : *INFO : Setting FUNCTION_LEVEL_INFO to %0d",$time,NAME,level);
      FUNCTION_LEVEL_INFO = level;
   end
endtask

//------------------------------------------------------------------------
// API TASK: set_stop_on_error
//------------------------------------------------------------------------
// set_stop_on_error(level)
// Description:
// This function sets the STOP_ON_ERROR internal variable to the 
// specified input value.
//------------------------------------------------------------------------
task automatic set_stop_on_error;
   input level;
   begin
      $display("[%0d] : %s : *INFO : Setting STOP_ON_ERROR to %0d",$time,NAME,level);
      STOP_ON_ERROR = level;
   end
endtask

//------------------------------------------------------------------------
// API TASK: set_response_timeout
//------------------------------------------------------------------------
// set_response_timeout(level)
// Description:
// This function sets the RESPONSE_TIMEOUT internal variable to the 
// specified input value.
//------------------------------------------------------------------------
task automatic set_response_timeout;
   input integer level;
   begin
      $display("[%0d] : %s : *INFO : Setting RESPONSE_TIMEOUT to %0d",$time,NAME,level);
      RESPONSE_TIMEOUT = level;
   end
endtask
     
//------------------------------------------------------------------------
// UTILITY FUNCTIONS
//------------------------------------------------------------------------

//------------------------------------------------------------------------
// UTILITY FUNCTION: report_status
//------------------------------------------------------------------------
// report_status(0)
// Description:
// This function prints out the current status of the BFM. A return value
// of zero means status OK. Non-zero means errors, warnings and/or pending
// transactions.
//------------------------------------------------------------------------
function automatic integer report_status;
   input dummy_bit;
   begin
      $display("[%0d] : %s : *INFO : REPORT_STATUS : errors = %0d, warnings = %0d, pending transactions = %0d",$time,NAME,error_count,warning_count,pending_transactions_count);
      report_status = error_count + warning_count + pending_transactions_count;
   end
endfunction

//------------------------------------------------------------------------
// UTILITY TASK: add_pending_transaction;
//------------------------------------------------------------------------
// add_pending_transaction
// Description:
// This task checks the current pending transactions count and checks it
// with the value of MAX_OUTSTANDING_TRANSACTIONS. If the count is less
// than this value then the transaction can proceed, otherwise it must wait
// i.e. this task is blocking.
//------------------------------------------------------------------------
task automatic add_pending_transaction;
   reg print_message;
   begin
      print_message = 1;
      while (pending_transactions_count == MAX_OUTSTANDING_TRANSACTIONS) begin
         if (print_message == 1) begin
            $display("[%0d] : %s : *INFO : Reached the maximum outstanding transactions limit (%0d). Blocking all future transactions until at least 1 of the outstanding transactions has completed.",$time,NAME,pending_transactions_count);
            print_message = 0;
         end
         @(posedge ACLK);
      end
      pending_transactions_count = pending_transactions_count+1;
   end
endtask

//------------------------------------------------------------------------
// UTILITY TASK: remove_pending_transaction;
//------------------------------------------------------------------------
// remove_pending_transaction
// Description:
// This task decrements the pending transactions count.
//------------------------------------------------------------------------
task automatic remove_pending_transaction;
   begin
      pending_transactions_count = pending_transactions_count-1;
   end
endtask

//----------------------------------------------------------------------------
// END OF FILE
//----------------------------------------------------------------------------

   //------------------------------------------------------------------------
   // Reset Logic and Reset Check
   //------------------------------------------------------------------------
   // Algorithm:
   // 1. Display INFO Message.
   // 2. The outputs of this BFM should be driven to the correct reset values.
   // 3. The inputs to this BFM should be checked for the correct reset values.
   // NOTE: The ready signal inputs can be ignored as they may be tied to 1.
   //------------------------------------------------------------------------
   always @(posedge ACLK) begin
      if (!ARESETn) begin
         //------------------------------------------------------------------
         // Step 1. Display INFO Message
         //------------------------------------------------------------------
         $display("[%0d] : %s : *INFO : Reset detected - setting output signals to reset values and checking input signals for correct reset values.",$time,NAME);
                  
         //------------------------------------------------------------------
         // Step 2. Drive outputs to reset values.
         //------------------------------------------------------------------

         // Write Address Channel Signals.
         AWREADY <= 0;
         // Write Data Channel Signals.
         WREADY <= 0;
         // Write Response Channel Signals.
         BID <= 0;
         BRESP <= 0;
         BVALID <= 0;
         BUSER <= 0;
         
         // Read Address Channel Signals.
         ARREADY <= 0;

         // Read Data Channel Signals.
         RID <= 0;
         RDATA <= 0;
         RRESP <= 0;
         RLAST <= 0;
         RUSER <= 0;
         RVALID <= 0;

         //------------------------------------------------------------------
         // Step 3. Check input signals are at the correct reset values.
         //------------------------------------------------------------------
         // Wait a clock cycle for reset to take effect and then check reset
         // values on input signals from the master/interconnect.
         @(posedge ACLK);
         
         if (ARVALID !== 0) begin
            $display("[%0d] : %s : *ERROR : ARVALID from master is not zero (reset value) - AMBA AXI SPEC V2 - Section 11.1.2 Reset",$time,NAME);
            if(STOP_ON_ERROR == 1) begin
              $display("*** TEST FAILED");
              $stop;
            end
            error_count = error_count+1;
         end
        
         if (AWVALID !== 0) begin
            $display("[%0d] : %s : *ERROR : AWVALID from master is not zero (reset value) - AMBA AXI SPEC V2 - Section 11.1.2 Reset",$time,NAME);     
            if(STOP_ON_ERROR == 1) begin
              $display("*** TEST FAILED");
              $stop;
            end
            error_count = error_count+1;
         end

         if (WVALID !== 0) begin
            $display("[%0d] : %s : *ERROR : WVALID from master is not zero (reset value) - AMBA AXI SPEC V2 - Section 11.1.2 Reset",$time,NAME);     
            if(STOP_ON_ERROR == 1) begin
              $display("*** TEST FAILED");
              $stop;
            end
            error_count = error_count+1;
         end
         $display("[%0d] : %s : *INFO : Reset Checks Complete",$time,NAME);
      end
   end

   //------------------------------------------------------------------------
   // Reset Release Check
   //------------------------------------------------------------------------
   // Description:
   // Reset should be released on the rising edge of the ACLK.
   // It is hard to check this without assertions.
   //------------------------------------------------------------------------
   always @(posedge ARESETn) begin
      if (ACLK === 0 && $stime != 0) begin
         $display("[%0d] : %s : *ERROR : Invalid release of reset. Reset can be asserted asyncronously but must be deasserted on the rising edge of the clock - AMBA AXI SPEC V2 - Section 11.1.2 Reset",$time,NAME);     
         if(STOP_ON_ERROR == 1) begin
           $display("*** TEST FAILED");
           $stop;
         end
         error_count = error_count+1;
      end
   end

   //------------------------------------------------------------------------
   // CHANNEL LEVEL API: SEND_WRITE_RESPONSE
   //------------------------------------------------------------------------
   // Description:
   // SEND_WRITE_RESPONSE(ID,RESPONSE,BUSER)
   // Creates a write response channel transaction.
   // This task returns after the write response has been acknowledged by the 
   // master.
   //------------------------------------------------------------------------
   // Algorithm:
   // 1. Display INFO message.
   // 2. Check if the write response bus is free or locked.
   // If free: lock and continue
   // If locked: then wait until free and lock it.
   // 3. Sync to the clk and drive the Write Response Channel with BVALID
   // asserted.
   // 4. Wait for BREADY on the next clk edge and de-assert BVALID. 
   // 5. Remove pending transaction.
   // 6. Release write response bus lock.
   // 7. Emit write_response_transfer_complete event.
   //------------------------------------------------------------------------
   task automatic SEND_WRITE_RESPONSE;
      input [ID_BUS_WIDTH-1:0]    id;
      input [`AXI4_RESP_BUS_WIDTH-1:0] response;
      input [BUSER_BUS_WIDTH-1:0] buser;
      begin
         //------------------------------------------------------------------
         // Step 1. Display INFO message.
         //------------------------------------------------------------------
         if (CHANNEL_LEVEL_INFO == 1) begin
            $display("[%0d] : %s : *INFO : SEND_WRITE_RESPONSE Task Call - ",
                     $time,NAME,
                     "id = 0x%0h",id,
                     ", response = 0x%0h",response,
                     ", buser = 0x%0h",buser);
         end
         
         //------------------------------------------------------------------
         // Step 2. Check if the write response bus is free or locked.
         // If free: lock and continue
         // If locked: then wait until free and lock it.
         //------------------------------------------------------------------
         if (write_response_bus_locked == 1'b1) begin
            wait(write_response_bus_locked == 1'b0);
         end
         write_response_bus_locked = 1'b1;
         
         //------------------------------------------------------------------
         // Step 3. Sync to the clk and drive the Write Response 
         // Channel with BVALID asserted.
         //------------------------------------------------------------------
         @(posedge ACLK);
         BID <= id;
         BRESP <= response;
         BUSER <= buser;
         BVALID <= 1;

         //------------------------------------------------------------------
         // Step 4. Wait for BREADY on the next clk edge and 
         // de-assert BVALID.
         //------------------------------------------------------------------
         wait (BREADY === 1) @(posedge ACLK);
         BVALID <= 0;

         //------------------------------------------------------------------
         // Step 5. Remove pending transaction.
         //------------------------------------------------------------------
         remove_pending_transaction;

         //------------------------------------------------------------------
         // Step 6. Release write address bus lock.
         //------------------------------------------------------------------
         write_response_bus_locked = 1'b0;

         //------------------------------------------------------------------
         // Step 7. Emit write_response_transfer_complete event.
         //------------------------------------------------------------------
         -> write_response_transfer_complete;
         
      end
   endtask
   
   //------------------------------------------------------------------------
   // CHANNEL LEVEL API: SEND_READ_DATA
   //------------------------------------------------------------------------
   // Description:
   // SEND_READ_DATA(ID,DATA,RESPONSE,LAST,RUSER)
   // Creates a single read data channel transaction. If a burst is needed
   // then control of the LAST flag must be taken. The ID tag should be the
   // same as the read address ID tag it is associated with. The data should
   // be the same size as the width of the data bus. This task returns after
   // is has been acknowledged by the master. NOTE: This would need to be
   // called multiple times for a burst.
   //------------------------------------------------------------------------
   // Algorithm:
   // 1. Display INFO Message.
   // 2. Check if the read data bus is free or locked.
   // If free: lock and continue
   // If locked: then wait until free and lock it.
   // 3. Sync to the clk and drive the Read Data Channel with RVALID 
   // asserted.
   // 4. Wait for RREADY on the next clk edge and de-assert RVALID and ensure
   // that RLAST is low.
   // 5. Release read data bus lock.
   // 6. Emit read_data_transfer_complete event.
   //------------------------------------------------------------------------
   task automatic SEND_READ_DATA;
      input [ID_BUS_WIDTH-1:0]    id;
      input [DATA_BUS_WIDTH-1:0]  rd_data;
      input [`AXI4_RESP_BUS_WIDTH-1:0] response;
      input                       last;
      input [RUSER_BUS_WIDTH-1:0] ruser;
      begin
         //------------------------------------------------------------------
         // Step 1. Display INFO message.
         //------------------------------------------------------------------
         if (CHANNEL_LEVEL_INFO == 1) begin
            $display("[%0d] : %s : *INFO : SEND_READ_DATA Task Call - ",
                     $time,NAME,
                     "id = 0x%0h",id,
                     ", data = 0x%0h",rd_data,
                     ", response = 0x%0h",response,
                     ", last = 0x%0h",last,
                     ", ruser = 0x%0h",ruser);
         end

         //------------------------------------------------------------------
         // Step 2. Check if the read data bus is free or locked.
         // If free: lock and continue
         // If locked: then wait until free and lock it.
         //------------------------------------------------------------------
         if (read_data_bus_locked == 1'b1) begin
            wait(read_data_bus_locked == 1'b0);
         end
         read_data_bus_locked = 1'b1;

         //------------------------------------------------------------------
         // Step 3. Sync to the clk and drive the Read Data Channel with 
         // RVALID asserted.
         //------------------------------------------------------------------
         @(posedge ACLK);
         RID <= id;
         RDATA <= rd_data;
         RRESP <= response;
         RLAST <= last;
         RUSER <= ruser;
         RVALID <= 1;

         //------------------------------------------------------------------
         // Step 4. Wait for RREADY on the next clk edge and de-assert
         // RVALID and ensure that RLAST is low.
         //------------------------------------------------------------------
         wait (RREADY === 1) @(posedge ACLK);
         RVALID <= 0;
         RLAST <= 0;

         //------------------------------------------------------------------
         // Step 5. Release read data bus lock.
         //------------------------------------------------------------------
         read_data_bus_locked = 1'b0;

         //------------------------------------------------------------------
         // Step 6. Emit read_data_transfer_complete event.
         //------------------------------------------------------------------
         -> read_data_transfer_complete;
         
      end
   endtask

   //------------------------------------------------------------------------
   // CHANNEL LEVEL API: RECEIVE_WRITE_ADDRESS
   //------------------------------------------------------------------------
   // Description:
   // RECEIVE_WRITE_ADDRESS(ID,IDVALID,ADDR,LEN,SIZE,BURST,LOCK,CACHE,PROT,
   // REGION,QOS,AWUSER,IDTAG)
   // This task drives the AWREADY signal and monitors the write address bus
   // for write address transfers coming from the master that have the 
   // specified ID tag (unless IDVALID = 0). It then returns the data 
   // associated with the write address transaction.
   // If IDVALID = 0 then the input ID tag is ignored and the next available 
   // write address transfer is sampled.
   //------------------------------------------------------------------------
   // Algorithm:
   // 1. Display INFO Message.
   // 2. Add pending transaction.
   // 3. Drive AWREADY and Wait for AWVALID to be asserted and the AWID to be
   // the expected id unless IDVALID = 0.
   // Once the handshake is complete then sample AWADDR,AWLEN,AWSIZE,AWBURST,
   // AWLOCK,AWCACHE,AWPROT and AWID.
   // If the handshake does not occur increment the timeout counter and wait
   // for it again or timeout with error message.
   // 4. Display INFO Message containing the sampled values.
   // 5. Check if the sampled values are valid.
   // 6. De-assert AWREADY.
   // 7. Emit write_address_transfer_complete event.
   //------------------------------------------------------------------------
   task automatic RECEIVE_WRITE_ADDRESS;
      input [ID_BUS_WIDTH-1:0]  id;
      input                     idvalid;
      output [ADDRESS_BUS_WIDTH-1:0] address;
      output [`AXI4_LENGTH_BUS_WIDTH-1:0] length;
      output [`AXI4_SIZE_BUS_WIDTH-1:0]   size;
      output [`AXI4_BURST_BUS_WIDTH-1:0]  burst_type;
      output [`AXI4_LOCK_BUS_WIDTH-1:0]   lock_type;
      output [`AXI4_CACHE_BUS_WIDTH-1:0]  cache_type;
      output [`AXI4_PROT_BUS_WIDTH-1:0]   protection_type;
      output [`AXI4_REGION_BUS_WIDTH-1:0] region;
      output [`AXI4_QOS_BUS_WIDTH-1:0]    qos;
      output [AWUSER_BUS_WIDTH-1:0]  awuser;
      output [ID_BUS_WIDTH-1:0]      idtag;
      integer                        timeout_counter;
      reg                            trigger_condition;
      begin
         //------------------------------------------------------------------
         // Step 1. Display INFO message.
         //------------------------------------------------------------------
         if (CHANNEL_LEVEL_INFO == 1) begin
            $display("[%0d] : %s : *INFO : RECEIVE_WRITE_ADDRESS Task Call - "
                     ,$time,NAME,
                     "id = 0x%0h",id,
                     ", id valid = 1'b%0b", idvalid);
         end
         //------------------------------------------------------------------
         // Step 2. Add pending transaction.
         //------------------------------------------------------------------
         add_pending_transaction;
         
         //------------------------------------------------------------------
         // Step 3. Drive AWREADY and Wait for AWVALID to be asserted and 
         // the AWID to be the expected id unless IDVALID = 0.
         // Once the handshake is complete then sample AWADDR,AWLEN,AWSIZE,
         // AWBURST,AWLOCK,AWCACHE,AWPROT and AWID.
         // If the handshake does not occur increment the timeout counter and
         // wait for it again or timeout with error message.
         //------------------------------------------------------------------
         trigger_condition = 0;         
         timeout_counter = 0;
         while (!trigger_condition) @(posedge ACLK) begin
            if (idvalid === `AXI4_IDVALID_TRUE) begin
               trigger_condition = (AWVALID === 1 && AWID === id);
            end
            else begin
               AWREADY <= 1;
               trigger_condition = (AWVALID === 1 && AWREADY === 1);
            end
            
            timeout_counter = timeout_counter+1;
            if (RESPONSE_TIMEOUT != 0) begin
               if (timeout_counter == RESPONSE_TIMEOUT) begin
                  if (idvalid === `AXI4_IDVALID_TRUE) begin
                     $display("[%0d] : %s : *ERROR : RECEIVE_WRITE_ADDRESS Task TIMEOUT - ",$time,NAME,
                              " TASK timed out waiting for a WRITE ADDRESS transfer with the id = 0x%0h",id);
                  end
                  else begin
                     $display("[%0d] : %s : *ERROR : RECEIVE_WRITE_ADDRESS Task TIMEOUT - ",$time,NAME,
                              " TASK timed out waiting for a WRITE ADDRESS transfer");
                  end
                  $stop;
               end
            end
         end
         if (idvalid === `AXI4_IDVALID_TRUE) begin
            AWREADY <= 1;
            @(posedge ACLK);
         end
         // Sample AWADDR,AWLEN,AWSIZE,AWBURST,AWLOCK,AWCACHE,AWPROT,AWID
         // AWREGION, AWQOS and AWUSER signals.
         address = AWADDR;
         length = AWLEN;
         size = AWSIZE;
         burst_type = AWBURST;
         lock_type = AWLOCK;
         cache_type = AWCACHE;
         protection_type = AWPROT;
         region = AWREGION;
         qos = AWQOS;
         awuser = AWUSER;
         idtag = AWID;
         
         //------------------------------------------------------------------
         // Step 4. Display INFO Message containing the sampled values.
         //------------------------------------------------------------------
         if (CHANNEL_LEVEL_INFO == 1) begin
            $display("[%0d] : %s : *INFO : RECEIVE_WRITE_ADDRESS Task - ",
                     $time,NAME,
                     "id = 0x%0h",idtag,
                     ", address = 0x%0h",address,
                     ", length = %0d",decode_burst_length(length),
                     ", size = %0d",transfer_size_in_bytes(size),
                     ", burst_type = 0x%0h",burst_type,
                     ", lock_type = 0x%0h",lock_type,
                     ", cache_type = 0x%0h",cache_type,
                     ", protection_type = 0x%0h",protection_type,
                     ", region = 0x%0h",region,
                     ", qos = 0x%0h",qos,
                     ", awuser = 0x%0h",awuser);
         end
         
         //------------------------------------------------------------------
         // Step 5. Check if the sampled values are valid.
         //------------------------------------------------------------------
         check_burst_type(burst_type);
         check_burst_length(burst_type,length,lock_type);
         check_burst_size(size);
         check_lock_type(lock_type);
         check_cache_type(cache_type);
         check_address_range(address,length,burst_type);
         check_address(address,burst_type,size);
         
         //------------------------------------------------------------------
         // Step 6. De-assert AWREADY.
         //------------------------------------------------------------------
         AWREADY <= 0;

         //------------------------------------------------------------------
         // Step 7. Emit write_address_transfer_complete event.
         //------------------------------------------------------------------
         -> write_address_transfer_complete;
         
      end
   endtask

   //------------------------------------------------------------------------
   // CHANNEL LEVEL API: RECEIVE_READ_ADDRESS
   //------------------------------------------------------------------------
   // Description:
   // RECEIVE_READ_ADDRESS(ID,IDVALID,ADDR,LEN,SIZE,BURST,LOCK,CACHE,PROT,
   // REGION,QOS,ARUSER,IDTAG)
   // This task drives the ARREADY signal and monitors the read address bus
   // for read address transfers coming from the master that have the 
   // specified ID tag (unless IDVALID = 0). It then returns the data 
   // associated with the read address transaction.
   // If IDVALID = 0 then the input ID tag is ignored and the next available 
   // read address transfer is sampled.
   //------------------------------------------------------------------------
   // Algorithm:
   // 1. Display INFO Message.
   // 2. Add pending transaction.
   // 3. Drive ARREADY and Wait for ARVALID to be asserted and the ARID to be
   // the expected id unless IDVALID = 0.
   // Once the handshake is complete then sample ARADDR,ARLEN,ARSIZE,ARBURST
   // ARLOCK,ARCACHE,ARPROT and ARID.
   // If the handshake does not occur increment the timeout counter and wait 
   // for it again or timeout with error message.
   // 4. Display INFO Message containing the sampled values.
   // 5. Check if the sampled values are valid.
   // 6. De-assert ARREADY.
   // 7. Emit read_address_transfer_complete event.
   //------------------------------------------------------------------------
   task automatic RECEIVE_READ_ADDRESS;
      input [ID_BUS_WIDTH-1:0]       id;
      input                          idvalid;
      output [ADDRESS_BUS_WIDTH-1:0] address;
      output [`AXI4_LENGTH_BUS_WIDTH-1:0] length;
      output [`AXI4_SIZE_BUS_WIDTH-1:0]   size;
      output [`AXI4_BURST_BUS_WIDTH-1:0]  burst_type;
      output [`AXI4_LOCK_BUS_WIDTH-1:0]   lock_type;
      output [`AXI4_CACHE_BUS_WIDTH-1:0]  cache_type;
      output [`AXI4_PROT_BUS_WIDTH-1:0]   protection_type;
      output [`AXI4_REGION_BUS_WIDTH-1:0] region;
      output [`AXI4_QOS_BUS_WIDTH-1:0]    qos;
      output [ARUSER_BUS_WIDTH-1:0]  aruser;
      output [ID_BUS_WIDTH-1:0]      idtag;
      integer                        timeout_counter;
      reg                            trigger_condition;
      begin
         //------------------------------------------------------------------
         // Step 1. Display INFO message.
         //------------------------------------------------------------------
         if (CHANNEL_LEVEL_INFO == 1) begin
            $display("[%0d] : %s : *INFO : RECEIVE_READ_ADDRESS Task Call - "
                     ,$time,NAME,
                     "id = 0x%0h",id,
                     ", id valid = 1'b%0b", idvalid);
         end

         //------------------------------------------------------------------
         // Step 2. Add pending transaction.
         //------------------------------------------------------------------
         add_pending_transaction;

         //------------------------------------------------------------------
         // Step 3. Drive ARREADY and Wait for ARVALID to be asserted and the
         // ARID to be the expected id unless IDVALID = 0.
         // Once the handshake is complete then sample ARADDR,ARLEN,ARSIZE,
         // ARBURST,ARLOCK,ARCACHE,ARPROT and ARID.
         // If the handshake does not occur increment the timeout counter and
         // wait for it again or timeout with error message.
         //------------------------------------------------------------------
         trigger_condition = 0;         
         timeout_counter = 0;
         while (!trigger_condition) @(posedge ACLK) begin
            if (idvalid === `AXI4_IDVALID_TRUE) begin
               trigger_condition = (ARVALID === 1 && ARID === id);
            end
            else begin
               ARREADY <= 1;
               trigger_condition = (ARVALID === 1 && ARREADY === 1);
            end
            
            timeout_counter = timeout_counter+1;
            if (RESPONSE_TIMEOUT != 0) begin
               if (timeout_counter == RESPONSE_TIMEOUT) begin
                  if (idvalid === `AXI4_IDVALID_TRUE) begin
                     $display("[%0d] : %s : *ERROR : RECEIVE_READ_ADDRESS Task TIMEOUT - ",$time,NAME,
                              " TASK timed out waiting for a READ ADDRESS transfer with the id = 0x%0h",id);
                  end
                  else begin
                     $display("[%0d] : %s : *ERROR : RECEIVE_READ_ADDRESS Task TIMEOUT - ",$time,NAME,
                              " TASK timed out waiting for a READ ADDRESS transfer");
                  end
                  $stop;
               end
            end
         end
         if (idvalid === `AXI4_IDVALID_TRUE) begin
            ARREADY <= 1;
            @(posedge ACLK);
         end
         // Sample ARADDR, ARLEN,ARSIZE,ARBURST,ARLOCK,ARCACHE,ARPROT and ARID
         // signals.
         address = ARADDR;
         length = ARLEN;
         size = ARSIZE;
         burst_type = ARBURST;
         lock_type = ARLOCK;
         cache_type = ARCACHE;
         protection_type = ARPROT;
         region = ARREGION;
         qos = ARQOS;
         aruser = ARUSER;
         idtag = ARID;

         //------------------------------------------------------------------
         // Step 4. Display INFO Message containing the sampled values.
         //------------------------------------------------------------------
         if (CHANNEL_LEVEL_INFO == 1) begin
            $display("[%0d] : %s : *INFO : RECEIVE_READ_ADDRESS Task - ",
                     $time,NAME,
                     "id = 0x%0h",idtag,
                     ", address = 0x%0h",address,
                     ", length = %0d",decode_burst_length(length),
                     ", size = %0d",transfer_size_in_bytes(size),
                     ", burst_type = 0x%0h",burst_type,
                     ", lock_type = 0x%0h",lock_type,
                     ", cache_type = 0x%0h",cache_type,
                     ", protection_type = 0x%0h",protection_type,
                     ", region = 0x%0h",region,
                     ", qos = 0x%0h",qos,
                     ", aruser = 0x%0h",aruser);
         end

         //------------------------------------------------------------------
         // Step 5. Check if the sampled values are valid.
         //------------------------------------------------------------------
         check_burst_type(burst_type);
         check_burst_length(burst_type,length,lock_type);
         check_burst_size(size);
         check_lock_type(lock_type);
         check_cache_type(cache_type);
         check_address_range(address,length,burst_type);
         check_address(address,burst_type,size);
         
         //------------------------------------------------------------------
         // Step 6. De-assert ARREADY.
         //------------------------------------------------------------------
         ARREADY <= 0;

         //------------------------------------------------------------------
         // Step 7. Emit read_address_transfer_complete event.
         //------------------------------------------------------------------
         -> read_address_transfer_complete;
         
      end
   endtask
   
   //------------------------------------------------------------------------
   // CHANNEL LEVEL API: RECEIVE_WRITE_DATA
   //------------------------------------------------------------------------
   // Description:
   // RECEIVE_WRITE_DATA(DATA,STROBE,LAST,WUSER)
   // This task drives the WREADY signal and monitors the write data bus for
   // write transfers coming from the master.
   // It then returns the data associated with the transaction and the status
   // of the last flag. NOTE: This would need to be called multiple times for
   // a burst > 1.
   //------------------------------------------------------------------------
   // Algorithm:
   // 1. Display INFO Message.
   // 2. Drive WREADY and Wait for WVALID to be asserted.
   // If the handshake occurs then sample WDATA, WSTRB and WLAST
   // If not reassert WREADY, increment the timeout counter and wait 
   // for the next handshake or timeout with error message.
   // 3. Display INFO Message containing the sampled values.
   // 4. De-assert WREADY.
   // 5. Emit write_data_transfer_complete event.
   //------------------------------------------------------------------------
   task automatic RECEIVE_WRITE_DATA;
      output [DATA_BUS_WIDTH-1:0]     wr_data;
      output [(DATA_BUS_WIDTH/8)-1:0] strb;
      output                          last;
      output [WUSER_BUS_WIDTH-1:0]    wuser;
      integer                         timeout_counter;
      reg                             trigger_condition;
      begin
         //------------------------------------------------------------------
         // Step 1. Display INFO message.
         //------------------------------------------------------------------
         if (CHANNEL_LEVEL_INFO == 1) begin
            $display("[%0d] : %s : *INFO : RECEIVE_WRITE_DATA Task Call - ",
                     $time,NAME);
         end

         //------------------------------------------------------------------
         // Step 2. Drive WREADY and Wait for WVALID to be asserted.
         // If the handshake occurs then sample WDATA, WSTRB, and WLAST
         // If not reassert WREADY, increment the timeout counter and wait 
         // for the next handshake or timeout with error message.
         //------------------------------------------------------------------
         trigger_condition = 0;         
         timeout_counter = 0;
         while (!trigger_condition) @(posedge ACLK) begin
            WREADY <= 1;
            trigger_condition = (WVALID === 1 && WREADY === 1);
            
            timeout_counter = timeout_counter+1;
            if (RESPONSE_TIMEOUT != 0) begin
               if (timeout_counter == RESPONSE_TIMEOUT) begin
                  $display("[%0d] : %s : *ERROR : RECEIVE_WRITE_DATA Task TIMEOUT - ",$time,NAME,
                           "TASK timed out waiting for a WRITE DATA transfer");
                  $stop;
               end
            end
         end
         // Sample the signals.
         wr_data = WDATA;
         strb = WSTRB;
         wuser = WUSER;
         last = WLAST;

         //------------------------------------------------------------------
         // Step 3. Display INFO Message containing the sampled values.
         //------------------------------------------------------------------
         if (CHANNEL_LEVEL_INFO == 1) begin
            $display("[%0d] : %s : *INFO : RECEIVE_WRITE_DATA Task - ",
                     $time,NAME,
                     "wr_data = 0x%0h",wr_data,
                     ", strobe = 0x%0h",strb,
                     ", last = 0x%0h",last,
                     ", wuser = 0x%0h",wuser);
         end

         //------------------------------------------------------------------
         // Step 4. De-assert WREADY.
         //------------------------------------------------------------------
         WREADY <= 0;

         //------------------------------------------------------------------
         // Step 5. Emit write_data_transfer_complete event.
         //------------------------------------------------------------------
         -> write_data_transfer_complete;
         
      end
   endtask

   //------------------------------------------------------------------------
   // CHANNEL LEVEL API: SEND_READ_BURST
   //------------------------------------------------------------------------
   // Description:
   // SEND_READ_BURST(ID,ADDR,LEN,SIZE,BURST,LOCK,DATA,RUSER)
   // This task does a read burst on the read data lines. It does not 
   // wait for the read address transfer to be received.
   // This task uses the SEND_READ_DATA task from the channel level API. 
   // This task returns when the complete read burst is complete.
   // This task automatically supports the generation of narrow transfers and
   // unaligned transfers i.e. this task aligns the input data with the 
   // burst so data padding is not required.
   //------------------------------------------------------------------------
   // Algorithm:
   // 1. Display INFO Message.
   // 2. Generate the appropriate read burst based on the input data and the
   // input parameters.
   // Call the SEND_READ_DATA task to start sending the read data onto the
   // read data channel. This needs to be done until the burst is complete
   // and the last burst is marked with the last signal asserted.
   // 3. Remove pending transaction.
   // 4. Emit read_data_burst_complete event.
   //------------------------------------------------------------------------
   task automatic SEND_READ_BURST;
      input [ID_BUS_WIDTH-1:0]  id;
      input [ADDRESS_BUS_WIDTH-1:0] address;
      input [`AXI4_LENGTH_BUS_WIDTH-1:0] length;
      input [`AXI4_SIZE_BUS_WIDTH-1:0]   size;
      input [`AXI4_BURST_BUS_WIDTH-1:0]  burst_type;
      input [`AXI4_LOCK_BUS_WIDTH-1:0]   lock_type;
      input [(DATA_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] rd_data;
      input [(RUSER_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] v_ruser;
      reg [DATA_BUS_WIDTH-1:0]    rd_data_slice;
      reg [RUSER_BUS_WIDTH-1:0]   ruser;
      reg [`AXI4_RESP_BUS_WIDTH-1:0]   response;
      reg                         last;
      reg [(DATA_BUS_WIDTH/8)-1:0] strobe;
      integer                      rd_transfer_count;
      integer                      trans_size_in_bytes;
      integer                      byte_number;
      integer                      slice_byte_number;
      integer                      strobe_index;
      begin
         //------------------------------------------------------------------
         // Step 1. Display INFO message.
         //------------------------------------------------------------------
         if (CHANNEL_LEVEL_INFO == 1) begin
            $display("[%0d] : %s : *INFO : SEND_READ_BURST Task Call - ",
                     $time,NAME,
                     "id = 0x%0h",id);
         end
         
         //------------------------------------------------------------------
         // Step 2. Generate the appropriate read burst based on the input
         // data and the input parameters.
         // Call the SEND_READ_DATA task to start sending the read
         // data onto the read data channel. This needs to be done until the
         // burst is complete and the last burst is marked with the last 
         // signal asserted.
         //------------------------------------------------------------------

         // Work out which response type to send based on the lock type.
         response = calculate_response(lock_type);
                            
         // Send the complete write burst data
         byte_number = 0;
         for (rd_transfer_count = 0; rd_transfer_count <= length; rd_transfer_count = rd_transfer_count+1) begin
            if (rd_transfer_count == length) begin 
               last = 1;
            end
            else begin
               last = 0;
            end

            // Calculate the stobe that would be required for this type of transfer.
            strobe = calculate_strobe(rd_transfer_count,address,length,size,burst_type);
            // Align the input data to the valid bytes of the transfer.
            slice_byte_number = 0;
            for (strobe_index = 0; strobe_index < (DATA_BUS_WIDTH/8); strobe_index = strobe_index+1) begin
               if (strobe[strobe_index] == 1) begin
                  rd_data_slice[slice_byte_number*8 +: 8] = rd_data[byte_number*8 +: 8];
                  // Only increment the byte number if the byte is used.
                  byte_number = byte_number+1;
               end
               else begin 
                  rd_data_slice[slice_byte_number*8 +: 8] = 0;
               end
               slice_byte_number = slice_byte_number+1;
            end

            ruser = v_ruser[rd_transfer_count*RUSER_BUS_WIDTH +: RUSER_BUS_WIDTH];

            SEND_READ_DATA(id,rd_data_slice,response,last,ruser);
            // No need to insert a gap after the last transfer.
            if (last != 1) begin
               repeat(READ_BURST_DATA_TRANSFER_GAP) @(posedge ACLK);
            end
         end
         //------------------------------------------------------------------
         // Step 3. Remove pending transaction.
         //------------------------------------------------------------------
         remove_pending_transaction;

         //------------------------------------------------------------------
         // Step 4. Emit read_data_burst_complete event.
         //------------------------------------------------------------------
         -> read_data_burst_complete;
         
      end
   endtask

   //------------------------------------------------------------------------
   // CHANNEL LEVEL API: SEND_READ_BURST_RESP_CTRL
   //------------------------------------------------------------------------
   // Description:
   // SEND_READ_BURST_RESP_CTRL(ID,ADDR,LEN,SIZE,BURST,DATA,RESPONSE,RUSER)
   // This task does a read burst on the read data lines. It does not 
   // wait for the read address transfer to be received.
   // This task uses the SEND_READ_DATA task from the channel level API. 
   // This task returns when the complete read burst is complete.
   // This task automatically supports the generation of narrow transfers and
   // unaligned transfers i.e. this task aligns the input data with the 
   // burst so data padding is not required.
   //------------------------------------------------------------------------
   // Algorithm:
   // 1. Display INFO Message.
   // 2. Generate the appropriate read burst based on the input data and the
   // input parameters.
   // Call the SEND_READ_DATA task to start sending the read data onto the
   // read data channel. This needs to be done until the burst is complete
   // and the last burst is marked with the last signal asserted.
   // 3. Remove pending transaction.
   // 4. Emit read_data_burst_complete event.
   //------------------------------------------------------------------------
   task automatic SEND_READ_BURST_RESP_CTRL;
      input [ID_BUS_WIDTH-1:0]  id;
      input [ADDRESS_BUS_WIDTH-1:0] address;
      input [`AXI4_LENGTH_BUS_WIDTH-1:0] length;
      input [`AXI4_SIZE_BUS_WIDTH-1:0]   size;
      input [`AXI4_BURST_BUS_WIDTH-1:0]  burst_type;
      input [(DATA_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] rd_data;
      input [(`AXI4_RESP_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] response;
      input [(RUSER_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] v_ruser;
      reg [DATA_BUS_WIDTH-1:0]      rd_data_slice;
      reg [RUSER_BUS_WIDTH-1:0]     ruser;
      reg                           last;
      reg [(DATA_BUS_WIDTH/8)-1:0]  strobe;
      reg [`AXI4_RESP_BUS_WIDTH-1:0]     transfer_response;
      integer                       rd_transfer_count;
      integer                       trans_size_in_bytes;
      integer                       byte_number;
      integer                       slice_byte_number;
      integer                       strobe_index;
      begin
         //------------------------------------------------------------------
         // Step 1. Display INFO message.
         //------------------------------------------------------------------
         if (CHANNEL_LEVEL_INFO == 1) begin
            $display("[%0d] : %s : *INFO : SEND_READ_BURST_RESP_CTRL Task Call - ",
                     $time,NAME,
                     "id = 0x%0h",id);
         end
         
         //------------------------------------------------------------------
         // Step 2. Generate the appropriate read burst based on the input
         // data and the input parameters.
         // Call the SEND_READ_DATA task to start sending the read
         // data onto the read data channel. This needs to be done until the
         // burst is complete and the last burst is marked with the last 
         // signal asserted.
         //------------------------------------------------------------------

         // Send the complete write burst data
         byte_number = 0;
         for (rd_transfer_count = 0; rd_transfer_count <= length; rd_transfer_count = rd_transfer_count+1) begin
            if (rd_transfer_count == length) begin 
               last = 1;
            end
            else begin
               last = 0;
            end

            // Calculate the stobe that would be required for this type of transfer.
            strobe = calculate_strobe(rd_transfer_count,address,length,size,burst_type);
            // Align the input data to the valid bytes of the transfer.
            slice_byte_number = 0;
            for (strobe_index = 0; strobe_index < (DATA_BUS_WIDTH/8); strobe_index = strobe_index+1) begin
               if (strobe[strobe_index] == 1) begin
                  rd_data_slice[slice_byte_number*8 +: 8] = rd_data[byte_number*8 +: 8];
                  // Only increment the byte number if the byte is used.
                  byte_number = byte_number+1;
               end
               else begin 
                  rd_data_slice[slice_byte_number*8 +: 8] = 0;
               end
               slice_byte_number = slice_byte_number+1;
            end

            // Work out which response for each transfer from the input
            // repsonse vector.
            transfer_response = response[rd_transfer_count*`AXI4_RESP_BUS_WIDTH +: `AXI4_RESP_BUS_WIDTH];

            ruser = v_ruser[rd_transfer_count*RUSER_BUS_WIDTH +: RUSER_BUS_WIDTH];
            SEND_READ_DATA(id,rd_data_slice,transfer_response,last,ruser);
            // No need to insert a gap after the last transfer.
            if (last != 1) begin
               repeat(READ_BURST_DATA_TRANSFER_GAP) @(posedge ACLK);
            end
         end
         //------------------------------------------------------------------
         // Step 3. Remove pending transaction.
         //------------------------------------------------------------------
         remove_pending_transaction;

         //------------------------------------------------------------------
         // Step 4. Emit read_data_burst_complete event.
         //------------------------------------------------------------------
         -> read_data_burst_complete;
      end
   endtask

   //------------------------------------------------------------------------
   // CHANNEL LEVEL API: RECEIVE_WRITE_BURST
   //------------------------------------------------------------------------
   // Description:
   // RECEIVE_WRITE_BURST(ADDR,LEN,SIZE,BURST,DATA,DATASIZE,WUSER)
   // This task receives and processes a write burst on the write data 
   // channel. It does not wait for the write address transfer to be received.
   // This task uses the RECEIVE_WRITE_DATA task from the channel level API. 
   // This task returns when the complete write burst is complete.
   // This task automatically supports narrow transfers and
   // unaligned transfers i.e. this task aligns the output data with the 
   // burst so the final output data should only contain valid data (up to
   // the size of the burst data).
   //------------------------------------------------------------------------
   // Algorithm:
   // 1. Display INFO Message.
   // 2. Call the RECEIVE_WRITE_DATA task to collect the write channel 
   // transfers associated with this burst. Keep reading data until last has
   // been flagged.
   // Check the length of the burst is correct.
   // Check the strobes are correct.
   // 3. Emit write_data_burst_complete event.
   //------------------------------------------------------------------------
   task automatic RECEIVE_WRITE_BURST;
      input [ADDRESS_BUS_WIDTH-1:0] address;
      input [`AXI4_LENGTH_BUS_WIDTH-1:0] length;
      input [`AXI4_SIZE_BUS_WIDTH-1:0]   size;
      input [`AXI4_BURST_BUS_WIDTH-1:0]  burst_type;
      output [(DATA_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] wr_data;
      output integer                                      datasize;
      output [(WUSER_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] v_wuser;
      reg [DATA_BUS_WIDTH-1:0]    wr_data_slice;
      reg [WUSER_BUS_WIDTH-1:0]   wuser;
      reg                         last;
      reg [(DATA_BUS_WIDTH/8)-1:0] strobe;
      integer                      wr_transfer_count;
      integer                      trans_size_in_bytes;
      integer                      slice_byte_number;
      integer                      strobe_index;
      begin
         //------------------------------------------------------------------
         // Step 1. Display INFO message.
         //------------------------------------------------------------------
         if (CHANNEL_LEVEL_INFO == 1) begin
            $display("[%0d] : %s : *INFO : RECEIVE_WRITE_BURST Task Call - ",
                     $time,NAME);
         end
         
         //------------------------------------------------------------------
         // Step 2. Call the RECEIVE_WRITE_DATA task to collect the write
         // channel transfers associated with this burst. Keep reading data
         // until last has been flagged.
         // Check the length of the burst is correct.
         // Check the strobes are correct.
         //------------------------------------------------------------------
         datasize = 0;
         wr_transfer_count = 0;
         last = 0;
         while (last != 1) begin
            RECEIVE_WRITE_DATA(wr_data_slice,strobe,last,wuser);

            v_wuser[wr_transfer_count*WUSER_BUS_WIDTH +: WUSER_BUS_WIDTH] = wuser;
                
            // Check the length of the burst is correct.
            if (wr_transfer_count > length) begin
               $display("[%0d] : %s : *ERROR : RECEIVE_WRITE_BURST Task - ",$time,NAME,
                        " The number of WRITE transfers is greater than the burst length i.e. length = %0d",decode_burst_length(length),
                        " != # of transfers = %0d",wr_transfer_count);
               if(STOP_ON_ERROR == 1) begin
                 $display("*** TEST FAILED");
                 $stop;
               end
               error_count = error_count+1;
            end

            // Check the strobe value for each transfer.
            check_strobe(strobe,wr_transfer_count,address,length,size,burst_type);

            // Align the valid bytes of the write transfer data to the output data vector.
            slice_byte_number = 0;
            for (strobe_index = 0; strobe_index < (DATA_BUS_WIDTH/8); strobe_index = strobe_index+1) begin
               if (strobe[strobe_index] === 1) begin
                  wr_data[datasize*8 +: 8] = wr_data_slice[slice_byte_number*8 +: 8];
                  // Only increment the byte number if the byte is used.
                  datasize = datasize+1;
               end
               slice_byte_number = slice_byte_number+1;
            end
            wr_transfer_count = wr_transfer_count+1;
         end


         // Check the final burst length was not too small.
         if (wr_transfer_count+1 < length) begin
            $display("[%0d] : %s : *ERROR : RECEIVE_WRITE_BURST Task - ",$time,NAME,
                     " The number of WRITE transfers is less than the burst length i.e. length = %0d",decode_burst_length(length),
                     " != # of transfers = %0d",wr_transfer_count);
            if(STOP_ON_ERROR == 1) begin
               $display("*** TEST FAILED");
               $stop;
            end
            error_count = error_count+1;
         end
         //------------------------------------------------------------------
         // Step 3. Emit write_data_burst_complete event.
         //------------------------------------------------------------------
         -> write_data_burst_complete;
         
      end
   endtask


   //------------------------------------------------------------------------
   // FUNCTION LEVEL API: READ_BURST_RESPOND
   //------------------------------------------------------------------------
   // Description:
   // READ_BURST_RESPOND(ID,DATA,RUSER)
   // Creates a semi-automatic response to a read request from the master. 
   // It checks if the ID tag for the read request is as expected and then
   // provides a read response using the data provided. It is composed of the
   // tasks RECEIVE_READ_ADDRESS and SEND_READ_BURST from the channel level
   // API. This task returns when the complete write transaction is complete.
   // This task automatically supports the generation of narrow transfers and
   // unaligned transfers i.e. this task aligns the input data with the 
   // burst so data padding is not required.
   //------------------------------------------------------------------------
   // Algorithm:
   // 1. Display INFO Message.
   // 2. Receive the read request with the correct ID.
   // 3. Generate the appropriate response based on the input data and the
   // parameters from the read request.
   // Call the SEND_READ_BURST task to send the read burst data onto
   // the read data channel.
   //------------------------------------------------------------------------
   task automatic READ_BURST_RESPOND;
      input [ID_BUS_WIDTH-1:0]  id;
      input [(DATA_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] rd_data;
      input [(RUSER_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] v_ruser;
      reg [ADDRESS_BUS_WIDTH-1:0] address;
      reg [`AXI4_LENGTH_BUS_WIDTH-1:0] length;
      reg [`AXI4_SIZE_BUS_WIDTH-1:0]   size;
      reg [`AXI4_BURST_BUS_WIDTH-1:0]  burst_type;
      reg [`AXI4_LOCK_BUS_WIDTH-1:0]   lock_type;
      reg [`AXI4_CACHE_BUS_WIDTH-1:0]  cache_type;
      reg [`AXI4_PROT_BUS_WIDTH-1:0]   protection_type;
      reg [`AXI4_REGION_BUS_WIDTH-1:0] region;
      reg [`AXI4_QOS_BUS_WIDTH-1:0]    qos;
      reg [ARUSER_BUS_WIDTH-1:0]  aruser;
      reg [ID_BUS_WIDTH-1:0]      idtag;
      begin
         //------------------------------------------------------------------
         // Step 1. Display INFO message.
         //------------------------------------------------------------------
         if (FUNCTION_LEVEL_INFO == 1) begin
            $display("[%0d] : %s : *INFO : READ_BURST_RESPOND Task Call - ",
                     $time,NAME,
                     "id = 0x%0h",id,
                     ", data = 0x%0h",rd_data,
                     ", ruser = 0x%0h",v_ruser);
         end
         
         //------------------------------------------------------------------
         // Step 2. Receive the read request with the correct ID.
         //------------------------------------------------------------------
         RECEIVE_READ_ADDRESS(id,`AXI4_IDVALID_TRUE,address,length,size,burst_type,lock_type,cache_type,protection_type,region,qos,aruser,idtag);
         
         //------------------------------------------------------------------
         // Step 3. Generate the appropriate response based on the input data
         // and the parameters from the read request.
         // Call the SEND_READ_BURST task to send the read burst data onto
         // the read data channel.
         //------------------------------------------------------------------
         repeat(READ_RESPONSE_GAP) @(posedge ACLK);
         SEND_READ_BURST(id,address,length,size,burst_type,lock_type,rd_data,v_ruser);

      end
   endtask

   //------------------------------------------------------------------------
   // FUNCTION LEVEL API: READ_BURST_RESP_CTRL
   //------------------------------------------------------------------------
   // Description:
   // READ_BURST_RESP_CTRL(ID,DATA,RESPONSE,RUSER)
   // Creates a semi-automatic response to a read request from the master. 
   // It checks if the ID tag for the read request is as expected and then
   // provides a read response using the data provided. It is composed of the
   // tasks RECEIVE_READ_ADDRESS and SEND_READ_BURST_RESP_CTRL from the
   // channel level API. This task returns when the complete write
   // transaction is complete.
   // This task automatically supports the generation of narrow transfers and
   // unaligned transfers i.e. this task aligns the input data with the 
   // burst so data padding is not required.
   //------------------------------------------------------------------------
   // Algorithm:
   // 1. Display INFO Message.
   // 2. Receive the read request with the correct ID.
   // 3. Generate the appropriate response based on the input data and the
   // parameters from the read request.
   // Call the SEND_READ_BURST task to send the read burst data onto
   // the read data channel.
   //------------------------------------------------------------------------
   task automatic READ_BURST_RESP_CTRL;
      input [ID_BUS_WIDTH-1:0]  id;
      input [(DATA_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] rd_data;
      input [(`AXI4_RESP_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] response;
      input [(RUSER_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] v_ruser;
      reg [ADDRESS_BUS_WIDTH-1:0] address;
      reg [`AXI4_LENGTH_BUS_WIDTH-1:0] length;
      reg [`AXI4_SIZE_BUS_WIDTH-1:0]   size;
      reg [`AXI4_BURST_BUS_WIDTH-1:0]  burst_type;
      reg [`AXI4_LOCK_BUS_WIDTH-1:0]   lock_type;
      reg [`AXI4_CACHE_BUS_WIDTH-1:0]  cache_type;
      reg [`AXI4_PROT_BUS_WIDTH-1:0]   protection_type;
      reg [`AXI4_REGION_BUS_WIDTH-1:0] region;
      reg [`AXI4_QOS_BUS_WIDTH-1:0]    qos;
      reg [ARUSER_BUS_WIDTH-1:0]  aruser;
      reg [ID_BUS_WIDTH-1:0]      idtag;
      begin
         //------------------------------------------------------------------
         // Step 1. Display INFO message.
         //------------------------------------------------------------------
         if (FUNCTION_LEVEL_INFO == 1) begin
            $display("[%0d] : %s : *INFO : READ_BURST_RESP_CTRL Task Call - ",
                     $time,NAME,
                     "id = 0x%0h",id,
                     ", response = 0x%0h",response,
                     ", data = 0x%0h",rd_data,
                     ", ruser = 0x%0h",v_ruser);
         end
         
         //------------------------------------------------------------------
         // Step 2. Receive the read request with the correct ID.
         //------------------------------------------------------------------
         RECEIVE_READ_ADDRESS(id,`AXI4_IDVALID_TRUE,address,length,size,burst_type,lock_type,cache_type,protection_type,region,qos,aruser,idtag);
         
         //------------------------------------------------------------------
         // Step 3. Generate the appropriate response based on the input data
         // and the parameters from the read request.
         // Call the SEND_READ_BURST_RESP_CTRL task to send the read burst
         // data onto the read data channel.
         //------------------------------------------------------------------
         repeat(READ_RESPONSE_GAP) @(posedge ACLK);
         SEND_READ_BURST_RESP_CTRL(id,address,length,size,burst_type,rd_data,response,v_ruser);

      end
   endtask

   //------------------------------------------------------------------------
   // FUNCTION LEVEL API: WRITE_BURST_RESPOND
   //------------------------------------------------------------------------
   // Description:
   // WRITE_BURST_RESPOND(ID,BUSER,DATA,DATASIZE,WUSER)
   // This is a semi-automatic task which waits for a write burst with the
   // specified ID tag and responds appropriately.
   // It returns the data received via the write as a data vector. It is
   // composed of the tasks RECEIVE_WRITE_ADDRESS, RECEIVE_WRITE_BURST and
   // SEND_WRITE_RESPONSE from the channel level API. This task returns when
   // the complete write transaction is complete.
   //------------------------------------------------------------------------
   // Algorithm:
   // 1. Display INFO Message.
   // 2. Recieve the write request with the specified ID tag.
   // 3. Recieve the write burst with the specified ID tag.
   // 4. Send the appropriate write response transfer. 
   // 5. Output data as an INFO message.
   //------------------------------------------------------------------------
   task automatic WRITE_BURST_RESPOND;
      input [ID_BUS_WIDTH-1:0]    id;
      input [BUSER_BUS_WIDTH-1:0] buser;
      output [(DATA_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] wr_data;
      output integer                                      datasize;
      output [(WUSER_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] v_wuser;
      reg [ADDRESS_BUS_WIDTH-1:0] address;
      reg [`AXI4_LENGTH_BUS_WIDTH-1:0] length;
      reg [`AXI4_SIZE_BUS_WIDTH-1:0]   size;
      reg [`AXI4_BURST_BUS_WIDTH-1:0]  burst_type;
      reg [`AXI4_LOCK_BUS_WIDTH-1:0]   lock_type;
      reg [`AXI4_CACHE_BUS_WIDTH-1:0]  cache_type;
      reg [`AXI4_PROT_BUS_WIDTH-1:0]   protection_type;
      reg [`AXI4_RESP_BUS_WIDTH-1:0]   response;
      reg [`AXI4_REGION_BUS_WIDTH-1:0] region;
      reg [`AXI4_QOS_BUS_WIDTH-1:0]    qos;
      reg [AWUSER_BUS_WIDTH-1:0]  awuser;
      reg [ID_BUS_WIDTH-1:0]      idtag;
      begin
         //------------------------------------------------------------------
         // Step 1. Display INFO message.
         //------------------------------------------------------------------
         if (FUNCTION_LEVEL_INFO == 1) begin
            $display("[%0d] : %s : *INFO : WRITE_BURST_RESPOND Task Call - ",
                     $time,NAME,
                     "id = 0x%0h",id);
         end
         
         //------------------------------------------------------------------
         // Step 2. Recieve the write request with the specified ID tag.
         //------------------------------------------------------------------

         RECEIVE_WRITE_ADDRESS(id,`AXI4_IDVALID_TRUE,address,length,size,burst_type,lock_type,cache_type,protection_type,region,qos,awuser,idtag);

         //------------------------------------------------------------------
         // Step 3. Recieve the write burst.
         //------------------------------------------------------------------
         RECEIVE_WRITE_BURST(address,length,size,burst_type,wr_data,datasize,v_wuser);
                  
         //------------------------------------------------------------------
         // Step 4. Send the appropriate write response transfer. 
         //------------------------------------------------------------------

         // Work out which response type to send based on the lock type.
         response = calculate_response(lock_type);
         repeat(WRITE_RESPONSE_GAP) @(posedge ACLK);
         SEND_WRITE_RESPONSE(id,response,buser);

         //------------------------------------------------------------------
         // Step 5. Display INFO message.
         //------------------------------------------------------------------
         if (FUNCTION_LEVEL_INFO == 1) begin
            $display("[%0d] : %s : *INFO : WRITE_BURST_RESPOND Task - ",
                     $time,NAME,
                     "id = 0x%0h",id,
                     ", data = 0x%0h",wr_data,
                     ", data size (in bytes) = %0d",datasize,
                     ", wuser = 0x%0h",v_wuser);
         end
      end
   endtask


   //------------------------------------------------------------------------
   // FUNCTION LEVEL API: WRITE_BURST_RESP_CTRL
   //------------------------------------------------------------------------
   // Description:
   // WRITE_BURST_RESP_CTRL(ID,RESPONSE,BUSER,DATA,DATASIZE,WUSER)
   // This is a semi-automatic task which waits for a write burst with the
   // specified ID tag and responds appropriately giving the final write
   // burst response as specifed by the response input.
   // It returns the data received via the write as a data vector. It is
   // composed of the tasks RECEIVE_WRITE_ADDRESS, RECEIVE_WRITE_BURST and
   // SEND_WRITE_RESPONSE from the channel level API. This task returns when
   // the complete write transaction is complete.
   //------------------------------------------------------------------------
   // Algorithm:
   // 1. Display INFO Message.
   // 2. Recieve the write request with the specified ID tag.
   // 3. Recieve the write burst with the specified ID tag.
   // 4. Send the write response transfer specified by the response input.
   // 5. Output data as an INFO message.
   //------------------------------------------------------------------------
   task automatic WRITE_BURST_RESP_CTRL;
      input [ID_BUS_WIDTH-1:0]  id;
      input [`AXI4_RESP_BUS_WIDTH-1:0] response;
      input [BUSER_BUS_WIDTH-1:0] buser;
      output [(DATA_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] wr_data;
      output integer                                      datasize;
      output [(WUSER_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] v_wuser;
      reg [ADDRESS_BUS_WIDTH-1:0] address;
      reg [`AXI4_LENGTH_BUS_WIDTH-1:0] length;
      reg [`AXI4_SIZE_BUS_WIDTH-1:0]   size;
      reg [`AXI4_BURST_BUS_WIDTH-1:0]  burst_type;
      reg [`AXI4_LOCK_BUS_WIDTH-1:0]   lock_type;
      reg [`AXI4_CACHE_BUS_WIDTH-1:0]  cache_type;
      reg [`AXI4_PROT_BUS_WIDTH-1:0]   protection_type;
      reg [`AXI4_REGION_BUS_WIDTH-1:0] region;
      reg [`AXI4_QOS_BUS_WIDTH-1:0]    qos;
      reg [AWUSER_BUS_WIDTH-1:0]  awuser;
      integer                     wr_transfer_count;
      integer                     bit_slice_index;
      integer                     byte_count;
      reg [(DATA_BUS_WIDTH/8)-1:0] strobe [`AXI4_LENGTH_BUS_WIDTH-1:0];
      reg [ID_BUS_WIDTH-1:0]       idtag;
      begin
         //------------------------------------------------------------------
         // Step 1. Display INFO message.
         //------------------------------------------------------------------
         if (FUNCTION_LEVEL_INFO == 1) begin
            $display("[%0d] : %s : *INFO : WRITE_BURST_RESP_CTRL Task Call - ",
                     $time,NAME,
                     "id = 0x%0h",id,
                     ", response = 0x%0h",response);
            
         end
         
         //------------------------------------------------------------------
         // Step 2. Recieve the write request with the specified ID tag.
         //------------------------------------------------------------------

         RECEIVE_WRITE_ADDRESS(id,`AXI4_IDVALID_TRUE,address,length,size,burst_type,lock_type,cache_type,protection_type,region,qos,awuser,idtag);

         //------------------------------------------------------------------
         // Step 3. Recieve the write burst.
         //------------------------------------------------------------------
         RECEIVE_WRITE_BURST(address,length,size,burst_type,wr_data,datasize,v_wuser);
                  
         //------------------------------------------------------------------
         // Step 4. Send the write response transfer specified by the 
         // response input.
         //------------------------------------------------------------------
         repeat(WRITE_RESPONSE_GAP) @(posedge ACLK);
         SEND_WRITE_RESPONSE(id,response,buser);

         //------------------------------------------------------------------
         // Step 5. Display INFO message.
         //------------------------------------------------------------------
         if (FUNCTION_LEVEL_INFO == 1) begin
            $display("[%0d] : %s : *INFO : WRITE_BURST_RESP_CTRL Task - ",
                     $time,NAME,
                     "id = 0x%0h",id,
                     ", response = 0x%0h",response,
                     ", data = 0x%0h",wr_data,
                     ", data size (in bytes) = %0d",datasize,
                     ", wuser = 0x%0h",v_wuser);
         end
      end
   endtask
   
   //------------------------------------------------------------------------
   // API TASKS/FUNCTIONS
   //------------------------------------------------------------------------

   //------------------------------------------------------------------------
   // API TASK: set_read_burst_data_transfer_gap
   //------------------------------------------------------------------------
   // set_read_burst_data_transfer_gap(gap_length)
   // Description:
   // This function sets the READ_BURST_DATA_TRANSFER_GAP internal variable
   // to the specified input value.
   //------------------------------------------------------------------------
   task automatic set_read_burst_data_transfer_gap;
      input integer gap_length;
      begin
         $display("[%0d] : %s : *INFO : Setting READ_BURST_DATA_TRANSFER_GAP to %0d",$time,NAME,gap_length);
         READ_BURST_DATA_TRANSFER_GAP = gap_length;
      end
   endtask

   //------------------------------------------------------------------------
   // API TASK: set_write_response_gap
   //------------------------------------------------------------------------
   // set_write_response_gap(gap_length)
   // Description:
   // This function sets the WRITE_RESPONSE_GAP internal variable to the 
   // specified input value.
   //------------------------------------------------------------------------
   task automatic set_write_response_gap;
      input integer gap_length;
      begin
         $display("[%0d] : %s : *INFO : Setting WRITE_RESPONSE_GAP to %0d",$time,NAME,gap_length);
         WRITE_RESPONSE_GAP = gap_length;
      end
   endtask

   //------------------------------------------------------------------------
   // API TASK: set_read_response_gap
   //------------------------------------------------------------------------
   // set_read_response_gap(gap_length)
   // Description:
   // This function sets the READ_RESPONSE_GAP internal variable to the 
   // specified input value.
   //------------------------------------------------------------------------
   task automatic set_read_response_gap;
      input integer gap_length;
      begin
         $display("[%0d] : %s : *INFO : Setting READ_RESPONSE_GAP to %0d",$time,NAME,gap_length);
         READ_RESPONSE_GAP = gap_length;
      end
   endtask

   //------------------------------------------------------------------------
   // CHECKING TASKS/FUNCTIONS
   //------------------------------------------------------------------------

   //------------------------------------------------------------------------
   // CHECKING TASK: check_address_range
   //------------------------------------------------------------------------
   // Description:
   // check_address_range(address,length,burst_type);
   // NOTE: This checking task is unique to the SLAVE BFM so is not located 
   // in the cdn_axi4_bfm_checkers.v file.
   //------------------------------------------------------------------------
   task automatic check_address_range;
      input [ADDRESS_BUS_WIDTH-1:0] address;
      input [`AXI4_LENGTH_BUS_WIDTH-1:0] length;
      input [`AXI4_BURST_BUS_WIDTH-1:0]  burst_type;
      integer                       burst_length;
      integer                       address_max;
      begin
         address_max = (SLAVE_ADDRESS+SLAVE_MEM_SIZE)-1;
         
         // Check the address is in range.
         if(address < SLAVE_ADDRESS || address > address_max) begin
            $display("[%0d] : %s : *ERROR : Address not in range! Address = 0x%0h but base address of slave is 0x%0h and the size is %0d bytes. The max address of this slave is 0x%0h.",$time,NAME,address,SLAVE_ADDRESS,SLAVE_MEM_SIZE,address_max);
            if(STOP_ON_ERROR == 1) begin
              $display("*** TEST FAILED");
              $stop;
            end
            error_count = error_count+1;
         end
         // Check the burst size is within the address range.
         burst_length = decode_burst_length(length)*(DATA_BUS_WIDTH/8);
         
         if ((address+burst_length)-1 > address_max) begin
            $display("[%0d] : %s : *ERROR : Burst is too large for slave address and size configuration. Burst address is 0x%0h and burst length = %0d bytes. Base address of slave is 0x%0h and the size is %0d bytes. The max address of this slave is 0x%0h.",$time,NAME,address,burst_length,SLAVE_ADDRESS,SLAVE_MEM_SIZE,address_max);
            if(STOP_ON_ERROR == 1) begin
              $display("*** TEST FAILED");
              $stop;
            end
            error_count = error_count+1;
         end
      end
   endtask

   //------------------------------------------------------------------------
   // CHECKING TASK: check_strobe
   //------------------------------------------------------------------------
   // Description:
   // check_strobe(strobe,transfer_number,address,length,size,burst_type)
   // Checks to see if the received strobe is equal to the expected stobe or
   // all zero strobe.
   // A zero strobe is allowed because this is how a master invalidates a 
   // burst (the burst cannot be cancelled but the data can be invalidated).
   // If the expected strobe is all ones, then the transfer is aligned so
   // the master can do what it likes with the strobe to create a valid
   // sparse transfer. Therefore, this checker passes if the expected strobe
   // is all one without comparing with the actual strobe.
   //------------------------------------------------------------------------
   task automatic check_strobe;
      input [(DATA_BUS_WIDTH/8)-1:0] strobe;
      input integer                  transfer_number;
      input [ADDRESS_BUS_WIDTH-1:0]  address;
      input [`AXI4_LENGTH_BUS_WIDTH-1:0]  length;
      input [`AXI4_SIZE_BUS_WIDTH-1:0]    size;
      input [`AXI4_BURST_BUS_WIDTH-1:0]   burst_type;
      reg [(DATA_BUS_WIDTH/8)-1:0]   calculated_strobe;
      reg [(DATA_BUS_WIDTH/8)-1:0]   all_one_strobe;
      integer                        i;
      begin
         for (i=0; i <(DATA_BUS_WIDTH/8); i=i+1) begin
            all_one_strobe[i] = 1'b1;
         end

         calculated_strobe = calculate_strobe(transfer_number,address,length,size,burst_type);
         if (calculated_strobe !== all_one_strobe) begin
            if (strobe !== calculated_strobe && strobe !== 0) begin
               $display("[%0d] : %s : *ERROR : The received strobe signal (0x%0h) is not expected (0x%0h)!",$time,NAME,strobe,calculated_strobe);
               if(STOP_ON_ERROR == 1) begin
                  $display("*** TEST FAILED");
                  $stop;
               end
               error_count = error_count+1;
            end
         end
      end
   endtask

   //------------------------------------------------------------------------
   // Memory Model
   //------------------------------------------------------------------------
   // NOTES: 
   // - The address range checking is performed in the channel level API.
   // - The control of outstanding transfers is controled via the channel 
   // level API.
   // - The data is aligned when using the channel level *_BURST tasks.
   //------------------------------------------------------------------------
   // Create a full memory array if MEMORY_MODEL_MODE is 1.
   //parameter SLAVE_MEM_DEPTH = ((SLAVE_MEM_SIZE % (DATA_BUS_WIDTH/8))*MEMORY_MODEL_MODE)+1;
   
//   reg [DATA_BUS_WIDTH-1:0] memory_array [SLAVE_MEM_DEPTH:0];

   parameter SLAVE_MEM_DEPTH = ((SLAVE_MEM_SIZE)*MEMORY_MODEL_MODE);

   reg [7:0] memory_array [SLAVE_MEM_DEPTH-1:0];
   
   
   // Display info and disable timeout.
   initial begin
      if (MEMORY_MODEL_MODE == 1) begin
         $display("[%0d] : %s : *INFO : MEMORY MODEL MODE ENABLED : Sizes in bytes : memory size = %0d memory depth = %0d, memory width = %0d",$time,NAME,SLAVE_MEM_SIZE,SLAVE_MEM_DEPTH,(DATA_BUS_WIDTH/8));
         // Disable timeout
         RESPONSE_TIMEOUT = 0;
      end
      else begin
         $display("[%0d] : %s : *INFO : MEMORY MODEL MODE DISABLED",$time,NAME);
      end
   end

   //---------------------------------------------------------------------
   // Read Path
   //---------------------------------------------------------------------
   // RECEIVE_READ_ADDRESS(ID,IDVALID,ADDR,LEN,SIZE,BURST,LOCK,CACHE,PROT,
   // IDTAG)
   // SEND_READ_BURST_RESP_CTRL(ID,ADDR,LEN,SIZE,BURST,DATA,RESPONSE)
   // SEND_READ_BURST(ID,ADDR,LEN,SIZE,BURST,LOCK,DATA)
   //---------------------------------------------------------------------
   always @(posedge ACLK) begin : READ_PATH
      // -----------------------------------------------------------------
      // Local Variables
      // -----------------------------------------------------------------
      reg [ID_BUS_WIDTH-1:0] id;
      reg [ADDRESS_BUS_WIDTH-1:0] address;
      reg [`AXI4_LENGTH_BUS_WIDTH-1:0] length;
      reg [`AXI4_SIZE_BUS_WIDTH-1:0]   size;
      reg [`AXI4_BURST_BUS_WIDTH-1:0]  burst_type;
      reg [`AXI4_LOCK_BUS_WIDTH-1:0]   lock_type;
      reg [`AXI4_CACHE_BUS_WIDTH-1:0]  cache_type;
      reg [`AXI4_PROT_BUS_WIDTH-1:0]   protection_type;
      reg [`AXI4_REGION_BUS_WIDTH-1:0] region;
      reg [`AXI4_QOS_BUS_WIDTH-1:0]    qos;
      reg [ARUSER_BUS_WIDTH-1:0]  aruser;
      reg [ID_BUS_WIDTH-1:0]      idtag;
      reg [(DATA_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] data;
      reg [ADDRESS_BUS_WIDTH-1:0]                      internal_address;
      reg [(RUSER_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] v_ruser;
      integer                                          i;
      integer                                          number_of_valid_bytes;
      
      // -----------------------------------------------------------------
      // Implementation Code
      // -----------------------------------------------------------------
      if (MEMORY_MODEL_MODE == 1) begin
         // Receive a read address transfer
         RECEIVE_READ_ADDRESS(id,`AXI4_IDVALID_FALSE,address,length,size,burst_type,lock_type,cache_type,protection_type,region,qos,aruser,idtag);

         // Get the data to send from the memory.
         internal_address = address - SLAVE_ADDRESS;
         data = 0;

         number_of_valid_bytes = (decode_burst_length(length)*transfer_size_in_bytes(size))-(address % (DATA_BUS_WIDTH/8));
           
         for (i=0; i < number_of_valid_bytes; i=i+1) begin
            data[i*8 +: 8] = memory_array[internal_address+i];
         end
         
         // Send the read data
         repeat(READ_RESPONSE_GAP) @(posedge ACLK);
         v_ruser = 0;
         SEND_READ_BURST(idtag,address,length,size,burst_type,lock_type,data,v_ruser);
           
      end
   end
   
   //---------------------------------------------------------------------
   // Write Path
   //---------------------------------------------------------------------
   // RECEIVE_WRITE_ADDRESS(ID,IDVALID,ADDR,LEN,SIZE,BURST,LOCK,CACHE,PROT,
   // IDTAG)  
   // RECEIVE_WRITE_BURST(ADDR,LEN,SIZE,BURST,DATA)
   // SEND_WRITE_RESPONSE(ID,RESPONSE)
   //---------------------------------------------------------------------
   always @(posedge ACLK) begin : WRITE_PATH
      // -----------------------------------------------------------------
      // Local Variables
      // -----------------------------------------------------------------
      reg [ID_BUS_WIDTH-1:0] id;
      reg [ADDRESS_BUS_WIDTH-1:0] address;
      reg [`AXI4_LENGTH_BUS_WIDTH-1:0] length;
      reg [`AXI4_SIZE_BUS_WIDTH-1:0]   size;
      reg [`AXI4_BURST_BUS_WIDTH-1:0]  burst_type;
      reg [`AXI4_LOCK_BUS_WIDTH-1:0]   lock_type;
      reg [`AXI4_CACHE_BUS_WIDTH-1:0]  cache_type;
      reg [`AXI4_PROT_BUS_WIDTH-1:0]   protection_type;
      reg [`AXI4_REGION_BUS_WIDTH-1:0] region;
      reg [`AXI4_QOS_BUS_WIDTH-1:0]    qos;
      reg [AWUSER_BUS_WIDTH-1:0]  awuser;
      reg [ID_BUS_WIDTH-1:0]      idtag;
      reg [BUSER_BUS_WIDTH-1:0]   buser;
      reg [(DATA_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] data;
      reg [ADDRESS_BUS_WIDTH-1:0]                      internal_address;
      reg [`AXI4_RESP_BUS_WIDTH-1:0]                        response;
      reg [(WUSER_BUS_WIDTH*(`AXI4_MAX_BURST_LENGTH+1))-1:0] v_wuser;
      integer                                          i;
      integer                                          datasize;

      // -----------------------------------------------------------------
      // Implementation Code
      // -----------------------------------------------------------------
      if (MEMORY_MODEL_MODE == 1) begin
         // Receive the next available write address
         RECEIVE_WRITE_ADDRESS(id,`AXI4_IDVALID_FALSE,address,length,size,burst_type,lock_type,cache_type,protection_type,region,qos,awuser,idtag);

         // Get the data to send to the memory.
         RECEIVE_WRITE_BURST(address,length,size,burst_type,data,datasize,v_wuser);

         // Put the data into the memory array
         internal_address = address - SLAVE_ADDRESS;

         for (i=0; i < datasize; i=i+1) begin
            memory_array[internal_address+i] = data[i*8 +: 8];
         end

         // End the complete write burst/transfer with a write response
         // Work out which response type to send based on the lock type.
         response = calculate_response(lock_type);
         repeat(WRITE_RESPONSE_GAP) @(posedge ACLK);
         buser = 0;
         SEND_WRITE_RESPONSE(idtag,response,buser);
      end
   end
   
endmodule

//----------------------------------------------------------------------------
// END OF FILE
//-----------------------------------------------------------------------