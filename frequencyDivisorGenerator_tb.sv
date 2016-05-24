module frequencyDivisorGenerator_tb();
	logic key_0, key_1, key_2, clk; 
	logic[31:0] frequency_divisor;
	
	frequencyDivisorGenerator #(.max_divisor(32'd1140), .min_divisor(32'd1130)) dut(
		.key_0(key_0),
		.key_1(key_1),
		.key_2(key_2),
		.clk(clk),
		.frequency_divisor(frequency_divisor)
	);


	initial begin
		forever begin
			clk = 1; #1;
			clk = 0; #1;
		end
	end

	initial begin
		key_0 = 1;
 		key_1 = 0;
		key_2 = 0;
		#20;
		
		key_0 = 0;
		key_1 = 1;
		key_2 = 0;
		#20;

		key_0 = 1;
		key_1 = 1;
		key_2 = 0;
		#20;

		key_2 = 1;
		#2;
		key_2 = 0;
		#20;
		
		$stop;
	end
endmodule