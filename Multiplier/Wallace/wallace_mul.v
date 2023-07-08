module wallace_mul 
#(
    parameter WIDTH=32
) 
(
	input [WIDTH-1:0] X,
	input [WIDTH-1:0] Y,
	output [2*WIDTH-1:0] P
);

wire [WIDTH-1:0][2*WIDTH-1:0] xy;
wire [WIDTH*2-1:0] s_lev01;
wire [WIDTH*2-1:0] c_lev01;
wire [WIDTH*2-1:0] s_lev02;
wire [WIDTH*2-1:0] c_lev02;
wire [WIDTH*2-1:0] s_lev11;
wire [WIDTH*2-1:0] c_lev11;
wire [WIDTH*2-1:0] s_lev12;
wire [WIDTH*2-1:0] c_lev12;
wire [WIDTH*2-1:0] s_lev21;
wire [WIDTH*2-1:0] c_lev21;
wire [WIDTH*2-1:0] s_lev31;
wire [WIDTH*2-1:0] c_lev31;

genvar i;
genvar j;

//generate xy
generate 
    for(i=0; i<WIDTH; i=i+1) begin
        for(j=0; j< WIDTH; j=j+1) begin
            assign xy[i][j] = Y[i] & X[j];
        end
        assign xy[i][2*WIDTH-1 : WIDTH] = 8'd0; //for "X"
    end
endgenerate

//level 0
csa #(WIDTH*2) csa_lev01(
	.op1( xy[0] ),
	.op2( xy[1] << 1 ),
	.op3( xy[2] << 2 ),
	.S	( s_lev01),
	.C	( c_lev01)
);

csa #(WIDTH*2) csa_lev02(
	.op1( xy[3] << 3),
	.op2( xy[4] << 4),
	.op3( xy[5] << 5),
	.S	( s_lev02 ),
	.C	( c_lev02 )
);

//level 1
csa #(WIDTH*2) csa_lev11(
	.op1( s_lev01 ),
	.op2( c_lev01 << 1 ),
	.op3( s_lev02 ),
	.S	( s_lev11 ),
	.C	( c_lev11 )
);

csa #(WIDTH*2) csa_lev12(
	.op1( c_lev02 << 1 ),
	.op2( xy[6] << 6 ),
	.op3( xy[7] << 7 ),
	.S	( s_lev12 ),
	.C	( c_lev12 )
);

//level 2
csa #(WIDTH*2) csa_lev21(
	.op1( s_lev11 ),
	.op2( c_lev11 << 1 ),
	.op3( s_lev12 ),
	.S	( s_lev21 ),
	.C	( c_lev21 )
);

//level 3
csa #(WIDTH*2) csa_lev31(
	.op1( s_lev21 ),
	.op2( c_lev21 << 1 ),
	.op3( c_lev12 << 1 ),
	.S	( s_lev31),
	.C	( c_lev31)
);

//adder
rca #(2*WIDTH) u_rca (
    .op1 ( s_lev31  ), 
    .op2 ( c_lev31 << 1  ),
    .cin ( 1'b0   ),
    .sum ( P      ),
    .cout(        )
);

endmodule