`timescale 10ns / 1ns

module fde_tb();

reg clk;
reg enable;
wire fetch;
wire decode;
wire execute;

initial begin
   clk = 0;
   enable = 1;
end 


fde fde1(
    .clk(clk),
    .enable(enable),
    .fetch(fetch),
    .decode(decode),
    .execute(execute)
    );

  initial 
  begin
    #1
    $dumpfile("vcd/fde_tb.vcd");
    $dumpvars(0, fde1);
    $display("<begin>");

    // ---------------------------------------------
    #1 // -- intial state  
    $monitor("%b %b %b %b",clk,fetch, decode, execute);
    
  
    #1 // -- enable + clk => increment crnt_adr 
    clk = 1;
    $monitor("%b %b %b %b",clk,fetch, decode, execute);
  
    #1 // -- no change  
    clk = 0;
    $monitor("%b %b %b %b",clk,fetch, decode, execute);
    
    #1 // -- enable + clk => increment crnt_adr 
    clk = 1;
    $monitor("%b %b %b %b",clk,fetch, decode, execute);
    
    #1 // load + address !clk
    clk = 0;
    $monitor("%b %b %b %b",clk,fetch, decode, execute);
    
    #1 // clk =? crnt_adr = 16
    clk = 1;
    $monitor("%b %b %b %b",clk,fetch, decode, execute);
    
    #1 // setting reset hight !clk
    clk = 0;
    $monitor("%b %b %b %b",clk,fetch, decode, execute);
    
    #1 // clk, crnt_adr => 0
    clk = 1;
    $monitor("%b %b %b %b",clk,fetch, decode, execute);
    
    #1 // setting reset hight !clk
    clk = 0;
    $monitor("%b %b %b %b",clk,fetch, decode, execute);
    
    #1 // clk, crnt_adr => 0
    clk = 1;
    $monitor("%b %b %b %b",clk,fetch, decode, execute);

    #1 // setting reset hight !clk
    clk = 0;
    $monitor("%b %b %b %b",clk,fetch, decode, execute);
    
    #1 // clk, crnt_adr => 0
    clk = 1;
    $monitor("%b %b %b %b",clk,fetch, decode, execute);


    // ---------------------------------------------
    #1
    $display("<end>");
  end

endmodule