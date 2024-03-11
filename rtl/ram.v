/*
    Author : Auke Dirk Pietersma
    Project: ByteBlast https://github.com/Auke-Dirk/ByteBlast
    Module : Random Access Memory (ram)
*/

module ram(clk, enable, address, data_in, data_out);

parameter ADDRESS_BITS = 6;
parameter DATA_BITS = 8;

localparam DATA_SIZE = 2 ** ADDRESS_BITS;   

// -- INPUTS
input clk;
input enable;
input [ADDRESS_BITS-1:0] address;
input [DATA_BITS-1:0] data_in;

// -- OUPUT
output reg [DATA_BITS-1:0] data_out;

// -- OTHER
reg [DATA_BITS-1:0] data [DATA_SIZE-1:0];


always @(posedge clk) begin
    if(enable) begin
        data[address] <= data_in;
    end
    data_out <= data[address];
end

endmodule