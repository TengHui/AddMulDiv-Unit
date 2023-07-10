module adder(
    input [2:0] data,
    output cout,
    output s
);

assign s = data[2] ^ data[1] ^ data[0];
assign cout = data[2] & data[1] | (data[0] & (data[2] ^ data[1]));

endmodule