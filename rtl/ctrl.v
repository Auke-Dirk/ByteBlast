/*
    Author : Auke Dirk Pietersma
    Project: ByteBlast https://github.com/Auke-Dirk/ByteBlast
    Controler : ISA Decoder + line controller
*/

module ctrl(clk, enable, value, o_address);

parameter ADDRESS_BITS = 5;
parameter INSTR_BITS = 3;

localparam VALUE_BITS = INSTR_BITS + ADDRESS_BITS;

input clk;
input enable;
input [VALUE_BITS - 1 : 0] value;

output reg [ADDRESS_BITS - 1:0] o_address;

reg [INSTR_BITS:0] instr;
reg [ADDRESS_BITS:0] address;



always @(posedge clk) begin
    if(enable) begin
        instr <= value[7:5];
        address <= value[ADDRESS_BITS-1: 0];
    end
end

always @(instr) begin
    case(instr)
      'b01: o_address = address;
      'b10: o_address = address; 
    endcase
  end


endmodule