/*
Module: musicController

inputs:	clk: the 50MHz clk
			keyboard_input: the value that is currentlly read from the keyboard 
			kybrd_data_ready: signal used to to tell if there has been a new input from 
									the keyboard, or if it is still just the same value. This 
									input ensures that the restart signal is only high for one 
									pulse so that it does not keep restarting the song 

outputs:	forward: determines if the music should be playinh forwards or backwards
						1'b1 means it should be forwards, 1'b0 means the music should be 
						be playing backwards 
			pause:	determines if the music should be paused or playing. 1'b1 means it 
						should be paused, 1'b0 means it should be playing

			restart:	determines if the song should restart to its begginning address of 0.
						This signal must only be a pulse so that it does not keep resetting the 
						the music. 

*/

module musicController(clk, keyboard_input, forward, pause, restart, kybrd_data_ready);

//variable declaration 
 input logic clk;
 input logic kybrd_data_ready; 
 input logic [7:0] keyboard_input;
 output reg forward = 1;
 output reg pause = 1;
 output reg restart = 0; 

 //valid keyboard inputs to this module 
 parameter character_B = 8'h42;
 parameter character_D = 8'h44;
 parameter character_E = 8'h45;
 parameter character_F = 8'h46;	
 parameter character_R = 8'h52; 
 
 //registered outputs for forward, pause and restart 
 always_ff @(posedge clk)
begin
	if(keyboard_input == character_F)
		forward <= 1'b1;
	else if(keyboard_input == character_B)
		forward <= 1'b0;
	else if(keyboard_input == character_E)
		pause <= 1'b0;
	else if(keyboard_input == character_D)
		pause <= 1'b1;
	else if((keyboard_input == character_R) && kybrd_data_ready) //kybrd_data_ready ensures there will only one restart pulse 
		restart <= 1'b1; 
	else
		restart <= 1'b0; 
	end
endmodule 