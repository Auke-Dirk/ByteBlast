/*
    Author : Auke Dirk Pietersma
    Project: ByteBlast https://github.com/Auke-Dirk/ByteBlast
    Module : Memory Select TB
*/

module byteblast8(clk, enable);

parameter ADDRESS_BITS = 5;
parameter DATA_BITS = 8;

input clk;
input enable;

reg halv_clk;
wire exec_clk;

wire fde_fetch;
wire fde_decode;
wire fde_execute;
wire [1:0] fde_state;
wire [ADDRESS_BITS-1:0] mux_address;

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



endmodule