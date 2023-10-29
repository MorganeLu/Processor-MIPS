

module clock_divider(
	input In_clk, 
	input reset,
	output reg Out_clk
);

   always @(posedge In_clk) begin
		if (reset)
        Out_clk <= 1'b0;
		else
        Out_clk <= ~Out_clk;	
   end
	
endmodule