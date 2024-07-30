/*
    Author : Auke Dirk Pietersma
    Project: ByteBlast https://github.com/Auke-Dirk/ByteBlast
    Module : ByteBlast Simulator architecture 8
*/

`timescale 10ns / 1ns

module arch8_tb();

// Program to load, cmd-argument
reg [400:0] prgloc;
reg result;

// Show memory location
integer memloc;

// Show elapsed time
integer show_time;

// External Clock and Enable
reg clk;
reg enable;

// Variable for loading RAM
reg [7:0] in_ram [0:0];
int fd, status, index, start, i;


// ByteBlast CPU 
byteblast8 cpu(
  .clk(clk),
  .enable(enable)
);

//*****************************************
// Start the program
//*****************************************
initial begin

status = 1;
index = 0;
show_time = 0;

// Read the program location
result = $value$plusargs("PROG=%s", prgloc);
$display("Program: %0s", prgloc);

// Read if time should be displayed
result = $value$plusargs("TIME=%d", show_time);

// Try open the program
fd = $fopen (prgloc, "rb");
if (fd) begin
  $display("Program found");
end else begin
  $display("Program could not be found.");
  $finish;
end


//*****************************************
// Populate RAM:
//*****************************************
while(status == 1) begin
  status = $fread (in_ram,fd);
  cpu.ram_1.data[index] = in_ram[0];  
  // $display ("status = %0d reg1 = %b",status,in_ram[0]);
  // $display ("index = %0d reg1 = %b",index,cpu.ram_1.data[index]);
  index = index + 1;
end
//*****************************************


enable = 1;
clk = 0;

#1
$dumpfile("vcd/arch8.vcd");
$dumpvars(0, cpu);    
$display("<begin>");

//*****************************************
// Run program until (instr == 000) => enable
//*****************************************
  i = 0;
  while(enable == 1) begin
    #1
    clk = 1;
    #1
    clk = 0;
    if (cpu.ctrl1.instr == 0) begin
      if (start < 3) begin
        start = start + 1;
      end else begin      
        enable = 0;
      end
    end
      i = i + 1;
      if (show_time)
        $display("time: %d", i);
  end 
  //*****************************************

  memloc = 0;
  result = $value$plusargs("MEM=%d", memloc);
  #1

  if(result)
    $display("memory %d %d",memloc,cpu.ram_1.data[memloc]);
  #1
  $display("<end>");
end

endmodule