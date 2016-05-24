module MusicPlayer_tb();
  logic clk, kybrd_forward, kybrd_pause;
  logic startsamplenow;
  logic[22:0] flsh_address;
  logic flsh_waitrequest,flsh_read;
  logic[31:0] flsh_readdata; 
  logic flsh_readdatavalid;
  logic[3:0] flsh_byteenable;
  logic[15:0] audio_data;
  
  MusicPlayer dut(
    .clk(clk),
    .kybrd_forward(kybrd_forward),
    .kybrd_pause(kybrd_pause),
    .startsamplenow(startsamplenow),
    .flsh_address(flsh_address),
    .flsh_waitrequest(flsh_waitrequest),
    .flsh_read(flsh_read),
    .flsh_readdata(flsh_readdata),
    .flsh_readdatavalid(flsh_readdatavalid),
    .flsh_byteenable(flsh_byteenable),
    .audio_data(audio_data)
  );
  
  initial begin
    forever begin
      clk = 1; #1;
      clk = 0; #1;
    end
  end
  
  initial begin
    startsamplenow = 0;
    kybrd_forward = 1;
    kybrd_pause = 0;
    flsh_waitrequest = 0;
    
    flsh_readdata = 32'hdeadbeef;
    flsh_readdatavalid = 0;
    #20;
    startsamplenow = 1;
    #2;
    startsamplenow = 0;
    #40;
    flsh_readdatavalid = 1;
    #2;
    flsh_readdatavalid = 0;
    #20;
    
    startsamplenow = 1;
    #2;
    startsamplenow = 0;
    #40;
    flsh_readdatavalid = 1;
    #2;
    flsh_readdatavalid = 0;
    #20;
    
    flsh_readdata = 32'haaaabbbb;
    flsh_readdatavalid = 0;
    #20;
    startsamplenow = 1;
    #2;
    startsamplenow = 0;
    #40;
    flsh_readdatavalid = 1;
    #2;
    flsh_readdatavalid = 0;
    #20;
    
    startsamplenow = 1;
    #2;
    startsamplenow = 0;
    #40;
    flsh_readdatavalid = 1;
    #2;
    flsh_readdatavalid = 0;
    #20;    
    
    $stop;
  end
endmodule