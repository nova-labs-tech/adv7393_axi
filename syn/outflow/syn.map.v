
//
// Verific Verilog Description of module dsync
//

module dsync (rst, clki, din, lost, clko, dout);
    input rst /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE */ ;
    input clki /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE */ ;
    input [7:0]din /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE */ ;
    output lost /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE */ ;
    input clko /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE */ ;
    output [7:0]dout /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE */ ;
    
    wire n7_2;
    
    wire mask_change, \i_bus_edet/din_d[0] , \i_bus_edet/din_d[1] , \i_bus_edet/din_d[2] , 
        \i_bus_edet/din_d[3] , \i_bus_edet/din_d[4] , \i_bus_edet/din_d[5] , 
        \i_bus_edet/din_d[6] , \i_bus_edet/din_d[7] , \i0_esync/sync_reg[2] , 
        \i0_esync/sync_reg_d , \i1_esync/sync_reg[2] , \i1_esync/sync_reg_d , 
        \clki~O , \hold[0] , dval, ceg_net2, \hold[1] , \hold[2] , 
        \hold[3] , \hold[4] , \hold[5] , \hold[6] , \hold[7] , \i0_esync/sync_reg[1] , 
        \i0_esync/sync_reg[0] , \i0_esync/toggle , change, \i1_esync/sync_reg[1] , 
        \i1_esync/sync_reg[0] , \clko~O , \i1_esync/toggle , n89, n90, 
        n91, n92;
    
    EFX_LUT4 LUT__133 (.I0(din[7]), .I1(\i_bus_edet/din_d[7] ), .I2(\i_bus_edet/din_d[6] ), 
            .I3(din[6]), .O(n89)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h9009 */ ;
    defparam LUT__133.LUTMASK = 16'h9009;
    EFX_LUT4 LUT__134 (.I0(din[5]), .I1(\i_bus_edet/din_d[5] ), .I2(\i_bus_edet/din_d[4] ), 
            .I3(din[4]), .O(n90)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h9009 */ ;
    defparam LUT__134.LUTMASK = 16'h9009;
    EFX_FF \dout[0]~FF  (.D(\hold[0] ), .CE(dval), .CLK(\clko~O ), .SR(1'b0), 
           .Q(dout[0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\dsync.sv(37)
    defparam \dout[0]~FF .CLK_POLARITY = 1'b1;
    defparam \dout[0]~FF .CE_POLARITY = 1'b1;
    defparam \dout[0]~FF .SR_POLARITY = 1'b1;
    defparam \dout[0]~FF .D_POLARITY = 1'b1;
    defparam \dout[0]~FF .SR_SYNC = 1'b1;
    defparam \dout[0]~FF .SR_VALUE = 1'b0;
    defparam \dout[0]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \mask_change~FF  (.D(n7_2), .CE(ceg_net2), .CLK(\clki~O ), 
           .SR(rst), .Q(mask_change)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\dsync.sv(31)
    defparam \mask_change~FF .CLK_POLARITY = 1'b1;
    defparam \mask_change~FF .CE_POLARITY = 1'b0;
    defparam \mask_change~FF .SR_POLARITY = 1'b1;
    defparam \mask_change~FF .D_POLARITY = 1'b1;
    defparam \mask_change~FF .SR_SYNC = 1'b0;
    defparam \mask_change~FF .SR_VALUE = 1'b0;
    defparam \mask_change~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \hold[0]_2~FF  (.D(din[0]), .CE(n7_2), .CLK(\clki~O ), .SR(rst), 
           .Q(\hold[0] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\dsync.sv(31)
    defparam \hold[0]_2~FF .CLK_POLARITY = 1'b1;
    defparam \hold[0]_2~FF .CE_POLARITY = 1'b1;
    defparam \hold[0]_2~FF .SR_POLARITY = 1'b1;
    defparam \hold[0]_2~FF .D_POLARITY = 1'b1;
    defparam \hold[0]_2~FF .SR_SYNC = 1'b0;
    defparam \hold[0]_2~FF .SR_VALUE = 1'b0;
    defparam \hold[0]_2~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i_bus_edet/din_d[0]~FF  (.D(din[0]), .CE(1'b1), .CLK(\clki~O ), 
           .SR(1'b0), .Q(\i_bus_edet/din_d[0] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\bus_edet.sv(11)
    defparam \i_bus_edet/din_d[0]~FF .CLK_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[0]~FF .CE_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[0]~FF .SR_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[0]~FF .D_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[0]~FF .SR_SYNC = 1'b1;
    defparam \i_bus_edet/din_d[0]~FF .SR_VALUE = 1'b0;
    defparam \i_bus_edet/din_d[0]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i_bus_edet/din_d[1]~FF  (.D(din[1]), .CE(1'b1), .CLK(\clki~O ), 
           .SR(1'b0), .Q(\i_bus_edet/din_d[1] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\bus_edet.sv(11)
    defparam \i_bus_edet/din_d[1]~FF .CLK_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[1]~FF .CE_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[1]~FF .SR_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[1]~FF .D_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[1]~FF .SR_SYNC = 1'b1;
    defparam \i_bus_edet/din_d[1]~FF .SR_VALUE = 1'b0;
    defparam \i_bus_edet/din_d[1]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i_bus_edet/din_d[2]~FF  (.D(din[2]), .CE(1'b1), .CLK(\clki~O ), 
           .SR(1'b0), .Q(\i_bus_edet/din_d[2] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\bus_edet.sv(11)
    defparam \i_bus_edet/din_d[2]~FF .CLK_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[2]~FF .CE_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[2]~FF .SR_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[2]~FF .D_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[2]~FF .SR_SYNC = 1'b1;
    defparam \i_bus_edet/din_d[2]~FF .SR_VALUE = 1'b0;
    defparam \i_bus_edet/din_d[2]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i_bus_edet/din_d[3]~FF  (.D(din[3]), .CE(1'b1), .CLK(\clki~O ), 
           .SR(1'b0), .Q(\i_bus_edet/din_d[3] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\bus_edet.sv(11)
    defparam \i_bus_edet/din_d[3]~FF .CLK_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[3]~FF .CE_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[3]~FF .SR_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[3]~FF .D_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[3]~FF .SR_SYNC = 1'b1;
    defparam \i_bus_edet/din_d[3]~FF .SR_VALUE = 1'b0;
    defparam \i_bus_edet/din_d[3]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i_bus_edet/din_d[4]~FF  (.D(din[4]), .CE(1'b1), .CLK(\clki~O ), 
           .SR(1'b0), .Q(\i_bus_edet/din_d[4] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\bus_edet.sv(11)
    defparam \i_bus_edet/din_d[4]~FF .CLK_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[4]~FF .CE_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[4]~FF .SR_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[4]~FF .D_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[4]~FF .SR_SYNC = 1'b1;
    defparam \i_bus_edet/din_d[4]~FF .SR_VALUE = 1'b0;
    defparam \i_bus_edet/din_d[4]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i_bus_edet/din_d[5]~FF  (.D(din[5]), .CE(1'b1), .CLK(\clki~O ), 
           .SR(1'b0), .Q(\i_bus_edet/din_d[5] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\bus_edet.sv(11)
    defparam \i_bus_edet/din_d[5]~FF .CLK_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[5]~FF .CE_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[5]~FF .SR_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[5]~FF .D_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[5]~FF .SR_SYNC = 1'b1;
    defparam \i_bus_edet/din_d[5]~FF .SR_VALUE = 1'b0;
    defparam \i_bus_edet/din_d[5]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i_bus_edet/din_d[6]~FF  (.D(din[6]), .CE(1'b1), .CLK(\clki~O ), 
           .SR(1'b0), .Q(\i_bus_edet/din_d[6] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\bus_edet.sv(11)
    defparam \i_bus_edet/din_d[6]~FF .CLK_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[6]~FF .CE_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[6]~FF .SR_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[6]~FF .D_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[6]~FF .SR_SYNC = 1'b1;
    defparam \i_bus_edet/din_d[6]~FF .SR_VALUE = 1'b0;
    defparam \i_bus_edet/din_d[6]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i_bus_edet/din_d[7]~FF  (.D(din[7]), .CE(1'b1), .CLK(\clki~O ), 
           .SR(1'b0), .Q(\i_bus_edet/din_d[7] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\bus_edet.sv(11)
    defparam \i_bus_edet/din_d[7]~FF .CLK_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[7]~FF .CE_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[7]~FF .SR_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[7]~FF .D_POLARITY = 1'b1;
    defparam \i_bus_edet/din_d[7]~FF .SR_SYNC = 1'b1;
    defparam \i_bus_edet/din_d[7]~FF .SR_VALUE = 1'b0;
    defparam \i_bus_edet/din_d[7]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \dout[1]~FF  (.D(\hold[1] ), .CE(dval), .CLK(\clko~O ), .SR(1'b0), 
           .Q(dout[1])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\dsync.sv(37)
    defparam \dout[1]~FF .CLK_POLARITY = 1'b1;
    defparam \dout[1]~FF .CE_POLARITY = 1'b1;
    defparam \dout[1]~FF .SR_POLARITY = 1'b1;
    defparam \dout[1]~FF .D_POLARITY = 1'b1;
    defparam \dout[1]~FF .SR_SYNC = 1'b1;
    defparam \dout[1]~FF .SR_VALUE = 1'b0;
    defparam \dout[1]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \dout[2]~FF  (.D(\hold[2] ), .CE(dval), .CLK(\clko~O ), .SR(1'b0), 
           .Q(dout[2])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\dsync.sv(37)
    defparam \dout[2]~FF .CLK_POLARITY = 1'b1;
    defparam \dout[2]~FF .CE_POLARITY = 1'b1;
    defparam \dout[2]~FF .SR_POLARITY = 1'b1;
    defparam \dout[2]~FF .D_POLARITY = 1'b1;
    defparam \dout[2]~FF .SR_SYNC = 1'b1;
    defparam \dout[2]~FF .SR_VALUE = 1'b0;
    defparam \dout[2]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \dout[3]~FF  (.D(\hold[3] ), .CE(dval), .CLK(\clko~O ), .SR(1'b0), 
           .Q(dout[3])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\dsync.sv(37)
    defparam \dout[3]~FF .CLK_POLARITY = 1'b1;
    defparam \dout[3]~FF .CE_POLARITY = 1'b1;
    defparam \dout[3]~FF .SR_POLARITY = 1'b1;
    defparam \dout[3]~FF .D_POLARITY = 1'b1;
    defparam \dout[3]~FF .SR_SYNC = 1'b1;
    defparam \dout[3]~FF .SR_VALUE = 1'b0;
    defparam \dout[3]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \dout[4]~FF  (.D(\hold[4] ), .CE(dval), .CLK(\clko~O ), .SR(1'b0), 
           .Q(dout[4])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\dsync.sv(37)
    defparam \dout[4]~FF .CLK_POLARITY = 1'b1;
    defparam \dout[4]~FF .CE_POLARITY = 1'b1;
    defparam \dout[4]~FF .SR_POLARITY = 1'b1;
    defparam \dout[4]~FF .D_POLARITY = 1'b1;
    defparam \dout[4]~FF .SR_SYNC = 1'b1;
    defparam \dout[4]~FF .SR_VALUE = 1'b0;
    defparam \dout[4]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \dout[5]~FF  (.D(\hold[5] ), .CE(dval), .CLK(\clko~O ), .SR(1'b0), 
           .Q(dout[5])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\dsync.sv(37)
    defparam \dout[5]~FF .CLK_POLARITY = 1'b1;
    defparam \dout[5]~FF .CE_POLARITY = 1'b1;
    defparam \dout[5]~FF .SR_POLARITY = 1'b1;
    defparam \dout[5]~FF .D_POLARITY = 1'b1;
    defparam \dout[5]~FF .SR_SYNC = 1'b1;
    defparam \dout[5]~FF .SR_VALUE = 1'b0;
    defparam \dout[5]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \dout[6]~FF  (.D(\hold[6] ), .CE(dval), .CLK(\clko~O ), .SR(1'b0), 
           .Q(dout[6])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\dsync.sv(37)
    defparam \dout[6]~FF .CLK_POLARITY = 1'b1;
    defparam \dout[6]~FF .CE_POLARITY = 1'b1;
    defparam \dout[6]~FF .SR_POLARITY = 1'b1;
    defparam \dout[6]~FF .D_POLARITY = 1'b1;
    defparam \dout[6]~FF .SR_SYNC = 1'b1;
    defparam \dout[6]~FF .SR_VALUE = 1'b0;
    defparam \dout[6]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \dout[7]~FF  (.D(\hold[7] ), .CE(dval), .CLK(\clko~O ), .SR(1'b0), 
           .Q(dout[7])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\dsync.sv(37)
    defparam \dout[7]~FF .CLK_POLARITY = 1'b1;
    defparam \dout[7]~FF .CE_POLARITY = 1'b1;
    defparam \dout[7]~FF .SR_POLARITY = 1'b1;
    defparam \dout[7]~FF .D_POLARITY = 1'b1;
    defparam \dout[7]~FF .SR_SYNC = 1'b1;
    defparam \dout[7]~FF .SR_VALUE = 1'b0;
    defparam \dout[7]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i0_esync/sync_reg[2]~FF  (.D(\i0_esync/sync_reg[1] ), .CE(1'b1), 
           .CLK(\clko~O ), .SR(rst), .Q(\i0_esync/sync_reg[2] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\esync.sv(28)
    defparam \i0_esync/sync_reg[2]~FF .CLK_POLARITY = 1'b1;
    defparam \i0_esync/sync_reg[2]~FF .CE_POLARITY = 1'b1;
    defparam \i0_esync/sync_reg[2]~FF .SR_POLARITY = 1'b1;
    defparam \i0_esync/sync_reg[2]~FF .D_POLARITY = 1'b1;
    defparam \i0_esync/sync_reg[2]~FF .SR_SYNC = 1'b0;
    defparam \i0_esync/sync_reg[2]~FF .SR_VALUE = 1'b0;
    defparam \i0_esync/sync_reg[2]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i0_esync/sync_reg[1]_2~FF  (.D(\i0_esync/sync_reg[0] ), .CE(1'b1), 
           .CLK(\clko~O ), .SR(rst), .Q(\i0_esync/sync_reg[1] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\esync.sv(28)
    defparam \i0_esync/sync_reg[1]_2~FF .CLK_POLARITY = 1'b1;
    defparam \i0_esync/sync_reg[1]_2~FF .CE_POLARITY = 1'b1;
    defparam \i0_esync/sync_reg[1]_2~FF .SR_POLARITY = 1'b1;
    defparam \i0_esync/sync_reg[1]_2~FF .D_POLARITY = 1'b1;
    defparam \i0_esync/sync_reg[1]_2~FF .SR_SYNC = 1'b0;
    defparam \i0_esync/sync_reg[1]_2~FF .SR_VALUE = 1'b0;
    defparam \i0_esync/sync_reg[1]_2~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i0_esync/sync_reg_d~FF  (.D(\i0_esync/sync_reg[2] ), .CE(1'b1), 
           .CLK(\clko~O ), .SR(rst), .Q(\i0_esync/sync_reg_d )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\esync.sv(32)
    defparam \i0_esync/sync_reg_d~FF .CLK_POLARITY = 1'b1;
    defparam \i0_esync/sync_reg_d~FF .CE_POLARITY = 1'b1;
    defparam \i0_esync/sync_reg_d~FF .SR_POLARITY = 1'b1;
    defparam \i0_esync/sync_reg_d~FF .D_POLARITY = 1'b1;
    defparam \i0_esync/sync_reg_d~FF .SR_SYNC = 1'b0;
    defparam \i0_esync/sync_reg_d~FF .SR_VALUE = 1'b0;
    defparam \i0_esync/sync_reg_d~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i0_esync/sync_reg[0]_2~FF  (.D(\i0_esync/toggle ), .CE(1'b1), 
           .CLK(\clko~O ), .SR(rst), .Q(\i0_esync/sync_reg[0] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\esync.sv(28)
    defparam \i0_esync/sync_reg[0]_2~FF .CLK_POLARITY = 1'b1;
    defparam \i0_esync/sync_reg[0]_2~FF .CE_POLARITY = 1'b1;
    defparam \i0_esync/sync_reg[0]_2~FF .SR_POLARITY = 1'b1;
    defparam \i0_esync/sync_reg[0]_2~FF .D_POLARITY = 1'b1;
    defparam \i0_esync/sync_reg[0]_2~FF .SR_SYNC = 1'b0;
    defparam \i0_esync/sync_reg[0]_2~FF .SR_VALUE = 1'b0;
    defparam \i0_esync/sync_reg[0]_2~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i0_esync/toggle_2~FF  (.D(\i0_esync/toggle ), .CE(change), .CLK(\clki~O ), 
           .SR(rst), .Q(\i0_esync/toggle )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b0, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\esync.sv(21)
    defparam \i0_esync/toggle_2~FF .CLK_POLARITY = 1'b1;
    defparam \i0_esync/toggle_2~FF .CE_POLARITY = 1'b1;
    defparam \i0_esync/toggle_2~FF .SR_POLARITY = 1'b1;
    defparam \i0_esync/toggle_2~FF .D_POLARITY = 1'b0;
    defparam \i0_esync/toggle_2~FF .SR_SYNC = 1'b0;
    defparam \i0_esync/toggle_2~FF .SR_VALUE = 1'b0;
    defparam \i0_esync/toggle_2~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i1_esync/sync_reg[2]~FF  (.D(\i1_esync/sync_reg[1] ), .CE(1'b1), 
           .CLK(\clki~O ), .SR(rst), .Q(\i1_esync/sync_reg[2] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\esync.sv(28)
    defparam \i1_esync/sync_reg[2]~FF .CLK_POLARITY = 1'b1;
    defparam \i1_esync/sync_reg[2]~FF .CE_POLARITY = 1'b1;
    defparam \i1_esync/sync_reg[2]~FF .SR_POLARITY = 1'b1;
    defparam \i1_esync/sync_reg[2]~FF .D_POLARITY = 1'b1;
    defparam \i1_esync/sync_reg[2]~FF .SR_SYNC = 1'b0;
    defparam \i1_esync/sync_reg[2]~FF .SR_VALUE = 1'b0;
    defparam \i1_esync/sync_reg[2]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i1_esync/sync_reg[1]_2~FF  (.D(\i1_esync/sync_reg[0] ), .CE(1'b1), 
           .CLK(\clki~O ), .SR(rst), .Q(\i1_esync/sync_reg[1] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\esync.sv(28)
    defparam \i1_esync/sync_reg[1]_2~FF .CLK_POLARITY = 1'b1;
    defparam \i1_esync/sync_reg[1]_2~FF .CE_POLARITY = 1'b1;
    defparam \i1_esync/sync_reg[1]_2~FF .SR_POLARITY = 1'b1;
    defparam \i1_esync/sync_reg[1]_2~FF .D_POLARITY = 1'b1;
    defparam \i1_esync/sync_reg[1]_2~FF .SR_SYNC = 1'b0;
    defparam \i1_esync/sync_reg[1]_2~FF .SR_VALUE = 1'b0;
    defparam \i1_esync/sync_reg[1]_2~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i1_esync/sync_reg_d~FF  (.D(\i1_esync/sync_reg[2] ), .CE(1'b1), 
           .CLK(\clki~O ), .SR(rst), .Q(\i1_esync/sync_reg_d )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\esync.sv(32)
    defparam \i1_esync/sync_reg_d~FF .CLK_POLARITY = 1'b1;
    defparam \i1_esync/sync_reg_d~FF .CE_POLARITY = 1'b1;
    defparam \i1_esync/sync_reg_d~FF .SR_POLARITY = 1'b1;
    defparam \i1_esync/sync_reg_d~FF .D_POLARITY = 1'b1;
    defparam \i1_esync/sync_reg_d~FF .SR_SYNC = 1'b0;
    defparam \i1_esync/sync_reg_d~FF .SR_VALUE = 1'b0;
    defparam \i1_esync/sync_reg_d~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i1_esync/sync_reg[0]_2~FF  (.D(\i1_esync/toggle ), .CE(1'b1), 
           .CLK(\clki~O ), .SR(rst), .Q(\i1_esync/sync_reg[0] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\esync.sv(28)
    defparam \i1_esync/sync_reg[0]_2~FF .CLK_POLARITY = 1'b1;
    defparam \i1_esync/sync_reg[0]_2~FF .CE_POLARITY = 1'b1;
    defparam \i1_esync/sync_reg[0]_2~FF .SR_POLARITY = 1'b1;
    defparam \i1_esync/sync_reg[0]_2~FF .D_POLARITY = 1'b1;
    defparam \i1_esync/sync_reg[0]_2~FF .SR_SYNC = 1'b0;
    defparam \i1_esync/sync_reg[0]_2~FF .SR_VALUE = 1'b0;
    defparam \i1_esync/sync_reg[0]_2~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \i1_esync/toggle_2~FF  (.D(\i1_esync/toggle ), .CE(dval), .CLK(\clko~O ), 
           .SR(rst), .Q(\i1_esync/toggle )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b0, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\esync.sv(21)
    defparam \i1_esync/toggle_2~FF .CLK_POLARITY = 1'b1;
    defparam \i1_esync/toggle_2~FF .CE_POLARITY = 1'b1;
    defparam \i1_esync/toggle_2~FF .SR_POLARITY = 1'b1;
    defparam \i1_esync/toggle_2~FF .D_POLARITY = 1'b0;
    defparam \i1_esync/toggle_2~FF .SR_SYNC = 1'b0;
    defparam \i1_esync/toggle_2~FF .SR_VALUE = 1'b0;
    defparam \i1_esync/toggle_2~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \hold[1]_2~FF  (.D(din[1]), .CE(n7_2), .CLK(\clki~O ), .SR(rst), 
           .Q(\hold[1] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\dsync.sv(31)
    defparam \hold[1]_2~FF .CLK_POLARITY = 1'b1;
    defparam \hold[1]_2~FF .CE_POLARITY = 1'b1;
    defparam \hold[1]_2~FF .SR_POLARITY = 1'b1;
    defparam \hold[1]_2~FF .D_POLARITY = 1'b1;
    defparam \hold[1]_2~FF .SR_SYNC = 1'b0;
    defparam \hold[1]_2~FF .SR_VALUE = 1'b0;
    defparam \hold[1]_2~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \hold[2]_2~FF  (.D(din[2]), .CE(n7_2), .CLK(\clki~O ), .SR(rst), 
           .Q(\hold[2] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\dsync.sv(31)
    defparam \hold[2]_2~FF .CLK_POLARITY = 1'b1;
    defparam \hold[2]_2~FF .CE_POLARITY = 1'b1;
    defparam \hold[2]_2~FF .SR_POLARITY = 1'b1;
    defparam \hold[2]_2~FF .D_POLARITY = 1'b1;
    defparam \hold[2]_2~FF .SR_SYNC = 1'b0;
    defparam \hold[2]_2~FF .SR_VALUE = 1'b0;
    defparam \hold[2]_2~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \hold[3]_2~FF  (.D(din[3]), .CE(n7_2), .CLK(\clki~O ), .SR(rst), 
           .Q(\hold[3] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\dsync.sv(31)
    defparam \hold[3]_2~FF .CLK_POLARITY = 1'b1;
    defparam \hold[3]_2~FF .CE_POLARITY = 1'b1;
    defparam \hold[3]_2~FF .SR_POLARITY = 1'b1;
    defparam \hold[3]_2~FF .D_POLARITY = 1'b1;
    defparam \hold[3]_2~FF .SR_SYNC = 1'b0;
    defparam \hold[3]_2~FF .SR_VALUE = 1'b0;
    defparam \hold[3]_2~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \hold[4]_2~FF  (.D(din[4]), .CE(n7_2), .CLK(\clki~O ), .SR(rst), 
           .Q(\hold[4] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\dsync.sv(31)
    defparam \hold[4]_2~FF .CLK_POLARITY = 1'b1;
    defparam \hold[4]_2~FF .CE_POLARITY = 1'b1;
    defparam \hold[4]_2~FF .SR_POLARITY = 1'b1;
    defparam \hold[4]_2~FF .D_POLARITY = 1'b1;
    defparam \hold[4]_2~FF .SR_SYNC = 1'b0;
    defparam \hold[4]_2~FF .SR_VALUE = 1'b0;
    defparam \hold[4]_2~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \hold[5]_2~FF  (.D(din[5]), .CE(n7_2), .CLK(\clki~O ), .SR(rst), 
           .Q(\hold[5] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\dsync.sv(31)
    defparam \hold[5]_2~FF .CLK_POLARITY = 1'b1;
    defparam \hold[5]_2~FF .CE_POLARITY = 1'b1;
    defparam \hold[5]_2~FF .SR_POLARITY = 1'b1;
    defparam \hold[5]_2~FF .D_POLARITY = 1'b1;
    defparam \hold[5]_2~FF .SR_SYNC = 1'b0;
    defparam \hold[5]_2~FF .SR_VALUE = 1'b0;
    defparam \hold[5]_2~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \hold[6]_2~FF  (.D(din[6]), .CE(n7_2), .CLK(\clki~O ), .SR(rst), 
           .Q(\hold[6] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\dsync.sv(31)
    defparam \hold[6]_2~FF .CLK_POLARITY = 1'b1;
    defparam \hold[6]_2~FF .CE_POLARITY = 1'b1;
    defparam \hold[6]_2~FF .SR_POLARITY = 1'b1;
    defparam \hold[6]_2~FF .D_POLARITY = 1'b1;
    defparam \hold[6]_2~FF .SR_SYNC = 1'b0;
    defparam \hold[6]_2~FF .SR_VALUE = 1'b0;
    defparam \hold[6]_2~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \hold[7]_2~FF  (.D(din[7]), .CE(n7_2), .CLK(\clki~O ), .SR(rst), 
           .Q(\hold[7] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b0, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // D:\Work\adv7393_axi\src\import\dsync.sv(31)
    defparam \hold[7]_2~FF .CLK_POLARITY = 1'b1;
    defparam \hold[7]_2~FF .CE_POLARITY = 1'b1;
    defparam \hold[7]_2~FF .SR_POLARITY = 1'b1;
    defparam \hold[7]_2~FF .D_POLARITY = 1'b1;
    defparam \hold[7]_2~FF .SR_SYNC = 1'b0;
    defparam \hold[7]_2~FF .SR_VALUE = 1'b0;
    defparam \hold[7]_2~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_LUT4 LUT__135 (.I0(din[3]), .I1(\i_bus_edet/din_d[3] ), .I2(\i_bus_edet/din_d[2] ), 
            .I3(din[2]), .O(n91)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h9009 */ ;
    defparam LUT__135.LUTMASK = 16'h9009;
    EFX_LUT4 LUT__136 (.I0(din[1]), .I1(\i_bus_edet/din_d[1] ), .I2(\i_bus_edet/din_d[0] ), 
            .I3(din[0]), .O(n92)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h9009 */ ;
    defparam LUT__136.LUTMASK = 16'h9009;
    EFX_LUT4 LUT__137 (.I0(n89), .I1(n90), .I2(n91), .I3(n92), .O(change)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h7fff */ ;
    defparam LUT__137.LUTMASK = 16'h7fff;
    EFX_LUT4 LUT__138 (.I0(change), .I1(mask_change), .O(lost)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8888 */ ;
    defparam LUT__138.LUTMASK = 16'h8888;
    EFX_LUT4 LUT__139 (.I0(\i0_esync/sync_reg[2] ), .I1(\i0_esync/sync_reg_d ), 
            .O(dval)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h6666 */ ;
    defparam LUT__139.LUTMASK = 16'h6666;
    EFX_LUT4 LUT__140 (.I0(mask_change), .I1(change), .O(n7_2)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4444 */ ;
    defparam LUT__140.LUTMASK = 16'h4444;
    EFX_LUT4 LUT__141 (.I0(mask_change), .I1(change), .I2(\i1_esync/sync_reg[2] ), 
            .I3(\i1_esync/sync_reg_d ), .O(ceg_net2)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'hb00b */ ;
    defparam LUT__141.LUTMASK = 16'hb00b;
    EFX_GBUFCE CLKBUF__1 (.CE(1'b1), .I(clko), .O(\clko~O )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_GBUFCE, CE_POLARITY=1'b1 */ ;
    defparam CLKBUF__1.CE_POLARITY = 1'b1;
    EFX_GBUFCE CLKBUF__0 (.CE(1'b1), .I(clki), .O(\clki~O )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_GBUFCE, CE_POLARITY=1'b1 */ ;
    defparam CLKBUF__0.CE_POLARITY = 1'b1;
    
endmodule

//
// Verific Verilog Description of module EFX_LUT4_826ff7cc_0
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_FF_826ff7cc_0
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_FF_826ff7cc_1
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_FF_826ff7cc_2
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_FF_826ff7cc_3
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_826ff7cc_1
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_826ff7cc_2
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_826ff7cc_3
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_826ff7cc_4
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_826ff7cc_5
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_GBUFCE_826ff7cc_0
// module not written out since it is a black box. 
//

