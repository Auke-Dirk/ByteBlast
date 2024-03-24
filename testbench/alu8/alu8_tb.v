`timescale 10ns / 1ns

module alu8_tb();

reg clk;
reg enable;
reg [7:0]opcode;
reg [7:0]operand_lhs;
reg [7:0]operand_rhs;
wire [7:0]result;

initial begin
   clk = 0;
   enable = 0;
   opcode = 0;
   operand_lhs = 0;
   operand_rhs = 0;
end 


alu8 alu8_1(
    .clk(clk),
    .enable(enable),
    .opcode(opcode),
    .operand_lhs(operand_lhs),
    .operand_rhs(operand_rhs),
    .result(result)
    );

  initial 
  begin
    #1
    $dumpfile("vcd/alu8_tb.vcd");
    $dumpvars(0, alu8_1);
    $display("<begin>");
    #1

    $monitor("op:%d lhs:%d rhs:%d res:%d",opcode, operand_lhs,operand_rhs, result);
    #1
    operand_lhs = 1;
    operand_rhs = 3;
    
    
    $monitor("op:%d lhs:%d rhs:%d res:%d",opcode, operand_lhs,operand_rhs, result);

    #1
    $display("<end>");
  end

endmodule