`default_nettype none

/*
 * FlashReader is an FSM which talks directly to the flash controller.
 * It handles the signals which tell the flash reader to bo begin a read, and it also selects the
 * relevant data from the data it recieves (whether to use to upper or lower 16 bits).
 * It does not directly control the address however, this is done by AddressController.
 *
 * inputs:	clk: Clock which this FSM runs on
 *				kybrd_pause: The FSM will stay in an idle state while this is true.
 *				flsh_waitrequest: The FSM must wait until this 
 *									   is de-asserted until it can continue a read
 *				flsh_readdata: 32 bit data from flash memory
 *				flsh_readdatavalid: Asserted when flsh_readdata is valid
 *				startsamplenow: Pulsed on each clock edge of the slower samplerate clock. 
 *									 Usually this is 22KHz
 *			
 *				
 * outputs:	flsh_read: This is pulsed for one clock cycle when data is requested 
 *							  from the flash controller.
 *				flsh_byteenable: This determines which bytes are needed from flash memory
 *				address_change: This is pulsed when the FSM is done reading a complete sample.
 *									 It causes address to the flash controller to either increment
 *									 or decrement.
 *				audio_enable: Enables the audio register to read new data
 *				audio_out: 16 bit audio output data. 
 *				debug: Includes the current state, and the values of flsh_waitrequest and flsh_readdata
 */
module FlashReader(clk,kybrd_pause,flsh_waitrequest,flsh_read,flsh_readdata,flsh_readdatavalid,flsh_byteenable,
	address_change,audio_enable,audio_out,startsamplenow, debug);
	
	/************************I/O*************************/
	input logic  			clk;
	output logic [15:0]	debug;
	
	//keyboard interface:
	input logic 			kybrd_pause;
	
	//Interface to flash:	
	input logic				flsh_waitrequest;
	output logic 			flsh_read;
	input logic[31:0]		flsh_readdata;
	input logic 			flsh_readdatavalid;
	output logic[3:0] 	flsh_byteenable;
	
	//Interface address controller:
	output logic 			address_change;
	
	//Interface to audio register:
	output logic 			audio_enable;
	output logic[15:0]   audio_out;
	
	//interface to slowClockTrigger:
	input	logic	 			startsamplenow; //this is not edge sensitive
	
	/*****************************************************************/
	
	
	//internal wires:
	wire start = startsamplenow & !kybrd_pause;
			

	//state encoding: {state bits}, {flsh_read}, {address_change}, {audio_use_lower}
	//audio enable is not assigned to a state bit. it is directly assigned to flsh_readdatavalid.
   reg[6:0] state = 0;
	parameter idlea = 7'b0000_0_0_0;
	parameter a1 = 7'b0001_1_0_1;
	parameter a2 = 7'b0010_0_0_1;
	
	parameter idleb = 7'b0011_0_0_1;
	parameter b1 = 7'b0100_1_0_0;
	parameter b2 = 7'b0101_0_0_0;
	parameter b3 = 7'b0110_0_0_0;
	parameter b4 = 7'b0111_0_1_0; //extra state to ensure we dont increment the address while reading audio data
	
	//simple output logic:
	assign flsh_read = state[2];
	assign address_change = state[1];
	
	assign flsh_byteenable = 4'b1111; //TODO: include this in state bits
	assign audio_enable = flsh_readdatavalid;
	assign audio_out = state[0] ? flsh_readdata[15:0] : flsh_readdata[31:16];
	assign debug = {6'b0, flsh_waitrequest,flsh_readdatavalid,4'b0,state[6:3]};
	
	//next state logic:
	always_ff @(posedge clk)
			begin
					case (state)
					
					idlea: begin 
							 if (start)
								state <= a1;				    
							 else					 
								state <= idlea;
							 end
							 
					a1:	 begin
							 if(!flsh_waitrequest)
								state <= a2;
							 else
								state <= a1;
							 end
							 
					a2:    begin 
							 if(flsh_readdatavalid) 
								state <= idleb;
							 else
								state <= a2;  
						    end
							 
					idleb: begin 
							 if (start)
								state <= b1;			    
							 else					 
								state <= idleb;
							 end
					
					b1:	 begin 
							 if(!flsh_waitrequest)
								state <= b2;
							 else
							   state <= b1;
							 end
					
					b2:    begin 
							 if(flsh_readdatavalid)
								state <= b3;
							 else
								state <= b2;
						    end
							 
					b3:	 begin
							 state <= b4;
							 end
							 
					b4:	 begin
							 state <= idlea;
							 end
		
					default: state <= idlea;
			endcase
		end
	
	endmodule