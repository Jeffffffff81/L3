module AddressController_tb();
  logic clk, rst, change, forward;
  logic[22:0] address;
  
  AddressController #(.width(23), .MAX_ADDRESS(23'h5)) addresscontroller(
	 .clk(clk),
	 .rst(rst),
	 .change(change),
	 .forward(forward),
	 .address(address)
	);
  
  initial begin
    forever begin
      clk = 1; #1;
      clk = 0; #1;
    end
  end
  
  initial begin
    rst = 0;
    forward = 1;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
     change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
     change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
     change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
     change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
     change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
     change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
     change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
     change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;

    //start moving back:    
    forward = 0;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    //test reset:
    rst = 1;
    #2;
    rst = 0;

    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    change = 0;
    #4;
    change = 1;
    #2;
    change = 0;
    #4;
    
    $stop;
  end
endmodule