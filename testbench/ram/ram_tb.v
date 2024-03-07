`timescale 10ns / 1ns

module ram_tb();

reg clk;
reg enable;
reg [5:0]address;
reg [7:0]value_in;
wire [7:0]value_out;


initial begin
   clk = 0;
   enable = 0;
   address = 0;
   value_in = 0;
end 


ram ram1(
    .clk(clk),
    .enable(enable),
    .address(address),
    .data_in(value_in),
    .data_out(value_out)
    );

  initial 
  begin
    #1
    $dumpfile("vcd/ram_tb.vcd");
    $dumpvars(0, ram1);
    $display("<begin>");

    // ---------------------------------------------
    #1 // -- intial state  
    $monitor("%b %d %d %d",clk, address, value_in, value_out);

    #1 // H
    clk = 1;
    enable = 1;
    value_in = 16;
    address = 0;
    $monitor("%b %d %d %d",clk, address, value_in, value_out);

    #1 // L
    clk = 0;
    $monitor("%b %d %d %d",clk, address, value_in, value_out);

    #1 // H
    clk = 1;
    $monitor("%b %d %d %d",clk, address, value_in, value_out);

    #1 // L
    clk = 0;
    $monitor("%b %d %d %d",clk, address, value_in, value_out);

    #1 // H
    clk = 1;
    $monitor("%b %d %d %d",clk, address, value_in, value_out);

    #1 // L
    clk = 0;
    $monitor("%b %d %d %d",clk, address, value_in, value_out);

    // ---------------------------------------------
    #1
    $display("<end>");
  end

endmodule