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
          pc     ----> a
          reg 1  ----> b
          reg 2  ----> c
          reg 3  ----> d         [ram]
                       out ----> address
                                 data_out --> ram_ctrl_value 
    
*/

`timescale 10ns / 1ns

module byteblast8_tb();

parameter ADDRESS_BITS = 5;
parameter DATA_BITS = 8;

reg clk;
reg halv_clk;
wire exec_clk;
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
//wire [DATA_BITS-1:0] ram_value;

wire [7:0]ctrl_value;

// Wires for ram read select address, input mux4_1
wire [4:0] pc_ram_select;
wire [4:0] ctrl_ram_select;

// Wire for ram output
wire [7:0] ram_ctrl_value;
wire ram_write;

// Wire fo alu
wire[7:0] ctrl_alu_opcode_lhs;

// Unused
wire [4:0] pc_next_address;

// Accumulator
wire[7:0] accu_in;
wire[7:0] accu_out;


clkdiv clkdiv_1(clk,halv_clk);

inv inv1(clk,exec_clk);

// Fetch Decode Execture 
// This dictates which rtl is currently active
fde fde_1(
    .clk(halv_clk),
    .enable(enable),
    .fetch(fde_fetch),
    .decode(fde_decode),
    .execute(fde_execute),
    .fde_state(fde_state)
    );

// Program Counter
pc #(5) pc1(
    .clk(halv_clk),
    .enable(fde_fetch),
    .reset(reset),
    .load(load),
    .nxt_adr(pc_next_address),
    .crnt_adr(pc_ram_select)
    );

// Controler / Decoder
ctrl ctrl1(
      .clk(exec_clk),
      .enable(fde_decode),
      .value(ram_ctrl_value),
      .o_address(ctrl_ram_select),
      .o_instr(ctrl_alu_opcode_lhs),
      .o_store(ram_write)
      );
  



ram #(5,8) ram_1(
    .clk(clk),
    .enable(ram_write), // should be called w_enable
    .address(mux_address),
    .data_in(accu_out),
    .data_out(ram_ctrl_value)
    );

mux4 #(5) mux4_1(
  .sel(fde_state),
  .a(pc_ram_select),
  .b(ctrl_ram_select),
  .c(ctrl_ram_select),
  .d(a4),
  .out(mux_address)
  );

  alu8 alu8_1(
  .clk(exec_clk),
  .enable(fde_execute),
  .opcode(ctrl_alu_opcode_lhs),
  .operand_lhs(ram_ctrl_value),
  .operand_rhs(accu_out),
  .result(accu_in)
  );

  register register_1
  (.clk(clk),
  .enable(enable),
  .data_in(accu_in),
  .data_o(accu_out)
  );

  integer i;
  initial 
  begin

    ram_enable = 0;
    enable = 1;
    clk = 0;

    ram_1.data[0] = 8'b00100011; //  35 23x 001 00011 LD  : address 3
    ram_1.data[1] = 8'b01000100; //  68 44x 010 00100 ADD : address 4
    ram_1.data[2] = 8'b10000101; // 133 85x 100 00101 STR : address 5
    ram_1.data[3] = 2;
    ram_1.data[4] = 5;
    ram_1.data[5] = 0; // 7 
    ram_1.data[6] = 0; // 7 
    ram_1.data[7] = 0; // 7 
    ram_1.data[8] = 0; // 7 
    ram_1.data[9] = 0; // 7 

    

    a1 = 7;
    a2 = 8;
    a3 = 9;
    a4 = 10;
  
    #1
    $dumpfile("vcd/byteblast8.vcd");
    $dumpvars(0, ram_1);    
    $dumpvars(0, mux4_1);
    $dumpvars(0, ctrl1);
    $dumpvars(0, fde_1);
    $dumpvars(0, pc1);
    $dumpvars(0,clkdiv_1);
    $dumpvars(0,register_1);
    $dumpvars(0,alu8_1);
    
    $display("<begin>");
    
    
    for (i=0; i<18; i=i+1) begin
      #1
      clk = 1;
      //$monitor("address:%d value:%b %d %d %d %d",mux_address, ram_ctrl_value, ctrl1.instr,ctrl1.address, fde_state, halv_clk);
      #1
      clk = 0;
    end

    #1
    $monitor("2 + 5 = %d", ram_1.data[5]);
    #1
    $display("<end>");
  end

endmodule