module clkdiv (clk, clk_out);
 

parameter WIDTH = 2; // Width of the register required

input clk;
output clk_out;
 
reg [WIDTH-1:0] memory;
 
initial begin
    memory = 0;
end

always @(posedge clk)
begin
	memory = memory << 1;
	if (memory == 0) begin
		memory <= 1;
	end
end
 
 assign clk_out = memory[0];
endmodule