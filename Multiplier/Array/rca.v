module rca 
#(
    parameter WIDTH=16
) 
(
    input  [WIDTH-1:0] op1,
    input  [WIDTH-1:0] op2,
    output [WIDTH-1:0] sum,
    output cout
);

wire [WIDTH:0] temp;
assign temp[0] = 0;

genvar i;
for( i=0; i<WIDTH; i=i+1) begin
    full_adder u_full_adder(
        .a      (   op1[i]     ),
        .b      (   op2[i]     ),
        .cin    (   temp[i]    ),
        .cout   (   temp[i+1]  ),
        .s      (   sum[i]     )
    );
end

assign cout = temp[WIDTH];

endmodule