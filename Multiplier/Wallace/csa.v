module csa 
#(
    parameter WIDTH=64
) 
(
	input [WIDTH-1:0] op1,
	input [WIDTH-1:0] op2,
	input [WIDTH-1:0] op3,
	output [WIDTH-1:0] S,
	output [WIDTH-1:0] C
);

genvar i;
generate
	for(i=0; i<WIDTH; i=i+1) begin
		full_adder u_full_adder(
			.a      (   op1[i]    ),
			.b      (   op2[i]    ),
			.cin    (   op3[i]    ),
			.cout   (   C[i]	  ),
			.s      (   S[i]      )
		);
	end
endgenerate

endmodule