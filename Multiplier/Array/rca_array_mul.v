module rca_array_mul 
#(
    parameter WIDTH=4
)
(
	input  [WIDTH-1: 0] A,
	input  [WIDTH-1: 0] B,
	output [2*WIDTH -1: 0] S
);

//for AB and
wire [WIDTH-1 : 0] [WIDTH-1: 0] ab;

//rca inputs
wire [WIDTH-1 : 0] level0_op1;
wire [WIDTH-1 : 0] level0_op2;
wire [WIDTH-1 : 0] level1_op1;
wire [WIDTH-1 : 0] level1_op2;
wire [WIDTH-1 : 0] level2_op1;
wire [WIDTH-1 : 0] level2_op2;

//rca outputs
wire [WIDTH-1 : 0] level0_sum;
wire               level0_cout;
wire [WIDTH-1 : 0] level1_sum;
wire               level1_cout;
wire [WIDTH-1 : 0] level2_sum;
wire               level2_cout;

//A and B "and gates"
genvar i, j;
generate
    for(i=0; i<WIDTH; i=i+1) begin
        for(j=0; j<WIDTH; j=j+1) begin
            assign ab[i][j] = B[i] & A[j];
        end
    end
endgenerate

//level0 rca
assign level0_op1 = {1'b0, ab[0][WIDTH-1:1]};
assign level0_op2 = ab[1][WIDTH-1:0];
rca #(4) rca_level0 (
    .op1 ( level0_op1),
    .op2 ( level0_op2),
    .sum ( level0_sum),
    .cout( level0_cout)
);

//level1 rca
assign level1_op1 = {level0_cout, level0_sum[WIDTH-1:1]};
assign level1_op2 = ab[2][WIDTH-1:0];
rca #(4) rca_level1 (
    .op1 ( level1_op1),
    .op2 ( level1_op2),
    .sum ( level1_sum),
    .cout( level1_cout)
);

//level2 rca
assign level2_op1 = {level1_cout, level1_sum[WIDTH-1:1]};
assign level2_op2 = ab[3][WIDTH-1:0];
rca #(4) rca_level2 (
    .op1 ( level2_op1), 
    .op2 ( level2_op2),
    .sum ( level2_sum),
    .cout( level2_cout)
);

//result output
assign S[0] = ab[0][0];
assign S[1] = level0_sum[0];
assign S[2] = level1_sum[0];
assign S[2*WIDTH-1:3] = {level2_cout, level2_sum};

endmodule