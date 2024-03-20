
/*
    Author : Auke Dirk Pietersma
    Project: ByteBlast https://github.com/Auke-Dirk/ByteBlast
    Module : Program Counter (pc)
*/

module pc(clk, enable, reset, load, nxt_adr, crnt_adr);

// Specifies the address with.
parameter WIDTH = 8;

// -- INPUTS
input clk;
input enable;
input reset;
input load;
input [WIDTH-1:0] nxt_adr;

// -- OUTPUTS
output [WIDTH-1:0]crnt_adr;

// -- OTHER
reg [WIDTH-1:0] data;

initial begin
    data = {WIDTH{1'b0}};
end 

always @(posedge clk) 
begin
    if (reset == 1) begin
        data <= {WIDTH{1'b1}};
    end else if (load == 1) begin
        data <= nxt_adr;
    end else if (enable == 1) begin
        data <= data + 1;
    end    
end

assign crnt_adr = data;

//
endmodule
