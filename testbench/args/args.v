module test;
reg [100:0] s1;
reg result;

initial begin
   result = $value$plusargs("MEM=%s", s1);
    $display("String is %0s", s1);
end

endmodule