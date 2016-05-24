`default_nettype none

/*
 * This module controls which address is fed into flash memory
 * 
 * inputs:	clk: The clock which this runs on
 *				rst: Synchronous reset. if set, the address will be 0
 *					  on the next clock edge.
 *					  typically it should be set for one clock cycle.
 *				change: This should be pulsed for one clock cycle.
 *						  It will cause the address to either increment
 *						  or decrement, depending on the value of forward
 *
 * outputs:	address: The address which is given to flash controller
 *
 * parameters: width: The width of the output address (number of bits)
 *					MAX_ADDRESS: The maximum address before the address is reset to 0.
 *									 Also, if the address is being decremented, and reaches 0,
 *									 it will wrap around to MAX_ADDRESS
 */
module AddressController(clk, rst, change, forward, address);	
	parameter width = 32;
	parameter MAX_ADDRESS = 0;
	
	input logic clk;
	input logic rst;
	input logic change;
	input logic forward;
	output reg[width-1:0] address = 0;

	always_ff @(posedge clk) begin
		if(rst) 
			address <= 0; 
		
		else if (change) begin
		  
		  if(address > MAX_ADDRESS)
		    address <= 0;
		  else if (address == 0 && !forward)
		    address <= MAX_ADDRESS;  
		  else
			 address <= forward ? address + 1 : address - 1;
			 
		end
		
		else 
			address <= address;
	end
endmodule
		