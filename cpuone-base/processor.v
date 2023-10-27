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

    ///////////////////////////////////////////////////////* YOUR CODE STARTS HERE *//////////////////////////////////////////////////////////
	 
	 reg [11:0] address_imem;
	 
	 // fetch from instruction
	 wire [4:0] opcode, rs, rt, rd, shamt;
	 wire [5:0] ALUop;
	 wire [15:0] immediate;
	 
	 assign opcode[4:0] = q_imem[31:27];
	 assign rs[4:0] = q_imem[26:22];
	 assign rs[4:0] = q_imem[21:17];
	 assign rd[4:0] = q_imem[16:12];
	 assign ALUop[5:0] = q_imem[5:0];
	 assign immediate[15:0] = q_imem[15:0]
	 
	 //  control bits wire declaration
	 wire ctrl_writeEnable, ctrl_writeEnable_raw,  ctrl_writeEnable_and_clock;
	 wire Rdst, ALUinB, wren_raw, wren, Rwd, JP, EXP, except_sel, BNE, JAL, JR, BLT, BEX, SETX;
	 wire [31:0] exception;
	 
	 
	 
	 // regfile params
	 wire [4:0] s1, s2, d;
	 assign s1 = rs;
	 assign s2 = rt;
	 MUX2_1_5b mux0(rt, immediate, Rdst, d); // 1->rt, 0->immediate
	 
	 regfile(clock, ctrl_writeEnable, reset, ctrl_writeReg, ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA, data_readRegB);
	 
	 
	 
	 // alu params
	 wire [31:0] alu_res;
	 wire isNotEqual, isLessThan, overflow;
	 wire [31:0] alu_in1, alu_in2;
	 wire [31:0] extend_imme;
	 
	 sign_extend SX(immediate, extend_imme);
	 MUX2_1_32b mux1();
	 
	 
	 
	 
	 alu ALU(data_readRegA, data_readRegB, ALUop, shamt, alu_res, isNotEqual, isLessThan, overflow);
	 

	 
	 


endmodule


