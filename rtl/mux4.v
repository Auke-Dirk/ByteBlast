/*
    Author : Auke Dirk Pietersma
    Project: ByteBlast https://github.com/Auke-Dirk/ByteBlast
    Module : Program Counter (pc)
*/
module mux4(sel, a, b, c, d, out);

  parameter BITS = 8;

  input [1:0] sel;
  input [BITS-1:0] a;
  input [BITS-1:0] b;
  input [BITS-1:0] c;
  input [BITS-1:0] d;
  
  output [3:0] out;          

  /*
  2'b00 : out <= a;  
  2'b01 : out <= b;  
  2'b10 : out <= c;  
  2'b11 : out <= d;  
  */
  
   assign out = sel[1] ? (sel[0] ? d : c) : (sel[0] ? b : a);  
  
endmodule 