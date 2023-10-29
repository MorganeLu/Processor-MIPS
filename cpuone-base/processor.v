/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
	 

	 /***  IF stage  ***/
	 wire [31:0] pc_in, pc_out;
	 
	 pc_counter pc_counter1(.clock(clock), .reset(reset), .pc_in(pc_in), .pc_out(pc_out));
	 assign address_imem = pc_out[11:0];
	 
	 
	 
	 /***  ID stage  ***/
	 wire [31:0] inst_code;
	 wire [7:0]  alu_code;
	 wire ctrl_ALU_integer;
	 
	 decoder_5to32 instr_decoder(q_imem[31:27], inst_code);
	 decoder_3to8  aluop_decoder(q_imem[4:2], alu_code);
	 
	 or Int_ctr1(ctrl_ALU_integer, inst_code[5], inst_code[7], inst_code[8]);	// addi/sw/lw; Integer in ALU_dataB
	 or write_reg(ctrl_writeEnable, inst_code[0], inst_code[5], inst_code[8]);	// ALU/addi/lw; write data to Regfile
	 assign wren = inst_code[7];		// sw; save data to MEM
	 assign ctrl_alu_dmem = inst_code[8];	// lw; load data from MEM
	 
	 assign ctrl_readRegA = q_imem[21:17];
	 assign ctrl_readRegB = q_imem[16:12];
		
		
	 /***  ALU  ***/
	 wire [31:0] Immediate_N, alu_datain_B, ALU_dataout, ALU_dataout_calc;
	 wire [4:0] ALUopcode;
	 wire isNotEqual, isLessThan, overflow;
	 
	 mux_2to1_5b mux_2to1_5b_1(.in0(q_imem[6:2]), .in1(5'd00000), .select(ctrl_ALU_integer), .out(ALUopcode));	// addi/lw/sw or ALU operation
	 
	 // get immediate value
	 assign Immediate_N[31:17] = q_imem[16] == 1 ? 15'h7FFF : 15'h0000;
	 assign Immediate_N[16:0]  = q_imem[16:0];
	 
	 mux_2to1_32b mux_immediate_regB(.in0(data_readRegB), .in1(Immediate_N), .select(ctrl_ALU_integer), .out(alu_datain_B)); // immediate or regB
	 
	 alu my_ALU(
		.data_operandA(data_readRegA),
		.data_operandB(alu_datain_B),
		.ctrl_ALUopcode(ALUopcode),
		.ctrl_shiftamt(q_imem[11:7]),
		.data_result(ALU_dataout_calc), 
		.isNotEqual(isNotEqual), 
		.isLessThan(isLessThan), 
		.overflow(overflow)
	 );
		
	 /***  Overflow  ***/
	 wire is_add_overflow,is_sub_overflow,is_addi_overflow,is_ovf;
	 wire [31:0] ALU_dataout_ovf;
	 
	 and (is_add_overflow,overflow,alu_code[0]);//add
	 and (is_sub_overflow,overflow,alu_code[1]);//sub
	 and (is_addi_overflow,overflow,inst_code[5]);//addi
	 or(is_ovf,is_add_overflow,is_sub_overflow,is_addi_overflow);
	 
	 assign ALU_dataout_ovf = is_ovf ? (is_add_overflow ? 32'd1 : (is_sub_overflow ? 32'd3 : 32'd2)) : 32'd0;
	 assign ALU_dataout = is_ovf ? ALU_dataout_ovf : ALU_dataout_calc;
	 
	 
	 
	 /***  dMEM  ***/
	 wire [31:0] MEM_dataout;
	 assign data[31:0] = data_readRegB[31:0];
	 assign address_dmem[11:0] = ALU_dataout[11:0];
	 mux_2to1_32b mux_ALU_MEM(.in0(ALU_dataout), .in1(q_dmem), .select(ctrl_alu_dmem), .out(MEM_dataout));
	 
	 


	 
	 /***  WB  ***/
	 assign data_writeReg = MEM_dataout;
	 assign ctrl_writeReg = is_ovf ? 5'b11110 : q_imem[26:22];

	always @*
		begin
			$display("==========================================================");
			$display("q_imem: %b", q_imem);
			$display("opcode: %b", q_imem[31:27]);
			$display("alu_code: %b", alu_code);
			$display("ctrl writeReg: %b", ctrl_writeReg);	
			$display("data_writeReg: %b", data_writeReg);		
			$display("ALU_dataout_calc: %b", ALU_dataout_calc);
			$display("overflow: %b", overflow);			
			$display("Immediate_N: %b", Immediate_N);
			$display("ctrl_readRegA: %b", ctrl_readRegA);
			$display("ctrl_readRegB: %b", ctrl_readRegB);
			
			$display("data_readRegA: %b", data_readRegA);
			$display("data_readRegB: %b", data_readRegB);
			$display("alu_datain_B: %b", alu_datain_B);
			
			
	 end
	 
endmodule
