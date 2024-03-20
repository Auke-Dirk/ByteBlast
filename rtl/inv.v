module inv(data_in,data_out);

input data_in;
output data_out;

assign data_out = !data_in;

endmodule