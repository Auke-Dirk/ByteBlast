`timescale 10ns / 1ns

module fde_tb();


reg clk;
reg enable;
reg load;
reg reset;
reg w_ram;
reg [5:0]nxt_adr;

reg[7:0]ram_reg;
wire [5:0]crnt_adr;
wire [7:0]value_out;


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

pc #(6) pc1(
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

ram ram1(
    .clk(clk),
    .enable(w_ram), // should be called w_enable
    .address(crnt_adr),
    .data_in(ram_reg),
    .data_out(value_out)
    );
 
  integer i;
  initial 
  begin
    ram1.data[0] = 1;
    ram1.data[1] = 2;
    ram1.data[2] = 3;
    ram1.data[3] = 4;

    #1
    $dumpfile("vcd/byteblast8.vcd");    
    $display("<begin>");
    #1
    $monitor("%b> %b %b %b: %d %d",clk, fetch,decode, execute, crnt_adr,value_out);
    #1
    $display("<----->");
    #1
    for (i=0; i<12; i=i+1) begin
      #1
      clk = 1;
      $monitor("%b> %b %b %b: %d %d",clk, fetch,decode, execute, crnt_adr,value_out);

      #1
      clk = 0;
      $monitor("%b> %b %b %b: %d %d",clk, fetch,decode, execute,crnt_adr,value_out);
    end



    #1
    $display("<end>");

    end


endmodule