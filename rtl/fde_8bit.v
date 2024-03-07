/*
    Author : Auke Dirk Pietersma
    Project: ByteBlast https://github.com/Auke-Dirk/ByteBlast
    Module : Fetch Decode Execute (fde 8 bit)
*/

module fde_8bit(clk, enable, fetch, decode, execute);

localparam FETCH = 0;
localparam DECODE = 1;
localparam EXECUTE = 2;
localparam IDLE = 3;
// inputs
input clk;
input enable;

//outputs
output fetch;
output decode;
output execute;

// internal
reg [1:0]fde_state;

initial begin
    fde_state = IDLE;
end 

always @(posedge clk) 
begin
    if (enable == 1) begin
        if (fde_state == 2) begin
            fde_state <= FETCH;
        end else begin
            fde_state <= fde_state + 1;
        end
    end
end    

assign fetch = fde_state == FETCH;
assign decode = fde_state == DECODE;
assign execute = fde_state == EXECUTE;

endmodule