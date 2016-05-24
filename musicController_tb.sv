module musicController_tb (); 
  
  //inputs to regfile
	logic clk; 
	logic [7:0]  keyboard_input;
	logic kybrd_data_ready; 	

  //output of regfile
  logic forward, pause; 
  logic restart; 

  //call regfile to test it  
  musicController dut(clk, keyboard_input, forward, pause, restart, kybrd_data_ready) ; 

   initial begin 
      //initially set clk to 0
      clk = 0 ; #5;
      
      //keep the clock cycling back and forth between 1 and 0
      forever begin 
         clk = 1; #5;
         clk = 0; #5; 
      end
   end

  initial begin 
  
kybrd_data_ready = 1; 
keyboard_input = 8'h45;
	#10
keyboard_input = 8'h44;
	#10
keyboard_input = 8'h46;
	#10
keyboard_input = 8'h42;
	#10; 
kybrd_data_ready = 0; 
	#10
kybrd_data_ready = 1; 
keyboard_input = 8'h45;
	#10
keyboard_input = 8'h46;
	#10
keyboard_input = 8'h45;
	#10; 
kybrd_data_ready = 0; 
	#40
kybrd_data_ready = 1; 
keyboard_input = 8'h52; 
	#10; 
kybrd_data_ready = 0; 
	#40; 
kybrd_data_ready = 1; //should make it restart again; 
	#10; 
kybrd_data_ready = 0; 
	#40; 
kybrd_data_ready = 1; 
keyboard_input = 8'h42;
	#10;
kybrd_data_ready = 0;
	#20;  

	
     $stop;
  end
endmodule 
