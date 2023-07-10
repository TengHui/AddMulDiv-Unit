module BoothSelectSignal
(
    input [2:0] y, //Yi+1, Yi, Yi-1
    output neg, //-x
    output pos, //x
    output neg2,//-2x
    output pos2 //2x
);

//===========Booth two-digit multiplication rule===========
//
//  yi+1    yi    yi-1    op
//  0       0     0       +0
//  0       0     1       +X
//  0       1     0       +X
//  0       1     1       +2X
//  1       0     0       -2X
//  1       0     1       -X
//  1       1     0       -X
//  1       1     1       +0
//
//===========Booth two-digit multiplication rule===========

assign neg = (y[2]&~y[1]&y[0]) | (y[2]&y[1]&~y[0]);
assign pos = (~y[2]&~y[1]&y[0]) | (~y[2]&y[1]&~y[0]);
assign neg2 = y[2]&~y[1]&~y[0];
assign pos2 = ~y[2]&y[1]&y[0];

endmodule