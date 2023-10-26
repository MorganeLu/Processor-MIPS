module sign_extend(extended, imme_num):
	input [15:0] imme_num;
	output reg [31:0] res;

	wire sign;

	assign sign = imme_num[15];
	
	genvar i;
	generate
	for (i = 31; i > 16; i = i - 1) begin : extendsign
		res[i] <= sign;
		res[i-16] <= imme_num[i-16];
	end
	end

endmodule
