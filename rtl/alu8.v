/*
    Author : Auke Dirk Pietersma
    Project: ByteBlast https://github.com/Auke-Dirk/ByteBlast
    Module : Arithmetic Logic Unit (alu 8 bit arithmatic)
*/

module alu8(clk, enable, opcode, operand_lhs, operand_rhs, result);

// -- INPUTS
input clk;
input enable;
input [7:0] opcode;
input [7:0] operand_lhs;
input [7:0] operand_rhs;


// -- OUPUT
output reg [7:0] result;
reg allow_operate;



initial begin
    result = 0;
end 

always @(posedge enable) begin
    allow_operate <= 1;
end

always @(posedge clk)
begin
    if (allow_operate ===1'b1) begin
        allow_operate <= 0;
        case(opcode)        
            'b00000000: result = operand_lhs; 
            'b00000001: result = operand_rhs;
            'b00000010: result = operand_lhs + operand_rhs;
            default:
            result = opcode; //operand_lhs + operand_rhs;            
        endcase
    end
end

endmodule