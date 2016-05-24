`default_nettype wire

/*
 * Produces a clock which is divisor times slower than clk_in.
 *
 * inputs: clk_in: The input clock
 *			  divisor: How much slower clk_out will be compared to clk_in
 *
 *	outputs:	clk_out: The output clock
 */
module frequencyDivider(clk_in, clk_out, divisor);
	input logic clk_in;
	input logic[31:0]  divisor;
	output reg clk_out = 0;

	logic[31:0] counter_out;
	logic reset_counter ;
	
	assign reset_counter = (counter_out >= divisor);
	
	counter counter(.clk(clk_in), .reset(reset_counter), .counter(counter_out));
		
	always_ff @(posedge clk_in)
	if(reset_counter) begin
		clk_out = !clk_out;
		end
	
endmodule

module counter(clk, reset, counter);
	parameter counter_width = 32;
	input clk;
	input reset;
	output reg[counter_width-1:0] counter = 0;
	
	always_ff @(posedge clk) begin
			if(reset) begin
				counter <= 0;
			end else begin
				counter <= counter + 1;
			end
		end
		
endmodule

