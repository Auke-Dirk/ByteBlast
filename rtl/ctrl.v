/*
    Author : Auke Dirk Pietersma
    Project: ByteBlast https://github.com/Auke-Dirk/ByteBlast
    Controler : ISA Decoder + line controller
*/

module ctrl(clk, enable, value);

parameter ADDRESS_BITS = 5;
parameter INSTR_BITS = 3;

localparam VALUE_BITS = INSTR_BITS + ADDRESS_BITS;

input clk;
input enbale;
input [VALUE_BITS - 1 : 0] value;

reg [INSTR_BITS] instr;
reg [ADDRESS_BITS] address;

always @(posedge clk) begin
    if(enable) begin
        instr <= value[VALUE_BITS-1: VALUE_BITS-1 -INSTR_BITS];
        address <= value[ADDRESS_BITS-1: 0];
    end
end



endmodule