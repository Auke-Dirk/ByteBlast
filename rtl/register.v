/*
    Author : Auke Dirk Pietersma
    Project: ByteBlast https://github.com/Auke-Dirk/ByteBlast
    Module : register
*/

module register(clk,enable,data_in, data_o);
    input[7:0] data_in; 
    input clk,enable;
    output[7:0] data_o;
    reg[7:0] memory;

    initial begin
        memory = 0;
    end 

    always @(posedge clk)
    begin
            if(enable)
            begin
                memory <= data_in;
            end            
    end
    
    assign data_o = memory;

endmodule