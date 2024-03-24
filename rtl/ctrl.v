/*
    Author : Auke Dirk Pietersma
    Project: ByteBlast https://github.com/Auke-Dirk/ByteBlast
    Controler : ISA Decoder + line controller
*/

module ctrl(clk, enable, value, o_address,o_instr, o_store);

parameter ADDRESS_BITS = 5;
parameter INSTR_BITS = 3;

localparam VALUE_BITS = INSTR_BITS + ADDRESS_BITS;

input clk;
input enable;
input [VALUE_BITS - 1 : 0] value;

output reg [ADDRESS_BITS - 1:0] o_address;
output reg [7:0] o_instr;
output reg o_store;

reg [INSTR_BITS:0] instr;
reg [ADDRESS_BITS:0] address;
reg allow_decode;


initial begin
  o_instr = 0;
  o_address = 0;
  o_store = 0;
  allow_decode = 0;
  instr = 0;
end 

always @(posedge enable) begin
  allow_decode <= 1;
end


always @(posedge clk) begin
    if(allow_decode) begin
        instr <= value[7:5];
        address <= value[ADDRESS_BITS-1: 0];
        allow_decode = 0;
    end
end

always @(instr) begin
    case(instr)
      'b001: o_store = 0;
      'b010: o_store = 0; 
      'b100: o_store = 1;
    endcase

    case(instr)
    'b001: o_address = address;
    'b010: o_address = address; 
    'b100: o_address = address;
    endcase
    
    case(instr)
      'b001: o_instr = 'b00000000; // LD  => ALU: LD LHS      
      'b010: o_instr = 'b00000010; // ADD => ALU: LHS + RHS
      'b100: o_instr = 'b00000001; // STO => ALU: LD RHS
      default: o_instr = 'b11111111; 
    endcase
  end


endmodule