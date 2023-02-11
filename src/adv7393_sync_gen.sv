// synopsys translate_off
`timescale 1 ns / 1 ns
// synopsys translate_on

module adv7393_sync_gen
  import adv7393_pkg::*;
(
  input                          clk        ,
  input                          rst        ,
  //!
  input  ADV7393RegBlock_t       registers  ,
  //!
  output logic                   line_valid ,
  output logic [LINES_CNT_W-1:0] line       ,
  output logic                   frame_start,
  output logic                   frame_end  ,
  output logic                   line_start ,
  //!
  output logic                   hsync_n    ,
  output logic                   field
);

`define IN_RNG_SN(ITEM, LEFT, RIGHT) (((ITEM) > (LEFT)) && ((ITEM) <= (RIGHT)))
`define IN_RNG_SS(ITEM, LEFT, RIGHT) (((ITEM) > (LEFT)) && ((ITEM) < (RIGHT)))
`define IN_RNG_NS(ITEM, LEFT, RIGHT) (((ITEM) >= (LEFT)) && ((ITEM) < (RIGHT)))
`define IN_RNG_NN(ITEM, LEFT, RIGHT) (((ITEM) >= (LEFT)) && ((ITEM) <= (RIGHT)))

typedef enum int { IDLE = 0, ODD, EVEN } field_t;
//!
logic                      pulseo   ;
//!
logic [LINE_LEN_CNT_W-1:0] line_cnt ;
logic                      line_ends;
logic [   LINES_CNT_W-1:0] frame_cnt;
//!
field_t                    field_fsm;
//!
int                        actLineStart;
int                        activeLineStop;

pulse #(.WIDTH(HSYNC_W)) i_pulse (.clk(clk), .ena('1), .str(line_ends), .pulseo(pulseo));

bcnts #(.MAX(LINE_LEN_T-1), .BEHAVIOR("ROLL")) i0_bcnts (
  .clk      (clk      ),
  .aclr     (rst      ),
  .ena      ('1       ),
  .dir      ('1       ),
  .ovf      (line_ends),
  .q        (line_cnt )
);

bcnts #(.MAX(LINES-1), .BEHAVIOR("ROLL")) i1_bcnts (
  .clk (clk      ),
  .aclr(rst      ),
  .ena (line_ends),
  .dir ('1       ),
  .ovf (frame_end),
  .q   (line     )
);

always_comb begin
  hsync_n        = !pulseo;
  actLineStart   = (registers.standard.PixelsPerLine - registers.frame.LineLength) / 2;
  activeLineStop = actLineStart + registers.frame.LineLength;
end

pdet i_pdet (.clk(clk), .in(field_fsm == ODD), .out(frame_start));

always_ff @(posedge clk or posedge rst) begin
  if(rst) begin
    field_fsm   <= IDLE;
    field       <= '0;
    line_active <= '0;
    line_valid  <= '0;
    line_start  <= '0;
  end else begin
    line_start <= line_ends;

    line_valid <= `IN_RANGE_NN(line_cnt, actLineStart, activeLineStop);
    
    case(field_fsm)
      IDLE: begin
        field_fsm <= ODD;
      end
      ODD : begin
        line_active <= `IN_RANGE_NN(line, registers.standard.Odd.start, 
                                          registers.standard.Odd.stop);
        field <= '1;

        if(line >= registers.standard.LineFieldChange) 
          field_fsm <= EVEN;

      end
      EVEN : begin
        line_active <= `IN_RANGE_NN(line, registers.standard.Even.start, 
                                          registers.standard.Even.stop);
        field <= '0;
        
        if(frame_end) 
          field_fsm <= ODD;

      end
      default : field_fsm <= IDLE;
    endcase
  end
end

endmodule