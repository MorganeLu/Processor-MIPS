module sign_extend(immediate, res):
	input [15:0] immediate;
	output reg [31:0] res;

	wire sign;

	assign sign = immediate[15];
	
	genvar i;
	generate
	for (i = 31; i > 16; i = i - 1) begin : extendsign
		res[i] <= sign;
		res[i-16] <= immediate[i-16];
	end
	endgenerate

endmodule
