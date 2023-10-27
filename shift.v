module shift2_16b(in, out);
	input [15:0] in;
	output [17:0] out;
	
	genvar i;
	generate for (i=0; i<16; i=i+1) begin:in_loop
		assign out[i+2] = in[i];
	end
	endgenerate
	
	assign out[0] = 0;
	assign out[0] = 0;

endmodule
