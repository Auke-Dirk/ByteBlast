`timescale 10ns / 1ns

module byteblast8_tb();

reg clk;
reg enable;
reg load;
reg reset;
reg w_ram;
reg [4:0]nxt_adr;

reg[7:0]ram_reg;
wire [4:0]crnt_adr;
wire [7:0]value_out;


wire fetch;
wire decode;
wire execute;

wire[7:0] pc_ramin_a;
wire[7:0] ctrl_ramin_b;
//wire fde_ramin_select;
wire[7:0] ramin_ram;


initial begin
   clk = 0;
   enable = 1;
   load = 0;
end 

/*
  [fde:fetch] -> [pc:enable]
*/


mux2 ramin(
  .select(fetch),
  .a(pc_ramin_a),
  .b(ctrl_ramin_b),
  .c(ramin_ram)
);

pc #(5) pc1(
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

ctrl ctrl1(
  .clk(clk),
  .enable(decode),
  .value(value_out),
  .o_address(ctrl_ramin_b)
  );

ram #(5,8) ram1(
    .clk(clk),
    .enable(w_ram), // should be called w_enable
    .address(crnt_adr),
    .data_in(ram_reg),
    .data_out(value_out)
    );
 
  integer i;
  initial 
  begin
    ram1.data[0] = 8'b00100011; // 001 00011 LD  : address 3
    ram1.data[1] = 8'b01000100; // 010 00100 ADD : address 4
    ram1.data[2] = 8'b10000101; // 100 00101 STR : address 5
    ram1.data[3] = 2;
    ram1.data[4] = 5;
    ram1.data[5] = 0; // 7 

    #1
    $dumpfile("vcd/byteblast8.vcd");    
    $display("<begin>");
    #1
    $display("C>  FDE :  A   V");
    #1
    $monitor("%b> %b %b %b: %d %d",clk, fetch,decode, execute, crnt_adr,value_out);    
    #1
    for (i=0; i<12; i=i+1) begin
      #1
      clk = 1;
      $monitor("%b> %b %b %b: %d %d",clk, fetch,decode, execute, crnt_adr,value_out);
      $monitor("> instr: %d addr:%d sel:%d mux-addr:%d rm:%d" , ctrl1.instr, ctrl1.address, ramin.select, ramin.c, ram1.data_out);

      #1
      clk = 0;
      $monitor("%b> %b %b %b: %d %d",clk, fetch,decode, execute,crnt_adr,value_out);
    end



    #1
    $display("<end>");

    end


endmodule