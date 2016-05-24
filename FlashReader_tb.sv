module FlashReader_tb();
  logic 					clk;
  
  //Interface to keyboard:
	logic					kybrd_pause;
	
	//Interface to flash:	
	logic 					flsh_waitrequest; 
  logic 			flsh_read;
	logic[31:0] 			flsh_readdata;
	logic 					flsh_readdatavalid;
	logic[3:0] 	flsh_byteenable;
	
	//Interface address controller:
	logic 			address_change;
	
	//Interface to audio register:
	logic 			audio_enable;
	logic[15:0]   audio_out;
	
	//interface to slowClockTrigger:
	logic			 			startsamplenow; //this is not edge sensitive
	
	FlashReader dut(
	 .clk(clk),
	 .kybrd_pause(kybrd_pause),
	 .flsh_waitrequest(flsh_waitrequest),
	 .flsh_read(flsh_read),
	 .flsh_readdata(flsh_readdata),
	 .flsh_readdatavalid(flsh_readdatavalid),
	 .flsh_byteenable(flsh_byteenable),
	 .address_change(address_change),
	 .audio_enable(audio_enable),
	 .audio_out(audio_out),
	 .startsamplenow(startsamplenow)
	);
  
  initial begin
    forever begin
      clk = 1; #1;
      clk = 0; #1;
    end
  end
  
  initial begin
    flsh_waitrequest = 0;
    kybrd_pause = 0;
    flsh_readdata = 32'hDEADBEEF;
    flsh_readdatavalid = 0;
    
    startsamplenow = 0;
    #10;
    startsamplenow = 1;
    #2;
    startsamplenow = 0;
    #10;
    flsh_readdatavalid = 1;
    #2;
    flsh_readdatavalid= 0;
    #20
    
    startsamplenow = 1;
    #2;
    startsamplenow = 0;
    #12;
    flsh_readdatavalid = 1;
    #2;
    flsh_readdatavalid = 0;
    #14
    
    $stop;
    
  end
endmodule