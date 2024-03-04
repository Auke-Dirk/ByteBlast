`timescale 10ns / 1ns

module pc_tb();

reg clk;
reg enable;
reg reset;
reg load;
reg [7:0]nxt_adr;
wire [7:0]crnt_adr;


initial begin
   clk = 0;
   enable = 0;
   reset = 0;
   nxt_adr = 0;
   load = 0;
end 


pc pc1(
    .clk(clk),
    .enable(enable),
    .reset(reset),
    .load(load),
    .nxt_adr(nxt_adr),
    .crnt_adr(crnt_adr)
    );

  initial 
  begin
    #1
    $dumpfile("vcd/pc_tb.vcd");
    $dumpvars(0, pc1);
    $display("<begin>");

    // ---------------------------------------------
    #1 // -- intial state  
    $monitor("%b %b %b %b %d %d",clk,enable,reset,load,crnt_adr,nxt_adr);
    
    #1 // -- enable + clk => increment crnt_adr 
    enable = 1;
    clk = 1;
    $monitor("%b %b %b %b %d %d",clk,enable,reset,load,crnt_adr,nxt_adr);

    #1 // -- no change  
    clk = 0;
    $monitor("%b %b %b %b %d %d",clk,enable,reset,load,crnt_adr,nxt_adr);

    #1 // -- enable + clk => increment crnt_adr 
    clk = 1;
     $monitor("%b %b %b %b %d %d",clk,enable,reset,load,crnt_adr,nxt_adr);

    #1 // load + address !clk
    clk = 0;
    nxt_adr = 16;
    load = 1;
    $monitor("%b %b %b %b %d %d",clk,enable,reset,load,crnt_adr,nxt_adr);

    #1 // clk =? crnt_adr = 16
    clk = 1;
    $monitor("%b %b %b %b %d %d",clk,enable,reset,load,crnt_adr,nxt_adr);

    #1 // setting reset hight !clk
    clk = 0;
    reset = 1;
   $monitor("%b %b %b %b %d %d",clk,enable,reset,load,crnt_adr,nxt_adr);

    #1 // clk, crnt_adr => 0
    clk = 1;
    $monitor("%b %b %b %b %d %d",clk,enable,reset,load,crnt_adr,nxt_adr);

    // ---------------------------------------------
    #1
    $display("<end>");
  end

endmodule