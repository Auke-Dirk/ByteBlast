`timescale 10ns / 1ns

module fde_tb();

reg clk;
reg enable;
reg load;
reg reset;
reg [7:0]nxt_adr;
wire [7:0]crnt_adr;

wire fetch;
wire decode;
wire execute;


initial begin
   clk = 0;
   enable = 1;
   load = 0;
end 

/*
  [fde:fetch] -> [pc:enable]
*/



pc pc1(
    .clk(clk),
    .enable(fetch),
    .reset(reset),
    .load(load),
    .nxt_adr(nxt_adr),
    .crnt_adr(crnt_adr)
    );

fde fde1(
    .clk(clk),
    .enable(enable),
    .fetch(fetch),
    .decode(decode),
    .execute(execute)
    );

  integer i;
  initial 
  begin
    #1
    $dumpfile("vcd/byteblast8.vcd");    
    $display("<begin>");

    for (i=0; i<12; i=i+1) begin
      #1
      clk = 1;
      $monitor("%b %b %b: %d",fetch,decode, execute, crnt_adr);

      #1
      clk = 0;
      $monitor("%b %b %b: %d",fetch,decode, execute,crnt_adr);
    end



    #1
    $display("<end>");

    end


endmodule