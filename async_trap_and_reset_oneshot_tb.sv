
module async_trap_and_reset_oneshot_tb();
  logic async_sig, outclk, out_sync_sig;
  
  async_trap_and_reset_oneshot dut(
    .async_sig(async_sig),
    .outclk(outclk),
    .out_sync_sig(out_sync_sig),
    .auto_reset(1'b1),
    .reset(1'b1)
  );
  
  initial begin
    forever begin
      outclk = 1; #5;
      outclk = 0; #5;
   end
  end
  
  initial begin
    async_sig = 0;
    #31;
    async_sig = 1;
    #31;
    async_sig = 0;
    #31;
    async_sig = 1;
    #31;
    async_sig = 0;
    #31;
    async_sig = 1;
    #31;
    $stop;
  end
endmodule
