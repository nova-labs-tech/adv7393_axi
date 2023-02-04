package axi_pkg;

typedef struct packed {
  logic [31:0] address;
  logic [15:0] size;
} AxiMasterRdCtrl_t;

typedef struct packed {
  logic success;
} AxiMasterRdStatus_t;

endpackage : axi_pkg