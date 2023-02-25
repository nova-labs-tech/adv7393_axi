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

task automatic rst_gen(ref rst_sig, ref clk_sig, int ticks);
  automatic int pre_tick = 1;
  wait_clk(clk_sig, pre_tick);
  rst_sig = '0;
  wait_clk(clk_sig, ticks);
  rst_sig = '1;
  wait_clk(clk_sig, ticks);
  rst_sig = '0;
endtask

task automatic gen_strobe(ref logic sig, ref logic clk, int duration);
  automatic int wait_val = 1;
  wait_clk(clk, wait_val);
  sig = '1;
  wait_clk(clk, duration);
  sig = '0;
endtask : gen_strobe 

endpackage : tb_helper