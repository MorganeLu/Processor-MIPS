module MUX2_1_1b(in1, in0, selctor, out);
	input in1, in0;
	input selector;
	output out;
	
	out = selector:in1?in0; //1->1, 0->0

endmodule


module MUX2_1_5b(in_1, in_0, selctor, out_5b);
	input [4:0] in_1, in_0;
	input selector;
	output [4:0] out_5b;
	
	out_5b[4:0] = selector:in_1[4:0]?in_0[4:0]; //1->1, 0->0
endmodule


module MUX2_1_32b(in1_, in0_, selctor, out_32b);
	input [31:0] in1_, in0_;
	input selector;
	output [31:0] out_32b;
	
	out_32b[31:0] = selector:in1_[31:0]?in0_[31:0]; //1->1, 0->0

endmodule
