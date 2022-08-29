`timescale 1ns / 1ps
//`include "user_module_341178296293130834.v"

module user_module_341178296293130834_tb;

reg [7:0] io_in;
wire [7:0] io_out;

user_module_341178296293130834 UUT (.io_in(io_in), .io_out(io_out));

`define I_NOP0  4'b0000
`define I_LD    4'b0001
`define I_ADD   4'b0010
`define I_SUB   4'b0011
`define I_ONE   4'b0100
`define I_NAND  4'b0101
`define I_OR    4'b0110
`define I_XOR   4'b0111
`define I_STO   4'b1000
`define I_STOC  4'b1001
`define I_IEN   4'b1010
`define I_OEN   4'b1011
`define I_JMP   4'b1100
`define I_RTN   4'b1101
`define I_SKZ   4'b1110
`define I_NOPF  4'b1111

parameter CLK_HALF_PERIOD = 5;

`define OP0(I) \
  io_in[5] = (I >> 3) & 1'b1; \
  io_in[4] = (I >> 2) & 1'b1; \
  io_in[3] = (I >> 1) & 1'b1; \
  io_in[2] = (I >> 0) & 1'b1; \
  io_in[0] = 1'b1; \
  #(CLK_HALF_PERIOD); \
  io_in[0] = 1'b0; \
  #(CLK_HALF_PERIOD); \
  io_in[0] = 1'b1; \
  #(CLK_HALF_PERIOD); \
  io_in[0] = 1'b0; \
  #(CLK_HALF_PERIOD);

`define OP1(I, P) \
  io_in[5] = (I >> 3) & 1'b1; \
  io_in[4] = (I >> 2) & 1'b1; \
  io_in[3] = (I >> 1) & 1'b1; \
  io_in[2] = (I >> 0) & 1'b1; \
  io_in[6] = P; \
  io_in[0] = 1'b1; \
  #(CLK_HALF_PERIOD); \
  io_in[0] = 1'b0; \
  #(CLK_HALF_PERIOD); \
  io_in[0] = 1'b1; \
  #(CLK_HALF_PERIOD); \
  io_in[0] = 1'b0; \
  #(CLK_HALF_PERIOD);

initial begin
  $dumpfile("user_module_341178296293130834_tb.vcd");
  $dumpvars(0, user_module_341178296293130834_tb);
end

initial begin
   #100_000_000; // Wait a long time in simulation units (adjust as needed).
   $display("Caught by trap");
   $finish;
 end

// always begin
//   io_in[0] = 1'b1;
//   #(CLK_HALF_PERIOD);
//   io_in[0] = 1'b0;
//   #(CLK_HALF_PERIOD);
// end

initial 
begin
  #20
	io_in[1] = 1;
	#(CLK_HALF_PERIOD);
	io_in[1] = 0;
	#(CLK_HALF_PERIOD);

  `OP0(`I_ONE);
  `OP0(`I_ONE);
  `OP1(`I_OEN, 0);
  `OP1(`I_IEN, 0);
  `OP0(`I_STO);
  `OP0(`I_STOC);
  `OP1(`I_OEN, 1);
  `OP1(`I_IEN, 1);
  `OP0(`I_STO);
  `OP0(`I_STOC);
  `OP1(`I_LD, 0);
  `OP0(`I_SKZ);
  `OP0(`I_STO);
  `OP0(`I_SKZ);
  `OP1(`I_LD, 1);
  `OP1(`I_LD, 1);
  `OP0(`I_SKZ);
  `OP1(`I_LD, 0);

  `OP0(`I_NOP0);
  `OP0(`I_NOPF);
  `OP0(`I_NOP0);
  `OP0(`I_JMP);

  `OP0(`I_RTN);
  `OP0(`I_JMP);

  `OP0(`I_STOC);
  `OP0(`I_STO);

  `OP1(`I_ADD, 0);
  `OP1(`I_ADD, 1);
  `OP1(`I_ADD, 1);
  `OP1(`I_ADD, 1);
  `OP1(`I_ADD, 0);

  `OP1(`I_ONE, 1); // set carry
  `OP1(`I_ADD, 1);
  `OP1(`I_LD, 1);
  `OP1(`I_SUB, 1);

  `OP1(`I_LD, 1);
  `OP1(`I_SUB, 0);

  `OP1(`I_ONE, 1);
  `OP1(`I_NAND, 1);
  `OP1(`I_NAND, 1);

  `OP1(`I_XOR, 1);
  `OP1(`I_XOR, 1);
  `OP1(`I_XOR, 1);
  `OP1(`I_OR, 1);

  `OP1(`I_LD, 0);
  `OP1(`I_OR, 0);
  


  `OP0(`I_NOP0);
  `OP0(`I_NOP0);
  `OP0(`I_NOP0);
end

endmodule
