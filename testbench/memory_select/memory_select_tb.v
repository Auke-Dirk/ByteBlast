/*
    Author : Auke Dirk Pietersma
    Project: ByteBlast https://github.com/Auke-Dirk/ByteBlast
    Module : Memory Select TB

    Here we test which component is selected to request the current 
    address to be read from ram. This will come available on the 
    next clock.
    
    ram address,value
      0,10
      1,11
      2,12
      3,13
      
                      [mux_4]
    [fed] state  ----> state  
          reg 0  ----> a
          reg 1  ----> b
          reg 2  ----> c
          reg 3  ----> d         [ram]
                       out ----> address
                                 data_out --> ram_value 
    
*/

`timescale 10ns / 1ns

module memory_select_tb();

parameter ADDRESS_BITS = 5;
parameter DATA_BITS = 8;

reg clk;
reg enable;
reg ram_enable;

reg [ADDRESS_BITS-1:0] a1; 
reg [ADDRESS_BITS-1:0] a2; 
reg [ADDRESS_BITS-1:0] a3; 
reg [ADDRESS_BITS-1:0] a4; 

reg [DATA_BITS-1:0] d1;

wire fde_fetch;
wire fde_decode;
wire fde_execute;
wire [1:0] fde_state;
wire [ADDRESS_BITS-1:0] mux_address;
wire [DATA_BITS-1:0] ram_value;

fde fde_1(
    .clk(clk),
    .enable(enable),
    .fetch(fde_fetch),
    .decode(fde_decode),
    .execute(fde_execute),
    .fde_state(fde_state)
    );

ram #(5,8) ram_1(
    .clk(clk),
    .enable(ram_enable), // should be called w_enable
    .address(mux_address),
    .data_in(d1),
    .data_out(ram_value)
    );

mux4 #(5) mux4_1(
  .sel(fde_state),
  .a(a1),
  .b(a2),
  .c(a3),
  .d(a4),
  .out(mux_address)
  );

  integer i;
  initial 
  begin

    ram_enable = 0;
    enable = 1;
    clk = 0;

    ram_1.data[0] = 10;
    ram_1.data[1] = 11;
    ram_1.data[2] = 12;
    ram_1.data[3] = 13;
    
    a1 = 0;
    a2 = 1;
    a3 = 2;
    a4 = 3;
  
    #1
    $dumpfile("vcd/memory_select.vcd");    
    $display("<begin>");
    
    
    for (i=0; i<12; i=i+1) begin
      #1
      clk = 1;
      $monitor("address:%d value:%d",mux_address, ram_value);
      #1
      clk = 0;
    end

    #1
    $display("<end>");
  end

endmodule