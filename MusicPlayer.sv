`default_nettype none

/*
 * This module takes input from the keyboard and the flash controller, and outputs to 
 * the audio controller. It contains an FSM to talk to the flash controller, an FSM
 * to controll the address, and a register to hold the audio data.
 *
 * inputs:	clk: Clock that all FSM's run on
 *				kybrd_forward: Set if the song is playing forward
 *				kybrd_pause: Set of the song is pause.
 *				kybrd_reset: This input should pulse for one cycle indicating that the 
 *								 flash address should be set to 0
 *				startsamplenow: A pulse which occurs on the edge of the samplerate clock 
 *									 (Normally 22KHz)
 *				flsh_waitrequest: This is set if the flash controller cannot 
 *									   perfom anymore pipelined reads
 *				flsh_readdata: The 32 bit data from flash memory
 *				flsh_readdatavalid: Set if flsh_readdata represents valid data
 *				
 *
 *	outputs: flsh_address: The address which goes into the flash controller			
 * 			flsh_byteenable: used to determine which bytes are needed from
 *										flash memory
 *				audio_data: 16 bit audio data from flash memory
 *				debug: general debug info. It includes current state, and status of
 *						 flsh_waitrequest and flsh_readdatavalid
 *				debug_address: The current address being given to flash memory
 *
 */

module MusicPlayer(clk, kybrd_forward, kybrd_pause, kybrd_reset, startsamplenow, flsh_address, 
	flsh_waitrequest,flsh_read,flsh_readdata,flsh_readdatavalid,flsh_byteenable,audio_data,debug, debug_address);
	
	//I/O:
	input logic clk;
	input logic kybrd_forward, kybrd_pause, kybrd_reset;
	input logic startsamplenow;
	output logic[22:0] flsh_address;
	input logic[31:0] flsh_readdata;
	input logic flsh_waitrequest, flsh_readdatavalid;
	output logic flsh_read;
	output logic[3:0] flsh_byteenable;
	output logic [15:0] audio_data;
	output logic [15:0] debug;
	output logic [15:0] debug_address;
	
	assign debug_address = flsh_address[15:0];
	
	//internal wires:
	wire address_change;
	wire audio_enable;
	wire[15:0] audio_fsmout;
	

	//The FlashReader FSM:
	FlashReader flashReader(
		.clk(clk),
		.kybrd_pause(kybrd_pause),
		.flsh_waitrequest(flsh_waitrequest),
		.flsh_read(flsh_read),
		.flsh_readdata(flsh_readdata),
		.flsh_readdatavalid(flsh_readdatavalid),
		.flsh_byteenable(flsh_byteenable),
		.address_change(address_change),
		.audio_enable(audio_enable),
		.audio_out(audio_fsmout),
		.startsamplenow(startsamplenow),
		.debug(debug)
	);
	
	//Address controller. Connected between FlashReader and Flash Interface:
	wire reset_address = (flsh_address >= 23'h7FFFF) || kybrd_reset;
	AddressController #(.width(23), .MAX_ADDRESS(23'h7FFFF)) addresscontroller(
	 .clk(clk),
	 .rst(kybrd_reset),
	 .change(address_change),
	 .forward(kybrd_forward),
	 .address(flsh_address)
	);
	
	
	//register with enable to hold audio data:
	always_ff @(posedge clk)
		if(audio_enable) audio_data = audio_fsmout;
		else audio_data = audio_data;
	
	
endmodule