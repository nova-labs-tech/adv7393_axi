package tb_helper;
  
task automatic clk_gen(ref logic clk, int period);
  clk = '0;
  forever
    #period clk = ~clk;
endtask : clk_gen

task automatic wait_clk(ref logic clk, int ticks);
  repeat(ticks) begin
    @ (posedge clk);
  end
endtask : wait_clk

task automatic reset_gen(ref logic clk, ref logic rst, int period);
  clk = '0;
  forever
    #period clk = ~clk;
endtask : reset_gen

task automatic gen_strobe(ref logic sig, ref logic clk, int duration);
  automatic int wait_val = 1;
  wait_clk(clk, wait_val);
  sig = '1;
  wait_clk(clk, duration);
  sig = '0;
endtask : gen_strobe 

endpackage : tb_helper