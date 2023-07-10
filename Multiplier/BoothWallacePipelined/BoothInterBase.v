module BoothInterBase
(
    input [2:0] y, //{yi+1, yi, yi-1}
    input [63:0] x,
    output [63:0] p,
    output c //carry
);

wire neg,pos,neg2,pos2;

//calculate p[0]
BoothSelectSignal u_BoothSelectSignal(
    .y(y),
    .neg(neg),
    .pos(pos),
    .neg2(neg2),
    .pos2(pos2)
);

BoothBase u_BoothBase(
    .neg(neg),
    .pos(pos),
    .neg2(neg2),
    .pos2(pos2),
    .x({x[0],1'b0}),
    .p(p[0])
);

//calculate p[63:1]
generate
    genvar i;
    for(i=1;i<64;i=i+1) begin
        BoothBase us_BoothBase(
            .neg(neg),
            .pos(pos),
            .neg2(neg2),
            .pos2(pos2),
            .x(x[i:i-1]),
            .p(p[i])
        );
    end
endgenerate

assign c = neg || neg2;

endmodule