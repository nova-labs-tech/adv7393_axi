package axi_pkg;

`include "macro.svh"

// Read this for information
// AMBA® AXI and ACE Protocol Specification

typedef enum logic [2:0] {
  SIZE_1 = '0,
  SIZE_2,
  SIZE_4,
  SIZE_8,
  SIZE_16,
  SIZE_32,
  SIZE_64,
  SIZE_128
} AxiSize_t;    // In bytes

typedef enum logic [1:0] {
  FIXED = 0,
  INCR,
  WRAP,
} AxiBurst_t;

typedef enum logic [1:0] {
  OKAY = 0,   //! normal access success
  EXOKAY,     //! exclusive access success
  SLVERR,     //! Subordinate error 
  DECERR      //! decode error
} AxiResp_t;

typedef struct packed {
  logic Bufferable;
  logic Cacheable;
  logic ReadAllocate;
  logic WriteAllocate;
} AxiCache_t;

typedef struct packed {
  logic [31:0] address;
  logic [15:0] bytes;   // In bytes
} AxiMasterRdCtrl_t;

typedef struct packed {
  AxiResp_t resp;
} AxiMasterRdStatus_t;

function int axiSize2bytes(AxiSize_t size);
  axiSize2bytes = 1 << int'(size);
endfunction

function bit addressAligned(logic [31:0] address, AxiSize_t size);
  address_aligned = bit'(`ALIGNED(address, size));
endfunction

function logic [7:0] axiLen(AxiMasterRdCtrl_t ctrl, AxiSize_t size);
  axiLen = '0;
  int transSizeInBytes = axiSize2bytes(size);
  int burstLenFloor = int'(ctrl.bytes) / transSizeInBytes - 1;
  if(!`ALIGNED(ctrl.bytes, transSizeInBytes))
    axiLen = 8'(burstLenFloor);
  else 
    axiLen = 8'(burstLenFloor + 1);
endfunction

function logic axiAccepted(logic valid, logic ready);
  return valid && ready;
endfunction

function logic axiSuccess(AxiResp_t resp);
  return (resp == OKAY) || (resp == EXOKAY);
endfunction

endpackage