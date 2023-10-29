

//module mux_2(select, in0, in1, out);
//	input select;
//	input [31:0] in0,in1;
//	output [31:0] out;
//	assign out = select ? in1 : in0;
//endmodule
//
//module mux_verilog(select, in0, in1, in2, in3, out);
//	input [1:0] select;
//	input [31:0] in0, in1, in2, in3;
//	output [31:0] out;
//	wire [31:0] w1,w2;
//	mux_2 first_top(.select(select[0]), .in0(in0), .in1(in1), .out(w1));
//	mux_2 first_bottom(.select(select[0]), .in0(in2), .in1(in3), .out(w2));
//	mux_2 second(.select(select[1]), .in0(w1), .in1(w2), .out(out));
//endmodule

module mux_2to1_1b(
	input [4:0] in0,
	input [4:0] in1,
	input select,
	output[4:0] out
);
    
	assign out = select ? in1 : in0;

endmodule


module mux_2to1_5b(
	input [4:0] in0,
	input [4:0] in1,
	input select,
	output[4:0] out
);
    
	assign out = select ? in1 : in0;

endmodule


module mux_2to1_32b(
	input [31:0] in0,
	input [31:0] in1,
	input select,
	output[31:0] out
);

	assign out = select ? in1 : in0;

endmodule


module mux_4to1_5b(
	input [1:0]  select,
	input [31:0] in0, in1, in2, in3,
	output[31:0] out
);
	wire [31:0] w1,w2;
	mux_2to1_5b first_top(.select(select[0]), .in0(in0), .in1(in1), .out(w1));
	mux_2to1_5b first_bottom(.select(select[0]), .in0(in2), .in1(in3), .out(w2));
	mux_2to1_5b second(.select(select[1]), .in0(w1), .in1(w2), .out(out));
endmodule