
module decoder_5to32 (
	input [4:0] in,
	input enable,
	output [31:0] out
);

    wire [3:0] out2_4, t1;
    decoder_2to4 d0(.in(in[4:3]), .out(t1));
    assign out2_4 = enable ? t1 : 0;
    decoder_3to8 d1(out[7:0],in[2:0],out2_4[0]);
    decoder_3to8 d2(out[15:8],in[2:0],out2_4[1]);
    decoder_3to8 d3(out[23:16],in[2:0],out2_4[2]);
    decoder_3to8 d4(out[31:24],in[2:0],out2_4[3]);

endmodule


module decoder_2to4 (
	input [1:0] in,
	output[3:0] out
);
	and(out[0],~in[0],~in[1]);
	and(out[1],~in[1],in[0]);
	and(out[2],in[1],~in[0]);
	and(out[3],in[1],in[0]);
endmodule


module decoder_3to8 (
	input[2:0] in,
	input enable,
	output[7:0] out
);

    and(out[0], ~in[2], ~in[1], ~in[0], enable);
    and(out[1], ~in[2], ~in[1],  in[0], enable);
    and(out[2], ~in[2],  in[1], ~in[0], enable);
    and(out[3], ~in[2],  in[1],  in[0], enable);
    and(out[4],  in[2], ~in[1], ~in[0], enable);
    and(out[5],  in[2], ~in[1],  in[0], enable);
    and(out[6],  in[2],  in[1], ~in[0], enable);
    and(out[7],  in[2],  in[1],  in[0], enable);
	 
endmodule