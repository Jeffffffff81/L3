/*
  Module: frequencyDivisorGenerator: This module generates the appropriate divisor in 
												 order to play the song at a certain speed. Its 
												 default speed is 22KHz.  

  inputs:	key_0: when key_0 goes high, it indicates that KEY0 on the DE1 SoC was pressed
					  and that the speed of the song should decrease
				key_1: when key_1 goes high, it indicates that KEY1 on the DE1 SoC was pressed
					  and that the speed of the song should increase
				key_2: when key_2 goes high, it indicates that KEY2 on the DE1 SoC was pressed
					  and that the speed of the song should return back to the starting value
					  of 22KHz. 
				clk: the 50MHz clock 
				
Parameters:	max_divisor: the maximum value for the divisor. This parameter is the 
								 divisor that will produce the slowest speed that we are allowing
								 the song to play at. 
				min_divisor: the minimum value for the divisor. This parameter is the 
								 divisor that will produce the largest speed that we are allowing
								 the song to play at. 
								 
				
 outputs: frequency_divisor: the amount to divide the 50MHz clock by 

*/

module frequencyDivisorGenerator(
				key_0, key_1, key_2,
				 clk, 
				frequency_divisor);

input logic key_0, key_1, key_2, clk; 
output reg[31:0] frequency_divisor = 32'd1136;

				
//max and min values for our divisors so they dont cross and boudry conditions				
parameter max_divisor = 11236000;
parameter min_divisor = 100;

wire [31:0] next_speed_down, next_speed_up; 

//next_speed_down and next_speed_up values
assign next_speed_up = (frequency_divisor - 1) > min_divisor ? frequency_divisor - 1 : frequency_divisor;
assign next_speed_down = (frequency_divisor + 1) < max_divisor ? frequency_divisor + 1 : frequency_divisor;   
									

//register to control next frequency output 							
always_ff @(posedge clk)
	begin 
		if (key_2 == 1'b1)        frequency_divisor <= 32'd1136;  //47800  1136
		else if (key_0 == 1'b1)	  frequency_divisor <= next_speed_up; //decrease the divisor 
		else if (key_1 == 1'b1)	  frequency_divisor <= next_speed_down; //increase the divisor 
	end	

endmodule 