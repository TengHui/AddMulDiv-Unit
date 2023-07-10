module BoothBase
(
    input neg, //-x
    input pos, //x
    input neg2,//-2x
    input pos2,//2x
    input [1:0] x, //{xi, xi-1}
    output p
);

assign p = (neg&~x[1]) | (neg2&~x[0]) | (pos&x[1]) | (pos2&x[0]);

endmodule